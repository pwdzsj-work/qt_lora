import QtQuick 2.7
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Page {
    id:deviceconfigpage
    title: qsTr("区域配置")
    visible: true
    property StackView stack: null
    readonly property bool compactLayout: width < 700
    readonly property real layoutGap: Math.max(6, Math.min(12, width * 0.01))
    readonly property real layoutTopInset: Math.max(72, Math.min(98, height * 0.12))
    readonly property real navigationWidth: compactLayout ? width - 2 * layoutGap
                                                          : Math.max(100, width * 0.10)
    readonly property real layoutContentX: compactLayout ? layoutGap
                                                          : navigationWidth + layoutGap
    readonly property real layoutContentTop: compactLayout ? layoutTopInset + 92
                                                            : layoutTopInset + 56
    readonly property real layoutContentWidth: width - layoutContentX - layoutGap
    readonly property real layoutContentHeight: height - layoutContentTop - layoutGap
    signal sendaddareSignal(var enflag,var seril);//
    signal sendaddpanSignal(var enflag,var seril,var editorcreat,var panname);//
    signal sendaddalarmSignal(var enflag,var seril);//
    width: parent ? parent.width : 1200
    height: parent ? parent.height : 800
    Rectangle {
        id:colorayu
        anchors.fill: parent
      //  color: "#e6e6e6"
           border.color: "#999999" //设置边框的颜色
               border.width: 1       //设置边框的大小
    Grid {
        id:coloumndev;
        x: deviceconfigpage.compactLayout ? deviceconfigpage.layoutGap : 0
        y: deviceconfigpage.layoutTopInset
        spacing: 0;
        columns: deviceconfigpage.compactLayout ? 4 : 1
        rows: deviceconfigpage.compactLayout ? 1 : 4
        width: deviceconfigpage.navigationWidth
        height: deviceconfigpage.compactLayout ? 40 : 160
        Rectangle{
            width: deviceconfigpage.compactLayout ? coloumndev.width / 4 : coloumndev.width
            height: 40;
            color: "#ffffff"
            Text{
                id:areaconfig_set
                text: "区域配置"
                font.bold: true
                font.pointSize: 15;
                anchors.centerIn: parent
                  color: "#2389f7"
               // color : "#2d2d2d"
            }

            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    areaconfig_menu0.text = "区域配置"
                    pag1_view.visible = true;
                    pag2_view.visible = false;
                    pag3_view.visible = false;
                    pag4_view.visible = false;
                    areaconfig_set.color = "#2389f7"
                    areaconfig_plan.color = "#2d2d2d"
                    areaconfig_alarm.color = "#2d2d2d"
                    areaconfig_about.color = "#2d2d2d"
                    toolButton.visible = true
                }
            }
        }
        Rectangle{
            width: deviceconfigpage.compactLayout ? coloumndev.width / 4 : coloumndev.width
            height: 40;
            color: "#ffffff"
            Text{
                id:areaconfig_plan
                text: "通道预案"
                font.bold: true
                font.pointSize: 15;
                anchors.centerIn: parent
                color : "#2d2d2d"
            }
            MouseArea{
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                anchors.fill: parent;

                onClicked: {
                    areaconfig_menu0.text = "通道预案"
                    pag1_view.visible = false;
                    pag2_view.visible = true;
                    pag3_view.visible = false;
                    pag4_view.visible = false;
                    areaconfig_set.color = "#2d2d2d"
                    areaconfig_plan.color = "#2389f7"
                    areaconfig_alarm.color = "#2d2d2d"
                    areaconfig_about.color = "#2d2d2d"
                     toolButton.visible = true
                }
            }
        }
        Rectangle{
            width: deviceconfigpage.compactLayout ? coloumndev.width / 4 : coloumndev.width
            height: 40;
            color: "#ffffff"
            Text{
                id:areaconfig_alarm
                text: "报警阈值"
                font.bold: true
                font.pointSize: 15;
                anchors.centerIn: parent
                color : "#2d2d2d"
            }
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    areaconfig_menu0.text = "报警阈值";
                    pag1_view.visible = false;
                    pag2_view.visible = false;
                    pag3_view.visible = true;
                    pag4_view.visible = false;
                    areaconfig_set.color = "#2d2d2d"
                    areaconfig_plan.color = "#2d2d2d"
                    areaconfig_alarm.color = "#2389f7"
                    areaconfig_about.color = "#2d2d2d"
                     toolButton.visible = true
                }
            }
        }
        Rectangle{
            width: deviceconfigpage.compactLayout ? coloumndev.width / 4 : coloumndev.width
            height: 40;
            color: "#ffffff"
            Text{
                id:areaconfig_about
                text: "关于软件"
                font.bold: true
                font.pointSize: 15;
                anchors.centerIn: parent
                color : "#2d2d2d"
            }
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    areaconfig_menu0.text = "关于软件"
                    pag1_view.visible = false;
                    pag2_view.visible = false;
                    pag3_view.visible = false;
                    pag4_view.visible = true;
                    areaconfig_set.color = "#2d2d2d"
                    areaconfig_plan.color = "#2d2d2d"
                    areaconfig_alarm.color = "#2d2d2d"
                    areaconfig_about.color = "#2389f7"
                    toolButton.visible = false
                }
            }
        }
    }


    Page{//新增预案
        id: pag2_view
        Rectangle {
            id: pag2tangle
            x: deviceconfigpage.layoutContentX
            y: deviceconfigpage.layoutContentTop
            width: deviceconfigpage.layoutContentWidth
            height: deviceconfigpage.layoutContentHeight
            color: "#FFFFFF"
            Rectangle {
                id: rectanglepag2
                width: parent.width
                height: 35
                color: "#f3f7ff"
                Text {
                    id: serilpag2
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 20
                    width: 46
                    height: 18
                    text:qsTr("序号")
                    font.pixelSize: 19
                }

                Text {
                    id: plannamepag2
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 220
                    width: 80
                    height: 18
                    text: qsTr("预案名称")
                    font.pixelSize: 19
                }

                Text {
                    id: swdelaypag2
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 450
                    width: 80
                    height: 18
                    text: qsTr("开关动作延时(秒)")
                    font.pixelSize: 19
                }

                Text {
                    id: swopedelaypag2
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 850
                    width: 80
                    height: 18
                    text: qsTr("操作")
                    font.pixelSize: 19
                }
            }
            Rectangle {
                id: regionalplanypag2
                anchors.top:parent.top
                anchors.topMargin: 35
                width: parent.width
                height: parent.height - anchors.topMargin
                color: "#ffffff"
                CreatChannelPlanModel {
                    id: mode_newplanList1
                    anchors.fill: parent
                    anchors.centerIn: parent
                    anchors.margins: 5

                }
            }
        }

    }
    Page{
        id: pag3_view
        x: deviceconfigpage.layoutContentX
        y: deviceconfigpage.layoutContentTop
        width: deviceconfigpage.layoutContentWidth
        height: deviceconfigpage.layoutContentHeight
        Rectangle {
            id: allrectanglepag3
            width: parent.width
            height: parent.height
            color: "#FFFFFF"
            Rectangle {
                id: rectanglepag3
                width: parent.width
                height: 35
                color: "#f3f7ff"
                Text {
                    id: alarmserilp3
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 20
                    width: 46
                    height: 18
                    text:qsTr("序号")
                    font.pixelSize: 19
                }

                Text {
                    id: alarmdevnamep3
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 100
                    width: 80
                    height: 18
                    text: qsTr("设备名称")
                    font.pixelSize: 19
                }

                Text {
                    id: alarmchnamep3
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 300
                    width: 80
                    height: 18
                    text: qsTr("通道")
                    font.pixelSize: 19
                }
                Text {
                    id: alarmimaxp3
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 460
                    width: 80
                    height: 18
                    text: qsTr("最高电流(A)")
                    font.pixelSize: 19
                }
                Text {
                    id: alarmvragngep3
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 600
                    width: 80
                    height: 18
                    text: qsTr("范围电压(V)")
                    font.pixelSize: 19
                }
                Text {
                    id: alarmvragngep344
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 740
                    width: 80
                    height: 18
                    text: qsTr("最高温度(℃)")
                    font.pixelSize: 19
                }
                Text {
                    id: elementcpag3
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 920
                    width: 80
                    height: 18
                    text: qsTr("操作")
                    font.pixelSize: 19
                }
            }
            Rectangle {
                id: regionalareap3
                anchors.top:parent.top
                anchors.topMargin: 35
                width: parent.width
                height: parent.height - anchors.topMargin
                color: "#ffffff"
                CreatAlarmRangeModel {
                    id: mode_alarmvalueListp3
                    anchors.fill: parent
                    anchors.centerIn: parent
                    anchors.margins: 5

                }
            }
        }
    }
    Page{
        id: pag4_view
        x: deviceconfigpage.layoutContentX
        y: deviceconfigpage.layoutContentTop
        width: deviceconfigpage.layoutContentWidth
        height: deviceconfigpage.layoutContentHeight
        Rectangle {
            id: allrectanglepag4
            width: parent.width
            height: parent.height
            color: "#FFFFFF"
            Text {
                id: softnamep4
                anchors.top:parent.top
                anchors.topMargin: 20
                anchors.left:parent.left
                anchors.leftMargin: 20
                width: 46
                height: 18
                text:qsTr("软件名称： 电力优化管控系统")
                color: "#14203f"
                font.pixelSize: 16
            }
            Text {
                id: softvarnamep4
                anchors.top:parent.top
                anchors.topMargin: 60
                anchors.left:parent.left
                anchors.leftMargin: 20
                width: 55
                height: 18
                text:qsTr("版本信息： V2.1.1")
                color: "#14203f"
                font.pixelSize: 16
            }
            Text {
                id: releasetimep4
                anchors.top:parent.top
                anchors.topMargin: 100
                anchors.left:parent.left
                anchors.leftMargin: 20
                width: 46
                height: 18
                text:qsTr("发布时间： 2021年11月18日")
                color: "#14203f"
                font.pixelSize: 16
            }
        }
    }
    Page{
        id: pag1_view
        Rectangle {
            id: allrectangle
            x: deviceconfigpage.layoutContentX
            y: deviceconfigpage.layoutContentTop
            width: deviceconfigpage.layoutContentWidth
            height: deviceconfigpage.layoutContentHeight
            color: "#FFFFFF"
            Rectangle {
                id: rectangle23
                width: parent.width
                height: 35
                color: "#f3f7ff"
                Text {
                    id: element
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 20
                    width: 46
                    height: 18
                    text:qsTr("序号")
                    font.pixelSize: 19
                }

                Text {
                    id: element1
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 220
                    width: 80
                    height: 18
                    text: qsTr("区域名称")
                    font.pixelSize: 19
                }

                Text {
                    id: element2
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 450
                    width: 80
                    height: 18
                    text: qsTr("设备名称")
                    font.pixelSize: 19
                }

                Text {
                    id: element3
                    anchors.top:parent.top
                    anchors.topMargin: 10
                    anchors.left:parent.left
                    anchors.leftMargin: 850
                    width: 80
                    height: 18
                    text: qsTr("操作")
                    font.pixelSize: 19
                }
            }
            Rectangle {
                id: creatAreaListModellist
                anchors.top:parent.top
                anchors.topMargin: 35
                width: parent.width
                height: parent.height - anchors.topMargin
                color: "#ffffff"
                CreatAreaListModel {
                    id: mode_CreatAreaListModel
                    anchors.fill: parent
                    anchors.centerIn: parent
                    anchors.margins: 5
                }
            }
        }

    }
    Rectangle {
        id: areaconfig_menu_q
        x: deviceconfigpage.layoutContentX
        y: deviceconfigpage.compactLayout ? deviceconfigpage.layoutTopInset + 46
                                           : deviceconfigpage.layoutTopInset
        width: deviceconfigpage.layoutContentWidth
        height: 41
        color: "#ffffff"
        border.color: "#f3f7ff"
        Text {
            id: areaconfig_menu0
            anchors.fill: parent
            text: qsTr("区域配置")

            anchors.rightMargin: 961
            anchors.bottomMargin: 9
            anchors.leftMargin: 9
            anchors.topMargin: 7
            font.bold: true
            font.pixelSize: 24
        }

        ToolButton {
            id: toolButton
            x: 118
            y: 8
            width: 35
            height: 25
            text: ""
            display: AbstractButton.IconOnly
            icon.source: "qrc:/icon/add.png"
            icon.width: 20
            icon.height: 20
            icon.color: "transparent"
            padding: 0
            onClicked: {
                if( areaconfig_menu0.text == "区域配置")
                {
                    var AddNewAreashow = Qt.createComponent("AddNewArea.qml").createObject(deviceconfigpage);//建立父类与子类关系
                    AddNewAreashow.show()//显示子对话框
                    deviceconfigpage.sendaddareSignal(0,0);//发送信号将动态复选框添加
                }
                else if( areaconfig_menu0.text == "通道预案")
                {

                    var AddNewPanshow = Qt.createComponent("AddNewPan.qml").createObject(deviceconfigpage);//建立父类与子类关系
                    AddNewPanshow.show()//显示子对话框
                    deviceconfigpage.sendaddpanSignal(0,0,"creat","");//发送信号将动态复选框添加
                }
                else if( areaconfig_menu0.text == "报警阈值")
                {
                    var AddAlarmValueshow = Qt.createComponent("AddAlarmValue.qml").createObject(deviceconfigpage);//建立父类与子类关系
                    AddAlarmValueshow.show()//显示子对话框
                    deviceconfigpage.sendaddalarmSignal(0,0);//发送信号将动态复选框添加
                }
                else
                {

                }

            }
        }
    }
}


    Component.onCompleted: {
        mainWindow.sendloginaddpanSignal.connect(loginaddplandata);
        mainWindow.sendloginaddareaSignal.connect(loginaddareadata);
        mainWindow.sendloginaddalarmSignal.connect(loginaddalarmdata);
    }
    function loginaddplandata()//自动登录数据库内容
    {
        if(mode_newplanList1.count > 0) return;
        var planid = sqlitefun_obj.traversedata("panlist","id");
        if(planid === "NONE" || planid === "FAIL" || planid === "") return;
        var planidbuf = planid.split("&");
        var panname = ""
        var pandevname = ""
        var panchchose = ""
        var swworkdelay = ""
        for(var i = 0; i < planidbuf.length; i ++)
        {
            panname = sqlitefun_obj.findsqldata("panlist","panname",Number(planidbuf[i]))
            swworkdelay = sqlitefun_obj.findsqldata("panlist","swworkdelay",Number(planidbuf[i]))
            mode_newplanList1.creatplanlist(String(mode_newplanList1.count + 1),panname,swworkdelay);
        }

    }
    function loginaddareadata(){//自动登录数据库内容
        if(mode_CreatAreaListModel.count > 0) return;
        var areaid = sqlitefun_obj.traversedata("arealist","id");
        if(areaid === "NONE" || areaid === "FAIL" || areaid === "") return;
        var areaidbuf = areaid.split("&");
        var arealistname = ""
        var arealistdevname = ""
        var operkind = ""
        for(var i = 0; i < areaidbuf.length; i ++)
        {
            arealistname = sqlitefun_obj.findsqldata("arealist","arealistname",Number(areaidbuf[i]))
            arealistdevname = sqlitefun_obj.findsqldata("arealist","arealistdevname",Number(areaidbuf[i]))
            operkind = sqlitefun_obj.findsqldata("arealist","operkind",Number(areaidbuf[i]))
            mode_CreatAreaListModel.creatregionallisthand(String(mode_CreatAreaListModel.count + 1),arealistname,arealistdevname);
        }
    }
    function loginaddalarmdata(){//自动登录数据库内容
        if(mode_alarmvalueListp3.count > 0) return;
        var alarmid = sqlitefun_obj.traversedata("alarmthreshold","id");
        if(alarmid === "NONE" || alarmid === "FAIL" || alarmid === "") return;
        var alarmidbuf = alarmid.split("&");
        var alarmdevname = ""
        var alarmch = ""
        var maxcurrent = ""
        var alarmvoltmin = ""
        var alarmvoltmax = ""
        var alarmtempmax = ""
        for(var i = 0; i < alarmidbuf.length; i ++)
        {
            alarmdevname = sqlitefun_obj.findsqldata("alarmthreshold","alarmdevname",Number(alarmidbuf[i]))
            alarmch = sqlitefun_obj.findsqldata("alarmthreshold","alarmch",Number(alarmidbuf[i]))
            maxcurrent = sqlitefun_obj.findsqldata("alarmthreshold","maxcurrent",Number(alarmidbuf[i]))
            alarmvoltmin = sqlitefun_obj.findsqldata("alarmthreshold","alarmvoltmin",Number(alarmidbuf[i]))
            alarmvoltmax = sqlitefun_obj.findsqldata("alarmthreshold","alarmvoltmax",Number(alarmidbuf[i]))
            alarmtempmax = sqlitefun_obj.findsqldata("alarmthreshold","alarmtempmax",Number(alarmidbuf[i]))
            mode_alarmvalueListp3.creatalarmrangisthand(String(mode_alarmvalueListp3.count + 1),alarmdevname,alarmch,maxcurrent,alarmvoltmin + "~" + alarmvoltmax,alarmtempmax);

        }
    }
    function hcreatregionallisth(areanamec,getalldevname,idcode,cmdkind){//创建/更新区域列表
        if(cmdkind === 1)//创建
        {
            mode_CreatAreaListModel.creatregionallisthand(String(mode_CreatAreaListModel.count + 1),areanamec,getalldevname);
        }
        else//更新
        {
            mode_CreatAreaListModel.model.set( idcode,{areaname_text: areanamec})
            mode_CreatAreaListModel.model.set( idcode,{devname_text: getalldevname})
        }
    }
    function hcreatnewplanlisth(plannameus,delaytime,idcode,cmdkind){//创建/更新预案列表
        if(cmdkind === 1)//创建
        {//        measure_showMode.model.append({reLiSer_text: itemser,planname_text:planname,delaytime_text:delaytim})
            mode_newplanList1.creatplanlist(String(mode_newplanList1.count + 1),plannameus,delaytime);
        }
        else//更新
        {
            mode_newplanList1.model.set( idcode,{planname_text: plannameus})
            mode_newplanList1.model.set( idcode,{delaytime_text: delaytime})
        }
    }

    function hcreatalarmvaluelisth(devnamep3,chnamep3,maxcurrp3,voltrangep3,maxtempp3,idcode,cmdkind){//创建/更新告警阈值
        if(cmdkind === 1)//创建
        {
            mode_alarmvalueListp3.creatalarmrangisthand(String(mode_alarmvalueListp3.count + 1),devnamep3,chnamep3,maxcurrp3,voltrangep3,maxtempp3);
        }
        else//更新
        {
            var alarmchnambuf = chnamep3.split(",");
         if(alarmchnambuf.length > 6)
         {

            var showchname1 = alarmchnambuf[0] + "," +alarmchnambuf[1] + "," + alarmchnambuf[2] + "," +alarmchnambuf[3] + "," +alarmchnambuf[4] +"..." + alarmchnambuf[alarmchnambuf.length - 1]
         }
            mode_alarmvalueListp3.model.set( idcode,{alarmdevname_text: devnamep3})
            mode_alarmvalueListp3.model.set( idcode,{alarmchname_text: showchname1})
            mode_alarmvalueListp3.model.set( idcode,{alarmmaxcurrname_text: maxcurrp3})
            mode_alarmvalueListp3.model.set( idcode,{alarmvoltrange_text: voltrangep3})
            mode_alarmvalueListp3.model.set( idcode,{alarmmaxtemp_text: maxtempp3})
        }
    }

    function areatodevcofigslot(index1) {//删除区域列表
        var i
        var sqlid = ""
        sqlid = sqlitefun_obj.findsqldataID("arealist","arealistname",mode_CreatAreaListModel.model.get(index1).areaname_text)
        if(sqlid === "FAIL" || sqlid === "NONE") return;
        mode_CreatAreaListModel.model.remove(index1,1);
        sqlitefun_obj.deleterow("arealist",Number(sqlid));
        for(i =  index1 + 2; i <= mode_CreatAreaListModel.model.count + 1; i ++)
        {
            mode_CreatAreaListModel.model.get(i-2).reLiSer_text = String(i -1)
        }
    }
    function plantodevcofigslot(index1) {//删除预案列表
        var i
        var sqlid = ""
        sqlid = sqlitefun_obj.findsqldataID("panlist","panname",mode_newplanList1.model.get(index1).planname_text)
        if(sqlid === "FAIL" || sqlid === "NONE") return;
        mainWindow.deletequickcontrol(mode_newplanList1.model.get(index1).planname_text,index1)
        mode_newplanList1.model.remove(index1,1);
        sqlitefun_obj.deleterow("panlist",Number(sqlid));
        for(i =  index1 + 2; i <= mode_newplanList1.model.count + 1; i ++)
        {
            mode_newplanList1.model.get(i-2).reLiSer_text = String(i -1)

        }
    }
    function deletalarmrangeconfigfun(index1){//删除告警阈值
        var i
        var sqlid = ""
        sqlid = sqlitefun_obj.findsqldataID("alarmthreshold","alarmdevname",mode_alarmvalueListp3.model.get(index1).alarmdevname_text)
        if(sqlid === "FAIL" || sqlid === "NONE") return;
        mode_alarmvalueListp3.model.remove(index1,1);
        sqlitefun_obj.deleterow("alarmthreshold",Number(sqlid));
        for(i =  index1 + 2; i <= mode_alarmvalueListp3.model.count + 1; i ++)
        {
            mode_alarmvalueListp3.model.get(i-2).reLiSer_text = String(i -1)
        }
    }

    function correctareatodevcofigslot(index1) {//编辑区域配置
        var AddNewAreashow = Qt.createComponent("AddNewArea.qml").createObject(deviceconfigpage);//建立父类与子类关系
        AddNewAreashow.show()//显示子对话框
        deviceconfigpage.sendaddareSignal(1,index1 + 1);//发送信号将动态复选框添加

    }


    function correctpantodevcofigslot(index1,edit,panname) {//编辑通道预案
        var AddNewPanshow = Qt.createComponent("AddNewPan.qml").createObject(deviceconfigpage);//建立父类与子类关系
        AddNewPanshow.show()//显示子对话框
        deviceconfigpage.sendaddpanSignal(1,index1 + 1,edit,panname);//发送信号将动态复选框添加

    }
    function correctalarmtodevcofigslot(index1) {//编辑报警阈值
        var AddAlarmValueshow = Qt.createComponent("AddAlarmValue.qml").createObject(deviceconfigpage);//建立父类与子类关系
        AddAlarmValueshow.show()//显示子对话框
        deviceconfigpage.sendaddalarmSignal(1,index1 + 1);//发送信号将动态复选框添加

    }
    function singletoMainQuick(namestr,delayt,modelid,editorcreat){
            mainWindow.updataquickmodelshowhandle(namestr,delayt,modelid,editorcreat);
    }
}
