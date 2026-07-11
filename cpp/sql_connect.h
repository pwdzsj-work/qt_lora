#ifndef SQL_CONNECT_H
#define SQL_CONNECT_H
#include <QMessageBox>
#include <QtSql/QSqlDatabase>
#include <QSqlQuery>
#include <QDebug>
#include <QSqlError>
static bool creatConnect()
{
  QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName("localhost");
    db.setPort(3306);
    db.setDatabaseName("alldevice");
    db.setUserName("root");
    db.setPassword("123456");

    bool ok = db.open();//建立数据库连接
    if(!ok)
    {
       // QMessageBox::critical(0,QObject::tr("连接数据库失败！！！"),db.lastError().text());
        return false;
    }
    else
    {
      //  QMessageBox::information(0,QObject::tr("Tips"),QObject::tr("连接数据库成功！！！"));
       // return true;
    }
    QSqlQuery query(db);
    query.exec("insert into course mainshow(0, '计3机', '李3师',3,'李3师','李3师','李3师')");
}
#endif // SQL_CONNECT_H
