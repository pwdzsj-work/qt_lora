#ifndef WIFI_DEVICE_DISCOVERY_H
#define WIFI_DEVICE_DISCOVERY_H

#include <QObject>
#include <QHash>
#include <QSet>
#include <QVector>

class QNetworkAccessManager;
class QNetworkReply;
class QTimer;

struct WifiDeviceStatus
{
    QString ip;
    quint8 relayMask = 0;
    quint8 inputMask = 0;
    QVector<double> voltage;
    QVector<double> current;
    QVector<bool> currentMode;
};

class WifiDeviceDiscovery : public QObject
{
    Q_OBJECT
public:
    explicit WifiDeviceDiscovery(QObject *parent = nullptr);

public slots:
    void startSearch();
    bool synchronizeClock(const QString &ip);

signals:
    void searchStarted(int addressCount);
    void searchFinished(int deviceCount);
    void deviceStatusReceived(WifiDeviceStatus status);
    void deviceOffline(QString ip);
    void clockSyncFinished(QString ip, bool success, QString message);

private slots:
    void pollKnownDevices();
    void requestFinished(QNetworkReply *reply);

private:
    void requestStatus(const QString &ip, bool discovery);
    QStringList localSubnetHosts() const;

    QNetworkAccessManager *manager;
    QTimer *pollTimer;
    QSet<QString> pendingHosts;
    QSet<QString> knownHosts;
    QHash<QString, int> failures;
    int discoveryPending = 0;
    bool searching = false;
};

Q_DECLARE_METATYPE(WifiDeviceStatus)

#endif // WIFI_DEVICE_DISCOVERY_H
