import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12


GridView{
    id: regional_moidu
    anchors.fill:parent
    anchors.margins:2
    property var itemser: ""
    property var areaname: ""
    property var devname: ""

    //  property alias cmodel: measure_showMode.model
    clip:true
    //  signal:careasendConfigSignal(var arealistseril);
        signal careasendConfigSignal(var arealistseril);
        signal correctreasendConfigSignal(var arealistseril);
    model: ListModel{
        //ListElement{reLiSer_text: "0";areaname_text:"1";devname_text:"2"}
    }
    cellWidth: width
    cellHeight: 25
    delegate:numberDelegate1

    Component{
        id : numberDelegate1
        Rectangle{
            id :all_user
            width: regional_moidu.width
            height: 20
            color:"#ffffff"
            Text {
                id: reLiSertext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 20
                width: 12
                height: 12
                text: reLiSer_text
                font.family: "宋体"
                font.pointSize: 12
            }
            Text {
                id: areanametext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 214
                width: 12
                height: 12
                text: areaname_text
                font.family: "宋体"
                font.pointSize: 12
            }
            Text {
                id: devnametext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 450
                width: 12
                height: 12
                text: devname_text
                font.family: "宋体"
                font.pointSize: 12
            }
            ToolButton {
                id: devoperbnt
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
                    correctreasendConfigSignal(model.index);//编辑
                }
            }
            ToolButton {
                id: devoperclosebnt
                anchors.top:parent.top
                anchors.topMargin: 1
                anchors.left:parent.left
                anchors.leftMargin: 870
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
                    careasendConfigSignal(model.index);//删除
                }
            }
        }
    }
    Component.onCompleted: {
            careasendConfigSignal.connect(areatodevcofigslot);
            correctreasendConfigSignal.connect(correctareatodevcofigslot);
    }

  //创建model显示
    function creatregionallisthand(itemser,areaname,devname){
        regional_moidu.model.append({reLiSer_text: itemser,areaname_text:areaname,devname_text:devname})
    }

}



