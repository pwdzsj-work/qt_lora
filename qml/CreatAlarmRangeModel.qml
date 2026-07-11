import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4


GridView{
    id: alarmrange_moidu
    anchors.fill:parent
    anchors.margins:2
    clip:true
    signal deletalarmrangelist(var arealistseril);//删除
    signal editalarmrangelist(var arealistseril);//编辑
    model: ListModel{
        //ListElement{reLiSer_text: "0";areaname_text:"1";devname_text:"2"}
    }
    cellWidth: 1200
    cellHeight: 25
    delegate:numberDelegatealarmv

    Component{
        id : numberDelegatealarmv
        Rectangle{
            id :all_user
            width: 950
            height: 20
            color:"#ffffff"
            Text {
                id: alarmSertext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 30
                width: 12
                height: 12
                text: alarmSer_text
                font.family: "宋体"
                font.pointSize: 12
            }
            Text {
                id: alarmdevnametext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 100
                width: 50
                height: 12
                text: alarmdevname_text
                font.family: "宋体"
                font.pointSize: 12
            }
            Text {
                id: alarmchnametext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 300
                width: 50
                height: 12
                text: alarmchname_text
                font.family: "宋体"
                font.pointSize: 12
            }
            Text {
                id: alarmmaxcurrnametext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 460
                width: 30
                height: 12
                text: alarmmaxcurrname_text
                font.family: "宋体"
                font.pointSize: 12
            }
            Text {
                id: alarmvoltrangetext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 600
                width: 30
                height: 12
                text: alarmvoltrange_text
                font.family: "宋体"
                font.pointSize: 12
            }
            Text {
                id: alarmmaxtemptext
                anchors.top:parent.top
                anchors.topMargin: 5
                anchors.left:parent.left
                anchors.leftMargin: 740
                width: 30
                height: 12
                text: alarmmaxtemp_text
                font.family: "宋体"
                font.pointSize: 12
            }
            ToolButton {
                id: devalarmoperbnt
                anchors.top:parent.top
                anchors.topMargin: 1
                anchors.left:parent.left
                anchors.leftMargin: 920
                width: 30
                height: 20
                text: qsTr("2")
                iconSource: "qrc:/icon/smal_Info_edit.png"
                onClicked: {
                    editalarmrangelist(model.index);//编辑
                }
            }
            ToolButton {
                id: devalarmoperclosebnt
                anchors.top:parent.top
                anchors.topMargin: 1
                anchors.left:parent.left
                anchors.leftMargin: 950
                width: 20
                height: 20
                text: qsTr("2")
                 iconSource: "qrc:/icon/smallclose.png"
                onClicked: {
                    deletalarmrangelist(model.index);//删除
                }
            }
        }
    }
    Component.onCompleted: {
        deletalarmrangelist.connect(deletalarmrangeconfigfun);
        editalarmrangelist.connect(correctalarmtodevcofigslot)
    }

  //创建model显示
    function creatalarmrangisthand(itemser,alarmdevnam,alarmchnam,maxcurrn,voltragena,tempmaxna){


           var alarmchnambuf = alarmchnam.split(",");
        if(alarmchnambuf.length > 6)
        {
           var showchname1 = alarmchnambuf[0] + "," +alarmchnambuf[1] + "," + alarmchnambuf[2] + "," +alarmchnambuf[3] + "," +alarmchnambuf[4] +"..." + alarmchnambuf[alarmchnambuf.length - 1]
            alarmrange_moidu.model.append({alarmSer_text: itemser,alarmdevname_text:alarmdevnam,alarmchname_text:showchname1,alarmmaxcurrname_text:maxcurrn,alarmvoltrange_text:voltragena,alarmmaxtemp_text:tempmaxna})
        }
        else
        {
            alarmrange_moidu.model.append({alarmSer_text: itemser,alarmdevname_text:alarmdevnam,alarmchname_text:alarmchnam,alarmmaxcurrname_text:maxcurrn,alarmvoltrange_text:voltragena,alarmmaxtemp_text:tempmaxna})

        }
       }

}



