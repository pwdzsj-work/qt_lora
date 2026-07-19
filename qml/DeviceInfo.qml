import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Page {

    id:setWindow
    title: qsTr("设置")
    visible: true
    width: 1200
    height: 800
    property StackView stack: null
    signal sendMainInterfaceSignal(var mac_str);
    Rectangle {
        id : infomain_rec
        width: 1200
        height: 717
        x: 0
        y: 83
        border.color: "#999999" //设置边框的颜色
        border.width: 1       //设置边框的大小
        Text {
            id: device_name_s21
            anchors.left:parent.left
            anchors.leftMargin: 10
            anchors.top:parent.top
            anchors.topMargin: 10
            width: 114
            height: 28
            text: qsTr("设备详情")
            font.bold: true
            font.family: "宋体"
            font.pointSize: 21
        }
        Rectangle {
            id: devsofthardvar
            anchors.left:parent.left
            anchors.leftMargin: 150
            anchors.top:parent.top
            anchors.topMargin: 3
            width: 170
            height: 50

            DevHardSoftVar {
                id: devHardSoftVarList1
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.margins: 5

            }
        }
        ToolButton {
            id: toolButton5
            anchors.left:parent.left
            anchors.leftMargin: 1050
            anchors.top:parent.top
            anchors.topMargin: 8
            width: 56
            height: 36
            icon.source: "qrc:/icon/Info_Return.png"
            onClicked:{
                stack.pop()
                sendMainInterfaceSignal(device_mac_s1.text);//发送信号
            }
        }
        MouseArea { //为窗口添加鼠标事件
            id:mouseidfh
            anchors.left:parent.left
            anchors.leftMargin: 1100
            anchors.top:parent.top
            anchors.topMargin: 10
            width: 59
            height: 28
            onPressed: { //接收鼠标按下事件
                stack.pop()
                sendMainInterfaceSignal(device_mac_s1.text);//发送信号
            }
            Text {
                id: device_name_s22
                anchors.fill: parent
                text: qsTr("返回")
                font.family: "宋体"
                font.pointSize: 21
                font.bold: true
            }
        }
        MouseArea { //为窗口添加鼠标事件
            id:mouseidrte23
            anchors.left:parent.left
            anchors.leftMargin: 124
            anchors.top:parent.top
            anchors.topMargin: 12
            width: 29
            height: 28
            onPressed: {
                devHardSoftVarList1.model.clear();
                var hardvarinfo
                var softvarinfo
                var iddev = sqlitefun_obj.findsqldataID("devdata","dev_mac",device_mac_s1.text);
                if(iddev === "FAIL" || iddev === "NONE") return;
                hardvarinfo = sqlitefun_obj.findsqldata("devdata","dev_hardver",Number(iddev))
                softvarinfo = sqlitefun_obj.findsqldata("devdata","dev_softver",Number(iddev))
                devHardSoftVarList1.creatdevhardsoftvar("硬件版本号: " + hardvarinfo,"软件版本号: " + softvarinfo)

            }

            onReleased:  { //接收鼠标释放
                 devHardSoftVarList1.model.remove(0,devHardSoftVarList1.count);
            }

        }
        Image {
            id: toolButton4
            anchors.left:parent.left
            anchors.leftMargin: 124
            anchors.top:parent.top
            anchors.topMargin: 13
            width: 29
            height: 25
            source:  "qrc:/icon/Info_Prompt.png"
            fillMode: Image.PreserveAspectFit
        }


        Text {
            id: device_name_s19
            anchors.left:parent.left
            anchors.leftMargin: 5
            anchors.top:parent.top
            anchors.topMargin: 44
            text: qsTr("________________________________________________________________________________________________________________________________________________")
            font.family: "宋体"
            font.pointSize: 13
        }
        Text {
            id: device_name_s14
            anchors.left:parent.left
            anchors.leftMargin: 10
            anchors.top:parent.top
            anchors.topMargin: 85
            text: qsTr("设备名称:")
            font.family: "宋体"
            font.pointSize: 13
        }
        TextField {
            id: device_Info_Name
            anchors.left:parent.left
            anchors.leftMargin: 87
            anchors.top:parent.top
            anchors.topMargin: 82
            width: 126
            height: 23
            placeholderText: "Text Field"
             inputMask: "XXXXXXXXXX"
            readOnly: true
            selectByMouse: true
        }
        ToolButton {
            id: devname_bnt
            anchors.left:parent.left
            anchors.leftMargin: 220
            anchors.top:parent.top
            anchors.topMargin: 82
            width: 22
            height: 22
            text: qsTr("")
            icon.source: "qrc:/icon/Info_EditCopy.png"
            onClicked: {
                device_Info_Name.readOnly = false
            }
        }
        Text {
            id: device_name_s1
            anchors.left:parent.left
            anchors.leftMargin: 260
            anchors.top:parent.top
            anchors.topMargin: 85
            text: qsTr("输入电压:")
            font.family: "宋体"
            font.pointSize: 13
        }
        Text {
            id: device_Info_Ave_V
            anchors.left:parent.left
            anchors.leftMargin: 350
            anchors.top:parent.top
            anchors.topMargin: 85
            color: "#588cfc"
            text: qsTr("220V")
            font.family: "宋体"
            font.pointSize: 13
        }


        Text {
            id: device_name_s2
            anchors.left:parent.left
            anchors.leftMargin: 510
            anchors.top:parent.top
            anchors.topMargin: 85
            text: qsTr("设备温度:")
            font.family: "宋体"
            font.pointSize: 13
        }



        Text {
            id: device_Info_Temp
            height: 18
            anchors.left:parent.left
            anchors.leftMargin: 600
            anchors.top:parent.top
            anchors.topMargin: 82
            color: "#588cfc"
            text: qsTr("40℃")
            font.family: "宋体"
            font.pointSize: 13
        }

        Text {
            id: device_name_s5
            anchors.left:parent.left
            anchors.leftMargin: 10
            anchors.top:parent.top
            anchors.topMargin: 133
            text: qsTr("IP:")
            font.family: "宋体"
            font.pointSize: 13
        }

        Text {
            id: device_info_IP
            anchors.left:parent.left
            anchors.leftMargin: 45
            anchors.top:parent.top
            anchors.topMargin: 133
            color: "#588cfc"
            text: qsTr("192.168.3.5")
            font.family: "宋体"
            font.pointSize: 13
        }

        Text {
            id: device_name_s7
            anchors.left:parent.left
            anchors.leftMargin: 260
            anchors.top:parent.top
            anchors.topMargin: 133
            text: qsTr("设备电流:")
            font.family: "宋体"
            font.pointSize: 13
        }

        Text {
            id: device_Info_Total_I
            anchors.left:parent.left
            anchors.leftMargin: 350
            anchors.top:parent.top
            anchors.topMargin: 133
            color: "#588cfc"
            text: qsTr("20A")
            font.family: "宋体"
            font.pointSize: 13
        }

        Text {
            id: device_onlinestate
            anchors.left:parent.left
            anchors.leftMargin: 510
            anchors.top:parent.top
            anchors.topMargin: 133
            text: qsTr("在线状态:")
            font.family: "宋体"
            font.pointSize: 13
        }

        Text {
            id: device_Info_State
            width: 34
            height: 18
            anchors.left:parent.left
            anchors.leftMargin: 600
            anchors.top:parent.top
            anchors.topMargin: 131
            color: "#588cfc"
            text: qsTr("在线")
            font.family: "宋体"
            font.pointSize: 13
        }
        Text {
            id: device_name_s12
            anchors.left:parent.left
            anchors.leftMargin: 5
            anchors.top:parent.top
            anchors.topMargin: 160
            text: qsTr("_________________________________________________________________________________________________________________________________________________")
            font.family: "宋体"
            font.pointSize: 13
        }
        Text {
            id: device_name_s11
            anchors.left:parent.left
            anchors.leftMargin: 10
            anchors.top:parent.top
            anchors.topMargin: 200
            width: 92
            height: 22
            text: qsTr("电源通道")
            font.family: "宋体"
            font.pointSize: 17
        }
        Text {
            id: device_mac_s1
            anchors.left:parent.left
            anchors.leftMargin: 120
            anchors.top:parent.top
            anchors.topMargin: 205
            width: 92
            height: 22
            color: "#ffffff"
            text: qsTr("mac")
            font.family: "宋体"
            font.pointSize: 10
        }

        MouseArea { //为窗口添加鼠标事件
            id:mouseidbj
            anchors.left:parent.left
            anchors.leftMargin: 1100
            anchors.top:parent.top
            anchors.topMargin: 200
            width: 59
            height: 28
            onPressed: { //接收鼠标按下事件
                for(var i = 0; i < totalch_id.model.count; i ++)
                {
                    totalch_id.model.get(i).textinpuvalue = false
                    totalch_id.model.get(i).closetimepro = false
                    totalch_id.model.get(i).boolbntopench = true
                    totalch_id.model.get(i).boolbntclosech = true
                }
            }
            Text {
                id: device_name_s13
                anchors.fill: parent
                text: qsTr("编辑")
                font.family: "宋体"
                font.pointSize: 21
            }
        }
        ToolButton {
            id: toolButton
            anchors.left:parent.left
            anchors.leftMargin: 1070
            anchors.top:parent.top
            anchors.topMargin: 205
            width: 22
            height: 22
            text: qsTr("")
            icon.source: "qrc:/icon/Info_EditCopy.png"
            onClicked: {
                for(var i = 0; i < totalch_id.model.count; i ++)
                {
                    totalch_id.model.get(i).textinpuvalue = false
                    totalch_id.model.get(i).closetimepro = false

                    totalch_id.model.get(i).boolbntopench = true
                    totalch_id.model.get(i).boolbntclosech = true
                }

            }
        }
        Rectangle {
            id: rectangle
            anchors.left:parent.left
            anchors.leftMargin: 10
            anchors.top:parent.top
            anchors.topMargin: 230
            width: 1126
            height: 460
            color: "#ffffff"
            CreatCHStateModel {
                id: totalch_id;
                anchors.bottomMargin: 66
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.margins: 18
            }
            ToolButton {
                id: savebtn
                anchors.left:parent.left
                anchors.leftMargin: 1050
                anchors.top:parent.top
                anchors.topMargin: 400
                width: 56
                height: 36
                icon.source: "qrc:/icon/Info_Save.png"
                onClicked: {
                    device_Info_Name.readOnly = true
                    var chnamestr = "";
                    var chswstatestt1 = "";
                    var chswstatestt2 = "";
                    var devkind = "";
                    var RegNum
                    var chstatestr1
                    var chstatestr2
                    var delayclosetimeu = ""
                    for(var i = 0; i < totalch_id.model.count; i ++)//详细信息数据保存到数据库
                    {
                        totalch_id.model.get(i).textinpuvalue = true
                        totalch_id.model.get(i).closetimepro = true
                        totalch_id.model.get(i).boolbntopench = false
                        delayclosetimeu += totalch_id.model.get(i).closedelaytime_text
                        chnamestr += totalch_id.model.get(i).chname_text
                        if(i !== totalch_id.model.count - 1)
                        {
                            chnamestr += "#";
                            delayclosetimeu += "#";
                        }
                        if(totalch_id.model.get(i).iconsourceopen === "qrc:/icon/Info_OpenE.png")//开状态
                        {
                            if(i > 15)
                            {
                                chswstatestt2 += "1"
                                chswstatestt2 += "#"
                            }
                            else
                            {
                                chswstatestt1 += "1"
                                 chswstatestt1 += "#"
                            }
                        }
                        else
                        {
                            if(i > 15)
                            {
                                chswstatestt2 += "0"
                                chswstatestt2 += "#"
                            }
                            else
                            {
                                chswstatestt1 += "0"
                                chswstatestt1 += "#"
                            }
                        }
                    }
                    if(chswstatestt1[chswstatestt1.length - 1] === "#")chswstatestt1 = chswstatestt1.substring(0, chswstatestt1.lastIndexOf('#'));//
                    if(chswstatestt2[chswstatestt2.length - 1] === "#")chswstatestt2 = chswstatestt2.substring(0, chswstatestt2.lastIndexOf('#'));//
                    var strtemp = sqlitefun_obj.findsqldataID("devdata","dev_mac",device_mac_s1.text);

                    if(strtemp !== "FAIL" && strtemp !== "NONE")
                    {
                        sqlitefun_obj.updaterowdata("devdata","dev_name",device_Info_Name.text,Number(strtemp))
                        sqlitefun_obj.updaterowdata("devdata","dev_chname",chnamestr,Number(strtemp))
                        sqlitefun_obj.updaterowdata("devdata","dev_closetime",delayclosetimeu,Number(strtemp))
                        sqlitefun_obj.updaterowdata("devdata","dev_closetimecurr",delayclosetimeu,Number(strtemp))
                        if(totalch_id.model.count > 16)
                        {
                            sqlitefun_obj.updaterowdata("devdata","dev_chswstate1",chswstatestt1,Number(strtemp))
                            sqlitefun_obj.updaterowdata("devdata","dev_chswstate2",chswstatestt2,Number(strtemp))
                        }
                        else
                        {
                            sqlitefun_obj.updaterowdata("devdata","dev_chswstate1",chswstatestt1,Number(strtemp))
                        }

                    }
                    var arrbuf1
                    var arrbuf2
                    devkind = sqlitefun_obj.findsqldata("devdata","dev_kind",Number(strtemp))
                    if(devkind === "4" || devkind === "8" || devkind === "16")
                    {
                        RegNum = 1
                        chstatestr1 = sqlitefun_obj.findsqldata("devdata","dev_chswstate1",Number(strtemp));
                        arrbuf1=   chstatestr1.split('#')
                    }
                    else
                    {
                        chstatestr1 = sqlitefun_obj.findsqldata("devdata","dev_chswstate1",Number(strtemp));
                        chstatestr2 = sqlitefun_obj.findsqldata("devdata","dev_chswstate2",Number(strtemp));
                        arrbuf1=   chstatestr1.split('#')
                        arrbuf2=   chstatestr2.split('#')
                        RegNum = 2
                    }
                    var myArray=new Array(2)
                    myArray[0] = ""
                    myArray[1] = ""
                    var arraystr
                    for(var gi = 0; gi < Number(devkind); gi ++)
                    {
                        if(gi < 16)
                        {
                            if(arrbuf1[gi] === "1")
                            {
                                myArray[0] |= (1 << gi)
                            }
                        }
                        else
                        {
                            if(arrbuf2[gi - 16] === "1")
                            {
                                myArray[1] |= (1 << (gi - 16))
                            }
                        }

                    }
                    if(myArray[0] === "") myArray[0] = "0";
                    if(myArray[1] === "") myArray[1] = "0";
                    if(devkind === "32")
                    {
                    arraystr = myArray[0].toString(10) + "#" + myArray[1].toString(10);
                    }
                    else
                    {
                    arraystr = myArray[0].toString(10);
                    }

                    user_tcpserver_qmlobj.serversocket_Send_WriteData(device_mac_s1.text, 0x022c, 0x06, RegNum,arraystr, 0x0304);
                    stack.pop()
                    sendMainInterfaceSignal(device_mac_s1.text);//调用

                }
            }
        }



        Component.onCompleted: {
            mainWindow.sendDeviceInfoSignal.connect(deviceInfoslot);
            setWindow.sendMainInterfaceSignal.connect(mainWindow.modifModleData);
        }
        function deviceInfoslot(devicemac){//设备上线显示设备，更新数据
            totalch_id.model.clear();
            //获取数据库数据
            var Totalchnum;//总共通道序号
            var strtemp;//临时变量
            var idInt;//数据库ID
            var sqlrowvalue;//数据库行数据
            var sqlrowbuf;
            var dev_chnamebuf;
            var dev_chswstatebuf1;
            var dev_chswstatebuf2;
            var dev_chswstatebuf;
            var dev_chvoltbuf;
            var dev_chcurrtbuf;
            var dev_voltcurrstrbuf;
            var dev_delayclosetimestr
            var getipstr
            strtemp = sqlitefun_obj.findsqldataID("devdata","dev_mac",devicemac);
            device_mac_s1.text = devicemac
            if(strtemp !== "FAIL" && strtemp !== "NONE")
            {
                idInt = Number(strtemp)
                sqlrowvalue = sqlitefun_obj.findsqlrowdata("devdata",20,idInt);//获取数据
                sqlrowbuf = sqlrowvalue.split("&");
                Totalchnum = Number(sqlrowbuf[13]);
                dev_chnamebuf = sqlrowbuf[8].split("#");//设备通道名字
                dev_chswstatebuf1 = sqlrowbuf[16].split("#");//设备1-16通道状态
                dev_chswstatebuf2 = sqlrowbuf[17].split("#");//设备16-32通道状态
                dev_chswstatebuf = dev_chswstatebuf1.concat(dev_chswstatebuf2);//开关通道
                dev_chvoltbuf = sqlrowbuf[14].split("#");//电压
                dev_chcurrtbuf = sqlrowbuf[15].split("#");//电流
                device_Info_Name.text = sqlrowbuf[7]//设备名字
                device_Info_Ave_V.text = sqlrowbuf[9] + "V"//设备输入电压
                device_Info_Temp.text = sqlrowbuf[10]//温度
                getipstr = sqlrowbuf[2].split("+");
                device_info_IP.text = getipstr[0]//Ip
                 device_Info_Total_I.text = sqlrowbuf[11] + "A"//设备总电流
                if(sqlrowbuf[12] === "1")//在线状态
                {
                    device_Info_State.text = "在线"
                }
                else
                {
                    device_Info_State.text = "离线"
                }
                for(var i = 0; i < Totalchnum;i ++)
                {
                    dev_chvoltbuf[i] += "V/"
                    dev_chcurrtbuf[i] += "A"
                    if(Totalchnum < 16)
                    {
                        dev_voltcurrstrbuf = dev_chvoltbuf[0] + dev_chcurrtbuf[i]
                    }
                    else
                    {
                        dev_voltcurrstrbuf = dev_chvoltbuf[i] + dev_chcurrtbuf[i]
                    }
                    totalch_id.creatAllCHModelShow(i+1,0,dev_voltcurrstrbuf,dev_chnamebuf[i],Number(dev_chswstatebuf[i]))//创建
                }
            }

        }

    }

    MsgDialog {
        id: msgDialog
        tipText: qsTr("QML  debugging is enabled. Only use this in a safe eenvironment.")
    }
}
