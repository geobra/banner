import QtQuick 2.3

Item{
    id: marquee;

    // Properties
    property string msg;
    property color fontColor: 'white';
    property int fontSize: 20;
    property int duration: 2000;
    property bool isRunning: false;

    signal animationDone;

    Rectangle {
        color: 'black'
        width: parent.width
        height: parent.height / 2
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: marqueeText;
            anchors.verticalCenter: parent.verticalCenter;

            font.family: 'Droid Sans Fallback';
            font.pointSize: marquee.fontSize;
            color: marquee.fontColor;
            text: marquee.msg;

            PropertyAnimation on x {
                running: marquee.isRunning;

                duration: marquee.duration;
                //loops: Animation.Infinite;
                from: marquee.width;
                to: -marqueeText.width;

                onRunningChanged: {
                    if(running == false)
                    {
                        //console.log("marquee animation done");
                        marquee.isRunning = false;
                        marquee.animationDone();
                    }
                }
            }

            SequentialAnimation on color {
                id: colorAn
                property int dr: 5000;
                ColorAnimation { to: "yellow"; duration: colorAn.dr }
                ColorAnimation { to: "blue"; duration: colorAn.dr }
                ColorAnimation { to: "red"; duration: colorAn.dr }
                loops: Animation.Infinite;
            }
        }
    }
}

