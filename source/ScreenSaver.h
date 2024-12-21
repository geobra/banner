#ifndef SCREENSAVER_H
#define SCREENSAVER_H

#include <QObject>

class ScreenSaver : public QObject
{
public:
    ScreenSaver(QObject *parent = 0);

    void disable();

};

#endif // SCREENSAVER_H
