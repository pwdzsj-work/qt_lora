import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

GridView{
    id: channelplan_view
    anchors.fill:parent
    anchors.margins:2
    clip:true
    signal plansendConfigSignal(var arealistseril);//删除
    signal plansendeditConfigSignal(var arealistseril,var edit,var planname);//编辑
    model: ListModel{
     //ListElement{reLiSer_text: "itemser";planname_text:"planname";delaytime_text:"delaytim"}
    }
    cellWidth: width
    cellHeight: 25
    delegate:numberDelegatepan
    Component{
        id : numberDelegatepan
        Rectangle{
            id :all_user
            width: channelplan_view.width
            height: 20
            color:"#f3f7ff"
            Text {
                id: reLiSertext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 15
                width: 12
                height: 12
                text: reLiSer_text
                font.family: "宋体"
                font.pointSize: 12
            }
            Text {
                id: plannametext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 215
                width: 12
                height: 12
                text: planname_text
                font.family: "宋体"
                font.pointSize: 12
            }
            Text {
                id: delaytimetext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 445
                width: 12
                height: 12
                text: delaytime_text
                font.family: "宋体"
                font.pointSize: 12
            }
            ToolButton {
                id: planvoperbnt
                anchors.top:parent.top
                anchors.topMargin: 1
                anchors.left:parent.left
                anchors.leftMargin: 840
                width: 20
                height: 20
                text: ""
                display: AbstractButton.IconOnly
                icon.source: "qrc:/icon/smal_Info_edit.png"
                icon.width: 16
                icon.height: 16
                icon.color: "transparent"
                padding: 0
                onClicked: {
                plansendeditConfigSignal(model.index,"edit",plannametext.text);
                }
            }
            ToolButton {
                id: planoperclosebnt
                anchors.top:parent.top
                anchors.topMargin: 1
                anchors.left:parent.left
                anchors.leftMargin: 875
                width: 20
                height: 20
                text: ""
                display: AbstractButton.IconOnly
                icon.source: "qrc:/icon/smallclose.png"
                icon.width: 16
                icon.height: 16
                icon.color: "transparent"
                padding: 0
                onClicked: {
                       plansendConfigSignal(model.index);//删除
                }
            }
        }
    }
    Component.onCompleted: {
            plansendConfigSignal.connect(plantodevcofigslot);
        plansendeditConfigSignal.connect(correctpantodevcofigslot)
    }
    //创建model显示
    function creatplanlist(itemser,planname,delaytim){
        channelplan_view.model.append({reLiSer_text: itemser,planname_text:planname,delaytime_text:delaytim})


    }
}


