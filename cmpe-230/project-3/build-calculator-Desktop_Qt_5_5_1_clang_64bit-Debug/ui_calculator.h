/********************************************************************************
** Form generated from reading UI file 'calculator.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_CALCULATOR_H
#define UI_CALCULATOR_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_calculator
{
public:
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QWidget *centralWidget;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *calculator)
    {
        if (calculator->objectName().isEmpty())
            calculator->setObjectName(QStringLiteral("calculator"));
        calculator->resize(400, 300);
        menuBar = new QMenuBar(calculator);
        menuBar->setObjectName(QStringLiteral("menuBar"));
        calculator->setMenuBar(menuBar);
        mainToolBar = new QToolBar(calculator);
        mainToolBar->setObjectName(QStringLiteral("mainToolBar"));
        calculator->addToolBar(mainToolBar);
        centralWidget = new QWidget(calculator);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        calculator->setCentralWidget(centralWidget);
        statusBar = new QStatusBar(calculator);
        statusBar->setObjectName(QStringLiteral("statusBar"));
        calculator->setStatusBar(statusBar);

        retranslateUi(calculator);

        QMetaObject::connectSlotsByName(calculator);
    } // setupUi

    void retranslateUi(QMainWindow *calculator)
    {
        calculator->setWindowTitle(QApplication::translate("calculator", "calculator", 0));
    } // retranslateUi

};

namespace Ui {
    class calculator: public Ui_calculator {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_CALCULATOR_H
