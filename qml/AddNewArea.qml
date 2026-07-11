import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4

Window {
    id: addnewareaWindow
    width: 504
    height: 480
    opacity: 1
    title: qsTr("电力优化管控系统")
    visible: false
        modality: Qt.ApplicationModal
    property int i :0
    flags: Qt.Window | Qt.FramelessWindowHint
        signal areamsendconfigSignal(var getallldevname);
    MouseArea { //为窗口添加鼠标事件
        width: 585
        height: 75
        acceptedButtons: Qt.LeftButton //只处理鼠标左键
        property point clickPos: "0,0"

        onPressed: { //接收鼠标按下事件
            clickPos  = Qt.point(mouse.x,mouse.y)
        }
        onPositionChanged: { //鼠标按下后改变位置
            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)

            //如果mainwindow继承自QWidget,用setPos
            addnewareaWindow.setX(addnewareaWindow.x+delta.x)
            addnewareaWindow.setY(addnewareaWindow.y+delta.y)
        }
    }
    Rectangle {
        id: rectangle3
        width: 504
        height: 480
        border.color: "#999999" //设置边框的颜色
        border.width: 1       //设置边框的大小
    Rectangle {
        id: rectangle
        width: 503
        height: 60
        color: "#2a5298"
        Text{
            id:addnewarea_name
            width: 117
            height: 22
            color: "#fffff9"
            text: "新增区域"
            font.bold: true
            font.pointSize: 20
            anchors.centerIn: parent
        }
        ToolButton {
            id: addnewarea_bntclose
            anchors.top:parent.top
            anchors.topMargin: 15
            anchors.left:parent.left
            anchors.leftMargin: 470
            width: 29
            height: 28
            text: qsTr("2")
            iconSource: "qrc:/icon/close.png"
            onClicked: {
                 addnewareaWindow.destroy();
            }
        } //去标题栏
    }


    Text {
        id: element
        anchors.top:parent.top
        anchors.topMargin: 95
        anchors.left:parent.left
        anchors.leftMargin: 50
        width: 98
        height: 31
        text: qsTr("区域名称")
        font.pixelSize: 23
    }
    TextField{               //区域名输入
        id: intputlistna
        anchors.top:parent.top
        anchors.topMargin: 95
        anchors.left:parent.left
        anchors.leftMargin: 165
        width: 213
        height: 31
        text: qsTr("请输入区域名称")
        font.capitalization: Font.MixedCase
        font.pointSize: 14
        selectByMouse: true
    }
    Text {
        id: kindope
        anchors.top:parent.top
        anchors.topMargin: 95
        anchors.left:parent.left
        anchors.leftMargin: 450
        width: 110
        height: 29
        text: kindope_tex
        color:"#ffffff"
        font.pixelSize: 2
    }
    Text {
        id: element1
        anchors.top:parent.top
        anchors.topMargin: 148
        anchors.left:parent.left
        anchors.leftMargin: 50
        width: 110
        height: 29
        text: qsTr("设备列表")
        font.pixelSize: 23
    }

    Rectangle {
        id: rectangle1
        anchors.top:parent.top
        anchors.topMargin: 148
        anchors.left:parent.left
        anchors.leftMargin: 165
        width: 272
        height: 266
        color: "#ffffff"
        border.color: "#ebedf2"
        GridView{
            id: checkbox_te
            anchors.fill:parent
            anchors.margins:10
            clip:true
            cellWidth: 90
            cellHeight: 60
                model:ListModel{
                   // id :ey
                  //  ListElement {checkboxtextc: "101";}
                  //  ListElement {checkboxtextc: "102";}
                }

            delegate:checkBoxDelegate
            Component{
                id : checkBoxDelegate
                Rectangle{
                    id :all_check
                    width: 50
                    height: 30
                    color:"#f9ffed"
                    CheckBox {
                        id: checkBoxe
                        width: 50
                        height: 30
                        checked: ubool
                        text:  checkboxtextc
                        onClicked: {
                          ubool = checkBoxe.checked
                        }
                    }
                }

            }

        }
    }
    ToolButton {
        id: toolButton2
        anchors.top:parent.top
        anchors.topMargin: 430
        anchors.left:parent.left
        anchors.leftMargin: 353
        width: 50
        height: 32
        text: qsTr("2")
        iconSource: "qrc:/icon/cancle_D.png"
        onClicked: {
  addnewareaWindow.destroy();
        }
    }
    ToolButton {
        id: toolButton1
        anchors.top:parent.top
        anchors.topMargin: 430
        anchors.left:parent.left
        anchors.leftMargin: 418
        width: 50
        height: 32
        text: qsTr("1")
        iconSource: "qrc:/icon/ok_E.png"
        onClicked: {//保存分两种情况，一种是创建，一种是修改保存
            savedatatoconfig();
        }
    }
}

    Component.onCompleted: {
        deviceconfigpage.sendaddareSignal.connect(creatcheckboxShow);//deviceconfigpage是本qml的父类
    }

    //创建check显示
    function creatcheckboxShow(enflag,id){
        var alldevname;
        var arealistdevname_temp;
        var dev_chnamebuf
        var cin = 0;
        alldevname = sqlitefun_obj.traversedata("devdata","dev_name")
        if(enflag)//编辑的时候使用
        {
            kindope.text = String(id)
            arealistdevname_temp = sqlitefun_obj.findsqldata("arealist","arealistdevname",id);
            intputlistna.text = sqlitefun_obj.findsqldata("arealist","arealistname",id);
            if(arealistdevname_temp !== "FAIL")
            {
                var arealistdevname_tempbuf = arealistdevname_temp.split("#");//设备通道名字
            }
            if(alldevname !== "FAIL")
            {
                dev_chnamebuf = alldevname.split("&");//设备通道名字
            }
            for(var i = 0;i < dev_chnamebuf.length; i ++)
            { cin = 1;
               for(var j = 0; j < arealistdevname_tempbuf.length;j ++)
               {

                  if(arealistdevname_tempbuf[j] === dev_chnamebuf[i])
                  {
                    checkbox_te.model.append({checkboxtextc: dev_chnamebuf[i],ubool : true})
                       cin = 0;
                  }
               }
               if(cin === 1)
               {
                     checkbox_te.model.append({checkboxtextc: dev_chnamebuf[i],ubool : false})
               }

            }
        }
        else//创建调用
        {
            kindope.text = "NONE"//代表创建
            if(alldevname !== "FAIL")
            {
                 dev_chnamebuf = alldevname.split("&");//设备通道名字
            }
            for(var m = 0; m < dev_chnamebuf.length; m ++)
            {
                checkbox_te.model.append({checkboxtextc: dev_chnamebuf[m],ubool : false})
            }
        }

    }

    //保存数据到数据库一种是创建一种是修改
        function savedatatoconfig(){


                var flag = 0
                var boxencount
                var getalldevname = ""
               var getarealistid = sqlitefun_obj.findsqldataID("arealist","arealistname",intputlistna.text)
               if(getalldevname === "NONE" || getalldevname === "")
               {
                   addnewareamMsg1.tipText = "配置参数不正确"
                   addnewareamMsg1.openMsg()
                   return;
               }
            for(boxencount = 0; boxencount < checkbox_te.count; boxencount ++)
                {
                    if(checkbox_te.model.get(boxencount).ubool)
                    {
                      getalldevname += checkbox_te.model.get(boxencount).checkboxtextc
                      getalldevname += "#"
                        flag = 1
                        var devdataid = sqlitefun_obj.findsqldataID("devdata","dev_name",intputlistna.text)
                       sqlitefun_obj.updaterowdata("devdata","dev_floor",Number(devdataid));//更新大楼数据
                    }
                }
                if(flag)
                {
                getalldevname = getalldevname.substring(0, getalldevname.lastIndexOf('#'));
                }

                 if(getarealistid !== "FAIL" && getarealistid !== "NONE" )//为真就是修改
                 {
                     if(kindope.text === "NONE")
                     {
                         deviceconfigpage.hcreatregionallisth(intputlistna.text,getalldevname,Number(getarealistid) -1,0);
                         sqlitefun_obj.updaterowdata("arealist","arealistname",intputlistna.text,Number(getarealistid));
                         sqlitefun_obj.updaterowdata("arealist","arealistdevname",getalldevname,Number(getarealistid));
                     }
                     else
                     {
                         deviceconfigpage.hcreatregionallisth(intputlistna.text,getalldevname,Number(kindope.text) -1,0);
                         sqlitefun_obj.updaterowdata("arealist","arealistname",intputlistna.text,Number(kindope.text));
                         sqlitefun_obj.updaterowdata("arealist","arealistdevname",getalldevname,Number(kindope.text));
                     }
                  }
                 else
                 {
                        deviceconfigpage.hcreatregionallisth(intputlistna.text,getalldevname,Number(kindope.text),1);
                         var strtemp = sqlitefun_obj.nOIDinsterdata(intputlistna.text,getalldevname);
                 }

                addnewareaWindow.destroy();

        }
        MsgDialog {
            id: addnewareamMsg1
            tipText: qsTr("QML  debugging is enabled. Only use this in a safe eenvironment.")
        }

}
