import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

GridView{
    id: creatalarmlist_showMode
    anchors.fill:parent
    anchors.margins:200
    clip:true
    signal deletalarmlist(var arealistseril);//删除
    model: ListModel{
        //ListElement{chserial_text: chserial;alarmcolor:"red";chname_text:chname;voltcurr_text:chvoltcurr;iconsourceopen:miconsourceopen; iconsourceclose:miconsourceclose}
    }
    cellWidth: width
    cellHeight: 55
    delegate:numberDelegatecalarm
    Component{
        id : numberDelegatecalarm
        Rectangle{
            id :creatalarmlistre
            width: creatalarmlist_showMode.width
            height: 50
            color:"#f3f7ff"
            Rectangle {
                id: chstateled
                anchors.top:parent.top
                anchors.topMargin: 2
                anchors.left:parent.left
                anchors.leftMargin: 15
                width:20
                height: 10
                Text {
                    id: alarmname
                    width: 20
                    height: 8
                    text: alarmname_text
                    font.family: "宋体"
                    font.pointSize: 8
                    color: "red"
                }
                ToolButton {
                    id: devalarmoclosebnt
                    anchors.top:parent.top
                    anchors.topMargin: 1
                    anchors.left:parent.left
                    anchors.leftMargin: 230
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
                        deletalarmlist(model.index);//删除
                    }
                }
            }
            Text {
                id: alarmplacename
                anchors.top:parent.top
                anchors.topMargin: 15
                anchors.left:parent.left
                anchors.leftMargin: 10
                width: 20
                height: 8
                text: placename_text
                font.family: "宋体"
                font.pointSize: 8
            }

            Text {
                id: alarmwhyname
                anchors.top:parent.top
                anchors.topMargin: 15
                anchors.left:parent.left
                anchors.leftMargin: 30
                width: 20
                height: 8
                text: whyname_text
                font.family: "宋体"
                font.pointSize: 8
            }

            Text {
                id: alarmtimename
                anchors.top:parent.top
                anchors.topMargin: 30
                anchors.left:parent.left
                anchors.leftMargin: 10
                width: 20
                height: 8
                text: timename_text
                font.family: "宋体"
                font.pointSize: 8
            }
        }
    }
    Component.onCompleted: {
        deletalarmlist.connect(deletalarmlistfun);
    }


    //创建model显示
    function creatalarmlistShow(alarmnameu,alarmplacenameu,alarmwhynameu,alarmtimenameu){
        creatalarmlist_showMode.model.append({alarmname_text: alarmnameu,placename_text:alarmplacenameu,whyname_text:alarmwhynameu,timename_text:alarmtimenameu})

    }
}

