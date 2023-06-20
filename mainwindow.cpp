
#include "mainwindow.h"
#include <QTimer>
#include <QCursor>
#include <QDebug>
#include <QGuiApplication>
#include <QQuickItem>

MainWindow::MainWindow()
{
}

QQuickItem *MainWindow::wrapItemWithDockable(QQuickItem *item, const QString& title)
{
    QVariant dockableItemVariant;
    QMetaObject::invokeMethod(this, "wrapItemWithDockableImpl",
                              Q_RETURN_ARG(QVariant, dockableItemVariant),
                              Q_ARG(QVariant, QVariant::fromValue<QQuickItem*>(item)),
                              Q_ARG(QVariant, QVariant::fromValue<QString>(title)));

    QQuickItem *dockableItem = dockableItemVariant.value<QQuickItem*>();

    return dockableItem;
}

void MainWindow::setCentralDockItem(QQuickItem *dockItem)
{
    QMetaObject::invokeMethod(this, "setCentralDockItemImpl",
                              Q_ARG(QVariant, QVariant::fromValue<QQuickItem*>(dockItem)));
}

void MainWindow::attachToCentralDockItem(QQuickItem *dockItem, bool horizontalAttach, bool attachAsFirst, qreal splitScale)
{
    QMetaObject::invokeMethod(this, "attachToCentralDockItemImpl",
                              Q_ARG(QVariant, QVariant::fromValue<QQuickItem*>(dockItem)),
                              Q_ARG(QVariant, QVariant::fromValue<bool>(horizontalAttach)),
                              Q_ARG(QVariant, QVariant::fromValue<bool>(attachAsFirst)),
                              Q_ARG(QVariant, QVariant::fromValue<qreal>(splitScale))
                              );
}
