#include "ScreenSaver.h"

#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>
#include <QDebug>

#define MAX_SERVICES 2

// https://stackoverflow.com/questions/31498114/how-to-programmatically-prevent-linux-computer-from-sleeping-or-turning-on-scree
ScreenSaver::ScreenSaver(QObject *parent) :QObject(parent)
{

}

void ScreenSaver::disable()
{
    QDBusConnection bus = QDBusConnection::sessionBus();
    if(bus.isConnected())
    {
        QString services[MAX_SERVICES] = {
            "org.freedesktop.ScreenSaver",
            "org.gnome.SessionManager"
        };
        QString paths[MAX_SERVICES] = {
            "/org/freedesktop/ScreenSaver",
            "/org/gnome/SessionManager"
        };

        for(int i = 0; i < MAX_SERVICES ; i++)
        {
            QDBusInterface screenSaverInterface(services[i], paths[i],services[i], bus, this);
            if (!screenSaverInterface.isValid())
                continue;

            QDBusReply<uint> reply = screenSaverInterface.call(
                "Inhibit", "banner", "disabled to show banner");
            if (reply.isValid())
            {
                auto cookieID = reply.value();
                qDebug() << "ScreenSaver disable succesful. CookiId: " << cookieID;
            } else {
                QDBusError error =reply.error();
                qDebug() << "Screensaver diable error: " << error.message() << error.name();
            }
        }
    }
}
