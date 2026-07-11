#include "user_global_param.h"
#include <QTcpSocket>//仅需通信套接字
QString user_global_param::DeviceName = "";
QString user_global_param::DeviceIP ;
QString user_global_param::DeviceMAC ;
QString user_global_param::DeviceVer = "";
QString user_global_param::DeviceGetWay = "";
QString user_global_param::DeviceMask = "";
quint8  user_global_param:: DeviceDHCP;        //动态主机配置协议
quint8  user_global_param::DeviceCOMHands;   //串口协商配置
quint8  user_global_param::NetType;         //标识模块处于哪种模式(TCP/UDP Server/client)
quint8 user_global_param::NetPortState;  //本地端口失能否
QString user_global_param::NetsrcPort;  //源端口
quint8  user_global_param::IPDomainChoose;//IP和域名选择
QString user_global_param::ServerIP;         //目的IP
QString user_global_param::ServerPort;  //目的端口

QString user_global_param::NetCOM_baud;  //串口波特率
QString user_global_param::NetCOM_databit;  //串口数据位
QString user_global_param::NetCOM_stopbit;  //串口停止位
quint8 user_global_param::NetCOM_Checkbit;  //串口校验位
quint8 user_global_param::NetClose_Flag;  //关闭网络连接
QString user_global_param::NetRX_Len;//RX打包包长度
QString user_global_param::NetRX_Outtime;//RX打包超时
quint8 user_global_param::NetConnectClearData;//清空串口数据


QString user_global_param::SetDeviceMAC;
QString user_global_param::SetDeviceIP;
QByteArray user_global_param::UDPReadSendDataBuf;//UDP收到发送数组
quint8 user_global_param::UdpNetReadCmd = 0;
bool user_global_param::m_isOpenMatlabEngine = 1;
bool user_global_param::Tcp_isOpenMatlabEngine = 1;
//TCP服务器创建连接以及数据通信
QString user_global_param::allClientsIP[100];
QString user_global_param::allClientsMac[100];//客户端MAC地址
QString user_global_param:: allClientsPort[100];//客户端端口号保存
QString user_global_param:: allClientsIpPort[100];//客户端端口号保存
quint8  user_global_param:: ClientNum;//客户端数量
quint8 user_global_param::  ClientWorking;
quint8 user_global_param::   WClientWorking;
quint8 user_global_param:: MsgKind;//消息种类 1-监听成功
quint16  user_global_param::  DataCmd;

quint8 user_global_param::ServerSend_buf[50]; //服务器发送函数
quint8 user_global_param::ServerSend_buflen;//服务器发送数据长度

//设备数据
QString user_global_param::Device_Volt;
QString user_global_param::Device_Temp;
QString user_global_param::Device_Curr[11][9];//设备电流
quint8 user_global_param:: Device_State[11][9];//设备线路状态
quint8 user_global_param:: Device_MAC[11][10];//设备MAC
quint8 user_global_param:: Device_CurrAlarm[11][9];//电流告警信息
quint8 user_global_param:: Device_VoltAlarm[11][9];//电压告警信息
quint8 user_global_param:: Device_TempAlarm;//温度告警信息
quint8 user_global_param:: Device_PowerAlarm;//功率告警信息
//获取配置时间
quint8 user_global_param::SetTime1EnableFlag = 0;
quint8 user_global_param::SetTime2EnableFlag = 0;
quint8 user_global_param::SetTime3EnableFlag = 0;
quint8 user_global_param::SetTime4EnableFlag = 0;
quint8 user_global_param::SetTime5EnableFlag = 0;
quint8 user_global_param::SetTime6EnableFlag = 0;
quint8 user_global_param::SetTime7EnableFlag = 0;
quint8 user_global_param::SetTime8EnableFlag = 0;
quint8 user_global_param::SetTimeSingleOpen1Flag = 0;
quint8 user_global_param::SetTimeSingleOpen2Flag = 0;
quint8 user_global_param::SetTimeSingleOpen3Flag = 0;
quint8 user_global_param::SetTimeSingleOpen4Flag = 0;
quint8 user_global_param::SetTimeSingleOpen5Flag = 0;
quint8 user_global_param::SetTimeSingleOpen6Flag = 0;
quint8 user_global_param::SetTimeSingleOpen7Flag = 0;
quint8 user_global_param::SetTimeSingleOpen8Flag = 0;
QString user_global_param::SetTime1L;
QString user_global_param::SetTime1H;
QString user_global_param::SetTime2L;
QString user_global_param::SetTime2H;
QString user_global_param::SetTime3L;
QString user_global_param::SetTime3H;
QString user_global_param::SetTime4L;
QString user_global_param::SetTime4H;
QString user_global_param::SetTime5L;
QString user_global_param::SetTime5H;
QString user_global_param::SetTime6L;
QString user_global_param::SetTime6H;
QString user_global_param::SetTime7L;
QString user_global_param::SetTime7H;
QString user_global_param::SetTime8L;
QString user_global_param::SetTime8H;

quint8 user_global_param::Timetempi1 = 0;
quint8 user_global_param::Timetempi2 = 0;
quint8 user_global_param::Timetempi3 = 0;
quint8 user_global_param::Timetempi4 = 0;
quint8 user_global_param::Timetempi5 = 0;
quint8 user_global_param::Timetempi6 = 0;
quint8 user_global_param::Timetempi7 = 0;
quint8 user_global_param::Timetempi8 = 0;
quint8 user_global_param::TimerNull;

quint8 user_global_param:: TimerProi;

//界面顺序IP保存
QString user_global_param::InterfaceIPSaveSort[11];//
//远程升级
quint16 user_global_param::BIN_Buf[50 * 1024];
quint32 user_global_param::BIN_Len;
quint8  user_global_param::OTA_Updata_Flag;
quint16 user_global_param::OTA_CRC;
quint16 user_global_param::BIN_SendCont;
//TCP参数
 QTcpSocket* user_global_param:: tcpsocket_OTA[20];
 quint8 user_global_param:: OTA_Updata_Flag_Pro;
//UDP参数
QString user_global_param::Udp_IP;
//设备类型
 quint8 user_global_param::Drive_CH_Num;
 quint8 user_global_param::Drive_init_falg;
//qml和c++
 quint8 user_global_param::sendVITrangeflag = 0;
 QString user_global_param::sqlsenddatamac[100];
 QString user_global_param::sqlmaxcurrent;
 QString user_global_param::sqlminvolt;
 QString user_global_param::sqlmaxvolt;
 QString user_global_param::sqlmaxtemp;
 QString user_global_param::sqlmactemp;
 QStringList user_global_param::sqlmaclist;
 QStringList user_global_param::sqlchlist;
 QStringList user_global_param::sqlroomlist;
 QString user_global_param::timestrqml;
 QString user_global_param::holiddays;
 QString user_global_param::weekqml;
 QString user_global_param::swstate;
 QString user_global_param::planname;
 quint8 user_global_param::starttimetaskfalg = 0;
 QString user_global_param::timetaskmac[100];
 qint16 user_global_param::timetasktimecountdowm[100];
 qint32 user_global_param::timetasktimeoldswstate[100];
 quint16 user_global_param::total_dev_count_show;
  quint16 user_global_param::total_old_dev_count_show;
 quint8 user_global_param::quickcontrolflag;
 quint8 user_global_param::quickcontrolflagstart = 0;
 QString user_global_param::quickcontrolmacbuf;
 QString user_global_param::quickcontrolplanname;
 QString user_global_param::quickcontrolchvalue;
 QString user_global_param::quickcontroldelay;
 quint16 user_global_param::quickdelayctrstate1[50];
 quint16 user_global_param::quickdelayctrstate2[50];
