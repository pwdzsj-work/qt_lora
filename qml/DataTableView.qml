pragma ComponentBehavior: Bound

import QtQuick

Item {
    id: tableRoot

    property alias model: rowModel
    property var holdMenuModelDataArray: null
    property var columnTitles: []
    property var columnWidths: []
    property var columnRoles: []
    property color frameBorderColor: "#b0b0b0"

    ListModel { id: rowModel }

    Row {
        id: header
        width: parent.width
        height: 30

        Repeater {
            model: tableRoot.columnTitles.length
            delegate: Rectangle {
                required property int index
                width: tableRoot.columnWidths[index] || 0
                height: header.height
                border.color: tableRoot.frameBorderColor
                color: "#f3f7ff"

                Text {
                    anchors.centerIn: parent
                    text: tableRoot.columnTitles[index]
                    font.pixelSize: 24
                    color: "#000000"
                }
            }
        }
    }

    ListView {
        id: rows
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true
        model: rowModel

        delegate: Row {
            id: dataRow
            required property var model
            width: rows.width
            height: 30

            Repeater {
                model: tableRoot.columnRoles.length
                delegate: Rectangle {
                    required property int index
                    width: tableRoot.columnWidths[index] || 0
                    height: dataRow.height
                    border.color: tableRoot.frameBorderColor
                    color: "#5976e0"

                    Text {
                        anchors.centerIn: parent
                        text: dataRow.model[tableRoot.columnRoles[index]] ?? ""
                        font.pixelSize: 24
                        color: "#000000"
                    }
                }
            }
        }
    }

    function updateColumn2Table(arrayData) {
        if (arrayData.length !== 3) {
            console.log("DataTableView.qml: updateColumn2Table expects three arrays")
            return
        }

        const titles = arrayData[0]
        const widths = arrayData[1]
        const roles = arrayData[2]
        if (titles.length !== widths.length || titles.length > roles.length) {
            console.log("DataTableView.qml: invalid column metadata")
            return
        }

        let totalWidth = 0
        for (let i = 0; i < widths.length; ++i)
            totalWidth += widths[i]

        const calculatedWidths = []
        for (let column = 0; column < widths.length; ++column)
            calculatedWidths.push(totalWidth > 0
                                  ? Math.round(tableRoot.width * widths[column] / totalWidth)
                                  : 0)

        rowModel.clear()
        columnTitles = titles
        columnWidths = calculatedWidths
        columnRoles = roles
    }
}
