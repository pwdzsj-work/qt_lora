#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QProcess>
#include "cpp/user_tcpserver.h"
#include "cpp/sqlitefun.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    user_tcpserver  *user_tcpserver_qmlobj  = new user_tcpserver;//TCP通信
    sqlitefun *sqlitefun_obj = new sqlitefun;//数据库
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("user_tcpserver_qmlobj",user_tcpserver_qmlobj);
    engine.rootContext()->setContextProperty("sqlitefun_obj",sqlitefun_obj);
    engine.load(QUrl(QStringLiteral("qrc:/qml/Login.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();

}
