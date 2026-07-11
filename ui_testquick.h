/********************************************************************************
** Form generated from reading UI file 'testquick.ui'
**
** Created by: Qt User Interface Compiler version 5.14.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_TESTQUICK_H
#define UI_TESTQUICK_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QDialog>
#include <QtWidgets/QDialogButtonBox>
#include <QtWidgets/QPushButton>

QT_BEGIN_NAMESPACE

class Ui_TestQuick
{
public:
    QDialogButtonBox *buttonBox;
    QPushButton *T_B;

    void setupUi(QDialog *TestQuick)
    {
        if (TestQuick->objectName().isEmpty())
            TestQuick->setObjectName(QString::fromUtf8("TestQuick"));
        TestQuick->resize(400, 300);
        buttonBox = new QDialogButtonBox(TestQuick);
        buttonBox->setObjectName(QString::fromUtf8("buttonBox"));
        buttonBox->setGeometry(QRect(30, 240, 341, 32));
        buttonBox->setOrientation(Qt::Horizontal);
        buttonBox->setStandardButtons(QDialogButtonBox::Cancel|QDialogButtonBox::Ok);
        T_B = new QPushButton(TestQuick);
        T_B->setObjectName(QString::fromUtf8("T_B"));
        T_B->setGeometry(QRect(60, 200, 81, 31));

        retranslateUi(TestQuick);
        QObject::connect(buttonBox, SIGNAL(accepted()), TestQuick, SLOT(accept()));
        QObject::connect(buttonBox, SIGNAL(rejected()), TestQuick, SLOT(reject()));

        QMetaObject::connectSlotsByName(TestQuick);
    } // setupUi

    void retranslateUi(QDialog *TestQuick)
    {
        TestQuick->setWindowTitle(QCoreApplication::translate("TestQuick", "Dialog", nullptr));
        T_B->setText(QCoreApplication::translate("TestQuick", "Test_button", nullptr));
    } // retranslateUi

};

namespace Ui {
    class TestQuick: public Ui_TestQuick {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_TESTQUICK_H
