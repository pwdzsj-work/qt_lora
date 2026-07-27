#ifndef LORA_MODBUS_PROTOCOL_H
#define LORA_MODBUS_PROTOCOL_H

#include <QByteArray>
#include <QString>
#include <QVector>
#include <QtGlobal>

namespace LoraModbusProtocol {

constexpr quint8 ReadCoils = 0x01;
constexpr quint8 ReadInputRegisters = 0x04;
constexpr quint8 ReportServerId = 0x11;
constexpr quint16 RelayCoilStart = 0x0000;
constexpr quint16 RelayCoilCount = 4;

struct ServerInfo
{
    quint8 address = 0;
    quint8 serverId = 0;
    bool running = false;
    QString model;
};

QByteArray makeReportServerId(quint8 address);
bool takeServerIdResponse(QByteArray &buffer, quint8 expectedAddress,
                          ServerInfo *server,
                          quint8 *exceptionCode = nullptr);

QByteArray makeReadInputRegisters(quint8 address, quint16 start,
                                  quint16 count);

QByteArray makeReadRelayStates(quint8 address);
bool takeReadRelayStatesResponse(QByteArray &buffer, quint8 expectedAddress,
                                 quint8 *relayMask,
                                 quint8 *exceptionCode = nullptr);

/*
 * Consumes one Modbus RTU response from buffer. Returns true only when a
 * complete, CRC-valid normal or exception response has been decoded.
 */
bool takeReadInputResponse(QByteArray &buffer, quint8 expectedAddress,
                           QVector<quint16> *values,
                           quint8 *exceptionCode = nullptr);

quint16 crc16(const QByteArray &data);

} // namespace LoraModbusProtocol

#endif // LORA_MODBUS_PROTOCOL_H
