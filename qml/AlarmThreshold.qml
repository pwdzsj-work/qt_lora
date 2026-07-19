import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

GridView{
    id: alarmthreshold_view
    anchors.fill:parent
    anchors.margins:2
    clip:true
    model: ListModel{
 //ListElement{chserial_text: chserial;alarmcolor:"red";chname_text:chname;voltcurr_text:chvoltcurr;iconsourceopen:miconsourceopen; iconsourceclose:miconsourceclose}
    }
    cellWidth: width
    cellHeight: 55
    delegate:numberDelegate
    Component{
        id : numberDelegate
        Rectangle{
            id :all_user
            width: measure_showMode.width
            height: 20
            color:"#f3f7ff"
            Text {
                id: reLiSertext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 10
                width: 5
                height: 5
                text: reLiSer_text
                font.family: "宋体"
                font.pointSize: 8
            }
            Text {
                id: dennametext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 150
                width: 5
                height: 5
                text: denname_text
                font.family: "宋体"
                font.pointSize: 8
            }
            Text {
                id: chnametext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 300
                width: 5
                height: 5
                text: chname_text
                font.family: "宋体"
                font.pointSize: 8
            }
            Text {
                id: maxcurrtext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 450
                width: 5
                height: 5
                text: maxcurr_text
                font.family: "宋体"
                font.pointSize: 8
            }
            Text {
                id: volyrangtext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 600
                width: 5
                height: 5
                text: volyrang_text
                font.family: "宋体"
                font.pointSize: 8
            }
            Text {
                id: maxtemptext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 750
                width: 5
                height: 5
                text: maxtemp_text
                font.family: "宋体"
                font.pointSize: 8
            }
            ToolButton {
                id: alarmoperbnt
                anchors.top:parent.top
                anchors.topMargin: 1
                anchors.left:parent.left
                anchors.leftMargin: 890
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

                }
            }
            ToolButton {
                id: alarmoperclosebnt
                anchors.top:parent.top
                anchors.topMargin: 1
                anchors.left:parent.left
                anchors.leftMargin: 920
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

                }
            }
        }
    }
    //创建model显示
    function creatregionallist(itemser,areaname,devname){
        measure_showMode.model.append({reLiSer_text: itemser,areaname_text:areaname,devname_text:devname})


    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
