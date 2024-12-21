#include "ScreenSaver.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <iostream>

int main(int argc, char *argv[])
{
    #if defined(Q_PROCESSOR_ARM)
    int platformId = 0;

    ScreenSaver screenSaver;
    screenSaver.disable();
    #else
    // desktop probably
    int platformId = 1;
    #endif

    qputenv("QT_QUICK_CONTROLS_STYLE", QByteArray("Material"));
    qputenv("QT_QUICK_CONTROLS_MATERIAL_THEME", QByteArray("Dark"));

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);
    engine.rootContext()->setContextProperty("platform",  platformId);

    //std::cout << "plattform: " << platformId << std::endl;

    return app.exec();
}