#include <QtGui>
#include <QGridLayout>
#include <QSpacerItem>
#include <QMessageBox>


#include "calculator.h"
#include <limits.h>
#include <math.h>


calculator::calculator(QWidget *parent)
    : QWidget(parent)
{

    lastOperator = tr("=");

    display = new QLineEdit("0");
    display->setAlignment(Qt::AlignRight);
    display->setReadOnly(true);
    display->setMaxLength(100);

    for (int i = 0; i < 16; i++) {
        if (i < 10)
            digitButtons[i] = createButton(QString::number(i), SLOT(digitClicked()));
        else if(i == 10)
            digitButtons[i] = createButton(tr("A"), SLOT(digitClicked()));
        else if(i == 11)
            digitButtons[i] = createButton(tr("B"), SLOT(digitClicked()));

        else if(i == 12)
            digitButtons[i] = createButton(tr("C"), SLOT(digitClicked()));
        else if(i == 13)
            digitButtons[i] = createButton(tr("D"), SLOT(digitClicked()));
        //else if(i == 14)
          //  digitButtons[i] = createButton(tr("E"), SLOT(digitClicked()));
        /*
        else
            digitButtons[i] = createButton(tr("F"), SLOT(digitClicked()));
            */

    }

    QPushButton *clearButton = createButton(tr("C"), SLOT(clear()));
    QPushButton *minusButton = createButton(tr("-"), SLOT(operatorClicked()));
    QPushButton *plusButton = createButton(tr("+"), SLOT(operatorClicked()));
    QPushButton *equalButton = createButton(tr("="), SLOT(operatorClicked()));

    QGridLayout *mainLayout = new QGridLayout;
    mainLayout->setSizeConstraint(QLayout::SetFixedSize);

    QSpacerItem *space = new QSpacerItem(0,100);

    mainLayout->addWidget(display, 0, 0, 1, 5);
    mainLayout->addItem(space, 1, 0);
    mainLayout->addWidget(clearButton, 3, 4);

    for (int i = 0; i < 14; ++i) {
        int row = i / 4 + 4;
        int column = (i % 4) + 1;
        mainLayout->addWidget(digitButtons[i], row, column);
    }

    //mainLayout->addWidget(digitButtons[0], 6, 1);


    //mainLayout->addWidget(divisionButton, 3, 4);
    //mainLayout->addWidget(timesButton, 4, 4);
    mainLayout->addWidget(minusButton, 3, 1);
    mainLayout->addWidget(plusButton, 3, 2);
    mainLayout->addWidget(equalButton, 3, 3);
    setLayout(mainLayout);
    setWindowTitle(tr("Calculator"));
}

void calculator::digitClicked()
{
    QPushButton *clickedButton = qobject_cast<QPushButton *>(sender());

    if (waitingForOperand) {
        display->clear();
        waitingForOperand = false;
    }

    int digitValue = clickedButton->text().toInt();
    int displayValue = display->text().toInt();
    if(displayValue >= INT_MAX / 10) return;

    int result = digitValue==0?displayValue*10  :displayValue*10 + digitValue*(digitValue / abs(digitValue));
    display->setText(QString::number(result));
}

void calculator::operatorClicked()
{
    QPushButton *clickedButton = qobject_cast<QPushButton *>(sender());

    doOperation(clickedButton->text());
}

void calculator::clear()
{
    display->setText(tr("0"));
}

void calculator::doOperation(const QString &_operator)
{
    if(!waitingForOperand)
    {
        if(lastOperator == "=")
        {
            leftOperand = display->text().toInt();
        }
        else
        {
            int result = calculate(lastOperator, leftOperand, display->text().toInt());
            leftOperand = result;
            display->setText(QString::number(result));
        }
        waitingForOperand = true;
    }
    lastOperator = _operator;
}


int calculator::calculate(const QString &_operator, int num1, int num2)
{
    int result;

    if(_operator == tr("+") && safeAdd(&result, num1, num2))
    {
        return result;
    }
    if(_operator == tr("-") && safeSub(&result, num1, num2))
    {
        return result;
    }

    QMessageBox::warning(this, tr("Error!"), tr("Integer overflow."), QMessageBox::Close);
    return num1;
}

QPushButton *calculator::createButton(const QString &text, const char *member)
{
    QPushButton *button = new QPushButton(text);
    connect(button, SIGNAL(clicked()), this, member);
    return button;
}

bool calculator::safeAdd(int* result, int a, int b)
{
    *result = a + b;
    if(a > 0 && b > 0 && *result < 0)
        return false;
    if(a < 0 && b < 0 && *result > 0)
        return false;
    return true;
}

bool calculator::safeSub(int* result, int a, int b)
{
    return safeAdd(result, a, -b );
}

