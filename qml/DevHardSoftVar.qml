import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4

GridView{
    id: devhardsoftvar
    anchors.fill:parent
    anchors.margins:200
    clip:true
    model: ListModel{
    }
    cellWidth: 190
    cellHeight: 50
    delegate:numberDelegatevar
    Component{
        id : numberDelegatevar
        Rectangle{
            id :qdevvar_user
            width: 165
            height: 45
            color:"#f3f7ff"
            Text {
                id: devhardvar
                anchors.top:parent.top
                anchors.topMargin:2
                anchors.left:parent.left
                anchors.leftMargin: 5
                anchors.fill: parent
                text: devhardvar_text
                font.family: "宋体"
                font.pointSize: 12

            }
            Text {
                id: devsoftvar
                anchors.top:parent.top
                anchors.topMargin:21
                anchors.left:parent.left
                anchors.leftMargin: 5
                anchors.fill: parent
                text: devsoftvar_text
                font.family: "宋体"
                font.pointSize: 12
            }

        }
    }
    //创建model显示
    function creatdevhardsoftvar(devhardvar,devsoftvar){
        devhardsoftvar.model.append({devhardvar_text: devhardvar,devsoftvar_text:devsoftvar})
    }
}






