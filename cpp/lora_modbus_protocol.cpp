#include "lora_modbus_protocol.h"

namespace LoraModbusProtocol {

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

QByteArray makeReportServerId(quint8 address)
{
    QByteArray frame;
    frame.reserve(4);
    frame.append(static_cast<char>(address));
    frame.append(static_cast<char>(ReportServerId));
    const quint16 crc = crc16(frame);
    frame.append(static_cast<char>(crc));
    frame.append(static_cast<char>(crc >> 8));
    return frame;
}

bool takeServerIdResponse(QByteArray &buffer, quint8 expectedAddress,
                          ServerInfo *server, quint8 *exceptionCode)
{
    if (!server)
        return false;
    if (exceptionCode)
        *exceptionCode = 0;

    while (!buffer.isEmpty() &&
           static_cast<quint8>(buffer.at(0)) != expectedAddress)
        buffer.remove(0, 1);
    if (buffer.size() < 2)
        return false;

    const quint8 function = static_cast<quint8>(buffer.at(1));
    int frameSize = 0;
    if (function == ReportServerId) {
        if (buffer.size() < 3)
            return false;
        const quint8 byteCount = static_cast<quint8>(buffer.at(2));
        if (byteCount < 2 || byteCount > 64) {
            buffer.remove(0, 1);
            return takeServerIdResponse(buffer, expectedAddress, server,
                                        exceptionCode);
        }
        frameSize = 3 + byteCount + 2;
    } else if (function == (ReportServerId | 0x80U)) {
        frameSize = 5;
    } else {
        buffer.remove(0, 1);
        return takeServerIdResponse(buffer, expectedAddress, server,
                                    exceptionCode);
    }

    if (buffer.size() < frameSize)
        return false;
    const QByteArray frame = buffer.left(frameSize);
    const quint16 receivedCrc =
        static_cast<quint8>(frame.at(frameSize - 2)) |
        (static_cast<quint16>(
             static_cast<quint8>(frame.at(frameSize - 1))) << 8);
    if (receivedCrc != crc16(frame.left(frameSize - 2))) {
        buffer.remove(0, 1);
        return takeServerIdResponse(buffer, expectedAddress, server,
                                    exceptionCode);
    }

    buffer.remove(0, frameSize);
    if (function & 0x80U) {
        if (exceptionCode)
            *exceptionCode = static_cast<quint8>(frame.at(2));
        return true;
    }

    const quint8 byteCount = static_cast<quint8>(frame.at(2));
    server->address = expectedAddress;
    server->serverId = static_cast<quint8>(frame.at(3));
    server->running = static_cast<quint8>(frame.at(4)) == 0xFF;
    server->model = QString::fromLatin1(frame.constData() + 5, byteCount - 2);
    return true;
}

QByteArray makeReadInputRegisters(quint8 address, quint16 start,
                                  quint16 count)
{
    QByteArray frame;
    frame.reserve(8);
    frame.append(static_cast<char>(address));
    frame.append(static_cast<char>(ReadInputRegisters));
    frame.append(static_cast<char>(start >> 8));
    frame.append(static_cast<char>(start));
    frame.append(static_cast<char>(count >> 8));
    frame.append(static_cast<char>(count));
    const quint16 crc = crc16(frame);
    frame.append(static_cast<char>(crc));
    frame.append(static_cast<char>(crc >> 8));
    return frame;
}

QByteArray makeReadRelayStates(quint8 address)
{
    QByteArray frame;
    frame.reserve(8);
    frame.append(static_cast<char>(address));
    frame.append(static_cast<char>(ReadCoils));
    frame.append(static_cast<char>(RelayCoilStart >> 8));
    frame.append(static_cast<char>(RelayCoilStart));
    frame.append(static_cast<char>(RelayCoilCount >> 8));
    frame.append(static_cast<char>(RelayCoilCount));
    const quint16 crc = crc16(frame);
    frame.append(static_cast<char>(crc));
    frame.append(static_cast<char>(crc >> 8));
    return frame;
}

bool takeReadRelayStatesResponse(QByteArray &buffer, quint8 expectedAddress,
                                 quint8 *relayMask, quint8 *exceptionCode)
{
    if (!relayMask)
        return false;
    if (exceptionCode)
        *exceptionCode = 0;

    while (!buffer.isEmpty() &&
           static_cast<quint8>(buffer.at(0)) != expectedAddress)
        buffer.remove(0, 1);
    if (buffer.size() < 2)
        return false;

    const quint8 function = static_cast<quint8>(buffer.at(1));
    int frameSize = 0;
    if (function == ReadCoils) {
        if (buffer.size() < 3)
            return false;
        const quint8 byteCount = static_cast<quint8>(buffer.at(2));
        if (byteCount != 1) {
            buffer.remove(0, 1);
            return takeReadRelayStatesResponse(
                buffer, expectedAddress, relayMask, exceptionCode);
        }
        frameSize = 3 + byteCount + 2;
    } else if (function == (ReadCoils | 0x80U)) {
        frameSize = 5;
    } else {
        buffer.remove(0, 1);
        return takeReadRelayStatesResponse(
            buffer, expectedAddress, relayMask, exceptionCode);
    }

    if (buffer.size() < frameSize)
        return false;
    const QByteArray frame = buffer.left(frameSize);
    const quint16 receivedCrc =
        static_cast<quint8>(frame.at(frameSize - 2)) |
        (static_cast<quint16>(
             static_cast<quint8>(frame.at(frameSize - 1))) << 8);
    if (receivedCrc != crc16(frame.left(frameSize - 2))) {
        buffer.remove(0, 1);
        return takeReadRelayStatesResponse(
            buffer, expectedAddress, relayMask, exceptionCode);
    }

    buffer.remove(0, frameSize);
    if (function & 0x80U) {
        if (exceptionCode)
            *exceptionCode = static_cast<quint8>(frame.at(2));
        return true;
    }

    *relayMask = static_cast<quint8>(frame.at(3)) &
                 static_cast<quint8>((1U << RelayCoilCount) - 1U);
    return true;
}

QByteArray makeWriteSingleRegister(quint8 address, quint16 reg,
                                   quint16 value)
{
    QByteArray frame;
    frame.reserve(8);
    frame.append(static_cast<char>(address));
    frame.append(static_cast<char>(WriteSingleRegister));
    frame.append(static_cast<char>(reg >> 8));
    frame.append(static_cast<char>(reg));
    frame.append(static_cast<char>(value >> 8));
    frame.append(static_cast<char>(value));
    const quint16 crc = crc16(frame);
    frame.append(static_cast<char>(crc));
    frame.append(static_cast<char>(crc >> 8));
    return frame;
}

bool takeWriteSingleRegisterResponse(QByteArray &buffer,
                                     quint8 expectedAddress,
                                     quint16 expectedRegister,
                                     quint16 expectedValue,
                                     quint8 *exceptionCode)
{
    if (exceptionCode)
        *exceptionCode = 0;

    while (!buffer.isEmpty() &&
           static_cast<quint8>(buffer.at(0)) != expectedAddress)
        buffer.remove(0, 1);
    if (buffer.size() < 2)
        return false;

    const quint8 function = static_cast<quint8>(buffer.at(1));
    const int frameSize =
        function == WriteSingleRegister ? 8
        : function == (WriteSingleRegister | 0x80U) ? 5 : 0;
    if (frameSize == 0) {
        buffer.remove(0, 1);
        return takeWriteSingleRegisterResponse(
            buffer, expectedAddress, expectedRegister, expectedValue,
            exceptionCode);
    }
    if (buffer.size() < frameSize)
        return false;

    const QByteArray frame = buffer.left(frameSize);
    const quint16 receivedCrc =
        static_cast<quint8>(frame.at(frameSize - 2)) |
        (static_cast<quint16>(
             static_cast<quint8>(frame.at(frameSize - 1))) << 8);
    if (receivedCrc != crc16(frame.left(frameSize - 2))) {
        buffer.remove(0, 1);
        return takeWriteSingleRegisterResponse(
            buffer, expectedAddress, expectedRegister, expectedValue,
            exceptionCode);
    }
    buffer.remove(0, frameSize);

    if (function & 0x80U) {
        if (exceptionCode)
            *exceptionCode = static_cast<quint8>(frame.at(2));
        return true;
    }

    const quint16 returnedRegister =
        (static_cast<quint16>(static_cast<quint8>(frame.at(2))) << 8) |
        static_cast<quint8>(frame.at(3));
    const quint16 returnedValue =
        (static_cast<quint16>(static_cast<quint8>(frame.at(4))) << 8) |
        static_cast<quint8>(frame.at(5));
    if (returnedRegister != expectedRegister ||
        returnedValue != expectedValue) {
        return false;
    }
    return true;
}

QByteArray makeWriteMultipleRegisters(quint8 address, quint16 start,
                                      const QVector<quint16> &values)
{
    if (values.isEmpty() || values.size() > 123)
        return {};

    QByteArray frame;
    frame.reserve(9 + values.size() * 2);
    frame.append(static_cast<char>(address));
    frame.append(static_cast<char>(WriteMultipleRegisters));
    frame.append(static_cast<char>(start >> 8));
    frame.append(static_cast<char>(start));
    frame.append(static_cast<char>(values.size() >> 8));
    frame.append(static_cast<char>(values.size()));
    frame.append(static_cast<char>(values.size() * 2));
    for (const quint16 value : values) {
        frame.append(static_cast<char>(value >> 8));
        frame.append(static_cast<char>(value));
    }
    const quint16 crc = crc16(frame);
    frame.append(static_cast<char>(crc));
    frame.append(static_cast<char>(crc >> 8));
    return frame;
}

bool takeWriteMultipleRegistersResponse(QByteArray &buffer,
                                        quint8 expectedAddress,
                                        quint16 expectedStart,
                                        quint16 expectedCount,
                                        quint8 *exceptionCode)
{
    if (exceptionCode)
        *exceptionCode = 0;

    while (!buffer.isEmpty() &&
           static_cast<quint8>(buffer.at(0)) != expectedAddress)
        buffer.remove(0, 1);
    if (buffer.size() < 2)
        return false;

    const quint8 function = static_cast<quint8>(buffer.at(1));
    const int frameSize =
        function == WriteMultipleRegisters ? 8
        : function == (WriteMultipleRegisters | 0x80U) ? 5 : 0;
    if (frameSize == 0) {
        buffer.remove(0, 1);
        return takeWriteMultipleRegistersResponse(
            buffer, expectedAddress, expectedStart, expectedCount,
            exceptionCode);
    }
    if (buffer.size() < frameSize)
        return false;

    const QByteArray frame = buffer.left(frameSize);
    const quint16 receivedCrc =
        static_cast<quint8>(frame.at(frameSize - 2)) |
        (static_cast<quint16>(
             static_cast<quint8>(frame.at(frameSize - 1))) << 8);
    if (receivedCrc != crc16(frame.left(frameSize - 2))) {
        buffer.remove(0, 1);
        return takeWriteMultipleRegistersResponse(
            buffer, expectedAddress, expectedStart, expectedCount,
            exceptionCode);
    }
    buffer.remove(0, frameSize);

    if (function & 0x80U) {
        if (exceptionCode)
            *exceptionCode = static_cast<quint8>(frame.at(2));
        return true;
    }

    const quint16 returnedStart =
        (static_cast<quint16>(static_cast<quint8>(frame.at(2))) << 8) |
        static_cast<quint8>(frame.at(3));
    const quint16 returnedCount =
        (static_cast<quint16>(static_cast<quint8>(frame.at(4))) << 8) |
        static_cast<quint8>(frame.at(5));
    return returnedStart == expectedStart &&
           returnedCount == expectedCount;
}

bool takeReadInputResponse(QByteArray &buffer, quint8 expectedAddress,
                           QVector<quint16> *values, quint8 *exceptionCode)
{
    if (!values)
        return false;
    if (exceptionCode)
        *exceptionCode = 0;

    while (!buffer.isEmpty() &&
           static_cast<quint8>(buffer.at(0)) != expectedAddress)
        buffer.remove(0, 1);
    if (buffer.size() < 2)
        return false;

    const quint8 function = static_cast<quint8>(buffer.at(1));
    int frameSize = 0;
    if (function == ReadInputRegisters) {
        if (buffer.size() < 3)
            return false;
        const quint8 byteCount = static_cast<quint8>(buffer.at(2));
        if (byteCount == 0 || (byteCount & 1U) != 0 || byteCount > 64) {
            buffer.remove(0, 1);
            return takeReadInputResponse(buffer, expectedAddress, values,
                                         exceptionCode);
        }
        frameSize = 3 + byteCount + 2;
    } else if (function == (ReadInputRegisters | 0x80U)) {
        frameSize = 5;
    } else {
        buffer.remove(0, 1);
        return takeReadInputResponse(buffer, expectedAddress, values,
                                     exceptionCode);
    }

    if (buffer.size() < frameSize)
        return false;

    const QByteArray frame = buffer.left(frameSize);
    const quint16 receivedCrc =
        static_cast<quint8>(frame.at(frameSize - 2)) |
        (static_cast<quint16>(
             static_cast<quint8>(frame.at(frameSize - 1))) << 8);
    if (receivedCrc != crc16(frame.left(frameSize - 2))) {
        buffer.remove(0, 1);
        return takeReadInputResponse(buffer, expectedAddress, values,
                                     exceptionCode);
    }

    buffer.remove(0, frameSize);
    values->clear();
    if (function & 0x80U) {
        if (exceptionCode)
            *exceptionCode = static_cast<quint8>(frame.at(2));
        return true;
    }

    const int registerCount = static_cast<quint8>(frame.at(2)) / 2;
    values->reserve(registerCount);
    for (int i = 0; i < registerCount; ++i) {
        const int offset = 3 + i * 2;
        values->append(
            (static_cast<quint16>(
                 static_cast<quint8>(frame.at(offset))) << 8) |
            static_cast<quint8>(frame.at(offset + 1)));
    }
    return true;
}

} // namespace LoraModbusProtocol
