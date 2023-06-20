
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QTimer>
#include <QMimeData>
#include <QQmlComponent>
#include <QQuickItem>
#include "mainwindow.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


    qmlRegisterType<MainWindow>("XFoo", 1, 0, "MainWindow");

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [&engine](QObject* object, const QUrl& url){

        MainWindow* mainWindow = qobject_cast<MainWindow*>(object);

        QQmlComponent* comp = new QQmlComponent(&engine);
        comp->loadUrl(QUrl("qrc:///ViewportItem.qml"));
        QQuickItem *item = qobject_cast<QQuickItem*>(comp->create());
        QQuickItem* dock = mainWindow->wrapItemWithDockable(item, "Viewport");
        mainWindow->setCentralDockItem(dock);


        QQmlComponent* comp2 = new QQmlComponent(&engine);
        comp2->loadUrl(QUrl("qrc:///DetailsItem.qml"));
        QQuickItem *item2 = qobject_cast<QQuickItem*>(comp2->create());
        QQuickItem* dock2 = mainWindow->wrapItemWithDockable(item2, "Details");
        mainWindow->attachToCentralDockItem(dock2, true, true, 0.3);


        QQmlComponent* comp3 = new QQmlComponent(&engine);
        comp3->loadUrl(QUrl("qrc:///LightingItem.qml"));
        QQuickItem *item3 = qobject_cast<QQuickItem*>(comp3->create());
        QQuickItem* dock3 = mainWindow->wrapItemWithDockable(item3, "Lighting");
        mainWindow->attachToCentralDockItem(dock3, false, false, 0.3);

    });

    engine.loadFromModule("XFoo", "Main");

    return app.exec();
}
