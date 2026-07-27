#ifndef USER_TCPSERVER_H
#define USER_TCPSERVER_H
#include <QTcpSocket> //仅需通信套接字
#include <QTcpServer>
#include <QSerialPort>
#include <QTimer>
#include <QTime>
#include <QThread>
#include <QString>
#include <QHash>
#include "user_global_param.h"
#include "DeviceDataStr.h"
#include "lora_modbus_protocol.h"
class user_tcpserver: public QObject
{
        Q_OBJECT
 //  Q_PROPERTY( READ TcpServerListen)
public:
    void serversocket_Send_ReadData(QString  qslmac, quint16 RegAddr, quint8 cmd, quint8 RegNum,quint16 Tocken);
    void serversocket_Send_ReturnData(QString  qslmac, quint16 RegAddr, quint8 cmd, quint8 Result,quint16 Tocken);
    QString timertaskcontrol(void);
    QString  timertaskdelaycontrol();
    QString quickcontrolhandle();
    QString quickcontroldelayhandle();
    explicit user_tcpserver(QObject *parent = nullptr);
    Q_INVOKABLE void serversocket_Send_WriteData(QString  qslmac, quint16 RegAddr, quint8 cmd, quint8 RegNum,QString DataParam, quint16 Tocken);//写数;//写数据
    Q_INVOKABLE void SetRangeHandle(QString macstr,QString chcontrilname,QString MaxCurr,QString Minvolt,QString Maxvolt,QString MaxTemp);
    Q_INVOKABLE void tcpServerListen();//服务器监听函数
    Q_INVOKABLE void serversocket_Disconnected();
    Q_INVOKABLE void timetasktotrigger(QString timetaskname,QString planstr,QString weekstr,QString timestr,QString holiddays,QString swstate,QString oprkind,QString oldpanname);
    Q_INVOKABLE void quickcontrolqml(QString chname,QString chvalue,QString modelinx);
    Q_INVOKABLE QStringList availableLoraSerialPorts() const;
    Q_INVOKABLE bool openLoraSerialPort(const QString &portName,
                                        qint32 baudRate = 9600);
    Q_INVOKABLE void closeLoraSerialPort();
    Q_INVOKABLE QString currentLoraSerialPort() const;
    Q_INVOKABLE bool setLoraAnalogInputMode(const QString &mac,
                                            int channel,
                                            bool currentMode);
    Q_INVOKABLE bool synchronizeLoraTerminalClock(const QString &mac);
  //  Q_INVOKABLE QString user_tcpserver::qmlsenddatatodev();
   // void TcpServerStopListen();//停止监听
    QTcpServer* tcpserver;
    QTcpSocket* tcpsocket[100];//最多支持100个TCP连接
    QTcpSocket* sqltcpsocket[100];//最多支持100个TCP连接
    QTimer *timerTask;
    QTimer *timerTaskedit;
    QTimer *loraTimer;
    QSerialPort *loraSerialPort;
    DeviceDataStr *DeviceDataStr_obj[100];
signals:
// Q_INVOKABLE   void QmlModelShowData(quint8 qmlcmd,quint8 qmldatanum,QString *measuredata);
    void QmlModelShowData(quint8 qmlcmd,QString qmlIpstr,QString qmlmacstr,QStringList  qmldatastr,quint8 alarmled);
    void deleqmlshowmodel(QString ipstr);
    void alarmmessagetoqml(QString alarmname,QString Placestr,QString alarmvalue,QString alarmtime);
    void updataquickmodelqml(QString macstr);
    void cppsigneltoqmlhandle(QString macstr,quint16 regaddr,quint8 cmd,quint8 regnum,QString value,quint16 token);
    void chargequiccontrolstate(QString inst,QString statesw);
    void loraSerialStatusChanged(bool opened, QString message);
    void loraClockSyncFinished(QString mac, bool success, QString message);
private slots:
    void user_server_New_Connect();
    void serversocker_Retrun_Data();
    void timerUpDate();
    void loraTimerUpdate();
    void loraSerialReadyRead();
    void loraSerialError(QSerialPort::SerialPortError error);
  //  void timertaskcontrol();
private:
    struct LoraTerminalEndpoint {
        QIODevice *transport = nullptr;
        quint8 modbusAddress = 0;
        quint8 pollPhase = 0;
    };
    enum class LoraRequestKind {
        None,
        Discovery,
        ReadInputs,
        ReadRelayStates,
        ReadDigitalInputs,
        WriteAnalogMode,
        WriteClock
    };

    void processLegacyData(QTcpSocket *socket, const QByteArray &data);
    bool processLoraModbusData(QIODevice *transport, const QByteArray &data);
    void sendNextLoraDiscovery();
    void pollNextLoraTerminal();
    bool sendPendingLoraAnalogMode();
    bool sendPendingLoraClock();
    void handleLoraDiscovered(QIODevice *transport,
                              const LoraModbusProtocol::ServerInfo &server);
    void handleLoraPollResponse(const QString &mac,
                                const QVector<quint16> &registers);
    void handleLoraRelayStates(const QString &mac, quint8 relayMask);
    void handleLoraDigitalInputs(const QString &mac, quint8 inputMask);
    QString makeLoraTerminalId(QIODevice *transport, quint8 address) const;
    void handleLoraRequestTimeout();
    void setLoraTerminalOffline(const QString &mac);
    void removeLoraTransport(QIODevice *transport);
    bool loraTransportReady(QIODevice *transport) const;
    QString loraTransportIdentity(QIODevice *transport) const;
    QString loraTransportLabel(QIODevice *transport) const;
    void writeLoraFrame(QIODevice *transport, const QByteArray &frame);
    void restartLoraDiscovery();

    QHash<QIODevice *, QByteArray> loraModbusBuffers;
    QHash<QString, quint8> loraPollFailures;
    QHash<QString, LoraTerminalEndpoint> loraTerminals;
    QString loraPollingMac;
    QIODevice *loraPollingTransport = nullptr;
    quint8 loraPollingAddress = 0;
    int loraPollingIndex = 0;
    quint16 loraDiscoveryAddress = 1;
    int loraDiscoverySocketIndex = 0;
    int loraRescanCountdown = 0;
    bool loraDiscoveryActive = true;
    bool loraDiscoveryTurn = true;
    QString loraPendingModeMac;
    int loraPendingModeChannel = -1;
    bool loraPendingCurrentMode = false;
    QString loraPendingClockMac;
    QVector<quint16> loraPendingClockValues;
    int loraPendingClockAttempts = 0;
    LoraRequestKind loraRequestKind = LoraRequestKind::None;
};

#endif // USER_TCPSERVER_H
