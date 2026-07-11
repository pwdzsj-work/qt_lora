import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4

GridView{
    id: measure_showMode
    anchors.fill:parent
    anchors.margins:200
    clip:true
    model: ListModel{
 //ListElement{chserial_text: chserial;alarmcolor:"red";chname_text:chname;voltcurr_text:chvoltcurr;iconsourceopen:miconsourceopen; iconsourceclose:miconsourceclose}
    }
    cellWidth: 250
    cellHeight: 65
    delegate:numberDelegate
    Component{
        id : numberDelegate
        Rectangle{
            id :all_user
            width: 240
            height: 55
            color:"#f3f7ff"
            Rectangle {
             id: chstateled
             radius: 6
             width: 10
             height: 10
             anchors.top:parent.top
             anchors.topMargin:2
             anchors.left:parent.left
             anchors.leftMargin:2
             color: alarmcolor
            }
            Text {
                id: chstatenum
                anchors.top:parent.top
                anchors.topMargin: 15
                anchors.left:parent.left
                anchors.leftMargin: 5
                width: 5
                height: 5
                text: chserial_text
                font.family: "宋体"
                font.pointSize: 8
                       color: "green"
            }

            TextInput {
                id: device_Info_CH_Name
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:chstatenum.right
                anchors.leftMargin: 10
                width: 80
                height: 20
                text: chname_text
                font.family: "宋体"
                font.pointSize: 11
                readOnly: textinpuvalue
                selectByMouse: true
                onTextEdited:{
                    chname_text = device_Info_CH_Name.text//更新文本
                }
            }
            Text {
                id: device_CH_V_I
                anchors.top:parent.top
                anchors.topMargin: 30
                anchors.left:parent.left
                anchors.leftMargin: 20
                width: 83
                height: 20
                text: voltcurr_text
                font.family: "宋体"
                font.pointSize: 13

            }
            ToolButton {
                id: devicechopen
                anchors.top:parent.top
                anchors.topMargin: 15
                anchors.left:parent.left
                anchors.leftMargin: 160
                width: 30
                height: 20
                enabled: boolbntopench
                text: qsTr("1")
                iconSource: iconsourceopen
                onClicked: {
                        iconsourceopen = "qrc:/icon/Info_OpenE.png"
                        iconsourceclose = "qrc:/icon/Info_CloseD.png"
                }
            }


            ToolButton {
                id: devicechclose
                anchors.top:parent.top
                anchors.topMargin: 15
                anchors.left:parent.left
                anchors.leftMargin: 200
                width: 30
                height: 20
                enabled: boolbntclosech
                text: qsTr("2")
                iconSource: iconsourceclose
                onClicked: {
                        iconsourceclose = "qrc:/icon/Info_CloseE.png"
                        iconsourceopen = "qrc:/icon/Info_OpenD.png"
                }
            }
        }
    }



    //创建model显示
    function creatAllCHModelShow(chserial,alarmled,chvoltcurr,chname,chswstate){
        var ledcolor;
        var chserialstr;
        var miconsourceopen;
         var miconsourceclose;
         if(alarmled === 0)
         {
          ledcolor = "#90c31e"
         }
         else if(alarmled === 1)
         {
          ledcolor = "red"
         }
         else
         {
          ledcolor = "yellow"
         }
         if(chswstate === 1)
         {
             miconsourceopen = "qrc:/icon/Info_OpenE.png"
             miconsourceclose = "qrc:/icon/Info_CloseD.png"
         }
         else
         {

             miconsourceclose = "qrc:/icon/Info_CloseE.png"
             miconsourceopen = "qrc:/icon/Info_OpenD.png"
         }
         chserialstr = chserial.toString();
        measure_showMode.model.append({chserial_text: chserialstr,alarmcolor:ledcolor,chname_text:chname,voltcurr_text:chvoltcurr,iconsourceopen:miconsourceopen, iconsourceclose:miconsourceclose,textinpuvalue:true,})
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
