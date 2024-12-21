import QtQuick 2.3

Item {
    id: ghost

    property string msg;
    property color fontColor: 'red';
    property int fontSize: 20;
    property int duration: 2000;
    property bool isRunning: false;

    signal animationDone;

    Rectangle {
        color: 'black'
        width: parent.width
        height: parent.height / 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: ghostText

            width: parent.width
            height: parent.height

            horizontalAlignment: Text.AlignHCenter

            anchors.horizontalCenter: parent.horizontalCenter

            text: ghost.msg
            color: ghost.fontColor;
            font.pointSize: ghost.fontSize;
            fontSizeMode: Text.HorizontalFit
            opacity: 0.1

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

    SequentialAnimation {
        id: playbanner

        running: ghost.isRunning;
        NumberAnimation { target: ghostText; property: "opacity"; to: 1.0; duration: ghost.duration}
        NumberAnimation { target: ghostText; property: "opacity"; to: 0; duration: ghost.duration}
        //loops: Animation.Infinite;

        onRunningChanged: {
            if(running == false)
            {
                //console.log("ghost animation done");
                ghost.isRunning = false;
                ghost.animationDone();
            }
        }
    }

}

