#include "sqlitefun.h"
#include <QVariant>
#include <QString>
#include <QCoreApplication>
sqlitefun :: sqlitefun(QObject *parent):  QObject(parent)
{

}
//查询数据定位ID标号
QString sqlitefun::findsqldataID(QString tablename,QString Column,QString data)
{
    if(tablename.isNull() || data.isNull()) return 0;
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
    if(db.open())
    {
        QSqlQuery query;
        query.exec("SELECT * FROM " + tablename + " WHERE " + Column  +" == " +"'" + data + "'" + ";");//表名字
        while (query.next())
        {
            QString  id = query.value(0).toString();
            if(id != "")
            {
               return id;
            }
        }
    }
    else
    {
        return "FAIL";//数据库打开失败
    }
    return "NONE";//没有数据
}
//根据ID查询一行数据
QString sqlitefun::findsqlrowdata(QString tablename,quint8 columnnum,quint8 ID)
{
    QString str_i;
    QString datastr;
    str_i =QString:: asprintf("%d",ID);
    if(tablename.isNull()) return 0;
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
    if(db.open())
    {
        QSqlQuery query;
        query.exec("SELECT * FROM  " + tablename +  " WHERE id  == " + str_i + ";");//表名字
        while(query.next())
        {
            for(quint8 i = 0; i < columnnum; i ++)
            {
                datastr += query.value(i).toString();
                if(i != columnnum - 1)
                {
                 datastr += "&";
                }


            }
            if(datastr != "")
            {
               return datastr;
            }

        }

    }
    else
    {
        return "FAIL";//数据库打开失败
    }
    return "NONE";//没有数据
}
//根据ID和Column查询数据
QString sqlitefun::findsqldata(QString tablename,QString Column,quint8 ID)
{
    QString str_i;
    QString datastr;
    str_i =QString:: asprintf("%d",ID);
    if(tablename.isNull()) return 0;
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
    if(db.open())
    {
        QSqlQuery query;
        //query.exec("SELECT * FROM  " + tablename +  " WHERE id  == " + str_i + " AND Column Name ==" + Column + ";");//
        query.exec("SELECT * FROM  " + tablename +  " WHERE id  == " + str_i + ";");//
        while(query.next())
        {
            QString result = query.value(Column).toString();
            if(result != "")
            {
               return result;
            }
        }
    }
    else
    {
        return "FAIL";//数据库打开失败
    }
    return "NONE";//没有数据
}
//插入一行数据
QString sqlitefun :: insertrowdata(QString tablename,QString Column,QString data,quint8 id)
{
    QString teg;
    QString idstr;
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
    if(db.open())
    {
        QSqlQuery query;
        teg = "INSERT INTO " + tablename + "(id," +Column + ") " + "VALUES (:id,:"  +Column + ")";
        query.prepare(teg);
        query.bindValue(":id",id);
        query.bindValue(":" +Column,data);
        if(query.exec())
        {
             return "SUCCESS";
        }
    }
        return "FAIL";
}
//删除表里某一行
QString sqlitefun :: deleterow(QString tablename,quint8 row)
{
    QString rowstr;
    rowstr =QString:: asprintf("%d", row);
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
    if(db.open())
    {
        QSqlQuery query;
       if(query.exec("DELETE FROM " + tablename + " WHERE  id = " + rowstr))
           {
            return "SUCCESS";
       }
    }
    return "FAIL";
}
//修改一行数据
QString sqlitefun :: updaterowdata(QString tablename,QString Column,QString data,quint8 id)
{
    QString rowstr;
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
    if(db.open())
    {
      QSqlQuery sql_query;
       //   QString update_sql = "update student set name = :name where id = :id";
        QString update_sql = "update " + tablename +" set "+Column + " = " + ":" + Column + " where id = :id";
        sql_query.prepare(update_sql);
        sql_query.bindValue(":" + Column, data);
        sql_query.bindValue(":id", id);
        if(sql_query.exec())
        {
             return "SUCCESS";
        }

    }
    else
    {
        return "FAIL";//数据库打开失败
    }
    return "NONE";//没有数据
}
//添加数据
QString sqlitefun :: adddata(QString tablename,QString Column,QString data)
{
    QString rowstr;
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
     if(db.open())
     {
     QSqlQuery sql_query;
     sql_query.prepare("INSERT INTO " + tablename + "(" + Column + ")"
                   "VALUES (:" + Column +")");
     sql_query.bindValue(":" + Column, data);                      //向绑定值里加入名字
         if(sql_query.exec())
         {
              return "SUCCESS";
         }
     }
     else
     {
         return "FAIL";//数据库打开失败
     }
     return "NONE";//没有数据
}
//扫描数据
QString sqlitefun :: traversedata(QString tablename,QString Column)
{
     QString Columnstr;
     quint8 flag = 0;
     QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
     QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
     db.setDatabaseName(dbpath);
     if(db.open())
     {
         QSqlQuery sql_query;
         sql_query.exec("select*from " + tablename);
           while(sql_query.next()){  //一行一行遍历
            Columnstr += sql_query.value(Column).toString();
            Columnstr += "&";
            flag  = 1;
           }
           if(flag)
           {
                 Columnstr = Columnstr.left(Columnstr.size() - 1);
           }
           if(Columnstr != "")
           {
              return Columnstr;
           }

     }
     else
     {
         return "FAIL";//数据库打开失败
     }
     return "NONE";//没有数据
}
//插入arealist数据
QString sqlitefun :: nOIDinsterdata(QString arealistnamevalue,QString arealistdevnamevalue)
{
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
     if(db.open())
     {
         QSqlQuery sql_query;
         sql_query.prepare("insert into arealist(arealistname, arealistdevname)"
                           " values(?, ?)");
         sql_query.addBindValue( arealistnamevalue);
         sql_query.addBindValue( arealistdevnamevalue);
         if(sql_query.exec())
         {
              return "SUCCESS";
         }
     }
    return "FAIL";
}

//插入数据pan
QString sqlitefun :: nOIDinsterpandata(QString apannamev,QString pandevnamev,QString pandevchchv,QString panswworkdelayv,QString pandevmac)
{
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
     if(db.open())
     {
         QSqlQuery sql_query;
         sql_query.prepare("insert into panlist(panname, pandevname,panchchose,swworkdelay,pandevmac)"
                           " values(?, ?,?,?,?)");
         sql_query.addBindValue( apannamev);
         sql_query.addBindValue( pandevnamev);
         sql_query.addBindValue( pandevchchv);
         sql_query.addBindValue( panswworkdelayv);
         sql_query.addBindValue( pandevmac);
         if(sql_query.exec())
         {
              return "SUCCESS";
         }
     }
    return "FAIL";
}
//插入数据alarm
QString sqlitefun :: nOIDinsteralarmdata(QString aramdevnameu,QString alarmchu,QString maxcurrentu,QString alarmvoltminu,QString alarmvoltmaxu,QString alarmtempmaxu,QString alarmmac)
{
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
     if(db.open())
     {
         QSqlQuery sql_query;
         sql_query.prepare("insert into alarmthreshold(alarmdevname, alarmch,maxcurrent,alarmvoltmin,alarmvoltmax,alarmtempmax,alarmmac)"
                           " values(?,?,?,?,?,?,?)");
         sql_query.addBindValue( aramdevnameu);
         sql_query.addBindValue( alarmchu);
         sql_query.addBindValue( maxcurrentu);
         sql_query.addBindValue( alarmvoltminu);
         sql_query.addBindValue( alarmvoltmaxu);
         sql_query.addBindValue( alarmtempmaxu);
         sql_query.addBindValue( alarmmac);
         if(sql_query.exec())
         {
              return "SUCCESS";
         }
     }
    return "FAIL";
}

//插入数据timetaska
QString sqlitefun :: nOIDinstertimetaskdata(QString tasknameu,QString timeu,QString frequ,QString statutorytimeenu,QString plannameu,QString swstateu)
{
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
     if(db.open())
     {
         QSqlQuery sql_query;
         sql_query.prepare("insert into timingtask(taskname, time,freq,statutorytimeen,planname,swstate)"
                           " values(?,?,?,?,?,?)");
         sql_query.addBindValue( tasknameu);
         sql_query.addBindValue( timeu);
         sql_query.addBindValue( frequ);
         sql_query.addBindValue( statutorytimeenu);
         sql_query.addBindValue( plannameu);
         sql_query.addBindValue( swstateu);
         if(sql_query.exec())
         {
              return "SUCCESS";
         }
     }
    return "FAIL";
}

//插入数据无定义
QString sqlitefun :: nOIDinsterweizhidata(QString tablename,QString Column,QString datavalue)
{
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
    if(db.open())
    {
        QSqlQuery sql_query;
        sql_query.prepare("insert into " + tablename + "(" + Column +")"
                          " values(?)");
        sql_query.addBindValue( datavalue);
        if(sql_query.exec())
        {
             return "SUCCESS";
        }
    }
   return "FAIL";
}
//插入数据无定义
QString sqlitefun :: nOIDinsterlogindata(QString passauto,QString logauto,QString password,QString account)
{
    QString dbpath =  QCoreApplication::applicationDirPath() + "/FormalClientTools.db";
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbpath);
     if(db.open())
     {
         QSqlQuery sql_query;
         sql_query.prepare("insert into userlog(passauto,logauto,password,account)"
                           " values(?,?,?,?)");
         sql_query.addBindValue( passauto);
         sql_query.addBindValue( logauto);
         sql_query.addBindValue( password);
         sql_query.addBindValue( account);
         if(sql_query.exec())
         {
              return "SUCCESS";
         }
     }
    return "FAIL";
}
