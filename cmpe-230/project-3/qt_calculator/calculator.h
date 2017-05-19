/*#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <QMainWindow>

namespace Ui {
class calculator;
}

class calculator : public QMainWindow
{
    Q_OBJECT

public:
    explicit calculator(QWidget *parent = 0);
    ~calculator();

private:
    Ui::calculator *ui;
};

#endif // CALCULATOR_H
*/


#ifndef calculator_H
#define calculator_H

#include <QWidget>
#include <QPushButton>
#include <QLineEdit>


class QPushButton;
class QLineEdit;

class calculator : public QWidget
{
    Q_OBJECT

public:
    calculator(QWidget *parent = 0);


private slots:
    void digitClicked();
    void operatorClicked();
    void clear();

private:

     QPushButton *createButton(const QString &text, const char *member);
     QPushButton *digitButtons[16];
     QLineEdit *display;
     bool waitingForOperand;
     QString lastOperator;
     int leftOperand;
     void doOperation(const QString &_operator);
     bool safeAdd(int* result, int a, int b);
     bool safeSub(int* result, int a, int b);
     int calculate(const QString &_operator, int num1, int num2);
     int valueInMemory;

};
#endif // calculator_H
