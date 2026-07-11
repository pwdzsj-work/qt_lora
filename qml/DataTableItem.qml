import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4

Rectangle{
    id: tableCell
    anchors.fill: parent;
    anchors.margins: 3;
    border.color: "blue";
    radius:3;
    color: styleData.selected ? "transparent" : "#1A4275";

    Text{
        id: textID;
        text:styleData.value ;
        font.family: "微软雅黑";
        font.pixelSize: 12;
        anchors.fill: parent;
        color: "#3359e1";
        elide: Text.ElideRight;
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
