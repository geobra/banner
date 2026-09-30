import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.0

Rectangle {
    id: configuration

    property bool lightMode: false
    property bool compact: width < 520
    property color pageColor: lightMode ? "#f1f3ed" : "#171b18"
    property color panelColor: lightMode ? "#ffffff" : "#222824"
    property color fieldColor: lightMode ? "#f4f6f1" : "#2b332e"
    property color primaryText: lightMode ? "#202820" : "#f1f4ee"
    property color secondaryText: lightMode ? "#657067" : "#aab5ac"
    property color accentColor: lightMode ? "#287a55" : "#a6e36e"
    property color borderColor: lightMode ? "#dce3da" : "#39443c"

    color: pageColor

    function addMessage() {
        displayTextModel.append({ bannerText: "message", durationTime: 1000, indexNr: 0 });
        messageList.positionViewAtEnd();
    }

    function startAnimation() {
        var messages = [];
        for (var row = 0; row < displayTextModel.rowCount(); row++) {
            var entry = displayTextModel.get(row);
            messages.push({
                msg: entry.bannerText,
                duration: entry.durationTime,
                type: entry.indexNr === 0 ? "ghost" : "wq"
            });
        }
        stack.push(Qt.resolvedUrl("Animation.qml"), { array: messages });
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: configuration.compact ? 16 : 28
        spacing: 18

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3

                Label {
                    text: "Banner queue"
                    color: configuration.primaryText
                    font.pixelSize: configuration.compact ? 23 : 28
                    font.weight: Font.DemiBold
                }

                Label {
                      text: messageList.count === 1
                          ? "1 message ready"
                          : messageList.count + " messages ready"
                    color: configuration.secondaryText
                    font.pixelSize: 13
                }
            }

            Button {
                text: configuration.compact ? "+ Add" : "+  Add message"
                Layout.preferredHeight: 42
                onClicked: configuration.addMessage()

                contentItem: Label {
                    text: parent.text
                    color: configuration.lightMode ? "#ffffff" : "#172015"
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: 7
                    color: configuration.accentColor
                }
            }
        }

        ListView {
            id: messageList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 10
            model: displayTextModel
            boundsBehavior: Flickable.StopAtBounds
            moveDisplaced: Transition {
                NumberAnimation { properties: "y"; duration: 150; easing.type: Easing.OutQuad }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            delegate: Rectangle {
                id: messagePanel
                required property int index
                required property string bannerText
                required property int durationTime
                required property int indexNr

                width: messageList.width
                height: fields.implicitHeight + 32
                radius: 8
                color: configuration.panelColor
                border.width: 1
                border.color: configuration.borderColor

                ColumnLayout {
                    id: fields
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 11

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Label {
                            Layout.fillWidth: true
                            text: "MESSAGE " + (messagePanel.index + 1).toString().padStart(2, "0")
                            color: configuration.secondaryText
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                        }

                        ToolButton {
                            text: "\u25b2"
                            enabled: messagePanel.index > 0
                            implicitHeight: 30
                            implicitWidth: 34
                            onClicked: displayTextModel.moveRow(messagePanel.index, messagePanel.index - 1)
                            contentItem: Label {
                                text: parent.text
                                color: parent.enabled ? configuration.primaryText : configuration.secondaryText
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        ToolButton {
                            text: "\u25bc"
                            enabled: messagePanel.index < messageList.count - 1
                            implicitHeight: 30
                            implicitWidth: 34
                            onClicked: displayTextModel.moveRow(messagePanel.index, messagePanel.index + 1)
                            contentItem: Label {
                                text: parent.text
                                color: parent.enabled ? configuration.primaryText : configuration.secondaryText
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        ToolButton {
                            text: "Remove"
                            enabled: displayTextModel.rowCount() > 1
                            implicitHeight: 30
                            onClicked: displayTextModel.remove(messagePanel.index)
                            contentItem: Label {
                                text: parent.text
                                color: parent.enabled ? "#df877a" : configuration.secondaryText
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        Label {
                            text: "Banner text"
                            color: configuration.primaryText
                            font.pixelSize: 13
                            font.weight: Font.Medium
                        }

                        TextField {
                            Layout.fillWidth: true
                            implicitHeight: 44
                            text: messagePanel.bannerText
                            placeholderText: "Enter a message"
                            color: configuration.primaryText
                            placeholderTextColor: configuration.secondaryText
                            leftPadding: 12
                            rightPadding: 12
                            onTextEdited: displayTextModel.setBannerText(messagePanel.index, text)

                            background: Rectangle {
                                radius: 6
                                color: configuration.fieldColor
                                border.width: parent.activeFocus ? 2 : 1
                                border.color: parent.activeFocus ? configuration.accentColor : configuration.borderColor
                            }
                        }
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: configuration.compact ? 1 : 2
                        columnSpacing: 14
                        rowSpacing: 11

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Label {
                                text: "Duration"
                                color: configuration.primaryText
                                font.pixelSize: 13
                                font.weight: Font.Medium
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                TextField {
                                    Layout.fillWidth: true
                                    implicitHeight: 42
                                    text: messagePanel.durationTime
                                    color: configuration.primaryText
                                    validator: IntValidator { bottom: 1; top: 100000 }
                                    inputMethodHints: Qt.ImhDigitsOnly
                                    onTextEdited: displayTextModel.setDurationTime(messagePanel.index, text)
                                    onEditingFinished: text = messagePanel.durationTime

                                    background: Rectangle {
                                        radius: 6
                                        color: configuration.fieldColor
                                        border.width: parent.activeFocus ? 2 : 1
                                        border.color: parent.activeFocus ? configuration.accentColor : configuration.borderColor
                                    }
                                }

                                Label {
                                    text: "ms"
                                    color: configuration.secondaryText
                                    font.pixelSize: 13
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Label {
                                text: "Visual effect"
                                color: configuration.primaryText
                                font.pixelSize: 13
                                font.weight: Font.Medium
                            }

                            ComboBox {
                                Layout.fillWidth: true
                                implicitHeight: 42
                                model: [ "Ghost", "Marquee" ]
                                currentIndex: messagePanel.indexNr
                                onActivated: displayTextModel.setIndexNr(messagePanel.index, currentIndex)

                                contentItem: Text {
                                    leftPadding: 12
                                    rightPadding: 32
                                    text: parent.displayText
                                    color: configuration.primaryText
                                    font.pixelSize: 14
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                }
                                background: Rectangle {
                                    radius: 6
                                    color: configuration.fieldColor
                                    border.width: parent.activeFocus ? 2 : 1
                                    border.color: parent.activeFocus ? configuration.accentColor : configuration.borderColor
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Label {
                Layout.fillWidth: true
            }

            Button {
                text: "Start animation"
                Layout.preferredHeight: 46
                onClicked: configuration.startAnimation()

                contentItem: Label {
                    text: parent.text
                    color: "#172015"
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: 7
                    color: configuration.accentColor
                }
            }
        }
    }
}