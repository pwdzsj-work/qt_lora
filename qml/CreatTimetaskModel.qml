import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4

GridView{
    id: timetconmodel
    anchors.fill:parent
    anchors.margins:200
    clip:true
    signal deletimetasklist(var arealistseril);//删除
    signal editimetasklist(var arealistseril,var taskname);//编辑
    model: ListModel{
    }
    cellWidth: 260
    cellHeight: 30
    delegate:numberDelegatetm
    Component{
        id : numberDelegatetm
        Rectangle{
            id :qcall_user
            width: 260
            height: 40
            color:"#f3f7ff"
            Text {
                id: timetaskmodeseri
                anchors.top:parent.top
                anchors.topMargin:12
                anchors.left:parent.left
                anchors.leftMargin: 5
                anchors.fill: parent
                text: timetaskseri_text
                font.family: "宋体"
                font.pointSize: 8

            }
            Text {
                id: timetaskmodename
                anchors.top:parent.top
                anchors.topMargin:12
                anchors.left:parent.left
                anchors.leftMargin: 65
                anchors.fill: parent
                text: timetaskname_text
                font.family: "宋体"
                font.pointSize: 8

            }
            Text {
                id: timetaskmodetime
                anchors.top:parent.top
                anchors.topMargin:12
                anchors.left:parent.left
                anchors.leftMargin: 150
                anchors.fill: parent
                text: timetasktime_text
                font.family: "宋体"
                font.pointSize: 8
            }
            ToolButton {
                id: timetaskbntopr
                anchors.top:parent.top
                anchors.topMargin: 10
                anchors.left:parent.left
                anchors.leftMargin: 205
                width: 15
                height: 15
                text: qsTr("2")
                iconSource: "qrc:/icon/smal_Info_edit.png"
                onClicked: {
                 editimetasklist(model.index,timetaskmodename.text);
                }
            }
            ToolButton {
                id: timetaskbntclose
                anchors.top:parent.top
                anchors.topMargin: 10
                anchors.left:parent.left
                anchors.leftMargin: 225
                width: 15
                height: 15
                text: qsTr("2")
                iconSource: "qrc:/icon/smallclose.png"
                onClicked: {//删除
                  deletimetasklist(model.index);//删除
                }
            }
        }

    }
    Component.onCompleted: {
            deletimetasklist.connect(deletimetaskslot);//删除
            editimetasklist.connect(editimetaskslot);//编辑
    }
    //创建model显示
    function creattimeModelShow(chserial,timetaskname,time){
        timetconmodel.model.append({timetaskseri_text: chserial,timetaskname_text:timetaskname,timetasktime_text:time})

    }



}






