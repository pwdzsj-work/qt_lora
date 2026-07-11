import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4

GridView{
    id: measure_showMode
    anchors.fill:parent
    anchors.margins:200
    clip:true
    signal sendSignal(var userindex);
    model:ListModel{
      //  id :ey
     //   ListElement {roomnum_text: "roomnum";ip_text:"qmlip";mac_text:"qmlmac";
            //                                          roomvol_text: "arrayData[0]";roomcurr_text: "arrayData[0]";roomtemp_text:"arrayData[0]";alarmshow_color:"red"}
    }
    cellWidth: 155
    cellHeight: 135
    delegate:numberDelegate
    Component{
    id : numberDelegate

      Rectangle{
           id :all_user
           width: 146
           height: 102
           color:"#f9ffed"
           MouseArea {
                      anchors.fill: parent
                      onClicked: sendSignal(model.index);
                  }
           Rectangle {
               id: rectangle
               width: 146
               height: 29

               anchors.top: all_user.top
               anchors.topMargin: 0
               color: "#2752c3"
               Text {
                   id: mode_room
                   color: "#f8f8ff"
                   anchors.left:parent.left
                   anchors.leftMargin: 3

                   anchors.top:parent.top
                   anchors.topMargin: 5

                   text: room_text
                   font.bold: true
                   font.pixelSize: 16
               }

               Text {
                   id: mode_mac
                   color:"#2752c3"
                   anchors.left:parent.left
                   anchors.leftMargin: 41

                   anchors.top:parent.top
                   anchors.topMargin: 20

                   text: mac_text
                   font.bold: true
                   font.pixelSize: 6
               }
               Rectangle {
                id: rectanglealarm
                radius: 8
                width: 15
                height: 15
                anchors.top:parent.top
                anchors.topMargin:5
                anchors.left:parent.left
                anchors.leftMargin:120
                color: alarmshow_color
               }

           }
    Rectangle {
        id :power_user
        width: 146
        height: 21
        anchors.top: all_user.top
        anchors.topMargin: 40
        color:"#f9ffed"
           Text {
               id: element2
               anchors.left:parent.left
               anchors.leftMargin: 6
               width: 50
               height: 21
               text: qsTr("电源:")
               font.pixelSize: 15
           }
           Text {
               id: mode_volvalue
               anchors.left:parent.left
               anchors.leftMargin:55
               width: 45
               height: 21
               text: roomvol_text + "V/"
               font.pixelSize: 13
           }
           Text {
               id: mode_currvalue
               anchors.left:mode_volvalue.right
               anchors.leftMargin:4
               width: 45
               height: 21
               text: roomcurr_text + "A"
               font.pixelSize: 13
           }
    }
    Rectangle {
            id :temp_user
            width: 146
            height: 21
            anchors.top: all_user.top
            anchors.topMargin: 65
            color:"#f9ffed"
            Text {
               id: element3
               anchors.left:parent.left
               anchors.leftMargin: 6
               width: 50
               height: 21
               text: qsTr("温度:")
               font.pixelSize: 15
            }
           Text {
               id: mode_temp
               anchors.left:parent.left
               anchors.leftMargin:55
               width: 50
               height: 21
               text: roomtemp_text + "℃"
               font.pixelSize: 13
           }
         }
    Rectangle {
            id :tempip_user
            width: 70
            height: 12
            anchors.top: temp_user.top
            anchors.topMargin: 20
            anchors.left:parent.left
            anchors.leftMargin:63
            color:"#f9ffed"
            Text {
                id: mode_ip
                anchors.left:parent.left
                anchors.leftMargin: 2

                anchors.top:parent.top
                anchors.topMargin: 2

                text: ip_text
                font.bold: true
                font.weight: Font.DemiBold
                font.pixelSize: 11
            }
    }

        }
    }

    Component.onCompleted: {
            sendSignal.connect(mainInterslot);
    }

    //传递参数数据
    function upNumModelData(arrayData){
       // if(arrayData.lengh !== 9) return;
        mode_room.text = arrayData[1];  //房间号
        mode_powervalue.text = arrayData[2];//电压和电流值
        mode_temp.text = arrayData[3];//温度
        if(arrayData[4] === 1)//离线
            {
            rectanglealarm.color = "#707070"
        }
        else if(arrayData[4] === 2)//故障
            {
              rectanglealarm.color = "#e60012"
        }
        else //在线
            {
              rectanglealarm.color = "#8fc31f"
        }

    }
    //创建model显示
    function creatAllModelShow(qmlroomnum,qmlip,qmlmac,arrayData,alarmled){
       var ledcolor;
        if(alarmled === 0)
        {
         ledcolor = "#90c31e"//绿色
        }
        else if(alarmled === 1)
        {
         ledcolor = "red"
        }
        else
        {
         ledcolor = "yellow"
        }
            measure_showMode.model.append({room_text: qmlroomnum,ip_text:qmlip,mac_text:qmlmac,
                                              roomvol_text: arrayData[0],roomcurr_text: arrayData[0],roomtemp_text:arrayData[0],alarmshow_color:ledcolor})
    }
   //  function send21() {
 // totalModel_id.creatAllModelShow(101,qmlip,qmlmac,arrayData,ledcolor)//创建
   //  }
}








