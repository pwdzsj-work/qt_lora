#include "wifi_device_discovery.h"

#include <QHostAddress>
#include <QDateTime>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkInterface>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QTimer>
#include <QUrl>

WifiDeviceDiscovery::WifiDeviceDiscovery(QObject *parent)
    : QObject(parent),
      manager(new QNetworkAccessManager(this)),
      pollTimer(new QTimer(this))
{
    qRegisterMetaType<WifiDeviceStatus>();
    connect(manager, &QNetworkAccessManager::finished, this,
            &WifiDeviceDiscovery::requestFinished);
    connect(pollTimer, &QTimer::timeout, this,
            &WifiDeviceDiscovery::pollKnownDevices);
    pollTimer->start(2000);
}

QStringList WifiDeviceDiscovery::localSubnetHosts() const
{
    QSet<QString> hosts;
    const auto interfaces = QNetworkInterface::allInterfaces();
    for (const QNetworkInterface &network : interfaces) {
        const auto flags = network.flags();
        if (!(flags & QNetworkInterface::IsUp) ||
            !(flags & QNetworkInterface::IsRunning) ||
            (flags & QNetworkInterface::IsLoopBack))
            continue;

        for (const QNetworkAddressEntry &entry :
             network.addressEntries()) {
            const QHostAddress address = entry.ip();
            if (address.protocol() != QAbstractSocket::IPv4Protocol)
                continue;
            const quint32 local = address.toIPv4Address();
            const quint8 first = static_cast<quint8>(local >> 24);
            if (first == 127 || first == 0 || first == 169)
                continue;

            const quint32 subnet = local & 0xFFFFFF00U;
            for (quint32 host = 1; host < 255; ++host) {
                const quint32 candidate = subnet | host;
                if (candidate != local)
                    hosts.insert(QHostAddress(candidate).toString());
            }
        }
    }
    QStringList result = hosts.values();
    result.sort();
    return result;
}

void WifiDeviceDiscovery::startSearch()
{
    if (searching)
        return;
    const QStringList hosts = localSubnetHosts();
    searching = true;
    discoveryPending = hosts.size();
    emit searchStarted(discoveryPending);
    if (hosts.isEmpty()) {
        searching = false;
        emit searchFinished(knownHosts.size());
        return;
    }
    for (const QString &host : hosts)
        requestStatus(host, true);
}

bool WifiDeviceDiscovery::synchronizeClock(const QString &ip)
{
    if (!knownHosts.contains(ip))
        return false;

    const QDateTime now = QDateTime::currentDateTime();
    const QDate date = now.date();
    const QTime time = now.time();
    const QByteArray body =
        QStringLiteral("year=%1&month=%2&day=%3&hour=%4&minute=%5&second=%6")
            .arg(date.year())
            .arg(date.month())
            .arg(date.day())
            .arg(time.hour())
            .arg(time.minute())
            .arg(time.second())
            .toUtf8();

    QNetworkRequest request(
        QUrl(QStringLiteral("http://%1/api/time").arg(ip)));
    request.setTransferTimeout(3000);
    request.setHeader(QNetworkRequest::ContentTypeHeader,
                      QStringLiteral("application/x-www-form-urlencoded"));
    QNetworkReply *reply = manager->post(request, body);
    reply->setProperty("wifiIp", ip);
    reply->setProperty("wifiCommand", QStringLiteral("clock"));
    return true;
}

void WifiDeviceDiscovery::requestStatus(const QString &ip, bool discovery)
{
    if (pendingHosts.contains(ip)) {
        if (discovery && discoveryPending > 0) {
            --discoveryPending;
            if (searching && discoveryPending == 0) {
                searching = false;
                emit searchFinished(knownHosts.size());
            }
        }
        return;
    }
    pendingHosts.insert(ip);
    QNetworkRequest request(
        QUrl(QStringLiteral("http://%1/api/status").arg(ip)));
    request.setTransferTimeout(1200);
    request.setRawHeader("Cache-Control", "no-store");
    QNetworkReply *reply = manager->get(request);
    reply->setProperty("wifiIp", ip);
    reply->setProperty("wifiDiscovery", discovery);
}

void WifiDeviceDiscovery::pollKnownDevices()
{
    for (const QString &host : knownHosts)
        requestStatus(host, false);
}

void WifiDeviceDiscovery::requestFinished(QNetworkReply *reply)
{
    const QString ip = reply->property("wifiIp").toString();
    if (reply->property("wifiCommand").toString() ==
        QStringLiteral("clock")) {
        bool success = false;
        QString message;
        if (reply->error() == QNetworkReply::NoError) {
            QJsonParseError error;
            const QJsonDocument document =
                QJsonDocument::fromJson(reply->readAll(), &error);
            success = error.error == QJsonParseError::NoError &&
                      document.object().value("ok").toBool();
        }
        if (success) {
            message = QStringLiteral("校时成功");
        } else {
            message = QStringLiteral("校时失败：%1")
                          .arg(reply->error() == QNetworkReply::NoError
                                   ? QStringLiteral("终端返回异常")
                                   : reply->errorString());
        }
        emit clockSyncFinished(ip, success, message);
        reply->deleteLater();
        return;
    }

    const bool discovery =
        reply->property("wifiDiscovery").toBool();
    pendingHosts.remove(ip);

    bool valid = false;
    WifiDeviceStatus status;
    if (reply->error() == QNetworkReply::NoError) {
        QJsonParseError error;
        const QJsonDocument document =
            QJsonDocument::fromJson(reply->readAll(), &error);
        const QJsonObject object = document.object();
        const QJsonArray voltage = object.value("voltage").toArray();
        const QJsonArray current = object.value("current").toArray();
        const QJsonArray modes = object.value("modes").toArray();
        valid = error.error == QJsonParseError::NoError &&
                object.contains("relays") &&
                object.contains("inputs") &&
                voltage.size() >= 4 && current.size() >= 4 &&
                modes.size() >= 4;
        if (valid) {
            status.ip = ip;
            status.relayMask =
                static_cast<quint8>(object.value("relays").toInt());
            status.inputMask =
                static_cast<quint8>(object.value("inputs").toInt());
            for (int channel = 0; channel < 4; ++channel) {
                status.voltage.append(
                    voltage.at(channel).toDouble() / 100.0);
                status.current.append(
                    current.at(channel).toDouble() / 100.0);
                status.currentMode.append(
                    modes.at(channel).toInt() != 0);
            }
        }
    }

    if (valid) {
        knownHosts.insert(ip);
        failures.insert(ip, 0);
        emit deviceStatusReceived(status);
    } else if (!discovery && knownHosts.contains(ip)) {
        const int failed = failures.value(ip) + 1;
        failures.insert(ip, failed);
        if (failed >= 3) {
            knownHosts.remove(ip);
            failures.remove(ip);
            emit deviceOffline(ip);
        }
    }

    if (discovery && discoveryPending > 0) {
        --discoveryPending;
        if (discoveryPending == 0) {
            searching = false;
            emit searchFinished(knownHosts.size());
        }
    }
    reply->deleteLater();
}
