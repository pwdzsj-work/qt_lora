#ifndef USER_GLOBAL_PARAM_H
#define USER_GLOBAL_PARAM_H
#include <QString>
#include <QTcpSocket>//仅需通信套接字
class user_global_param
{
public:
    //模块配置结构体
    static QString DeviceName;          //设备名称
    static QString DeviceIP;         //设备IP
    static QString DeviceMAC;        //设备MAC
    static QString DeviceVer;      //设备版本
    static QString DeviceMask;      //子网掩码
    static QString DeviceGetWay;      //网关地址
    static quint8  DeviceDHCP;        //动态主机配置协议
    static quint8  DeviceCOMHands;        //串口协商配置
    static quint8  NetType;         //标识模块处于哪种模式(TCP/UDP Server/client)
    static quint8 NetPortState;  //本地端口失能否
    static QString NetsrcPort;  //源端口
    static quint8  IPDomainChoose;//IP和域名选择
    static QString ServerIP;         //目的IP
    static QString ServerPort;  //目的端口

    static QString NetCOM_baud;  //串口波特率
    static QString NetCOM_databit;  //串口数据位
    static QString NetCOM_stopbit;  //串口停止位
    static quint8 NetCOM_Checkbit;  //串口校验位
    static quint8 NetClose_Flag;  //关闭网络连接
    static QString NetRX_Len;//RX打包包长度
    static QString NetRX_Outtime;//RX打包超时
    static quint8 NetConnectClearData;//清空串口数据

    static QString SetDeviceMAC;  //设置
    static QString SetDeviceIP;  //设置
    static QByteArray UDPReadSendDataBuf;//UDP收到发送
    static quint8 UdpNetReadCmd;           //Tools工具获取设备信息功能码
    static bool   m_isOpenMatlabEngine; 
    static bool   Tcp_isOpenMatlabEngine;
//TCP服务器创建连接以及数据通信
    static QString allClientsIP[100];//客户端IP保存
    static QString allClientsMac[100];//客户端MAC地址
    static QString allClientsPort[100];//客户端端口号保存
     static QString allClientsIpPort[100];//客户端端口号保存
    static quint8  ClientNum;//客户端数量
    static quint8  ClientWorking;//当前通讯的客户端
    static quint8  WClientWorking;//当前写客户通讯的客户端
    static quint8   MsgKind;//消息种类 1-监听成功
    static quint16   DataCmd;//接收数据功能码

    static quint8 ServerSend_buf[50]; //服务器发送数据
    static quint8 ServerSend_buflen;//服务器发送数据长度
//设备数据
    static QString Device_Volt;//设备电压值
    static QString Device_Temp;//设备温度值
    static QString Device_Curr[11][9];//设备电流
    static quint8 Device_State[11][9];//设备线路状态
    static quint8 Device_MAC[11][10];//MAC地址
    static quint8 Device_CurrAlarm[11][9];//电流告警信息
    static quint8 Device_VoltAlarm[11][9];//电压告警信息
    static quint8 Device_TempAlarm;//温度告警信息
    static quint8 Device_PowerAlarm;//功率告警信息
//获取配置时间
    static quint8 SetTime1EnableFlag;
    static quint8 SetTime2EnableFlag;
    static quint8 SetTime3EnableFlag;
    static quint8 SetTime4EnableFlag;
    static quint8 SetTime5EnableFlag;
    static quint8 SetTime6EnableFlag;
    static quint8 SetTime7EnableFlag;
    static quint8 SetTime8EnableFlag;
    static quint8 SetTimeSingleOpen1Flag;
    static quint8 SetTimeSingleOpen2Flag;
    static quint8 SetTimeSingleOpen3Flag;
    static quint8 SetTimeSingleOpen4Flag;
    static quint8 SetTimeSingleOpen5Flag;
    static quint8 SetTimeSingleOpen6Flag;
    static quint8 SetTimeSingleOpen7Flag;
    static quint8 SetTimeSingleOpen8Flag;
    static QString SetTime1L;
    static QString SetTime1H;
    static QString SetTime2L;
    static QString SetTime2H;
    static QString SetTime3L;
    static QString SetTime3H;
    static QString SetTime4L;
    static QString SetTime4H;
    static QString SetTime5L;
    static QString SetTime5H;
    static QString SetTime6L;
    static QString SetTime6H;
    static QString SetTime7L;
    static QString SetTime7H;
    static QString SetTime8L;
    static QString SetTime8H;

    static quint8 Timetempi1;
    static quint8 Timetempi2;
    static quint8 Timetempi3;
    static quint8 Timetempi4;
    static quint8 Timetempi5;
    static quint8 Timetempi6;
    static quint8 Timetempi7;
    static quint8 Timetempi8;
    static quint8 TimerNull;

    static quint8 TimerProi;
//界面顺序IP保存
    static QString InterfaceIPSaveSort[11];
//远程升级
    static quint16 BIN_Buf[50 * 1024];
    static quint32  BIN_Len;
    static quint16  BIN_SendCont;
    static quint8 OTA_Updata_Flag;
    static quint16 OTA_CRC;
//TCP
static QTcpSocket* tcpsocket_OTA[20];
static quint8 OTA_Updata_Flag_Pro;
static quint8 Drive_init_falg;
//UDP
    static QString Udp_IP;
//设备类型
    static quint8 Drive_CH_Num;

    static quint8 sendVITrangeflag;
    static QString sqlsenddatamac[100];
    static QStringList sqlroomlist;
    static QStringList sqlmaclist;
     static QStringList sqlchlist;
   static  QString sqlmaxcurrent;
   static  QString sqlminvolt;
    static QString sqlmaxvolt;
    static QString sqlmaxtemp;
   static  QString sqlmactemp;
   static QString timestrqml;
 static  QString holiddays;
 static  QString weekqml;
  static  QString swstate;
  static  QString planname;
  static  quint8 starttimetaskfalg;
 static QString timetaskmac[100];
 static qint16 timetasktimecountdowm[100];
  static qint32 timetasktimeoldswstate[100];
 static  quint16 total_dev_count_show;
 static  quint16 total_old_dev_count_show;
 static quint8 quickcontrolflag;
 static quint8 quickcontrolflagstart;
 static QString quickcontrolmacbuf;
 static QString quickcontrolplanname;
 static QString quickcontrolchvalue;
 static QString quickcontroldelay;
 static quint16 quickdelayctrstate1[50];
 static quint16 quickdelayctrstate2[50];
};
#endif // USER_GLOBAL_PARAM_H
