import QtQuick.Controls 2.5
import QtQuick 2.15
import QtQuick.Layouts 1.0

Rectangle {
    id: configuration

    Component {
        id: displayTextDelegate

        RowLayout {
            Rectangle {
                Layout.fillWidth: true
                Layout.minimumWidth: 100
                Layout.preferredWidth: rootWindow.width * 0.5
                Layout.minimumHeight: 50
                TextField {
                    //font.pointSize: 20

                    placeholderText: bannerText
                    placeholderTextColor: 'grey'
                    onTextChanged: {
                        bannerText = text;
                    }
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.minimumWidth: 40
                Layout.preferredWidth: rootWindow.width * 0.20
                Layout.minimumHeight: 50
                TextField {
                    text: durationTime
                    onTextChanged: {
                        durationTime = text;
                    }
                    validator: IntValidator {bottom: 1; top: 100000}

                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.minimumWidth: 5
                Layout.preferredWidth: rootWindow.width * 0.08
                Layout.minimumHeight: 50
                Label {
                    text: "ms"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.minimumWidth: 40
                Layout.preferredWidth: rootWindow.width * 0.20
                Layout.minimumHeight: 50
                ComboBox {
                    id: animationChooser
                    model: [ "ghost", "wq" ];
                    currentIndex: indexNr;
                    onCurrentIndexChanged: {
                        indexNr = currentIndex;
                    }

                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
            }
        }

    }

    Rectangle {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: buttons.top
        }
        anchors.fill: parent

        ListView {
            id: listView

            width: rootWindow.width
            height: rootWindow.height - (buttons.height * 2)

            model: DisplayTextModel {}
            delegate: displayTextDelegate
        }
    }

    Row {
        id: buttons
        width: parent.width
        height: 43
        visible: true
        spacing: 16
        anchors.bottom: parent.bottom
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        Button {
            text: "add row";
            onClicked: {
                listView.model.append({ bannerText: "message", durationTime: "1000", indexNr: 0 });
            }
        }
        Button {
            text: "remove row";
            onClicked: {
                console.log("rm: " + listView.model.rowCount())
                if (listView.model.rowCount() > 1) {
                    listView.model.remove(listView.model.rowCount()-1);
                }
            }
        }

        Button {
            text: "Start Animation";

            onClicked: {
                var arr = [];
                for( var i = 0; i < listView.model.rowCount(); i++ ) {
                    //console.log( "text: " + listView.model.get(i).bannerText + " , duration: " + listView.model.get(i).durationTime + " , type: " + listView.model.get(i).indexNr);
                    arr.push({ msg : listView.model.get(i).bannerText, duration: listView.model.get(i).durationTime, type: (listView.model.get(i).indexNr === 0) ? "ghost" : "wq" });
                }

                stack.push(Qt.resolvedUrl("Animation.qml"), {array: arr})
            }
        }
    }

}
