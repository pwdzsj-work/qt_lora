#include "lora_online_protocol.h"

#include <QStringList>

namespace {

constexpr char Sof0 = static_cast<char>(0xA5);
constexpr char Sof1 = static_cast<char>(0x5A);
constexpr int HeaderSize = 7;
constexpr int CrcSize = 2;

QByteArray makeFrame(quint8 type, quint16 sequence, const QByteArray &payload)
{
    QByteArray frame;
    frame.reserve(HeaderSize + payload.size() + CrcSize);
    frame.append(Sof0);
    frame.append(Sof1);
    frame.append(static_cast<char>(LoraOnlineProtocol::Version));
    frame.append(static_cast<char>(type));
    frame.append(static_cast<char>(payload.size()));
    frame.append(static_cast<char>(sequence >> 8));
    frame.append(static_cast<char>(sequence));
    frame.append(payload);

    const quint16 crc = LoraOnlineProtocol::crc16(frame);
    frame.append(static_cast<char>(crc));
    frame.append(static_cast<char>(crc >> 8));
    return frame;
}

} // namespace

namespace LoraOnlineProtocol {

quint16 crc16(const QByteArray &data)
{
    quint16 crc = 0xFFFF;
    for (const char value : data) {
        crc ^= static_cast<quint8>(value);
        for (int bit = 0; bit < 8; ++bit)
            crc = (crc & 1U) ? static_cast<quint16>((crc >> 1) ^ 0xA001U)
                             : static_cast<quint16>(crc >> 1);
    }
    return crc;
}

QByteArray makeScanRequest(quint16 sequence, quint8 slotCount,
                           quint8 slotDuration10Ms)
{
    if (slotCount == 0)
        slotCount = 1;
    if (slotDuration10Ms == 0)
        slotDuration10Ms = 1;

    QByteArray payload;
    payload.append(static_cast<char>(slotCount));
    payload.append(static_cast<char>(slotDuration10Ms));
    return makeFrame(ScanRequest, sequence, payload);
}

bool takeFrame(QByteArray &buffer, Frame *frame)
{
    if (!frame)
        return false;

    const QByteArray marker("\xA5\x5A", 2);
    int start = buffer.indexOf(marker);
    if (start < 0) {
        if (!buffer.isEmpty() && buffer.back() == Sof0)
            buffer = QByteArray(1, Sof0);
        else
            buffer.clear();
        return false;
    }
    if (start > 0)
        buffer.remove(0, start);
    if (buffer.size() < HeaderSize)
        return false;

    const quint8 payloadSize = static_cast<quint8>(buffer.at(4));
    if (payloadSize > MaxPayloadSize) {
        buffer.remove(0, 2);
        return takeFrame(buffer, frame);
    }

    const int frameSize = HeaderSize + payloadSize + CrcSize;
    if (buffer.size() < frameSize)
        return false;

    const QByteArray encoded = buffer.left(frameSize);
    const quint16 receivedCrc =
        static_cast<quint8>(encoded.at(frameSize - 2)) |
        (static_cast<quint16>(static_cast<quint8>(encoded.at(frameSize - 1))) << 8);
    const quint16 calculatedCrc = crc16(encoded.left(frameSize - CrcSize));
    if (receivedCrc != calculatedCrc ||
        static_cast<quint8>(encoded.at(2)) != Version) {
        buffer.remove(0, 1);
        return takeFrame(buffer, frame);
    }

    frame->type = static_cast<quint8>(encoded.at(3));
    frame->sequence =
        (static_cast<quint16>(static_cast<quint8>(encoded.at(5))) << 8) |
        static_cast<quint8>(encoded.at(6));
    frame->payload = encoded.mid(HeaderSize, payloadSize);
    buffer.remove(0, frameSize);
    return true;
}

bool decodeOnlineResponse(const Frame &frame, OnlineDevice *device)
{
    constexpr int PayloadSize = 12;
    if (!device || frame.type != OnlineResponse ||
        frame.payload.size() != PayloadSize)
        return false;

    device->mac = frame.payload.left(6);
    device->modbusAddress = static_cast<quint8>(frame.payload.at(6));
    device->deviceType = static_cast<quint8>(frame.payload.at(7));
    device->channelCount = static_cast<quint8>(frame.payload.at(8));
    device->capabilities = static_cast<quint8>(frame.payload.at(9));
    device->firmwareMajor = static_cast<quint8>(frame.payload.at(10));
    device->firmwareMinor = static_cast<quint8>(frame.payload.at(11));
    return device->modbusAddress != 0 && device->channelCount != 0;
}

QString formatMac(const QByteArray &mac)
{
    if (mac.size() != 6)
        return {};

    QStringList parts;
    parts.reserve(6);
    for (const char value : mac)
        parts.append(QStringLiteral("%1").arg(static_cast<quint8>(value), 2, 16,
                                              QLatin1Char('0')).toUpper());
    return parts.join(QLatin1Char('-'));
}

} // namespace LoraOnlineProtocol
