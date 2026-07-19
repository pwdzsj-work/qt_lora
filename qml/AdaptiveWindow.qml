import QtQuick
import QtQuick.Window

Window {
    id: adaptiveWindow

    property real designWidth: 1200
    property real designHeight: 800
    property bool responsiveContent: false
    readonly property real contentScale: responsiveContent
                                         ? 1
                                         : Math.min(width / designWidth,
                                                    height / designHeight)
    default property alias scaledContent: designSurface.data

    width: designWidth
    height: designHeight
    color: "#f3f7ff"

    Item {
        id: designSurface
        width: adaptiveWindow.responsiveContent ? adaptiveWindow.width
                                                : adaptiveWindow.designWidth
        height: adaptiveWindow.responsiveContent ? adaptiveWindow.height
                                                 : adaptiveWindow.designHeight
        anchors.centerIn: parent
        scale: adaptiveWindow.contentScale
        transformOrigin: Item.Center
    }

    MouseArea {
        visible: adaptiveWindow.responsiveContent
        z: 1000
        width: 6
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        cursorShape: Qt.SizeHorCursor
        onPressed: adaptiveWindow.startSystemResize(Qt.LeftEdge)
    }

    MouseArea {
        visible: adaptiveWindow.responsiveContent
        z: 1000
        width: 6
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        cursorShape: Qt.SizeHorCursor
        onPressed: adaptiveWindow.startSystemResize(Qt.RightEdge)
    }

    MouseArea {
        visible: adaptiveWindow.responsiveContent
        z: 1000
        height: 6
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.SizeVerCursor
        onPressed: adaptiveWindow.startSystemResize(Qt.TopEdge)
    }

    MouseArea {
        visible: adaptiveWindow.responsiveContent
        z: 1000
        height: 6
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeVerCursor
        onPressed: adaptiveWindow.startSystemResize(Qt.BottomEdge)
    }
}
