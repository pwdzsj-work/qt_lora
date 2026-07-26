#ifndef LORA_ONLINE_PROTOCOL_H
#define LORA_ONLINE_PROTOCOL_H

#include <QByteArray>
#include <QString>
#include <QtGlobal>

namespace LoraOnlineProtocol {

constexpr quint8 Version = 0x01;
constexpr quint8 ScanRequest = 0x01;
constexpr quint8 OnlineResponse = 0x02;
constexpr int MaxPayloadSize = 32;

struct Frame
{
    quint8 type = 0;
    quint16 sequence = 0;
    QByteArray payload;
};

struct OnlineDevice
{
    QByteArray mac;
    quint8 modbusAddress = 0;
    quint8 deviceType = 0;
    quint8 channelCount = 0;
    quint8 capabilities = 0;
    quint8 firmwareMajor = 0;
    quint8 firmwareMinor = 0;
};

QByteArray makeScanRequest(quint16 sequence, quint8 slotCount = 16,
                           quint8 slotDuration10Ms = 12);
bool takeFrame(QByteArray &buffer, Frame *frame);
bool decodeOnlineResponse(const Frame &frame, OnlineDevice *device);
QString formatMac(const QByteArray &mac);
quint16 crc16(const QByteArray &data);

} // namespace LoraOnlineProtocol

#endif // LORA_ONLINE_PROTOCOL_H
