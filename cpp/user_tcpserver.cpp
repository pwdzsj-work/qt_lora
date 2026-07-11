#include "user_tcpserver.h"
#include "user_global_param.h"
#include <QLibrary>
#include <qtextcodec.h>
#include <QtGlobal>
#include <QJsonParseError>
#include <QJsonObject>
#include <QJsonArray>
#include <qjsonarray.h>
#include <QString>
#include <QSqlDatabase>
#include <QSqlError>
#include <QMessageBox>
#include "sqlitefun.h"
user_tcpserver :: user_tcpserver(QObject *parent):  QObject(parent)
{
    tcpserver= new QTcpServer(this);
    tcpsocket[user_global_param::ClientNum]= new QTcpSocket(this);
    tcpsocket[user_global_param::ClientNum]->abort();
    timerTask = new QTimer(this);
    timerTaskedit = new QTimer(this);
    //连接信号槽
    connect(tcpserver,&QTcpServer::newConnection,this,&user_tcpserver::user_server_New_Connect);
    connect(timerTask,SIGNAL(timeout()),this,SLOT(timerUpDate()));

    for(quint8 i = 0; i < 100; i ++)
    {
        DeviceDataStr_obj[i] = new DeviceDataStr();//初始化
        for(quint8 j = 0; j  < 100; j ++)
        {
            DeviceDataStr_obj[i]->Device_ID[j] = 0;
        }
        DeviceDataStr_obj[i]->DeviceKind = 0;
        DeviceDataStr_obj[i]->Device_SW_State= 0;
        DeviceDataStr_obj[i]->Device_IP = "";
        DeviceDataStr_obj[i]->Device_Temp = "";
        DeviceDataStr_obj[i]->Device_Name = "";
        for(quint8 j = 0; j  < 32; j ++)
        {
            DeviceDataStr_obj[i]->Device_Volt[j] = "";
            DeviceDataStr_obj[i]->Device_Current[j] = "";
        }
    }
}
void user_tcpserver::tcpServerListen()
{
    qDebug() << "Roger Test Beging..............";
    //监听指定的端口
    if(!tcpserver->listen(QHostAddress::Any, 11211))
    {
        return;
    }
}
void user_tcpserver::user_server_New_Connect()
{
    tcpsocket[user_global_param::ClientNum] = tcpserver->nextPendingConnection();
    DeviceDataStr_obj[user_global_param::ClientNum]->Device_IP = tcpsocket[user_global_param::ClientNum]->peerAddress().toString().remove(0, 7);
    //获取客户端连接QString:: asprintf("%0.1f",Datalist[i].toUInt(nullptr, 16) / 100.0);
    user_global_param::allClientsIP[user_global_param::ClientNum] = tcpsocket[user_global_param::ClientNum]->peerAddress().toString().remove(0, 7); //保存客户端IP
    user_global_param::allClientsPort[user_global_param::ClientNum] = QString:: asprintf("%d", tcpsocket[user_global_param::ClientNum]->peerPort());//保存客户端IP
    user_global_param:: allClientsIpPort[user_global_param::ClientNum] = user_global_param::allClientsIP[user_global_param::ClientNum] + "+" + user_global_param::allClientsPort[user_global_param::ClientNum];
    //连接QTcpSocket的信号槽，以读取新数据
    QObject::connect(tcpsocket[user_global_param::ClientNum], &QTcpSocket::readyRead, this, &user_tcpserver::serversocker_Retrun_Data);
    QObject::connect(tcpsocket[user_global_param::ClientNum], &QTcpSocket::disconnected, this, &user_tcpserver::serversocket_Disconnected);
    user_global_param::ClientNum ++;
    if (timerTask->isActive() == false)
    {
        timerTask->start(2000);
    }

}
void user_tcpserver::serversocket_Disconnected()//断开连接
{
    sqlitefun *sqlitefunobj = nullptr;
    QTcpSocket *obj = (QTcpSocket*)sender();
    QString toqmlIpstr = obj->QAbstractSocket::peerAddress().toString().remove(0, 7) + "+" + QString:: asprintf("%d",obj->QAbstractSocket::peerPort());
    QString currentdel_id  = sqlitefunobj->findsqldataID("devdata","dev_ip",toqmlIpstr);
    sqlitefunobj->updaterowdata("devdata","dev_linestate","0",currentdel_id.toUInt(nullptr,10));//初始化在线状态
    emit  deleqmlshowmodel(toqmlIpstr);
}
void user_tcpserver::serversocker_Retrun_Data()
{
    QString MsgdataRevDivStr;//设备返回数据，经过SDK的API函数处理返回字符串
    QTcpSocket *obj = (QTcpSocket*)sender();
    QByteArray TcpReadMsg = obj->readAll();//TCP获取设备原始数据
    quint8 TcpReadMsgToByteBuf[1024];
    quint8 UniqueID[10];//设备唯一ID
    QStringList IDList;
    QStringList Datalist;
    quint16 ParRegAddr = 0;//解析后的寄存器地址
    QString ParDatastr;//解析后的数据
    QLibrary mylib("universalprotocalinter.dll");   //声明所用到的dll文件
    quint8 toqmlcmd = 0;
    QStringList  toqmldatastr;
    QString test_temp;
    sqlitefun *sqlitefunobj = nullptr;
    QString sql_macstru = "";
    QString sql_485addr = "";
    QString sql_kindstr = "";
    QString sql_retrunreslut = "";
    quint8 sql_idvalue = 0;
    QString sql_inits = "";
    QString sql_dev_chvolt = "";
    QString sql_dev_totalcurr = "";
    QString sql_dev_inputvolt = "";
    quint8 sql_chnum = 0;
    QString alarmnamestr = "";

    QString swstate1tosql = "";
    QString swstate2tosql = "";
    quint16 swstateint1tosql = 0;
    quint16 swstateint2tosql = 0;
    QStringList hardvaretosqlbuf;
    QString softvaretosql1;
    QString softvaretosql2;
    QString softvaretosql3;
    QString hardvaretosql1;
    QString hardvaretosql2;
    QStringList softvaretosqlbuf;
    QString sqlstate1tosql;
    QString sqlstate2tosql;
    QString devidmatosql;
    QString kindtosql;
    qint64  devtotalcurr = 0;
    QString devtotalcurrstr = "";
    QString closetimestr = "";
    quint16 Tokenuint = 0;
    if(TcpReadMsg.size() < 25) return;
    //接收数据处理
    memcpy(TcpReadMsgToByteBuf,TcpReadMsg,TcpReadMsg.size());
    memcpy(UniqueID,&TcpReadMsgToByteBuf[4],10);
    Tokenuint = TcpReadMsgToByteBuf[TcpReadMsg.size() - 6] * 256 + TcpReadMsgToByteBuf[TcpReadMsg.size() - 5];
    //SDK函数声明
    typedef const char* (*Fun_R)(uint8_t* revbuf, uint16_t recvCount);
    typedef const char* (*Fun_W)(quint8* UniqueIDbuf, quint16 RegAddr, quint8 cmd,quint8 Result, quint16 Tocken);
    typedef const char* (*Fun_WR)( uint8_t *UniqueIDbuf, uint16_t RegAddr, uint8_t Cmd,  uint8_t RegNum, uint16_t Tocken);
    typedef const char* (*Fun_SW)(quint8* UniqueIDbuf, quint16 RegAddr, quint8 cmd,quint8 RegNum, quint16* DataParam, quint16 Tocken);
    //判断DLL是否加载成功
    if(mylib.load())
    {
        Fun_R BY_MsgRecvByTCP = (Fun_R)mylib.resolve("BY_MsgRecvByTCP");    //援引 BY_WriteRegValue() 函数
        Fun_W BY_ReturnDataToDrive = (Fun_W)mylib.resolve("BY_ReturnDataToDrive");    //援引 BY_WriteRegValue() 函数
        Fun_WR BY_ReadRegValue = (Fun_WR)mylib.resolve("BY_ReadRegValue");    //援引 BY_WriteRegValue() 函数
        Fun_SW BY_WriteRegValue = (Fun_SW)mylib.resolve("BY_WriteRegValue");    //援引 BY_WriteRegValue() 函数
        if(BY_MsgRecvByTCP && BY_ReturnDataToDrive && BY_ReadRegValue && BY_WriteRegValue)//函数解析成功，干活
        {
            QString sql_datastr;
            QString sql_columns;
            MsgdataRevDivStr = BY_MsgRecvByTCP(TcpReadMsgToByteBuf,TcpReadMsg.size());//获取经过API函数解析的数据
            QString toqmlIpstr = obj->QAbstractSocket::peerAddress().toString().remove(0, 7) + "+" + QString:: asprintf("%d", obj->QAbstractSocket::peerPort());;
            QString  toqmlmacstr = MsgdataRevDivStr.mid(11,17);
            ParRegAddr = MsgdataRevDivStr.mid(41,4).toUInt(nullptr, 16);
            IDList = MsgdataRevDivStr.mid(9,29).split("-");
            Datalist = MsgdataRevDivStr.mid(50,MsgdataRevDivStr.length() - 50).split("-");
            sql_macstru = MsgdataRevDivStr.mid(11, 17);//获取MAC地址
            sql_485addr = MsgdataRevDivStr.mid(29, 2);//获取485地址
            sql_retrunreslut = sqlitefunobj->findsqldataID("devdata","dev_mac",sql_macstru);
            if(sql_retrunreslut != "FAIL" && sql_retrunreslut != "NONE")
            {//更新
                sql_idvalue = sql_retrunreslut.toInt();
                for(quint8 ty = 0; ty < user_global_param::ClientNum;ty ++)
                {
                    if(user_global_param::allClientsIpPort[ty] == toqmlIpstr)
                    {
                        sqltcpsocket[sql_idvalue] = tcpsocket[ty];
                    }
                }
                sqlitefunobj->updaterowdata("devdata","dev_485adr",sql_485addr,sql_idvalue);//更新485数据
                sqlitefunobj->updaterowdata("devdata","dev_ip",toqmlIpstr,sql_idvalue);//更新IP数据
                sqlitefunobj->updaterowdata("devdata","dev_linestate","1",sql_idvalue);//初始化在线状态
            }
            else
            {//创建
                if((TcpReadMsg[19] & 0xff) == 1) sql_chnum = 4;
                else if((TcpReadMsg[19] & 0xff) == 2) sql_chnum = 8;
                else if((TcpReadMsg[19] & 0xff) == 3 || (TcpReadMsg[19] & 0xff) == 6) sql_chnum = 16;
                else if((TcpReadMsg[19] & 0xff) == 4) sql_chnum = 32;
                else return;
                sqlitefunobj->nOIDinsterweizhidata("devdata","dev_mac",sql_macstru);
                sql_retrunreslut = sqlitefunobj->findsqldataID("devdata","dev_mac",sql_macstru);
                if(sql_retrunreslut == "FAIL" || sql_retrunreslut == "NONE") return;
                sql_idvalue = sql_retrunreslut.toInt();
                for(quint8 ty = 0; ty < user_global_param::ClientNum;ty ++)
                {
                    if(user_global_param::allClientsIpPort[ty] == toqmlIpstr)
                    {
                        sqltcpsocket[sql_idvalue] = tcpsocket[ty];
                    }
                }
                QString strchname = "";
                QString stcchname_i = "";
                sql_dev_totalcurr = "---";
                for(quint8 iu = 0; iu < sql_chnum; iu ++)
                {
                    if((TcpReadMsg[19] & 0xff) == 6)//设备非PDU为十六路智能TDM开关
                    {
                        sql_inits += "---";
                        sql_dev_chvolt  += "---";
                    }
                    else
                    {
                        sql_inits += "0";
                        sql_dev_chvolt+= "0";
                        closetimestr += "00";
                    }
                    stcchname_i =QString:: asprintf("%d",(1 + iu));
                    strchname += "CH"+stcchname_i;
                    if(iu != (sql_chnum - 1))
                    {
                        sql_inits += "#";
                        sql_dev_chvolt += "#";
                        strchname += "#";
                        closetimestr += "#";
                    }

                }
                sqlitefunobj->updaterowdata("devdata","dev_485adr",sql_485addr,sql_idvalue);//更新485数据
                sqlitefunobj->updaterowdata("devdata","dev_chcurr",sql_inits,sql_idvalue);//初始化电流
                sqlitefunobj->updaterowdata("devdata","dev_chvolt",sql_dev_chvolt,sql_idvalue);//初始化电压
                sqlitefunobj->updaterowdata("devdata","dev_inputvolt","---",sql_idvalue);//初始化电压
                sqlitefunobj->updaterowdata("devdata","dev_ip",toqmlIpstr,sql_idvalue);//更新IP数据
                sqlitefunobj->updaterowdata("devdata","dev_name","101",sql_idvalue);//初始化房间号
                sqlitefunobj->updaterowdata("devdata","dev_temp","---",sql_idvalue);//初始化温度
                sqlitefunobj->updaterowdata("devdata","dev_totalcurr","---",sql_idvalue);//初始化设备电流
                sqlitefunobj->updaterowdata("devdata","dev_linestate","1",sql_idvalue);//初始化在线状态
                sqlitefunobj->updaterowdata("devdata","dev_chname",strchname,sql_idvalue);//通道命名
                sqlitefunobj->updaterowdata("devdata","dev_closetime",closetimestr,sql_idvalue);//通道命名
                //
            }
            user_global_param::allClientsMac[sql_idvalue] = sql_macstru;
            for(quint16 reg = ParRegAddr; reg < ParRegAddr + (MsgdataRevDivStr.mid(50,MsgdataRevDivStr.length() - 50).length() / 4);reg ++)
            {
                switch(reg)
                {

                case 0x0001://电压
                    toqmlcmd = 1;
                    for(quint8 i = 0; i < Datalist.length(); i ++)
                    {
                        test_temp =QString:: asprintf("%0.1f",Datalist[i].toUInt(nullptr, 16) / 100.0);
                        toqmldatastr.append(test_temp);
                        if(i == Datalist.length() - 1)
                        {
                            sql_datastr += test_temp;
                        }
                        else
                        {
                            sql_datastr += test_temp + "#";
                        }
                        sql_columns = "dev_chvolt";
                    }
                    break;
                case 0x0064://电流
                    if(Datalist.length() == 1) return;
                    toqmlcmd = 2;

                    for(quint8 i = 0; i < Datalist.length(); i ++)
                    {
                        if(Datalist.length() == 4)
                        {
                            test_temp =QString:: asprintf("%0.1f",Datalist[i].toUInt(nullptr, 16) / 1000.0);
                            devtotalcurr += Datalist[i].toUInt(nullptr, 16) ;
                        }
                        else
                        {
                            test_temp =QString:: asprintf("%0.1f",Datalist[i].toUInt(nullptr, 16) / 100.0);
                            devtotalcurr += Datalist[i].toUInt(nullptr, 16) ;
                        }

                        toqmldatastr.append(test_temp);
                        if(i == Datalist.length() - 1)
                        {
                            sql_datastr += test_temp;
                        }
                        else
                        {
                            sql_datastr += test_temp + "#";
                        }
                    }
                    sql_columns = "dev_chcurr";
                    if(Datalist.length() == 4)
                    {
                        devtotalcurrstr =QString:: asprintf("%0.1f",devtotalcurr/ 1000.0);
                    }
                    else
                    {
                        devtotalcurrstr =QString:: asprintf("%0.1f",devtotalcurr/ 100.0);
                    }

                    break;
                case 0x00C9://温度
                    if(Datalist.length() < (ParRegAddr - 0xC9))return;
                    toqmlcmd = 3;

                    test_temp =QString:: asprintf("%0.1f",Datalist[ParRegAddr - 0xC9].toUInt(nullptr, 16) / 100.0);
                    toqmldatastr.append(test_temp);
                    sql_datastr += test_temp;
                    sql_columns = "dev_temp";
                    break;
                case 0x022C: //获取线路状态1-16
                    devidmatosql  = sqlitefunobj->findsqldataID("devdata","dev_mac",toqmlmacstr);
                    kindtosql    = sqlitefunobj->findsqldata("devdata","dev_kind",devidmatosql.toUInt());
                    if(devidmatosql == "FAIL" || devidmatosql == "NONE") return;
                    if(kindtosql == "FAIL" || kindtosql == "NONE") return;
                    swstate1tosql = MsgdataRevDivStr.mid(50,4);
                    swstate2tosql = MsgdataRevDivStr.mid(55,4);
                    swstateint1tosql = swstate1tosql.toUInt(nullptr, 16);
                    swstateint2tosql = swstate2tosql.toUInt(nullptr, 16);
                    for(quint8 ki = 0; ki < kindtosql.toUInt();ki ++)
                    {
                        if(ki < 16)
                        {
                            if((swstateint1tosql >> ki) & 0x0001)
                            {
                                sqlstate1tosql += "1";
                            }
                            else
                            {
                                sqlstate1tosql += "0";
                            }
                            if(kindtosql.toUInt() <= 16)
                            {
                                if(ki != kindtosql.toUInt() - 1)
                                {
                                    sqlstate1tosql += "#";
                                }
                            }
                            else
                            {
                                if(ki != 15)
                                {
                                    sqlstate1tosql += "#";
                                }
                            }
                        }
                    }
                    if(kindtosql.toUInt() > 16)
                    {
                        for(quint8 ki = 0; ki < 16;ki ++)
                        {
                            if((swstateint2tosql >> ki) & 0x0001)
                            {
                                sqlstate2tosql += "1";
                            }
                            else
                            {
                                sqlstate2tosql += "0";
                            }
                            if(ki != 15)
                            {
                                sqlstate2tosql += "#";
                            }

                        }
                    }
                    sqlitefunobj->updaterowdata("devdata","dev_chswstate1",sqlstate1tosql,devidmatosql.toUInt());//修改一行数据
                    sqlitefunobj->updaterowdata("devdata","dev_chswstate2",sqlstate2tosql,devidmatosql.toUInt());//修改一行数据
                    break;
                case 0x022D: //获取线路状态17-32
                    break;
                case 0x036C://MAC地址
                    toqmlcmd = 6;
                    if((TcpReadMsg[19] & 0xff) == 1) sql_kindstr = "4";
                    if((TcpReadMsg[19] & 0xff) == 2) sql_kindstr = "8";
                    if((TcpReadMsg[19] & 0xff) == 3 || (TcpReadMsg[19] & 0xff) == 6) sql_kindstr = "16";
                    if((TcpReadMsg[19] & 0xff) == 4) sql_kindstr = "32";
                    for(quint8 ID_i = 0; ID_i < IDList.length(); ID_i ++)
                    {
                        DeviceDataStr_obj[sql_idvalue]->Device_ID[ID_i] =  IDList[ID_i].toUInt(nullptr, 16);
                    }
                    sqlitefunobj->updaterowdata("devdata","dev_kind",sql_kindstr,sql_idvalue);//更新kindstr数据
                    break;
                case 0x0376://软件版本号
                    devidmatosql  = sqlitefunobj->findsqldataID("devdata","dev_mac",toqmlmacstr);
                    if(devidmatosql == "FAIL" || devidmatosql == "NONE") return;
                    softvaretosqlbuf = MsgdataRevDivStr.mid(50,9).split("-");
                    if(softvaretosqlbuf.length() < 2)return;
                    softvaretosql1 =QString:: asprintf("%d",softvaretosqlbuf[0].toUInt(nullptr, 16));
                    softvaretosql2 =QString:: asprintf("%d",softvaretosqlbuf[1].mid(0,2).toUInt(nullptr, 16));
                    softvaretosql3 =QString:: asprintf("%d",softvaretosqlbuf[1].mid(2,2).toUInt(nullptr, 16));
                    sqlitefunobj->updaterowdata("devdata","dev_softver",("V" + softvaretosql1+"."+softvaretosql2+"."+softvaretosql3),devidmatosql.toUInt());
                    toqmlcmd = 7;
                    break;

                case 0x0378://硬件版本号
                    devidmatosql  = sqlitefunobj->findsqldataID("devdata","dev_mac",toqmlmacstr);
                    if(devidmatosql == "FAIL" || devidmatosql == "NONE") return;
                    hardvaretosqlbuf = MsgdataRevDivStr.mid(50,4).split("-");
                    if(hardvaretosqlbuf.length() == 0)return;
                    hardvaretosql1 =QString:: asprintf("%d",hardvaretosqlbuf[0].mid(0,2).toUInt(nullptr, 16));
                    hardvaretosql2 =QString:: asprintf("%d",hardvaretosqlbuf[0].mid(2,2).toUInt(nullptr, 16));
                    sqlitefunobj->updaterowdata("devdata","dev_hardver",("V" + hardvaretosql1+"."+hardvaretosql2),devidmatosql.toUInt());
                    toqmlcmd = 8;
                    break;
                case 0x0370://电流1告警
                    serversocket_Send_ReturnData(sql_macstru,0x0370,0xFE,1,Tokenuint);
                    alarmnamestr = "电流超限";
                    toqmlcmd = 9;
                    break;
                case 0x0371://电流2告警
                    alarmnamestr = "电流超限";
                    serversocket_Send_ReturnData(sql_macstru,0x0371,0xFE,1,Tokenuint);
                    toqmlcmd = 10;
                    break;
                case 0x0372://电压1告警
                    alarmnamestr = "电压超限";
                    serversocket_Send_ReturnData(sql_macstru,0x0372,0xFE,1,Tokenuint);
                    toqmlcmd = 11;
                    break;
                case 0x0373://电压2告警
                    serversocket_Send_ReturnData(sql_macstru,0x0373,0xFE,1,Tokenuint);
                    alarmnamestr = "电压超限";
                    toqmlcmd = 12;
                    break;
                case 0x0375://温度告警
                    serversocket_Send_ReturnData(sql_macstru,0x0375,0xFE,1,Tokenuint);
                    alarmnamestr = "温度超限";
                    toqmlcmd = 13;
                    break;
                case 0x038B://功率告警
                    serversocket_Send_ReturnData(sql_macstru,0x038B,0xFE,1,Tokenuint);
                    alarmnamestr = "功率告警";
                    toqmlcmd = 14;
                    break;
                default:

                    break;
                }
            }
            if(toqmlcmd == 0 || toqmlcmd > 5)
            {
                toqmldatastr.append("0");

            }
            if(sqlitefunobj->insertrowdata("devdata",sql_columns,sql_datastr,sql_idvalue) == "FAIL")
            {
                if( sql_columns == "dev_chvolt")
                {
                    sqlitefunobj->updaterowdata("devdata","dev_inputvolt",toqmldatastr[0],sql_idvalue);
                }
                if(sql_columns == "dev_chcurr")
                {
                    QString currentstr;
                    sqlitefunobj->updaterowdata("devdata","dev_totalcurr",devtotalcurrstr,sql_idvalue);
                }
                sqlitefunobj->updaterowdata("devdata",sql_columns,sql_datastr,sql_idvalue);
            }
            if(toqmlcmd > 8)//报警信息
            {
                toqmlcmd = 0;
                QString devid = sqlitefunobj->findsqldataID("devdata","dev_mac",toqmlmacstr);//获取id
                QString placesql = sqlitefunobj->findsqldata("devdata","dev_floor",devid.toUInt());
                QString devnamesql = sqlitefunobj->findsqldata("devdata","dev_name",devid.toUInt());
                if(devid == "FAIL" || devid == "NONE") return;
                if(devnamesql == "FAIL" || devnamesql == "NONE") return;
                QDateTime current_date_time = QDateTime::currentDateTime();
                QString temp_timer = current_date_time.toString("yyyy-MM-dd hh:mm:ss ddd");
                emit  alarmmessagetoqml(alarmnamestr,(placesql + "#" + devnamesql),"  ",temp_timer);
            }
            else
            {
                if(toqmlcmd != 0)
                {
                    QStringList toqmlipdata = toqmlIpstr.split("+");
                    emit  QmlModelShowData(toqmlcmd,toqmlipdata[0],toqmlmacstr,toqmldatastr,0);
                }

            }

        }
    }
}

void user_tcpserver::timerUpDate()//定时发送数据
{
    static quint8 temp_i = 0;
    static quint8 temp_j = 0;
    static quint8 sqltemp_i = 0;

    QString allmacstr = "";
    QStringList allmacstrbuf;
    QString allkindstr = "";
    QStringList allkindstrbuf;
    sqlitefun *sqlitefunobj = nullptr;
    static quint8 harddatasendendfalg = 0;
    if(harddatasendendfalg)
    {
        if(timertaskdelaycontrol() == "SUCCESS") return;//定时延时控制
        if(timertaskcontrol() == "SUCCESS" )//定时任务控制
        {
            return;
        }
        if(quickcontrolhandle() == "SUCCESS")//快捷控制
        {
            return;
        }
        if(quickcontroldelayhandle() == "SUCCESS")//快捷控制延时
        {
            return;
        }

    }



    if(user_global_param::sendVITrangeflag == 1 && harddatasendendfalg ==1 )
    {
        if(temp_j == 0)//电流范围
        {
            for(quint8 macnum = 0; macnum < user_global_param::sqlmaclist.length();macnum ++)
            {
                if(sqltemp_i % 2 > 0)
                {
                    serversocket_Send_WriteData(user_global_param::sqlmaclist[macnum],0x01C7 + user_global_param::sqlchlist[(sqltemp_i - 1)/ 2].toUInt(nullptr, 10),0x06,0x01,user_global_param::sqlmaxcurrent,0x0304);//最大电流发送
                }
             }
            sqltemp_i ++;
            if(sqltemp_i / 2 >= user_global_param::sqlchlist.length())
            {
                sqltemp_i = 0;
                temp_j = 1;
            }
        }
        else if(temp_j == 1)//最小电压
        {
            for(quint8 macnum = 0; macnum < user_global_param::sqlmaclist.length();macnum ++)
            {
                serversocket_Send_WriteData(user_global_param::sqlmaclist[macnum],0x0163 + user_global_param::sqlchlist[sqltemp_i].toUInt(nullptr, 10),0x06,0x01,user_global_param::sqlminvolt,0x0304);//最低电压发送
            }
            sqltemp_i ++;
            if(sqltemp_i >= user_global_param::sqlchlist.length() - 1)
            {
                sqltemp_i = 0;
                temp_j = 2;
            }

        }
        else if(temp_j == 2)//最大电压
        {
            for(quint8 macnum = 0; macnum < user_global_param::sqlmaclist.length();macnum ++)
            {
                serversocket_Send_WriteData(user_global_param::sqlmaclist[macnum],0x00FE + user_global_param::sqlchlist[sqltemp_i].toUInt(nullptr, 10),0x06,0x01,user_global_param::sqlmaxvolt,0x0304);//最高电压发送
            }
            sqltemp_i ++;
            if(sqltemp_i >= user_global_param::sqlchlist.length() - 1)
            {
                sqltemp_i = 0;
                temp_j = 3;
            }
        }
        else if(temp_j == 3)//最高温度
        {
            for(quint8 macnum = 0; macnum < user_global_param::sqlmaclist.length();macnum ++)
            {
                serversocket_Send_WriteData(user_global_param::sqlmaclist[macnum],0x029A,0x06,0x01,user_global_param::sqlmaxtemp,0x0304);//最高温度发送
            }
            temp_j = 0;
            user_global_param::sendVITrangeflag = 0;
        }


    }
    else
    {
        if(temp_i == 0)//心跳
        {
            temp_i ++;
            harddatasendendfalg = 1;
            serversocket_Send_ReadData("NONE", 0x036C, 0x03, 0x04,0x0334);


        }
        else if(temp_i == 1)//获取硬件版本号
        {
            temp_i ++;
            allmacstr = sqlitefunobj->traversedata("devdata","dev_mac");
            if(allmacstr == "FAIL" || allmacstr == "NONE") return;
            allmacstrbuf = allmacstr.split("&");
            for(quint8 iue = 0; iue < allmacstrbuf.length();iue ++)
            {
                serversocket_Send_ReadData(allmacstrbuf[iue], 0x0378, 0x03, 0x01,0x0324);

            }

        }
        else if(temp_i == 2)//获取软件版本号
        {
            temp_i ++;
            allmacstr = sqlitefunobj->traversedata("devdata","dev_mac");
            if(allmacstr == "FAIL" || allmacstr == "NONE") return;

            allmacstrbuf = allmacstr.split("&");
            for(quint8 iue1 = 0; iue1 < allmacstrbuf.length();iue1 ++)
            {
                serversocket_Send_ReadData(allmacstrbuf[iue1], 0x0376 ,0x03, 0x02,0x0314);

            }
        }
        else if(temp_i == 3)//获取开关状态
        {
            temp_i ++;
            allmacstr = sqlitefunobj->traversedata("devdata","dev_mac");
            if(allmacstr == "FAIL" || allmacstr == "NONE") return;
            allmacstrbuf = allmacstr.split("&");
            for(quint8 iue = 0; iue < allmacstrbuf.length();iue ++)
            {
                serversocket_Send_ReadData(allmacstrbuf[iue], 0x022c, 0x03, 0x02,0x0344);

            }
        }
        else if(temp_i == 4)//获取电流
        {
            temp_i ++;
            allmacstr = sqlitefunobj->traversedata("devdata","dev_mac");
            if(allmacstr == "FAIL" || allmacstr == "NONE") return;
            allmacstrbuf = allmacstr.split("&");
            allkindstr = sqlitefunobj->traversedata("devdata","dev_kind");
            if(allkindstr == "FAIL" || allmacstr == "NONE") return;
            allkindstrbuf = allkindstr.split("&");
            for(quint8 iue = 0; iue < allmacstrbuf.length();iue ++)
            {
                serversocket_Send_ReadData(allmacstrbuf[iue], 0x0064, 0x03,allkindstrbuf[iue].toUInt() ,0x0354);
            }
        }
        else if(temp_i == 5)//获取温度
        {
            temp_i ++;
            allmacstr = sqlitefunobj->traversedata("devdata","dev_mac");
            if(allmacstr == "FAIL" || allmacstr == "NONE") return;
            allmacstrbuf = allmacstr.split("&");
            allkindstr = sqlitefunobj->traversedata("devdata","dev_kind");
            if(allkindstr == "FAIL" || allmacstr == "NONE") return;
            allkindstrbuf = allkindstr.split("&");
            for(quint8 iue = 0; iue < allmacstrbuf.length();iue ++)
            {
                serversocket_Send_ReadData(allmacstrbuf[iue], 0x00C9, 0x03,0x01 ,0x0354);
            }
        }
        else if(temp_i == 6)//获取温度
        {
            temp_i ++;
            allmacstr = sqlitefunobj->traversedata("devdata","dev_mac");
            if(allmacstr == "FAIL" || allmacstr == "NONE") return;
            allmacstrbuf = allmacstr.split("&");
            allkindstr = sqlitefunobj->traversedata("devdata","dev_kind");
            if(allkindstr == "FAIL" || allmacstr == "NONE") return;
            allkindstrbuf = allkindstr.split("&");
            for(quint8 iue = 0; iue < allmacstrbuf.length();iue ++)
            {
                serversocket_Send_ReadData(allmacstrbuf[iue], 0x0001, 0x03,allkindstrbuf[iue].toUInt() ,0x0354);
            }
        }
        else
        {
            temp_i = 0;
        }
    }
}

void user_tcpserver::serversocket_Send_ReturnData(QString  qslmac, quint16 RegAddr, quint8 cmd, quint8 Result,quint16 Tocken)//写数据
{
    QByteArray Block_tcpdata;
    QStringList list;
    quint8 UniqueID[10];
    QStringList listmac;
    QString        Sqtidstr;
    QString        Modbusaddr;
    sqlitefun *sqlitefunobj = nullptr;
    quint8 macokflag = 0;
    Block_tcpdata.resize(user_global_param::ServerSend_buflen);
    typedef const char* (*Fun)(quint8* UniqueID, quint16 RegAddr, quint8 cmd,quint8 Result, quint16 Tocken);
    QLibrary mylib("universalprotocalinter.dll");   //声明所用到的dll文件
    for(quint8 iu = 0; iu < 99; iu ++)
    {
        if(user_global_param::allClientsMac[iu] == qslmac || RegAddr == 0x036c)
        {
            macokflag = 1;
        }
    }
    if(macokflag == 0)
    {
        return;
    }
    if(RegAddr != 0x036c)
    {
        listmac = qslmac.split("-");
        if(listmac.length() == 0)return;
        Sqtidstr = sqlitefunobj->findsqldataID("devdata","dev_mac",qslmac);
        if(Sqtidstr == "FAIL" || Sqtidstr == "NONE") return;
        Modbusaddr = sqlitefunobj->findsqldata("devdata","dev_485adr",Sqtidstr.toUInt(nullptr, 10));
        if(Modbusaddr == "FAIL" || Modbusaddr == "NONE") return;
    }
    else
    {
        if(qslmac == "FAIL" || qslmac == "NONE")
        {
            qslmac = "0-0-0-0-0-0";
            Modbusaddr = "0";
            listmac =  qslmac.split("-");
        }
        else
        {
            listmac =  qslmac.split("-");
            Sqtidstr = sqlitefunobj->findsqldataID("devdata","dev_mac",qslmac);
            if(Sqtidstr == "FAIL" || Sqtidstr == "NONE") return;
            Modbusaddr = sqlitefunobj->findsqldata("devdata","dev_485adr",Sqtidstr.toUInt(nullptr, 10));
            if(Modbusaddr == "FAIL" || Modbusaddr == "NONE") return;

        }

    }
    if (mylib.load())              //判断是否正确加载
    {
        Fun BY_ReturnDataToDrive = (Fun)mylib.resolve("BY_ReturnDataToDrive");    //援引 BY_WriteRegValue() 函数
        if(BY_ReturnDataToDrive)//函数解析成功
        {
            UniqueID[0] = 0;
            for(quint8 j = 0;j <listmac.length(); j ++)
            {
                UniqueID[j + 1] = listmac[j].toUInt(nullptr, 16);
            }

            UniqueID[7] = Modbusaddr.toUInt(nullptr, 16);
            UniqueID[8] = 0;
            UniqueID[9] = 0;
            QString  CodeDataStr =  BY_ReturnDataToDrive(UniqueID,RegAddr,cmd, Result,Tocken);
            list = CodeDataStr.split("-");

            for(quint8 i = 0; i < list.length(); i ++)
            {
                Block_tcpdata[i] = list[i].toUInt(nullptr, 16);
            }
            if(RegAddr == 0x036C && qslmac == "0-0-0-0-0-0")
            {
                for(quint8 i = 0; i  < user_global_param::ClientNum; i ++)
                {
                    tcpsocket[i]->write(Block_tcpdata);
                    tcpsocket[i]->flush();
                }
            }
            else
            {
                sqltcpsocket[Sqtidstr.toUInt(nullptr, 10)]->write(Block_tcpdata);
                sqltcpsocket[Sqtidstr.toUInt(nullptr, 10)]->flush();
            }

        }
    }
}
void user_tcpserver::serversocket_Send_ReadData(QString  qslmac, quint16 RegAddr, quint8 cmd, quint8 RegNum,quint16 Tocken)//写数据
{
    QByteArray Block_tcpdata;
    QStringList list;
    quint8 UniqueID[10];
    QStringList listmac;
    QString        Sqtidstr;
    QString        Modbusaddr;
    sqlitefun *sqlitefunobj = nullptr;
    quint8 macokflag = 0;
    Block_tcpdata.resize(user_global_param::ServerSend_buflen);
    typedef const char* (*Fun)(quint8* UniqueID, quint16 RegAddr, quint8 cmd,quint8 RegNum, quint16 Tocken);
    QLibrary mylib("universalprotocalinter.dll");   //声明所用到的dll文件
    for(quint8 iu = 0; iu < 99; iu ++)
    {
        if(user_global_param::allClientsMac[iu] == qslmac || RegAddr == 0x036c)
        {
            macokflag = 1;
        }
    }
    if(macokflag == 0)
    {
        return;
    }
    if(RegAddr != 0x036c)
    {
        listmac = qslmac.split("-");
        if(listmac.length() == 0)return;
        Sqtidstr = sqlitefunobj->findsqldataID("devdata","dev_mac",qslmac);
        if(Sqtidstr == "FAIL" || Sqtidstr == "NONE") return;
        Modbusaddr = sqlitefunobj->findsqldata("devdata","dev_485adr",Sqtidstr.toUInt(nullptr, 10));
        if(Modbusaddr == "FAIL" || Modbusaddr == "NONE") return;
    }
    else
    {
        if(qslmac == "FAIL" || qslmac == "NONE")
        {
            qslmac = "0-0-0-0-0-0";
            Modbusaddr = "0";
            listmac =  qslmac.split("-");
        }
        else
        {
            listmac =  qslmac.split("-");
            Sqtidstr = sqlitefunobj->findsqldataID("devdata","dev_mac",qslmac);
            if(Sqtidstr == "FAIL" || Sqtidstr == "NONE") return;
            Modbusaddr = sqlitefunobj->findsqldata("devdata","dev_485adr",Sqtidstr.toUInt(nullptr, 10));
            if(Modbusaddr == "FAIL" || Modbusaddr == "NONE") return;

        }

    }
    if (mylib.load())              //判断是否正确加载
    {
        Fun BY_ReadRegValue = (Fun)mylib.resolve("BY_ReadRegValue");    //援引 BY_WriteRegValue() 函数
        if(BY_ReadRegValue)//函数解析成功
        {
            UniqueID[0] = 0;
            for(quint8 j = 0;j <listmac.length(); j ++)
            {
                UniqueID[j + 1] = listmac[j].toUInt(nullptr, 16);
            }

            UniqueID[7] = Modbusaddr.toUInt(nullptr, 16);
            UniqueID[8] = 0;
            UniqueID[9] = 0;
            QString  CodeDataStr =  BY_ReadRegValue(UniqueID,RegAddr,cmd, RegNum,Tocken);
            list = CodeDataStr.split("-");

            for(quint8 i = 0; i < list.length(); i ++)
            {
                Block_tcpdata[i] = list[i].toUInt(nullptr, 16);
            }
            if(RegAddr == 0x036C && qslmac == "0-0-0-0-0-0")
            {
                for(quint8 i = 0; i  < user_global_param::ClientNum; i ++)
                {
                    tcpsocket[i]->write(Block_tcpdata);
                    tcpsocket[i]->flush();
                }
            }
            else
            {
                sqltcpsocket[Sqtidstr.toUInt(nullptr, 10)]->write(Block_tcpdata);
                sqltcpsocket[Sqtidstr.toUInt(nullptr, 10)]->flush();
            }

        }
    }
}
void user_tcpserver::serversocket_Send_WriteData(QString  qslmac, quint16 RegAddr, quint8 cmd, quint8 RegNum,QString DataParam, quint16 Tocken)//写数据
{
    QByteArray Block_tcpdata;
    QStringList list;
    quint8 UniqueID1[10];
    QStringList listmac;
    QStringList listdata;
    QString        Sqtidstr;
    QString        Modbusaddr;
    quint16 dataparamu[2];
    sqlitefun *sqlitefunobj = nullptr;
    quint8 macokflag = 0;
    Block_tcpdata.resize(user_global_param::ServerSend_buflen);
    typedef const char* (*Fun)(quint8* UniqueID, quint16 RegAddr, quint8 cmd,quint8 RegNum, quint16* DataParam, quint16 Tocken);
    QLibrary mylib("universalprotocalinter.dll");   //声明所用到的dll文件
    listmac = qslmac.split("-");
    listdata = DataParam.split("#");
    for(quint8 iu = 0; iu < 99; iu ++)
    {
        if(user_global_param::allClientsMac[iu] == qslmac)
        {
            macokflag = 1;
        }
    }
    if(macokflag == 0)
    {
        return;
    }
    Sqtidstr = sqlitefunobj->findsqldataID("devdata","dev_mac",qslmac);
    if(Sqtidstr == "FAIL" || Sqtidstr == "NONE") return;
    if(listdata.length() == 0)return;
    dataparamu[0] = listdata[0].toUInt(nullptr, 10);
    if(RegNum == 2)
    {
        if(listdata.length() < 2)return;
        dataparamu[1] = listdata[1].toUInt(nullptr, 10);
    }
    Modbusaddr = sqlitefunobj->findsqldata("devdata","dev_485adr",Sqtidstr.toUInt(nullptr, 10));
    if(Modbusaddr == "FAIL" || Modbusaddr == "NONE") return;
    if (mylib.load())              //判断是否正确加载
    {
        Fun BY_WriteRegValue = (Fun)mylib.resolve("BY_WriteRegValue");    //援引 BY_WriteRegValue() 函数
        if(BY_WriteRegValue)//函数解析成功
        {
            UniqueID1[0] = 0;
            for(quint8 j = 1;j < listmac.length() + 1; j ++)
            {
                UniqueID1[j] = listmac[j-1].toUInt(nullptr, 16);
            }

            UniqueID1[7] = Modbusaddr.toUInt(nullptr, 16);
            UniqueID1[8] = 0;
            UniqueID1[9] = 0;
            QString  CodeDataStr = BY_WriteRegValue(UniqueID1,RegAddr,cmd,RegNum,dataparamu,Tocken);
            list = CodeDataStr.split("-");

            for(quint8 i = 0; i < list.length(); i ++)
            {
                Block_tcpdata[i] = list[i].toUInt(nullptr, 16);
            }
            //  if(sqltcpsocket[Sqtidstr.toUInt(nullptr, 10)]->isOpen() == false) return;
            sqltcpsocket[Sqtidstr.toUInt(nullptr, 10)]->write(Block_tcpdata);
            sqltcpsocket[Sqtidstr.toUInt(nullptr, 10)]->flush();
        }
    }
}
//设置电压、电流、温度范围
void user_tcpserver::SetRangeHandle(QString macstr,QString chcontrilname,QString MaxCurr,QString Minvolt,QString Maxvolt,QString MaxTemp)
{
    QString ids = "";
    quint16 datavalue = 0;
    user_global_param::sendVITrangeflag = 1;
    user_global_param::sqlmaclist = macstr.split(",");

    user_global_param::sqlchlist = chcontrilname.split(",");

    datavalue = MaxCurr.toFloat()*100;
    user_global_param::sqlmaxcurrent = QString::number(datavalue,10);
    datavalue = Minvolt.toFloat()*100;
    user_global_param::sqlminvolt = QString::number(datavalue,10);
    datavalue = Maxvolt.toFloat()*100;
    user_global_param::sqlmaxvolt = QString::number(datavalue,10);
    datavalue = MaxTemp.toFloat()*100;
    user_global_param::sqlmaxtemp = QString::number(datavalue,10);


}
//定时任务处理
void user_tcpserver::timetasktotrigger(QString timetaskname,QString plannamestr,QString weekstr,QString timestr,QString holiddays,QString swstate,QString oprkind,QString oldpanname)
{
    user_global_param::weekqml = weekstr;
    user_global_param::timestrqml = timestr;
    user_global_param::holiddays = holiddays;
    user_global_param::swstate = swstate;
    user_global_param::planname = plannamestr;

    QString  devnameid = 0;
    sqlitefun *sqlitefunobj = nullptr;

    QString timetaskcontrolid = sqlitefunobj->findsqldataID("timingtaskdelay","tasknamed",oldpanname);

    if(oprkind == "creat")
    {//创建
        sqlitefunobj->nOIDinsterweizhidata("timingtaskdelay","tasknamed",timetaskname);
        timetaskcontrolid = sqlitefunobj->findsqldataID("timingtaskdelay","tasknamed",timetaskname);
        QString timetasklistid = sqlitefunobj->findsqldataID("timingtask","taskname",timetaskname);
        QString timetasktime = sqlitefunobj->findsqldata("timingtask","time",timetasklistid.toUInt(nullptr,10));//获取时间
        QString timetaskfreq = sqlitefunobj->findsqldata("timingtask","freq",timetasklistid.toUInt(nullptr,10));  //获取星期
        QString timetasktimeen = sqlitefunobj->findsqldata("timingtask","statutorytimeen",timetasklistid.toUInt(nullptr,10)); //节假日是否执行
        QString timetaskplanname = sqlitefunobj->findsqldata("timingtask","planname",timetasklistid.toUInt(nullptr,10)); //预按名字
        QString swstates = sqlitefunobj->findsqldata("timingtask","swstate",timetasklistid.toUInt(nullptr,10)); //开关状态
        QStringList timingpannamebuf = timetaskplanname.split("&");
        QString panlist_panname = sqlitefunobj->traversedata("panlist","panname");
        QStringList panlist_pannamebuf = panlist_panname.split("&");
        QString timeingdelay = "";
        for(quint8 uie = 0; uie < timingpannamebuf.length(); uie ++)
        {
            for(quint8 iy = 0; iy < panlist_pannamebuf.length(); iy ++)//所有pan名字
            {
                if(timingpannamebuf[uie] == panlist_pannamebuf[iy])
                {
                    QString pangetid  =  sqlitefunobj->findsqldataID("panlist","panname",timingpannamebuf[uie]);
                    timeingdelay += sqlitefunobj->findsqldata("panlist","swworkdelay",pangetid.toUInt(nullptr,10));  //
                    timeingdelay += "&";
                }

            }

        }
        if(timeingdelay[timeingdelay.length() - 1] == "&") timeingdelay = timeingdelay.left(timeingdelay.length()-1);
        sqlitefunobj->updaterowdata("timingtask","timingdelaytime",timeingdelay,timetasklistid.toUInt(nullptr,10));
        sqlitefunobj->updaterowdata("timingtaskdelay","timingtaskdelay",timeingdelay,timetaskcontrolid.toUInt(nullptr,10));
        sqlitefunobj->updaterowdata("timingtaskdelay","timed",timetasktime,timetaskcontrolid.toUInt(nullptr,10)); //保存通道
        sqlitefunobj->updaterowdata("timingtaskdelay","freqd",timetaskfreq,timetaskcontrolid.toUInt(nullptr,10)); //保存延时时间
        sqlitefunobj->updaterowdata("timingtaskdelay","statutorytimeend",timetasktimeen,timetaskcontrolid.toUInt(nullptr,10)); //保存通道之
        sqlitefunobj->updaterowdata("timingtaskdelay","plannamed",timetaskplanname,timetaskcontrolid.toUInt(nullptr,10)); //保存通道之
        sqlitefunobj->updaterowdata("timingtaskdelay","swstated",swstates,timetaskcontrolid.toUInt(nullptr,10)); //保存通道之         sqlitefunobj->updaterowdata("quickcontrol","plannamed",panlistdevname,quickcontrolid.toUInt(nullptr,10)); //保存通道之

        QString handleendstr = "";

        handleendstr += "0";

        sqlitefunobj->updaterowdata("timingtaskdelay","handleend",handleendstr,timetaskcontrolid.toUInt(nullptr,10)); //保存通道之
    }
    else
    {
        QString timetasklistid = sqlitefunobj->findsqldataID("timingtask","taskname",timetaskname);
        QString timetasktime = sqlitefunobj->findsqldata("timingtask","time",timetasklistid.toUInt(nullptr,10));//获取时间
        QString timetaskfreq = sqlitefunobj->findsqldata("timingtask","freq",timetasklistid.toUInt(nullptr,10));  //获取星期
        QString timetasktimeen = sqlitefunobj->findsqldata("timingtask","statutorytimeen",timetasklistid.toUInt(nullptr,10)); //节假日是否执行
        QString timetaskplanname = sqlitefunobj->findsqldata("timingtask","planname",timetasklistid.toUInt(nullptr,10)); //预按名字
        QString swstates = sqlitefunobj->findsqldata("timingtask","swstate",timetasklistid.toUInt(nullptr,10)); //开关状态
        QString tasknametimg = sqlitefunobj->findsqldata("timingtask","taskname",timetasklistid.toUInt(nullptr,10)); //预按名字
        QStringList timingpannamebuf = timetaskplanname.split("&");
        QString panlist_panname = sqlitefunobj->traversedata("panlist","panname");
        QStringList panlist_pannamebuf = panlist_panname.split("&");
        QString timeingdelay = "";
        for(quint8 uie = 0; uie < timingpannamebuf.length(); uie ++)
        {
            for(quint8 iy = 0; iy < panlist_pannamebuf.length(); iy ++)//所有pan名字
            {
                if(timingpannamebuf[uie] == panlist_pannamebuf[iy])
                {
                    QString pangetid  =  sqlitefunobj->findsqldataID("panlist","panname",timingpannamebuf[uie]);
                    timeingdelay += sqlitefunobj->findsqldata("panlist","swworkdelay",pangetid.toUInt(nullptr,10));  //
                    timeingdelay += "&";
                }
            }

        }
        if(timeingdelay[timeingdelay.length() - 1] == "&") timeingdelay = timeingdelay.left(timeingdelay.length()-1);
        sqlitefunobj->updaterowdata("timingtask","timingdelaytime",timeingdelay,timetasklistid.toUInt(nullptr,10));
        sqlitefunobj->updaterowdata("timingtaskdelay","timingtaskdelay",timeingdelay,timetaskcontrolid.toUInt(nullptr,10));
        sqlitefunobj->updaterowdata("timingtaskdelay","timed",timetasktime,timetaskcontrolid.toUInt(nullptr,10)); //保存通道
        sqlitefunobj->updaterowdata("timingtaskdelay","freqd",timetaskfreq,timetaskcontrolid.toUInt(nullptr,10)); //保存延时时间
        sqlitefunobj->updaterowdata("timingtaskdelay","statutorytimeend",timetasktimeen,timetaskcontrolid.toUInt(nullptr,10)); //保存通道之
        sqlitefunobj->updaterowdata("timingtaskdelay","plannamed",timetaskplanname,timetaskcontrolid.toUInt(nullptr,10)); //保存通道之
        sqlitefunobj->updaterowdata("timingtaskdelay","swstated",swstates,timetaskcontrolid.toUInt(nullptr,10)); //保存通道之
        sqlitefunobj->updaterowdata("timingtaskdelay","tasknamed",tasknametimg,timetaskcontrolid.toUInt(nullptr,10)); //保存通道之
        QString handleendstr = "";
        handleendstr += "0";
        sqlitefunobj->updaterowdata("timingtaskdelay","handleend",handleendstr,timetaskcontrolid.toUInt(nullptr,10)); //保存通道之
    }
}
QString user_tcpserver::timertaskdelaycontrol()//定时任务延时控制
{
    sqlitefun *sqlitefunobj = nullptr;
    QString devid = "";
    QString devmac = "";
    QString pandevnames = "";
    QString pandevchosech;
    QStringList panalldevchosechbuf;
    QStringList panalldevchosechpbuf;
    QString currdevtoalid;
    QString getcurrdevtotalch;
    QStringList getcurrdevtotalchbuf;
    QString getcurrdevtotalswstate;
    QStringList getcurrdevtotalswstatebuf;
    quint32 sendswstate = 0;
    QString deleterowid = "";
    QString sendswstate1 = "";
    QString sendswstate2 = "";
    QString getpandelaystr = "";
    qint8 getpandelayint = 0;
    QString sendsignlestr = "";
    QString dev_kindstr = "";
    QString timtab_tasknamed = "";
    QStringList timtab_tasknamedbuf;
    QString delayupdata = "";
    quint8 senokflagtime = 0;
    if(user_global_param::starttimetaskfalg == 0 ) return "FAIL";//还没有控制
    timtab_tasknamed = sqlitefunobj->traversedata("timingtaskdelay","tasknamed");
    timtab_tasknamedbuf = timtab_tasknamed.split("&");
    QString handlenndstrstarfalgstr = sqlitefunobj->traversedata("timingtaskdelay","handleend");
    QStringList handlenndstrstarfalgstrbuf = handlenndstrstarfalgstr.split("&");
    if(timtab_tasknamed == "" || timtab_tasknamed == "NONE") user_global_param::starttimetaskfalg = 0;
    for(quint8 jii = 0; jii < timtab_tasknamedbuf.length(); jii ++)//所有定时任务一个个判断控制
    {
        if(handlenndstrstarfalgstrbuf[jii] == "0") continue;
        QString timingtaskpannameid = sqlitefunobj->findsqldataID("timingtaskdelay","tasknamed",timtab_tasknamedbuf[jii]);
        QString pannamed_timg = sqlitefunobj->findsqldata("timingtaskdelay","plannamed",timingtaskpannameid.toUInt());
        QStringList pannamed_timgbuf = pannamed_timg.split("&");
        for(quint8 uiettr = 0; uiettr < pannamed_timgbuf.length(); uiettr ++)//每个预案一个一个判断
        {
            delayupdata = "";
            if(pannamed_timgbuf[uiettr] == "") continue;
            QString plannameid = sqlitefunobj->findsqldataID("panlist","panname",pannamed_timgbuf[uiettr]);
            QString pandevmacstr = sqlitefunobj->findsqldata("panlist","pandevmac",plannameid.toUInt());
            QStringList pandevmacstrbuf = pandevmacstr.split("&");//获取设备MAC
            getpandelaystr = sqlitefunobj->findsqldata("timingtaskdelay","timingtaskdelay",jii + 1);
            QStringList getpandelaystrbuf = getpandelaystr.split("&");
            for(quint8 uiet = 0; uiet < getpandelaystrbuf.length();uiet ++)
            {
                getpandelayint = getpandelaystrbuf[uiet].toUInt(nullptr,10);
                getpandelayint -= 2;
                getpandelaystr =QString:: asprintf("%d",getpandelayint);
                if(uiet == uiettr)
                {
                    delayupdata += getpandelaystr;
                }
                else
                {
                    delayupdata += getpandelaystrbuf[uiet];

                }
                if(uiet != getpandelaystrbuf.length() - 1)
                {
                    delayupdata += "&";
                }
            }
            sqlitefunobj->updaterowdata("timingtaskdelay","timingtaskdelay",delayupdata,timingtaskpannameid.toUInt(nullptr,10)); //保存通道之
            QString swstatetiming = sqlitefunobj->findsqldata("timingtaskdelay","swstated",timingtaskpannameid.toUInt(nullptr,10));
            QString handleendflag = sqlitefunobj->findsqldata("timingtaskdelay","handleend",timingtaskpannameid.toUInt(nullptr,10));
            getpandelaystr = sqlitefunobj->findsqldata("timingtaskdelay","timingtaskdelay",timingtaskpannameid.toUInt(nullptr,10));
            getpandelaystrbuf = getpandelaystr.split("&");
            for(quint8 jit = 0; jit < pandevmacstrbuf.length(); jit ++)//所有设备一个一个判断控制
            {
                 if(pandevmacstrbuf[jit] == "")continue;
                if(getpandelaystrbuf[uiettr].toInt() > 0) continue;
                sendswstate = 0;

                QString  panlistcurrid = sqlitefunobj->findsqldataID("panlist","panname",pannamed_timgbuf[uiettr]);
                pandevchosech =  sqlitefunobj->findsqldata("panlist","panchchose",panlistcurrid.toUInt(nullptr,10));
                panalldevchosechbuf = pandevchosech.split("&");//将每个设备的通道分开
                panalldevchosechpbuf = panalldevchosechbuf[jit].split("#");
                currdevtoalid = sqlitefunobj->findsqldataID("devdata","dev_mac",pandevmacstrbuf[jit]);
                getcurrdevtotalch = sqlitefunobj->findsqldata("devdata","dev_chname",currdevtoalid.toUInt(nullptr,10));//获取当前设备所有通道
                dev_kindstr = sqlitefunobj->findsqldata("devdata","dev_kind",currdevtoalid.toUInt(nullptr,10));//获取当前设备所有通道
                getcurrdevtotalchbuf = getcurrdevtotalch.split("#");
                getcurrdevtotalswstate = sqlitefunobj->findsqldata("devdata","dev_chswstate1",currdevtoalid.toUInt(nullptr,10)) + "#" + sqlitefunobj->findsqldata("devdata","dev_chswstate2",currdevtoalid.toUInt(nullptr,10));//获取当前设备所有通道
                getcurrdevtotalswstatebuf = getcurrdevtotalswstate.split("#");
                devid = sqlitefunobj->findsqldataID("devdata","dev_mac",pandevmacstrbuf[jit]);
                devmac = sqlitefunobj->findsqldata("devdata","dev_mac",devid.toUInt(nullptr,10));
                for(quint8 ttu = 0; ttu < dev_kindstr.toUInt(nullptr,10); ttu ++)//判断所有通道
                {
                    if(getcurrdevtotalswstatebuf[ttu] == "1")
                    {
                        sendswstate |= 1 << ttu;
                    }
                    else
                    {
                        sendswstate &= ~(1 << ttu);
                    }
                    for(quint8 uy = 0; uy < panalldevchosechpbuf.length(); uy ++)
                    {
                        if(panalldevchosechpbuf[uy] == "")continue;
                        if(getcurrdevtotalchbuf[ttu] == panalldevchosechpbuf[uy])
                        {
                            //设备关闭
                            if(swstatetiming == "1")
                            {
                                sendswstate &= ~(1 << ttu);
                            }
                            else
                            {

                                sendswstate |= 1 << ttu;
                            }

                        }

                    }
                }
                if(getcurrdevtotalchbuf.length() <= 16)
                {
                    senokflagtime = 1;
                    sendswstate1 =QString:: asprintf("%d",(sendswstate & 0xffff));
                    serversocket_Send_WriteData(pandevmacstrbuf[jit],0x022c,0x06,1,sendswstate1,0x2234);

                }
                else
                {
                    senokflagtime = 1;
                    sendswstate1 =QString:: asprintf("%d",(sendswstate & 0xffff));
                    sendswstate2 =QString:: asprintf("%d",(sendswstate >> 16)& 0xffff);
                    serversocket_Send_WriteData(pandevmacstrbuf[jit],0x022c,0x06,2,sendswstate1 + "#" + sendswstate2,0x2234);


                }
            }
        }
        QString  iddd  = sqlitefunobj->findsqldataID("timingtaskdelay","tasknamed",timtab_tasknamedbuf[jii]);
        QString timingstr = sqlitefunobj->findsqldata("timingtaskdelay","timingtaskdelay",iddd.toUInt(nullptr,10));
        QStringList timingstrbuf = timingstr.split("&");
        quint8 Successflag = 1;
        for(quint8 ui = 0; ui < timingstrbuf.length();ui ++)
        {
            if(timingstrbuf[ui].toInt() > 0)
            {
                Successflag = 0;
            }
        }
        if(Successflag == 1)
        {
            sqlitefunobj->updaterowdata("timingtaskdelay","handleend","0",iddd.toUInt()); //保存通道之
            QString tasktimgid = sqlitefunobj->findsqldataID("timingtask","taskname",timtab_tasknamedbuf[jii]);
            QString getdelaytime = sqlitefunobj->findsqldata("timingtask","timingdelaytime",tasktimgid.toUInt(nullptr,10));
            QString tasktimedelayd = sqlitefunobj->findsqldataID("timingtaskdelay","tasknamed",timtab_tasknamedbuf[jii]);
            sqlitefunobj->updaterowdata("timingtaskdelay","timingtaskdelay",getdelaytime,tasktimedelayd.toUInt(nullptr,10));
        }


    }
    if(senokflagtime == 1)
    {
        return "SUCCESS";
    }
    else
    {
        return "FAIL";
    }


}
QString user_tcpserver::timertaskcontrol()//定时任务处理
{
    QString timetasklistid = "";
    QString timetasktime = "";//获取时间
    QString timetaskfreq = "";  //获取星期
    QStringList timetaskfreqbuf;
    QString timetasktimeen = ""; //节假日是否执行
    QString timetaskplanname = ""; //预按名字
    QStringList timetaskplannamebuf; //预按名字
    QString swstates = ""; //开关状态
    QDateTime current_date_time = QDateTime::currentDateTime();
    QString current_week = current_date_time.toString("ddd");
    sqlitefun *sqlitefunobj = nullptr;
    QString timtab_tasknamed = "";//获取定时
    QStringList timtab_tasknamedbuf;//获取定时列表
    QString timtab_tasknamedid;//获取定时列表
    QTime Systimer = QTime::currentTime();
    QString curr_timer = Systimer.toString("HH:mm");//当前系统时间
    quint8 minute = Systimer.minute(); //当前的分
    static QString curr_timerold[100];
    QString timedelay = "";
    QString timeplanid = "";

    QString panlisttab_id = "";
    QString panlisttab_pandevname = "";
    QStringList panlisttab_pandevnamebuf;

    QString panlisttab_pandevmac = "";
    QStringList panlisttab_pandevmacbuf;

    QString devdatatab_devid = "";//设备所有通道
    QString devdatatab_devallch = "";//设备所有通道
    QStringList devdatatab_devallchbuf;//设备所有通道
    QString devdatatab_devallsw = "";//设备所有通道开关状态
    QStringList devdatatab_devallswbuf;//设备所有通道开关状态
    quint32 devswvalue = 0;

    QString panlist_chosech = "";//选中通道
    QStringList panlist_chosechbuf ;//选中通道
    QString panlist_chosechg = "";//选中通道
    QStringList panlist_chosechbufg ;//选中通道
    QString sendswstate1 = "";
    QString sendswstate2 = "";
    quint8 senddataokflag = 0;
    QString timingtaskdelay_id = "";
    QString timingtaskdelay_handleend = "";
    QString delaytimepl = "";
    QString timeroldstr = "";
    timtab_tasknamed = sqlitefunobj->traversedata("timingtaskdelay","tasknamed");
    timtab_tasknamedbuf = timtab_tasknamed.split("&");
    for(quint8 i = 0; i < timtab_tasknamedbuf.length(); i ++)//定时任务名称一个一个判断
    {
        timeroldstr = curr_timerold[i].right(2);
        if(minute > timeroldstr.toUInt(nullptr,10))
        {
          curr_timerold[i] = "";
        }
        if(curr_timerold[i] == curr_timer) return "FAIL";
        timingtaskdelay_id = sqlitefunobj->findsqldataID("timingtaskdelay","tasknamed",timtab_tasknamedbuf[i]);
        timingtaskdelay_handleend = sqlitefunobj->findsqldata("timingtaskdelay","handleend",timingtaskdelay_id.toUInt(nullptr,10)); //预按名字
        timetasklistid = sqlitefunobj->findsqldataID("timingtask","taskname",timtab_tasknamedbuf[i]);
        timetaskplanname = sqlitefunobj->findsqldata("timingtask","planname",timetasklistid.toUInt(nullptr,10)); //预按名字
        timetaskplannamebuf = timetaskplanname.split("&");
        timetasktime = sqlitefunobj->findsqldata("timingtask","time",timetasklistid.toUInt(nullptr,10));//获取时间
        timetaskfreq = sqlitefunobj->findsqldata("timingtask","freq",timetasklistid.toUInt(nullptr,10));  //获取星期
        timetaskfreqbuf = timetaskfreq.split("&");
        timetasktimeen = sqlitefunobj->findsqldata("timingtask","statutorytimeen",timetasklistid.toUInt(nullptr,10)); //节假日是否执行
        swstates = sqlitefunobj->findsqldata("timingtask","swstate",timetasklistid.toUInt(nullptr,10)); //开关状态
        timeplanid = sqlitefunobj->findsqldataID("panlist","panname",timetaskplanname);
        timedelay = sqlitefunobj->findsqldata("panlist","swworkdelay",timeplanid.toUInt(nullptr,10));//获取delaytime
        if(timetasktime == curr_timer)//时间判断
        {
            curr_timerold[i] = curr_timer;
            for(quint8 gg = 0; gg < timetaskfreqbuf.length(); gg ++)//星期判断
            {
                if(timetaskfreqbuf[gg] == current_week)//星期判断
                {
                    for(quint8 j = 0; j < timetaskplannamebuf.length(); j ++)//获取所有预案名字
                    {
                        QString handleendflag = sqlitefunobj->findsqldata("timingtaskdelay","handleend",timingtaskdelay_id.toUInt(nullptr,10));
                        QStringList handleendflagbuf = handleendflag.split("&");
                        panlisttab_id = sqlitefunobj->findsqldataID("panlist","panname",timetaskplannamebuf[j]);
                        panlisttab_pandevmac = sqlitefunobj->findsqldata("panlist","pandevmac",panlisttab_id.toUInt(nullptr,10)); //获取本预案设备名字
                        panlisttab_pandevmacbuf = panlisttab_pandevmac.split("&");
                        delaytimepl = sqlitefunobj->findsqldata("panlist","swworkdelay",panlisttab_id.toUInt(nullptr,10));
                        for(quint8 juk = 0;  juk < panlisttab_pandevmacbuf.length(); juk ++)//判断所有设备mac
                        {
                            devswvalue = 0;
                            if(panlisttab_pandevmacbuf[juk] == "") continue;
                            devdatatab_devid = sqlitefunobj->findsqldataID("devdata","dev_mac",panlisttab_pandevmacbuf[juk]);
                            devdatatab_devallch =  sqlitefunobj->findsqldata("devdata","dev_chname",devdatatab_devid.toUInt(nullptr,10)); //设备通道名
                            devdatatab_devallchbuf = devdatatab_devallch.split("#");//获取当前设备名字
                            devdatatab_devallsw = sqlitefunobj->findsqldata("devdata","dev_chswstate1",devdatatab_devid.toUInt(nullptr,10)) + "#" + sqlitefunobj->findsqldata("devdata","dev_chswstate2",devdatatab_devid.toUInt(nullptr,10));//获取当前设备所有通道
                            devdatatab_devallswbuf = devdatatab_devallsw.split("#");
                            for(quint8 tetu = 0; tetu < devdatatab_devallchbuf.length(); tetu ++)//判断所有通道
                            {
                                if(devdatatab_devallswbuf[tetu] == "1")
                                {
                                    devswvalue |= 1 << tetu;
                                }
                                else
                                {
                                    devswvalue &= ~(1 << tetu);
                                }
                                panlist_chosech =  sqlitefunobj->findsqldata("panlist","panchchose",panlisttab_id.toUInt(nullptr,10));
                                panlist_chosechbuf = panlist_chosech.split("&");//所有设备选中通道
                                //   if(panlist_chosechbuf.length() < juk - 1) return "FAIL";
                                panlist_chosechbufg = panlist_chosechbuf[juk].split("#");
                                if(panlist_chosechbuf[juk] == "") continue;
                                for(quint8 uy = 0; uy < panlist_chosechbufg.length(); uy ++)
                                {
                                    if(devdatatab_devallchbuf[tetu] == panlist_chosechbufg[uy])
                                    {
                                        //设备关闭
                                        if(swstates == "1")
                                        {
                                            devswvalue |= 1 << tetu;


                                        }
                                        else
                                        {
                                            devswvalue &= ~(1 << tetu);
                                        }

                                    }

                                }
                            }
                            if(devdatatab_devallchbuf.length() <= 16)//判断设备类型
                            {
                                sendswstate1 =QString:: asprintf("%d",(devswvalue & 0xffff));
                                serversocket_Send_WriteData(panlisttab_pandevmacbuf[juk],0x022c,0x06,1,sendswstate1,0x2234);
                                user_global_param::starttimetaskfalg = 1;
                                senddataokflag = 1;

                            }
                            else
                            {
                                sendswstate1 =QString:: asprintf("%d",(devswvalue & 0xffff));
                                sendswstate2 =QString:: asprintf("%d",(devswvalue >> 16)& 0xffff);
                                serversocket_Send_WriteData(panlisttab_pandevmacbuf[juk],0x022c,0x06,2,sendswstate1 + "#" + sendswstate2,0x2234);
                                user_global_param::starttimetaskfalg = 1;
                                senddataokflag = 1;
                            }
                        }
                        QString handleendupdata = "";
                        sqlitefunobj->updaterowdata("timingtaskdelay","handleend","1",timingtaskdelay_id.toUInt()); //保存通道之

                    }
                    if(delaytimepl == "0" || delaytimepl == "00" || delaytimepl == "")
                    {
                     user_global_param::starttimetaskfalg = 0;
                     QString gettesksksjid = sqlitefunobj->findsqldataID("timingtaskdelay","tasknamed",timtab_tasknamedbuf[i]);
                     sqlitefunobj->updaterowdata("timingtaskdelay","handleend","0",gettesksksjid.toUInt(nullptr,10));

                    }

                }

            }
        }


    }
    if(senddataokflag == 1)
    {
        return "SUCCESS";
    }
    else
    {
        return "FAIL";
    }
}




//快捷控制slot函数
void user_tcpserver::quickcontrolqml(QString planname,QString chvalue,QString modelinx)
{
    QString  devnameid = 0;
    sqlitefun *sqlitefunobj = nullptr;
    user_global_param::quickcontrolflag = 1;
    user_global_param::quickcontrolplanname = planname;
    user_global_param::quickcontrolchvalue = chvalue;

    QString quickcontrolid = sqlitefunobj->findsqldataID("quickcontrol","quickplanname",planname);

    if(quickcontrolid == "NONE" || quickcontrolid == "FAIL")
    {
        sqlitefunobj->nOIDinsterweizhidata("quickcontrol","quickplanname",planname);
        quickcontrolid = sqlitefunobj->findsqldataID("quickcontrol","quickplanname",planname);
        QString panlistid = sqlitefunobj->findsqldataID("panlist","panname",planname);
        QString panlistdevname = sqlitefunobj->findsqldata("panlist","pandevname",panlistid.toUInt(nullptr,10));//获取所有通道
        QString panlistchchose = sqlitefunobj->findsqldata("panlist","panchchose",panlistid.toUInt(nullptr,10));  //获取通道
        QString panlistdelay = sqlitefunobj->findsqldata("panlist","swworkdelay",panlistid.toUInt(nullptr,10)); //获取延时时间
        user_global_param::quickcontroldelay =  panlistdelay;
        sqlitefunobj->updaterowdata("quickcontrol","quickplanname",planname,quickcontrolid.toUInt(nullptr,10));//保存预案名称
        sqlitefunobj->updaterowdata("quickcontrol","quickchosech",panlistchchose,quickcontrolid.toUInt(nullptr,10)); //保存通道
        sqlitefunobj->updaterowdata("quickcontrol","quickdelaytime",panlistdelay,quickcontrolid.toUInt(nullptr,10)); //保存延时时间
        sqlitefunobj->updaterowdata("quickcontrol","quickswstate",chvalue,quickcontrolid.toUInt(nullptr,10)); //保存通道之
        sqlitefunobj->updaterowdata("quickcontrol","quickdevnames",panlistdevname,quickcontrolid.toUInt(nullptr,10)); //保存通道之
        sqlitefunobj->updaterowdata("quickcontrol","modelindex",modelinx,quickcontrolid.toUInt(nullptr,10)); //Model序列号

    }
    else
    {
        QString panlistid = sqlitefunobj->findsqldataID("panlist","panname",planname);
        QString panlistdevname = sqlitefunobj->findsqldata("panlist","pandevname",panlistid.toUInt(nullptr,10));//获取所有通道
        QString panlistchchose = sqlitefunobj->findsqldata("panlist","panchchose",panlistid.toUInt(nullptr,10));  //获取通道
        QString panlistdelay = sqlitefunobj->findsqldata("panlist","swworkdelay",panlistid.toUInt(nullptr,10)); //获取延时时间
        user_global_param::quickcontroldelay =  panlistdelay;
        sqlitefunobj->updaterowdata("quickcontrol","quickplanname",planname,quickcontrolid.toUInt(nullptr,10));//保存预案名称
        sqlitefunobj->updaterowdata("quickcontrol","quickchosech",panlistchchose,quickcontrolid.toUInt(nullptr,10)); //保存通道
        sqlitefunobj->updaterowdata("quickcontrol","quickdelaytime",panlistdelay,quickcontrolid.toUInt(nullptr,10)); //保存延时时间
        sqlitefunobj->updaterowdata("quickcontrol","quickswstate",chvalue,quickcontrolid.toUInt(nullptr,10)); //保存通道之
        sqlitefunobj->updaterowdata("quickcontrol","quickdevnames",panlistdevname,quickcontrolid.toUInt(nullptr,10)); //保存通道之
        sqlitefunobj->updaterowdata("quickcontrol","modelindex",modelinx,quickcontrolid.toUInt(nullptr,10)); //Model序列号
    }

}
//快捷延时控制
QString user_tcpserver::quickcontroldelayhandle()
{
    sqlitefun *sqlitefunobj = nullptr;
    QString pannameid = "";
    QString devid = "";
    QString devmac = "";
    QString pandevnames = "";
    QString pandevchosech;
    QStringList panalldevchosechbuf;
    QStringList pansingledevchosechbuf;
    QString currdevtoalid;
    QString getcurrdevtotalch;
    QStringList getcurrdevtotalchbuf;
    QString getcurrdevtotalswstate;
    QStringList getcurrdevtotalswstatebuf;
    quint32 sendswstate = 0;
    QString deleterowid = "";
    QString sendswstate1 = "";
    QString sendswstate2 = "";
    QString getpandelaystr = "";
    qint8 getpandelayint = 0;
    QString sendsignlestr = "";
    QString dev_kindstr = "";
    quint8 uiery = 0;
    quint8 controldevflag = 1;
    if(user_global_param::quickcontrolflagstart == 0 ) return "FAIL";//还没有控制
    QString quickplanname = sqlitefunobj->traversedata("quickcontrol","quickplanname");//获取所有生效的预案名称
    QStringList quickplannamebuf = quickplanname.split("&");
    if(quickplanname == "" || quickplanname == "NONE") user_global_param::quickcontrolflagstart = 0;
    for(quint8 jii = 0; jii < quickplannamebuf.length(); jii ++)//所有预案名称一个个判断控制
    {
        controldevflag = 1;
        QString plannameid = sqlitefunobj->findsqldataID("panlist","panname",quickplannamebuf[jii]);
        QString pandevmacstr = sqlitefunobj->findsqldata("panlist","pandevmac",plannameid.toUInt());

        QStringList pandevmacstrbuf = pandevmacstr.split("&");//获取设备名字

        pannameid = sqlitefunobj->findsqldataID("quickcontrol","quickplanname",quickplannamebuf[jii]);
        getpandelaystr = sqlitefunobj->findsqldata("quickcontrol","quickdelaytime",pannameid.toUInt(nullptr,10));
        QString quickswstate = sqlitefunobj->findsqldata("quickcontrol","quickswstate",pannameid.toUInt(nullptr,10));
        QString modellindexstr = sqlitefunobj->findsqldata("quickcontrol","modelindex",pannameid.toUInt(nullptr,10));
        getpandelayint = getpandelaystr.toUInt(nullptr,10);
        if(getpandelayint == 0) controldevflag = 0;
        getpandelayint -= 2;
        getpandelaystr =QString:: asprintf("%d",getpandelayint);
        sqlitefunobj->updaterowdata("quickcontrol","quickdelaytime",getpandelaystr,pannameid.toUInt(nullptr,10)); //保存通道之
        if(getpandelayint > 0) continue;
        for(quint8 jit = 0; jit < pandevmacstrbuf.length(); jit ++)//所有设备一个一个判断控制
        {
            sendswstate = 0;
            if(pandevmacstrbuf[jit] == "")continue;
            pandevchosech =  sqlitefunobj->findsqldata("quickcontrol","quickchosech",pannameid.toUInt(nullptr,10));
            panalldevchosechbuf = pandevchosech.split("&");//将每个设备的通道分开
            pansingledevchosechbuf = panalldevchosechbuf[jit].split("#");//每台设备选中的通道
            currdevtoalid = sqlitefunobj->findsqldataID("devdata","dev_mac",pandevmacstrbuf[jit]);
            getcurrdevtotalch = sqlitefunobj->findsqldata("devdata","dev_chname",currdevtoalid.toUInt(nullptr,10));//获取当前设备所有通道
            dev_kindstr = sqlitefunobj->findsqldata("devdata","dev_kind",currdevtoalid.toUInt(nullptr,10));//获取当前设备所有通道
            getcurrdevtotalchbuf = getcurrdevtotalch.split("#");
            getcurrdevtotalswstate = sqlitefunobj->findsqldata("devdata","dev_chswstate1",currdevtoalid.toUInt(nullptr,10)) + "#" + sqlitefunobj->findsqldata("devdata","dev_chswstate2",currdevtoalid.toUInt(nullptr,10));//获取当前设备所有通道
            getcurrdevtotalswstatebuf = getcurrdevtotalswstate.split("#");
            devid = sqlitefunobj->findsqldataID("devdata","dev_mac",pandevmacstrbuf[jit]);
            devmac = sqlitefunobj->findsqldata("devdata","dev_mac",devid.toUInt(nullptr,10));
            for(quint8 ttu = 0; ttu < dev_kindstr.toUInt(nullptr,10); ttu ++)//判断所有通道
            {
                if(getcurrdevtotalswstatebuf.length() < ttu - 1)return "FAIL";
                if(getcurrdevtotalswstatebuf[ttu] == "1")
                {
                    sendswstate |= 1 << ttu;
                }
                else
                {
                    sendswstate &= ~(1 << ttu);
                }
                for(quint8 uy = 0; uy < pansingledevchosechbuf.length(); uy ++)
                {
                    if(getcurrdevtotalchbuf[ttu] == pansingledevchosechbuf[uy])
                    {
                        if(quickswstate == "1")
                        {
                            sendswstate &= ~(1 << ttu);

                        }
                        else
                        {
                            sendswstate |= 1 << ttu;
                        }
                    }

                }
            }
            if(getcurrdevtotalchbuf.length() <= 16)
            {
                if(controldevflag == 1)
                {
                    uiery = 1;
                    sendswstate1 =QString:: asprintf("%d",(sendswstate & 0xffff));
                    serversocket_Send_WriteData(devmac,0x022c,0x06,1,sendswstate1,0x2234);
                }

            }
            else
            {
                if(controldevflag == 1)
                {
                    uiery = 1;
                    sendswstate1 =QString:: asprintf("%d",(sendswstate & 0xffff));
                    sendswstate2 =QString:: asprintf("%d",(sendswstate >> 16)& 0xffff);
                    serversocket_Send_WriteData(devmac,0x022c,0x06,2,sendswstate1 + "#" + sendswstate2,0x2234);
                }

            }
        }

        if(modellindexstr != "NONE" && modellindexstr != "FAIL")
        {
            emit chargequiccontrolstate(modellindexstr,quickswstate);
        }
        sqlitefunobj-> deleterow("quickcontrol",pannameid.toUInt(nullptr,10));//删除处理过的快捷控制

    }
    if(uiery == 1)
    {
        return "SUCCESS";
    }
    else
    {
        return "FAIL";
    }

}
//快捷控制
QString user_tcpserver::quickcontrolhandle()
{

    QStringList plannamebufs;
    quint32 swstate = 0;
    sqlitefun *sqlitefunobj = nullptr;
    QDateTime current_date_time = QDateTime::currentDateTime();
    if(user_global_param::quickcontrolflag == 0)return "FAIL";
    plannamebufs = user_global_param::quickcontrolplanname.split("&");//预案名字
    for(quint8 quickhandle_i = 0; quickhandle_i < plannamebufs.length(); quickhandle_i ++)//判断预按名字
    {

        QString plannameid = sqlitefunobj->findsqldataID("panlist","panname",plannamebufs[quickhandle_i]);
        QString pandevmacstr = sqlitefunobj->findsqldata("panlist","pandevmac",plannameid.toUInt());
        QString pandevdelay = sqlitefunobj->findsqldata("panlist","swworkdelay",plannameid.toUInt());
        QStringList pandevmacstrbuf = pandevmacstr.split("&");//获取设备名字

        QString iddevstrbuf[ pandevmacstrbuf.length()];
        QString devchstatebuf[ pandevmacstrbuf.length()] ;
        QString devchstate1buf[ pandevmacstrbuf.length()] ;
        QString devchstate2buf[ pandevmacstrbuf.length()] ;
        QString devkindbuf[ pandevmacstrbuf.length()] ;

        for(quint8 iu = 0; iu < pandevmacstrbuf.length(); iu ++)//设备名称
        {
            iddevstrbuf[iu] = sqlitefunobj->findsqldataID("devdata","dev_mac",pandevmacstrbuf[iu]);
            devchstate1buf[iu] = sqlitefunobj->findsqldata("devdata","dev_chswstate1",iddevstrbuf[iu].toUInt());
            devchstate2buf[iu] = sqlitefunobj->findsqldata("devdata","dev_chswstate2",iddevstrbuf[iu].toUInt());
            devkindbuf[iu] = sqlitefunobj->findsqldata("devdata","dev_kind",iddevstrbuf[iu].toUInt());
            if(iddevstrbuf[quickhandle_i] == "FAIL" || iddevstrbuf[quickhandle_i] == "NONE") return "FAIL";
            if(devchstate1buf[quickhandle_i] == "FAIL" || devchstate1buf[quickhandle_i] == "NONE") return "FAIL";
            if(devkindbuf[quickhandle_i] == "FAIL" || devkindbuf[quickhandle_i] == "NONE") return "FAIL";
            devchstatebuf[iu] = devchstate1buf[iu] + "#" + devchstate2buf[iu];
        }
        if(plannameid == "FAIL" || plannameid == "NONE") return "FAIL";
        if(pandevmacstr == "FAIL" || pandevmacstr == "NONE") return "FAIL";
        for(quint8 uio = 0; uio < pandevmacstrbuf.length();uio ++)//一个预案下的处理
        {
            swstate = 0;
            if(pandevmacstrbuf[uio] == "")continue;
            QStringList devchstatebuflist = devchstatebuf[uio].split("#");
            for(quint8 iii = 0; iii < devkindbuf[uio].toUInt(); iii ++)
            {
                if(devchstatebuflist[iii] == "1")
                {
                    swstate |= 1 << iii;
                }
            }
            QString panidstr = "";
            QString panchchose = "";
            QStringList panchchosebuf;
            QStringList panchchosepbuf;
            QString devidstr = "";
            QString devchstr = "";
            QStringList devchbuf;
            devidstr = sqlitefunobj->findsqldataID("devdata","dev_mac",pandevmacstrbuf[uio]);
            devchstr = sqlitefunobj->findsqldata("devdata","dev_chname",devidstr.toUInt());//设备所有通达

            panidstr = sqlitefunobj->findsqldataID("panlist","panname",plannamebufs[quickhandle_i]);
            panchchose = sqlitefunobj->findsqldata("panlist","panchchose",panidstr.toUInt());
            panchchosebuf = panchchose.split("&");
            if(panchchosebuf.length() < uio + 1)
            {
                if(user_global_param::quickcontrolflagstart == 1)
                {
                    return "SUCCESS";
                }
                else
                {
                    return "FAIL";
                }
            }

            panchchosepbuf = panchchosebuf[uio].split("#");
            if(devidstr == "FAIL" || devidstr == "NONE") return "FAIL";
            if(devchstr == "FAIL" || devchstr == "NONE") return "FAIL";
            if(panidstr == "FAIL" || panidstr == "NONE") return "FAIL";
            if(panchchose == "FAIL" || panchchose == "NONE") return "FAIL";
            devchbuf = devchstr.split("#");

            for(quint8 yy = 0; yy < devchbuf.length(); yy ++)
            {
                for(quint8 iju = 0; iju < panchchosepbuf.length(); iju ++)
                {
                    if(panchchosepbuf[iju] == devchbuf[yy])
                    {
                        if(yy > 15)
                        {
                            if(user_global_param::quickcontrolchvalue == "1")
                            {
                                swstate |= 1 << yy;
                            }
                            else
                            {
                                swstate &= ~(1 << yy);
                            }

                        }
                        else
                        {
                            if(user_global_param::quickcontrolchvalue == "1")
                            {
                                swstate |= 1 << yy;
                            }
                            else
                            {
                                swstate &= ~(1 << yy);
                            }

                        }

                    }

                }

            }
            QString devidstr1 = sqlitefunobj->findsqldataID("devdata","dev_mac",pandevmacstrbuf[uio]);
            QString devmac = sqlitefunobj->findsqldata("devdata","dev_mac",devidstr1.toUInt());
            QString dev_kindu = sqlitefunobj->findsqldata("devdata","dev_kind",devidstr1.toUInt());
            if(devidstr1 == "FAIL" || devidstr1 == "NONE") return "FAIL";
            if(devmac == "FAIL" || devmac == "NONE") return "FAIL";
            QString swstatestr1= "";
            QString swstatestr2= "";
            swstatestr1 =QString:: asprintf("%d",swstate & 0x0000ffff);
            swstatestr2 =QString:: asprintf("%d",(swstate >> 16) & 0x0000ffff);
            if(dev_kindu.toUInt(nullptr,10) > 16)
            {
                serversocket_Send_WriteData(devmac,0x022c,0x06,2,swstatestr1 + "#" +swstatestr2,0x2334);

            }
            else
            {
                serversocket_Send_WriteData(devmac,0x022c,0x06,1,swstatestr1,0x2334);
            }

            user_global_param::quickcontrolflag = 0;
            //   if(user_global_param::quickcontroldelay == "0" || user_global_param::quickcontroldelay == "00" || user_global_param::quickcontroldelay == "")
            //  {
            //      user_global_param::quickcontrolflagstart = 0;
            //   }
            ////    else
            //  {
            user_global_param::quickcontrolflagstart = 1;
            //   }
            //// if(pandevdelay == "0" || pandevdelay == "00" || pandevdelay == "")
            // {
            //    user_global_param::quickcontrolflagstart = 0;
            //   QString quickcontrolid = sqlitefunobj->findsqldataID("quickcontrol","dev_mac",plannamebufs[quickhandle_i]);
            //  sqlitefunobj-> deleterow("quickcontrol",quickcontrolid.toUInt(nullptr,10));//删除处理过的快捷控制
            //  }

        }

    }
    return "SUCCESS";


}

