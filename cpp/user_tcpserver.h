#ifndef USER_TCPSERVER_H
#define USER_TCPSERVER_H
#include <QTcpSocket> //仅需通信套接字
#include <QTcpServer>
#include <QTimer>
#include <QTime>
#include <QThread>
#include <QString>
#include "user_global_param.h"
#include "DeviceDataStr.h"
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
  //  Q_INVOKABLE QString user_tcpserver::qmlsenddatatodev();
   // void TcpServerStopListen();//停止监听
    QTcpServer* tcpserver;
    QTcpSocket* tcpsocket[100];//最多支持100个TCP连接
    QTcpSocket* sqltcpsocket[100];//最多支持100个TCP连接
    QTimer *timerTask;
    QTimer *timerTaskedit;
    DeviceDataStr *DeviceDataStr_obj[100];
signals:
// Q_INVOKABLE   void QmlModelShowData(quint8 qmlcmd,quint8 qmldatanum,QString *measuredata);
    void QmlModelShowData(quint8 qmlcmd,QString qmlIpstr,QString qmlmacstr,QStringList  qmldatastr,quint8 alarmled);
    void deleqmlshowmodel(QString ipstr);
    void alarmmessagetoqml(QString alarmname,QString Placestr,QString alarmvalue,QString alarmtime);
    void updataquickmodelqml(QString macstr);
    void cppsigneltoqmlhandle(QString macstr,quint16 regaddr,quint8 cmd,quint8 regnum,QString value,quint16 token);
    void chargequiccontrolstate(QString inst,QString statesw);
private slots:
    void user_server_New_Connect();
    void serversocker_Retrun_Data();
    void timerUpDate();
  //  void timertaskcontrol();
};

#endif // USER_TCPSERVER_H
