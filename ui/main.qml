import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.0

Window {
    id: rootWindow

    Material.theme: Material.Dark
    Material.primary: Material.Grey
    Material.accent: Material.Indigo
    Material.foreground: Material.Blue
    Material.background: Material.Orange

    property int plattform: 1; // from main.cpp. 0 = arm, 1 is other
    property bool lightMode: false

    width: 640
    height: 480
    visible: true
    title: qsTr("Banner")

    Component.onCompleted: {
        if(plattform === 0) {
            rootWindow.showFullScreen()
            flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
        }

        console.log("lightmode: " + lightMode)
    }

    Component {
        id: configuration
        Configuration {
            lightMode: lightMode
        }
    }

    StackView
    {
        id: stack
        anchors.fill: parent

        background: Rectangle {
            anchors.fill: parent
            color: "#000000"
        }

        //initialItem: Qt.resolvedUrl("Configuration.qml")
        initialItem: {configuration}
    }
}
