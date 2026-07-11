#ifndef TESTQUICK_H
#define TESTQUICK_H

#include <QDialog>

namespace Ui {
class TestQuick;
}

class TestQuick : public QDialog
{
    Q_OBJECT

public:
    explicit TestQuick(QWidget *parent = nullptr);
    ~TestQuick();

private slots:
    void on_T_B_clicked();

private:
    Ui::TestQuick *ui;
};

#endif // TESTQUICK_H
