#ifndef SQLITEFUN_H
#define SQLITEFUN_H
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QString>
#include <QThread>

class sqlitefun : public QObject
{
      Q_OBJECT
public:
   explicit sqlitefun(QObject *parent = nullptr);
    Q_INVOKABLE   QString findsqldataID(QString tablename,QString Column,QString data);//查询数据定位ID标号
    Q_INVOKABLE   QString findsqlrowdata(QString tablename,quint8 columnnum,quint8 ID);//查询数据
    Q_INVOKABLE   QString  findsqldata(QString tablename,QString Column,quint8 ID);//根据ID查数据
    Q_INVOKABLE   QString insertrowdata(QString tablename,QString Column,QString data,quint8 id);//插入一行数据
    Q_INVOKABLE   QString  deleterow(QString tablename,quint8 row);//删除表里某一行
    Q_INVOKABLE   QString  updaterowdata(QString tablename,QString Column,QString data,quint8 id);//修改一行数据
    Q_INVOKABLE   QString  adddata(QString tablename,QString Column,QString data);//根据id添加数据
    Q_INVOKABLE   QString traversedata(QString tablename,QString Column);//获取列数据
    Q_INVOKABLE   QString nOIDinsterdata(QString arealistnamevalue,QString arealistdevnamevalue);//插入表arealist数据
    Q_INVOKABLE   QString nOIDinsterpandata(QString apannamev,QString pandevnamev,QString pandevchchv,QString panswworkdelayv,QString pandevmac);//插入表panlist数据
    Q_INVOKABLE   QString  nOIDinsteralarmdata(QString aramdevnameu,QString alarmchu,QString maxcurrentu,QString alarmvoltminu,QString alarmvoltmaxu,QString alarmtempmaxu,QString alarmmac);
    Q_INVOKABLE   QString nOIDinstertimetaskdata(QString tasknameu,QString timeu,QString frequ,QString statutorytimeenu,QString plannameu,QString swstateu);
    Q_INVOKABLE   QString nOIDinsterweizhidata(QString tablename,QString Column,QString datavalue);
    Q_INVOKABLE   QString nOIDinsterlogindata(QString passauto,QString logauto,QString password,QString account);
};

#endif // SQLITEFUN_H
