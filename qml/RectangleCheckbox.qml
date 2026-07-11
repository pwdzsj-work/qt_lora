import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle
{
   property var nRectangleWidth: 100   //整体框宽度
    property var nRectangleHeight: 36   //整体框高度
  //  property var nTextFrameWidth: 100    //显示文字外框宽度
    property var tText: qsTr("")        //显示文字
    property alias cbmodel: m_combobox.model;//外部注入显示列表
    width: nRectangleWidth
    height: nRectangleHeight - 3
   // border.color: "#7D7D7D"
    ComboBox {
        id: m_combobox
        anchors.top:parent.top
        anchors.topMargin: 1
        anchors.left:parent.left
        anchors.leftMargin: 1
        width:100
        height: 32
        model: ListModel {//model1
        }
        delegate:ItemDelegate{
            id: itedmdfdd
            width: m_combobox.width
            height: m_combobox.height
            contentItem: CheckBox{//复选框太大，需要改小点
                id: checkddid
                anchors.fill: parent;
                checked: model.nCheck
                text: model.nText
                onClicked: {
                    model.nCheck = checkddid.checked
                    //在此处保存数就
                }

            }
        }
    }

}

