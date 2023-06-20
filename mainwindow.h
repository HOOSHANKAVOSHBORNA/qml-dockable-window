#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QQuickWindow>

class MainWindow : public QQuickWindow
{
    Q_OBJECT
public:
    MainWindow();

public:
    QQuickItem* wrapItemWithDockable(QQuickItem* item,const QString& title);
    void setCentralDockItem(QQuickItem* dockItem);
    void attachToCentralDockItem(QQuickItem* dockItem, bool horizontalAttach, bool attachAsFirst, qreal splitScale);
};

#endif // MAINWINDOW_H
