import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    id: addalarmWindow
    width: 390
    height: 330
    opacity: 1
     modality: Qt.ApplicationModal
    title: qsTr("定时任务")
    property int i :0
    flags: Qt.Window | Qt.FramelessWindowHint
    signal sendaddalarmSignal(var getallldevname);

    MouseArea { //为窗口添加鼠标事件
        width: 390
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
            addalarmWindow.setX(addalarmWindow.x+delta.x)
            addalarmWindow.setY(addalarmWindow.y+delta.y)
        }
    }
    Rectangle {
        id:addaleamidarm
        width: 390
        height: 330
        border.color: "#999999" //设置边框的颜色
            border.width: 1       //设置边框的大小
    Rectangle {
        id: rectangle
        width: 390
        height: 41
        color: "#2a5298"
        Text{
            id:addnewarea_name
            width: 117
            height: 22
            color: "#fffff9"
            text: "报警阈值"
            font.bold: true
            font.pointSize: 20
            anchors.centerIn: parent
        }
        ToolButton {
            id: addalarmarea_bntclose
            anchors.top:parent.top
            anchors.topMargin: 10
            anchors.left:parent.left
            anchors.leftMargin: 355
            width: 29
            height: 28
            text: qsTr("2")
            icon.source: "qrc:/icon/close.png"
            icon.color: "transparent"
            display: AbstractButton.TextUnderIcon
            icon.width: 50
            icon.height: 32
            onClicked: {
                  addalarmWindow.destroy();
            }
        } //去标题栏
    }

    Text {
        id: element
        anchors.top:parent.top
        anchors.topMargin: 67
        anchors.left:parent.left
        anchors.leftMargin:25
        width: 81
        height: 22
        text: qsTr("设备名称")
        font.pixelSize: 19
    }

    Rectangle {
        id: rectanglealaerm
        anchors.top:parent.top
        anchors.topMargin: 62
        anchors.left:parent.left
        anchors.leftMargin: 137
        width: 205
        height: 32
        color: "#ffffff"
        border.color: "#ebedf2"
        ComboBox{
            id: checkbox_devname
            width: 205
            height: 32
            anchors.top:parent.top
            anchors.topMargin: 0
            anchors.left:parent.left
            anchors.leftMargin:0
            clip:true
            model:ListModel{
                //  id :eygsdf
                //   ListElement {checkalarmboxtextc: "101";}
                //   ListElement {checkalarmboxtextc: "102";}
                //  ListElement {checkalarmboxtextc: "101";}
            }
            delegate:ItemDelegate{
                id : checkalarmDelegate
                Rectangle{
                    id :alarmcdevname
                    width: 100
                    height: 30
                    color:"#f9ffed"
                    CheckBox {
                        id: checkBoxealarm
                        width: 200
                        height: 30
                        checked: uboolalarmdev
                        text:  checkdevalarmbox_text
                        onClicked: {
                            uboolalarmdev = checkBoxealarm.checked
                        }
                    }
                    Text{
                        id: alarmdevmac
                        width: 1
                        height: 1
                         text: alarmmac_textp
                        font.family: "宋体"
                        font.pointSize: 1
                        color:"#f8f8ff"
                    }
                }
            }
        }
    }
    Text {
        id: alarmkindope
        anchors.top:parent.top
        anchors.topMargin: 62
        anchors.left:parent.left
        anchors.leftMargin: 310
        width: 110
        height: 29
        text: alarmkindope_tex
        color:"#ffffff"
        font.pixelSize: 2
    }
    Text {
        id: element1
        anchors.top:parent.top
        anchors.topMargin: 113
        anchors.left:parent.left
        anchors.leftMargin:25
        width: 81
        height: 22
        text: qsTr("通道")
        font.pixelSize: 19
    }

    Rectangle {
        id: yuanaddchname
        anchors.top:parent.top
        anchors.topMargin: 105
        anchors.left:parent.left
        anchors.leftMargin: 137
        width: 205
        height: 32
        color: "#ffffff"
        border.color: "#ebedf2"
        ComboBox{
            id: checkbox_chname
            width: 205
            height: 32
            anchors.top:parent.top
            anchors.topMargin: 0
            anchors.left:parent.left
            anchors.leftMargin:0
            clip:true
            model:ListModel{
                //   id :yuanchname
                //   ListElement {checkalarmboxtextc: "101";}
                //    ListElement {checkalarmboxtextc: "102";}
                //   ListElement {checkalarmboxtextc: "101";}
            }
            delegate:ItemDelegate{
                id : checkalarmyuzhi
                Rectangle{
                    id :alarmcdevyuzhi
                    width: 100
                    height: 30
                    color:"#f9ffed"
                    CheckBox {
                        id: checkBoxealarmch
                        width: 200
                        height: 30
                        checked: uboolarlch
                        text:  checkalarmchbox_text
                        onClicked: {
                            uboolarlch = checkBoxealarmch.checked
                        }
                    }
                }
            }
        }
    }

    Text {
        id: element2
        anchors.top:parent.top
        anchors.topMargin: 155
        anchors.left:parent.left
        anchors.leftMargin:25
        width: 81
        height: 22
        text: qsTr("最高电流")
        font.pixelSize: 19
    }
    TextField{               //用户名输入
        id: maxcurralarm
        anchors.top:parent.top
        anchors.topMargin: 150
        anchors.left:parent.left
        anchors.leftMargin:120
        width:89
        height:31
        selectByMouse: true
        text: "9.9"
        inputMask: "0.0"
      //  validator: RegExpValidator{regExp:/[0.0-10]/}
        font.capitalization: Font.MixedCase
        font.pointSize: 14
    }


    Text {
        id: element3
        anchors.top:parent.top
        anchors.topMargin: 154
        anchors.left:parent.left
        anchors.leftMargin:220
        width: 26
        height: 22
        text: qsTr("A")
        font.pixelSize: 19
    }

    Text {
        id: element4
        anchors.top:parent.top
        anchors.topMargin: 200
        anchors.left:parent.left
        anchors.leftMargin:25
        width: 81
        height: 22
        text: qsTr("电压范围  最低")
        font.pixelSize: 19
    }

    TextField{               //
        id: voltminalarm
        anchors.top:parent.top
        anchors.topMargin: 195
        anchors.left:parent.left
        anchors.leftMargin:170
        width:53
        height:29
        text: "180"
       // inputMask: "000"
        validator: RegExpValidator{regExp:/[1-2][0-9][0-9]/}
        selectByMouse: true
        font.capitalization: Font.MixedCase
        font.pointSize: 14
    }
    Text {
        id: element5
        anchors.top:parent.top
        anchors.topMargin: 200
        anchors.left:parent.left
        anchors.leftMargin:234
        width: 48
        height: 22
        text: qsTr("最高")
        font.pixelSize: 19
    }


    TextField{               //
        id: voltmaxalarm
        anchors.top:parent.top
        anchors.topMargin: 195
        anchors.left:parent.left
        anchors.leftMargin:284
        width:53
        height:28
        text: "260"
       // inputMask: "000"
        validator: RegExpValidator{regExp:/[1-2][0-9][0-9]/}
        selectByMouse: true
        font.capitalization: Font.MixedCase
        font.pointSize: 14
    }
    Text {
        id: element6
        anchors.top:parent.top
        anchors.topMargin: 200
        anchors.left:parent.left
        anchors.leftMargin:344
        width: 30
        height: 22
        text: qsTr("V")
        font.pixelSize: 19
    }

    Text {
        id: element7
        anchors.top:parent.top
        anchors.topMargin: 245
        anchors.left:parent.left
        anchors.leftMargin:25
        width: 81
        height: 22
        text: qsTr("最高温度")
        font.pixelSize: 19
    }

    TextField{               //用户名输入
        id: maxtempalarm
        anchors.top:parent.top
        anchors.topMargin: 240
        anchors.left:parent.left
        anchors.leftMargin: 120
        width:71
        height:29
        text: "65"
        inputMask: "00"
        selectByMouse: true
        font.capitalization: Font.MixedCase
        font.pointSize: 14
    }

    Text {
        id: element8
        anchors.top:parent.top
        anchors.topMargin: 247
        anchors.left:parent.left
        anchors.leftMargin: 200
        width: 26
        height: 22
        text: qsTr("℃")
        font.pixelSize: 19
    }

    ToolButton {
        id: toolButton
        anchors.top:parent.top
        anchors.topMargin: 280
        anchors.left:parent.left
        anchors.leftMargin: 300
        width: 60
        height: 35
        text: qsTr("1")
        icon.source: "qrc:/icon/ok_E.png"
        icon.color: "transparent"
        icon.height: 35
        icon.width: 66
        display: AbstractButton.IconOnly
        onClicked: {
            savealarmatatoconfig();
        }
    }

    ToolButton {
        id: toolButton1
        anchors.top:parent.top
        anchors.topMargin: 280
        anchors.left:parent.left
        anchors.leftMargin: 230
        width: 60
        height: 35
        text: qsTr("取消")
        icon.source: "qrc:/icon/cancle_D.png"
        icon.color: "transparent"
        icon.height: 35
        icon.width: 66
        display: AbstractButton.IconOnly
        onClicked: {
            addalarmWindow.destroy();
        }

    }
}
    Component.onCompleted: {
        deviceconfigpage.sendaddalarmSignal.connect(creatlalrmrangechildm);//deviceconfigpageplan是本qml的父类
    }
    //创建新增界面的子模块
    function creatlalrmrangechildm(planenflag,planid){
        var alldev_linestate = sqlitefun_obj.traversedata("devdata","dev_linestate")
        var alldev_linestatebuf = alldev_linestate.split("&")
        var alldevmacback = sqlitefun_obj.traversedata("devdata","dev_mac")
        var alldevmacbackbuf = alldevmacback.split("&");
        var alldevmac = ""
        var allchtotalback = sqlitefun_obj.traversedata("devdata","dev_chname")
        var allchtotalbackbuf = allchtotalback.split("&");
        var allchtotal = ""
        var alldevmacbuf
        var allchtotalbuf
        var editchosealldevmac
        var editchosealldevmacbuf
        var dev_devchnamebuf
        var chosedevnamep = ""//选中设备字符串
        var chosechnamep = ""//选中通道 字符串
        var chosedevnamebuf//选中设备
        var chosechnamebuf//选中通道
        var cin = 0;

        for(var tte = 0; tte < alldevmacbackbuf.length; tte ++)
        {
            if(alldev_linestatebuf[tte] === "1")
            {
                alldevmac += alldevmacbackbuf[tte]
                alldevmac += "&"
                allchtotal += allchtotalbackbuf[tte]
                allchtotal += "&"
            }
        }
        if(alldevmac[alldevmac.length - 1] === '&')
        {
             alldevmac = alldevmac.substring(0, alldevmac.lastIndexOf('&'));
        }
        if(allchtotal[allchtotal.length - 1] === '&')
        {
             allchtotal = allchtotal.substring(0, allchtotal.lastIndexOf('&'));
        }
        if(planenflag)//编辑的时候使用
        {
            alarmkindope.text = String(planid)
            maxcurralarm.text = sqlitefun_obj.findsqldata("alarmthreshold","maxcurrent",planid);
            voltminalarm.text = sqlitefun_obj.findsqldata("alarmthreshold","alarmvoltmin",planid);
            voltmaxalarm.text = sqlitefun_obj.findsqldata("alarmthreshold","alarmvoltmax",planid);
            maxtempalarm.text = sqlitefun_obj.findsqldata("alarmthreshold","alarmtempmax",planid);
            chosedevnamep = sqlitefun_obj.findsqldata("alarmthreshold","alarmdevname",planid);
            chosechnamep = sqlitefun_obj.findsqldata("alarmthreshold","alarmch",planid);
            editchosealldevmac = sqlitefun_obj.findsqldata("alarmthreshold","alarmmac",planid);
            if(chosedevnamep !== "FAIL")
            {
                chosedevnamebuf = chosedevnamep.split(",");//选中设备放入buf
            }
            if(chosechnamep !== "FAIL")
            {
                chosechnamebuf = chosechnamep.split(",");//选中通道放入buf
            }
            if(editchosealldevmac !== "FAIL")
            {
                editchosealldevmacbuf = editchosealldevmac.split(",");//所有设备
            }
            for(var ji = 0; ji < chosedevnamebuf.length; ji ++)
            {
                 if(editchosealldevmacbuf[ji] === "")continue;
                 checkbox_devname.model.append({checkdevalarmbox_text: chosedevnamebuf[ji],uboolalarmdev :true,alarmmac_textp:editchosealldevmacbuf[ji]})
            }

            for(var jm = 0; jm < 32; jm ++)
            {
                cin = 1
                for(var jk = 0; jk < chosechnamebuf.length; jk ++)
                {
                    if(chosechnamebuf[jk] === String(jm+1))
                    {
                        checkbox_chname.model.append({checkalarmchbox_text: String(jm+1),uboolarlch : true})
                        cin = 0;
                    }

                }
                if(cin === 1)
                {
                    checkbox_chname.model.append({checkalarmchbox_text: String(jm+1),uboolarlch : false})
                }

            }



        }
        else//创建
        {
            alarmkindope.text = "NONE"
            if(alldevmac !== "FAIL")
            {
                alldevmacbuf = alldevmac.split("&");//获取所有在线mac
            }
            if(allchtotal !== "FAIL")
            {
                allchtotalbuf = allchtotal.split("&");//设备通道名字
            }
            for(var m = 0; m < alldevmacbuf.length; m ++)
            {
                var devmacid = sqlitefun_obj.findsqldataID("devdata","dev_mac",alldevmacbuf[m])
                var devname = sqlitefun_obj.findsqldata("devdata","dev_name",Number(devmacid))
                checkbox_devname.model.append({checkdevalarmbox_text: devname,uboolalarmdev :false,alarmmac_textp:alldevmacbuf[m]})
            }
            for(var n = 0; n < 32; n ++)
            {
                checkbox_chname.model.append({checkalarmchbox_text: String(n +1),uboolarlch : false})
            }
        }


    }

    //保存数据
    function savealarmatatoconfig(){
        var flag = 0
        var getdevname = ""//获取设备名称
        var chosedevmac = ""//勾选的设备mac
        var chosedevname = ""//选中设备名称
        var getchenchen = ""//勾选的通道
        var voltrange = ""//电压范围
        var ids = ""
        voltrange = voltminalarm.text + "~" + voltmaxalarm.text
        for(var i = 0; i < checkbox_devname.count; i ++)//搜索有多少行获取数据
        {
            if(checkbox_devname.model.get(i).uboolalarmdev === true )//获取设备被勾选的mac
            {
                chosedevmac += checkbox_devname.model.get(i).alarmmac_textp;
                chosedevname += checkbox_devname.model.get(i).checkdevalarmbox_text;
                 chosedevmac += ","
                    chosedevname += ","
            }


        }
        for(var jj = 0; jj < checkbox_chname.count; jj ++)
        {
            if(checkbox_chname.model.get(jj).uboolarlch === true )//获取通道被勾选的
            {
                getchenchen += checkbox_chname.model.get(jj).checkalarmchbox_text;
                getchenchen += ","
            }
        }
        if(checkbox_devname.count > 0)
        {
            chosedevmac = chosedevmac.substring(0, chosedevmac.lastIndexOf(','));//勾选设备
            getchenchen = getchenchen.substring(0, getchenchen.lastIndexOf(','));//勾选通道
            chosedevname = chosedevname.substring(0, chosedevname.lastIndexOf(','));//勾选通道
        }
        //if(chosedevmac[chosedevmac.length - 1] === ",")chosedevmac = chosedevmac.substring(0, chosedevmac.lastIndexOf(','));//勾选通道
        var getalarmlistid = sqlitefun_obj.findsqldataID("alarmthreshold","alarmdevname",chosedevname)//判断有无数据
        if(chosedevmac === "NONE" || chosedevmac === "" || chosedevmac === "")
        {
            addalarmMsg1.tipText = "配置参数不正确"
            addalarmMsg1.openMsg()
            return;
        }

        if( getalarmlistid !== "FAIL" && getalarmlistid !== "NONE")//为真就是修改
        {

            if(alarmkindope.text === "NONE")
            {
                deviceconfigpage.hcreatalarmvaluelisth(chosedevname,getchenchen,maxcurralarm.text,voltrange,maxtempalarm.text,Number(getalarmlistid)-1,0);
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmdevname",chosedevname,Number(getalarmlistid));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmmac",chosedevmac,Number(getalarmlistid));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmch",getchenchen,Number(getalarmlistid));
                sqlitefun_obj.updaterowdata("alarmthreshold","maxcurrent",maxcurralarm.text,Number(getalarmlistid));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmvoltmin",voltminalarm.text,Number(getalarmlistid));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmvoltmax",voltmaxalarm.text,Number(getalarmlistid));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmtempmax",maxtempalarm.text,Number(getalarmlistid));
            }
            else
            {
                deviceconfigpage.hcreatalarmvaluelisth(chosedevname,getchenchen,maxcurralarm.text,voltrange,maxtempalarm.text,Number(alarmkindope.text)-1,0);
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmdevname",chosedevname,Number(getalarmlistid));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmmac",chosedevmac,Number(alarmkindope.text));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmch",getchenchen,Number(alarmkindope.text));
                sqlitefun_obj.updaterowdata("alarmthreshold","maxcurrent",maxcurralarm.text,Number(alarmkindope.text));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmvoltmin",voltminalarm.text,Number(alarmkindope.text));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmvoltmax",voltmaxalarm.text,Number(alarmkindope.text));
                sqlitefun_obj.updaterowdata("alarmthreshold","alarmtempmax",maxtempalarm.text,Number(alarmkindope.text));
            }
        }
        else
        {

            sqlitefun_obj.nOIDinsteralarmdata(chosedevname,getchenchen,maxcurralarm.text,voltminalarm.text,voltmaxalarm.text,maxtempalarm.text,chosedevmac);
            deviceconfigpage.hcreatalarmvaluelisth(chosedevname,getchenchen,maxcurralarm.text,voltrange,maxtempalarm.text,Number(getalarmlistid),1);

        }
        user_tcpserver_qmlobj.SetRangeHandle(chosedevmac,getchenchen,maxcurralarm.text,voltminalarm.text,voltmaxalarm.text,maxtempalarm.text);
        addalarmWindow.destroy();

    }
    MsgDialog {
        id: addalarmMsg1
        tipText: qsTr("QML  debugging is enabled. Only use this in a safe eenvironment.")
    }
}
