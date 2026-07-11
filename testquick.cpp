#include "testquick.h"
#include "ui_testquick.h"
#include <QtQuickWidgets/QQuickWidget>
#include <qqmlengine.h>
#include <QtQuickWidgets/qquickwidget.h>
#include <QQmlApplicationEngine>
#include <qquickview.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
TestQuick::TestQuick(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::TestQuick)
{
    ui->setupUi(this);
}

TestQuick::~TestQuick()
{
    delete ui;
}

void TestQuick::on_T_B_clicked()
{

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);


    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    engine.load(url);

}
