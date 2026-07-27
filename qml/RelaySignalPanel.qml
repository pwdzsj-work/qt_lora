import QtQuick 2.12

Rectangle {
    id: signalPanel
    signal analogModeChangeRequested(int channel, bool currentMode)
    color: "#f8faff"
    radius: 6
    border.color: "#cbd5e5"
    border.width: 1
    clip: true

    ListModel {
        id: digitalInputModel
    }

    ListModel {
        id: analogInputModel
    }

    Component.onCompleted: {
        for (var input = 0; input < 4; ++input)
            digitalInputModel.append({ channel: input + 1, high: false })
        for (var analog = 0; analog < 4; ++analog) {
            analogInputModel.append({
                channel: analog + 1,
                currentMode: false,
                valueText: "0.00"
            })
        }
    }

    function updateSignals(values) {
        if (!values || values.length < 12)
            return
        for (var input = 0; input < 4; ++input) {
            digitalInputModel.setProperty(input, "high",
                                          Number(values[input]) !== 0)
        }
        for (var analog = 0; analog < 4; ++analog) {
            analogInputModel.setProperty(analog, "valueText",
                                         Number(values[4 + analog]).toFixed(2))
            analogInputModel.setProperty(analog, "currentMode",
                                         Number(values[8 + analog]) !== 0)
        }
    }

    Text {
        id: panelTitle
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.top: parent.top
        anchors.topMargin: 8
        text: qsTr("检测信号")
        color: "#26364d"
        font.pixelSize: 18
        font.bold: true
    }

    Rectangle {
        id: digitalPanel
        anchors.left: parent.left
        anchors.top: panelTitle.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 6
        anchors.bottomMargin: 10
        width: parent.width * 0.43
        color: "white"
        radius: 5
        border.color: "#d8dfeb"

        Text {
            id: digitalTitle
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 6
            text: qsTr("输入高低电平")
            color: "#4a5b73"
            font.pixelSize: 14
            font.bold: true
        }

        GridView {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: digitalTitle.bottom
            anchors.bottom: parent.bottom
            anchors.margins: 6
            model: digitalInputModel
            interactive: false
            cellWidth: width / 2
            cellHeight: height / 2

            delegate: Item {
                id: digitalDelegate
                required property int channel
                required property bool high
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 3
                    radius: 4
                    color: digitalDelegate.high ? "#e9f8ed" : "#f0f2f5"
                    border.color: digitalDelegate.high ? "#35a853" : "#a8b0bc"

                    Rectangle {
                        width: 10
                        height: 10
                        radius: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 9
                        anchors.verticalCenter: parent.verticalCenter
                        color: digitalDelegate.high ? "#2ebc59" : "#7c8796"
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 24
                        anchors.verticalCenter: parent.verticalCenter
                        text: "NQ" + digitalDelegate.channel
                        color: "#26364d"
                        font.pixelSize: 13
                        font.bold: true
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: digitalDelegate.high ? qsTr("高") : qsTr("低")
                        color: digitalDelegate.high ? "#238a42" : "#606a78"
                        font.pixelSize: 12
                    }
                }
            }
        }
    }

    Rectangle {
        id: analogPanel
        anchors.left: digitalPanel.right
        anchors.right: parent.right
        anchors.top: digitalPanel.top
        anchors.bottom: digitalPanel.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        color: "white"
        radius: 5
        border.color: "#d8dfeb"

        Text {
            id: analogTitle
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 6
            text: qsTr("模拟量输入")
            color: "#4a5b73"
            font.pixelSize: 14
            font.bold: true
        }

        GridView {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: analogTitle.bottom
            anchors.bottom: parent.bottom
            anchors.margins: 6
            model: analogInputModel
            interactive: false
            cellWidth: width / 2
            cellHeight: height / 2

            delegate: Item {
                id: analogDelegate
                required property int channel
                required property bool currentMode
                required property string valueText
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 3
                    radius: 4
                    color: analogDelegate.currentMode ? "#fff5e8" : "#eaf3ff"
                    border.color: analogDelegate.currentMode
                                  ? "#e39a32" : "#4e8fd8"

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 9
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        text: "AN" + analogDelegate.channel
                        color: "#26364d"
                        font.pixelSize: 13
                        font.bold: true
                    }

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 9
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        spacing: 5

                        Rectangle {
                            width: 50
                            height: 18
                            radius: 3
                            color: !analogDelegate.currentMode
                                   ? "#4e8fd8" : "#edf1f6"
                            border.color: "#4e8fd8"
                            Text {
                                anchors.centerIn: parent
                                text: "0–10 V"
                                color: !analogDelegate.currentMode
                                       ? "white" : "#326da9"
                                font.pixelSize: 10
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    analogInputModel.setProperty(
                                                analogDelegate.channel - 1,
                                                "currentMode", false)
                                    signalPanel.analogModeChangeRequested(
                                                analogDelegate.channel, false)
                                }
                            }
                        }

                        Rectangle {
                            width: 64
                            height: 18
                            radius: 3
                            color: analogDelegate.currentMode
                                   ? "#e39a32" : "#f4f1ec"
                            border.color: "#e39a32"
                            Text {
                                anchors.centerIn: parent
                                text: "4–20 mA"
                                color: analogDelegate.currentMode
                                       ? "white" : "#a96613"
                                font.pixelSize: 10
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    analogInputModel.setProperty(
                                                analogDelegate.channel - 1,
                                                "currentMode", true)
                                    signalPanel.analogModeChangeRequested(
                                                analogDelegate.channel, true)
                                }
                            }
                        }
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 9
                        anchors.verticalCenter: parent.verticalCenter
                        text: analogDelegate.valueText
                              + (analogDelegate.currentMode ? " mA" : " V")
                        color: analogDelegate.currentMode ? "#d27b12" : "#256bb2"
                        font.pixelSize: 17
                        font.bold: true
                    }
                }
            }
        }
    }
}
