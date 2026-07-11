import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4

GridView{
    id: quickconmodel
    anchors.fill:parent
    anchors.margins:5
    clip:true
    signal quickcontrolswstate(var arealistseril,var chvalue);//删除
    model: ListModel{
    }
    cellWidth: 280
    cellHeight: 40

    delegate:numberDelegatequ
    Component{
        id : numberDelegatequ
        Rectangle{
            id :qcall_user
            width: 280
            height: 40
            color:"#f3f7ff"
            Text {
                id: quickcontrolname
                anchors.top:parent.top
                anchors.topMargin:12
                anchors.left:parent.left
                anchors.leftMargin: 10
                 anchors.fill: parent
                text: quickconname_text
                font.family: "宋体"
                font.pointSize: 10

            }
            ToolButton {
                id: devoperbntqc
                anchors.top:parent.top
                anchors.topMargin: 10
                anchors.left:parent.left
                anchors.leftMargin: 140
                width: 40
                height: 20
                text: qsTr("2")
                iconSource:devopbnt_icon
                //iconSource: "qrc:/icon/smal_Info_edit.png"
                onClicked: {
                    closebnt_icon = "qrc:/icon/Finsh_D.png"
                    devopbnt_icon = "qrc:/icon/Start_E.png"
                    quickcontrolswstate(model.index,"1");
                }
            }
            ToolButton {
                id: devoperclosebntqc
                anchors.top:parent.top
                anchors.topMargin: 10
                anchors.left:devoperbntqc.right
                anchors.leftMargin: 10
                width: 40
                height: 20
                text: qsTr("2")
                iconSource:closebnt_icon
               // iconSource: "qrc:/icon/smallclose.png"
                onClicked: {
                  //  closebnt_icon = "qrc:/icon/Finsh_E.png"
                 //   devopbnt_icon = "qrc:/icon/Start_D.png"
                 //   quickcontrolswstate(model.index,"0");
                }
            }

            }

        }
    Component.onCompleted: {
            quickcontrolswstate.connect(quickcontrolswhslothandle);//操作
    }
    //创建model显示
    function creatquicModelShow(chname,swbool){
        var opencolorshow
        var closecolorshow
        if(swbool === "1")//开
        {
          closecolorshow = "qrc:/icon/Finsh_D.png"
          opencolorshow = "qrc:/icon/Start_E.png"
        }
        else
        {
            closecolorshow = "qrc:/icon/Finsh_E.png"
            opencolorshow = "qrc:/icon/Start_D.png"
        }
        quickconmodel.model.append({quickconname_text: chname,devopbnt_icon:opencolorshow,closebnt_icon:closecolorshow})

    }



 }






