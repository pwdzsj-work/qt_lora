import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

GridView{
    id: measure_showMode
    clip:true
    interactive: contentHeight > height
    property int minimumCellWidth: 245
    property int columnCount: Math.max(
                                  1,
                                  Math.min(model.count > 0 ? model.count : 1,
                                           Math.floor(width / minimumCellWidth)))
    model: ListModel{
 //ListElement{chserial_text: chserial;alarmcolor:"red";chname_text:chname;voltcurr_text:chvoltcurr;iconsourceopen:miconsourceopen; iconsourceclose:miconsourceclose}
    }
    cellWidth: width / columnCount
    cellHeight: 64
    delegate:numberDelegate
    Component{
        id : numberDelegate
        Item {
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight

        Rectangle{
            id: all_user
            anchors.fill: parent
            anchors.margins: 4
            radius: 5
            color: relaystate ? "#eef9f1" : "#f3f5f8"
            border.width: 1
            border.color: relaystate ? "#79c98d" : "#d4d9e1"
            Rectangle {
             id: chstateled
             radius: 5
             width: 10
             height: 10
             anchors.left:parent.left
             anchors.leftMargin:10
             anchors.top: parent.top
             anchors.topMargin: 11
             color: relaystate ? alarmcolor : "#9aa3af"
            }
            Text {
                id: chstatenum
                anchors.left: chstateled.right
                anchors.leftMargin: 7
                anchors.verticalCenter: chstateled.verticalCenter
                text: "CH" + chserial_text
                font.family: "宋体"
                font.pixelSize: 12
                color: relaystate ? "#238a42" : "#66717f"
            }

            TextInput {
                id: device_Info_CH_Name
                anchors.left: chstatenum.right
                anchors.leftMargin: 9
                anchors.verticalCenter: chstatenum.verticalCenter
                width: Math.max(60, devicechopen.x - x - 8)
                height: 20
                text: chname_text
                font.family: "宋体"
                font.pixelSize: 14
                readOnly: textinpuvalue
                selectByMouse: true
                onTextEdited:{
                    chname_text = device_Info_CH_Name.text//更新文本
                }
            }
            Text {
                id: device_CH_V_I
                anchors.left: parent.left
                anchors.leftMargin: 27
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 7
                width: devicechopen.x - x - 8
                height: 20
                text: voltcurr_text
                font.family: "宋体"
                font.pixelSize: 14
                color: "#26364d"
            }
            ToolButton {
                id: devicechopen
                anchors.right: devicechclose.left
                anchors.rightMargin: 7
                anchors.verticalCenter: parent.verticalCenter
                width: 34
                height: 24
                enabled: true
                text: ""
                display: AbstractButton.IconOnly
                icon.source: iconsourceopen
                icon.width: 26
                icon.height: 18
                icon.color: "transparent"
                padding: 0
                onClicked: {
                        relaystate = true
                        alarmcolor = "#2ebc59"
                        iconsourceopen = "qrc:/icon/Info_OpenE.png"
                        iconsourceclose = "qrc:/icon/Info_CloseD.png"
                }
            }


            ToolButton {
                id: devicechclose
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 34
                height: 24
                enabled: true
                text: ""
                display: AbstractButton.IconOnly
                icon.source: iconsourceclose
                icon.width: 26
                icon.height: 18
                icon.color: "transparent"
                padding: 0
                onClicked: {
                        relaystate = false
                        iconsourceclose = "qrc:/icon/Info_CloseE.png"
                        iconsourceopen = "qrc:/icon/Info_OpenD.png"
                }
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
             ledcolor = "#2ebc59"
             miconsourceopen = "qrc:/icon/Info_OpenE.png"
             miconsourceclose = "qrc:/icon/Info_CloseD.png"
         }
         else
         {
             ledcolor = "#9aa3af"
             miconsourceclose = "qrc:/icon/Info_CloseE.png"
             miconsourceopen = "qrc:/icon/Info_OpenD.png"
         }
         chserialstr = chserial.toString();
        measure_showMode.model.append({
            chserial_text: chserialstr,
            alarmcolor: ledcolor,
            relaystate: chswstate === 1,
            chname_text: chname,
            voltcurr_text: chvoltcurr,
            iconsourceopen: miconsourceopen,
            iconsourceclose: miconsourceclose,
            textinpuvalue: true
        })
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
