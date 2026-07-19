import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

AdaptiveWindow {
    id: mainWindow
    visible: true
    responsiveContent: true
    designWidth: 1200
    designHeight: 800
    width: 1200
    height: 800
    minimumWidth: 560
    minimumHeight: 480
    title: qsTr("LoRa继电器智控系统")
    property int i :0
    readonly property bool narrowLayout: width < 760
    readonly property bool mediumLayout: width >= 760 && width < 1050
    readonly property real responsiveGap: Math.max(6, Math.min(12, width * 0.01))
    readonly property real responsiveHeaderHeight: Math.max(64, Math.min(84, height * 0.11))
    readonly property real responsiveContentTop: responsiveHeaderHeight + responsiveGap
    readonly property real responsiveBodyHeight: Math.max(240, height - responsiveContentTop - responsiveGap)
    readonly property real panelHeaderHeight: 48
    readonly property real narrowPanelWidth: Math.max(280, width - 2 * responsiveGap)
    readonly property real narrowContentHeight: responsiveContentTop + 48 + 260 + responsiveGap
                                                + 48 + 240 + responsiveGap
                                                + 48 + 420 + responsiveGap
                                                + 48 + 320 + responsiveGap
    readonly property real leftColumnWidth: narrowLayout ? narrowPanelWidth
                                                          : mediumLayout ? width * 0.34 - 1.5 * responsiveGap
                                                                         : width * 0.23 - 1.5 * responsiveGap
    readonly property real contentColumnX: narrowLayout ? responsiveGap
                                                         : leftColumnWidth + 2 * responsiveGap
    readonly property real contentAreaWidth: width - contentColumnX - responsiveGap
    readonly property real alarmColumnWidth: narrowLayout ? narrowPanelWidth
                                                           : mediumLayout ? contentAreaWidth
                                                                          : width * 0.26 - 1.5 * responsiveGap
    readonly property real deviceColumnWidth: narrowLayout ? narrowPanelWidth
                                                            : mediumLayout ? contentAreaWidth
                                                                           : contentAreaWidth - alarmColumnWidth - responsiveGap
    readonly property real alarmColumnX: narrowLayout || mediumLayout
                                         ? contentColumnX
                                         : contentColumnX + deviceColumnWidth + responsiveGap
    readonly property real leftSectionHeight: (responsiveBodyHeight - responsiveGap) / 2
    readonly property real timerPanelY: narrowLayout
                                        ? responsiveContentTop + panelHeaderHeight + 260 + responsiveGap
                                        : responsiveContentTop + leftSectionHeight + responsiveGap
    readonly property real devicePanelY: narrowLayout
                                         ? timerPanelY + panelHeaderHeight + 240 + responsiveGap
                                         : responsiveContentTop
    readonly property real alarmPanelY: narrowLayout
                                        ? devicePanelY + panelHeaderHeight + 420 + responsiveGap
                                        : mediumLayout ? responsiveContentTop + responsiveBodyHeight * 0.60 + responsiveGap
                                                       : responsiveContentTop
    signal sendDeviceInfoSignal(var devicemacstr);
    signal sendedittimetask(var enflag,var seril);//
    flags: Qt.Window | Qt.FramelessWindowHint //去标题栏
    signal sendaddtimetaskSignal(var enflag,var seril,var tasktimename);//
    signal sendloginaddpanSignal();//
    signal sendloginaddareaSignal();//
    signal sendloginaddalarmSignal();//

    function showMainPage() {
        if (stack.currentItem !== mainView)
            stack.pop(mainView, StackView.Immediate)

        mainView.visible = true
        mainView.stack = stack
    }

    function showConfigPage() {
        if (stack.currentItem === page_areaconfig)
            return

        if (stack.depth > 1)
            stack.pop(mainView, StackView.Immediate)

        page_areaconfig.visible = true
        page_areaconfig.stack = stack
        stack.push(page_areaconfig, StackView.Immediate)

        mainWindow.sendloginaddpanSignal()
        mainWindow.sendloginaddareaSignal()
        mainWindow.sendloginaddalarmSignal()
    }

    StackView {
        id: stack
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        initialItem: mainView
        anchors.fill: parent
    }
    Rectangle
    {
        width: parent.width
        height: mainWindow.responsiveHeaderHeight
        color: "#2a5298"
    }
    MouseArea { //为窗口添加鼠标事件
        width: parent.width
        height: mainWindow.responsiveHeaderHeight
        acceptedButtons: Qt.LeftButton //只处理鼠标左键
        property point clickPos: "0,0"

        onPressed: { //接收鼠标按下事件
            clickPos  = Qt.point(mouse.x,mouse.y)
        }
        onPositionChanged: { //鼠标按下后改变位置
            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)

            //如果mainwindow继承自QWidget,用setPos
            mainWindow.setX(mainWindow.x + delta.x)
            mainWindow.setY(mainWindow.y + delta.y)
        }
        onDoubleClicked: {
            if (mainWindow.visibility === Window.Maximized)
                mainWindow.showNormal()
            else
                mainWindow.showMaximized()
        }

        Text {
            id: element
            anchors.left:parent.left
            anchors.leftMargin: 24
            anchors.top:parent.top
            anchors.topMargin: 26
            width: Math.max(180, parent.width * 0.25)
            height: 36
            color: "#f2efef"
            text: qsTr("LoRa继电器智控系统")
            font.bold: true
            font.pixelSize: Math.max(18, Math.min(30, mainWindow.width / 40))
        }
        MouseArea { //为窗口添加鼠标事件
            id:mouseid
            anchors.left:parent.left
            anchors.leftMargin: Math.max(250, mainWindow.width * 0.30)
            anchors.top:parent.top
            anchors.topMargin: 32
            width: 52
            height: 24
            onPressed: { //接收鼠标按下事件
                mainWindow.showMainPage()
            }
            Text {
                id: element3
                anchors.fill: parent
                color: "#f2efef"
                text: qsTr("首页")
                font.bold: true
                font.pixelSize: 24
            }
        }
        MouseArea { //为窗口添加鼠标事件
            id:mouseidee
            anchors.left:parent.left
            anchors.leftMargin: Math.max(380, mainWindow.width * 0.41)
            anchors.top:parent.top
            anchors.topMargin: 32
            width: 52
            height: 24
            onPressed: { //接收鼠标按下事件
                mainWindow.showConfigPage()
            }
            Text {
                id: element5
                anchors.fill: parent
                color: "#f2efef"
                text: qsTr("配置")
                font.bold: true
                font.pixelSize: 24
            }
        }
        ToolButton {
            id: toolButton
            anchors.left:parent.left
            anchors.leftMargin: Math.max(216, mainWindow.width * 0.27)
            anchors.top:parent.top
            anchors.topMargin: 28
            width: 34
            height: 32
            text: ""
            display: AbstractButton.IconOnly
            icon.source: "qrc:/icon/firstpage.png"
            icon.width: 30
            icon.height: 26
            icon.color: "transparent"
            padding: 0
            onClicked: {
                mainWindow.showMainPage()
            }
        }

        ToolButton {
            id: toolButton1
            anchors.left:parent.left
            anchors.leftMargin: Math.max(346, mainWindow.width * 0.38)
            anchors.top:parent.top
            anchors.topMargin: 30
            width: 34
            height: 28
            text: ""
            display: AbstractButton.IconOnly
            icon.source: "qrc:/icon/Setting.png"
            icon.width: 28
            icon.height: 28
            icon.color: "transparent"
            padding: 0
            onClicked: {
                mainWindow.showConfigPage()
            }
        }

        ToolButton {
            id: btnMainExit
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.top:parent.top
            anchors.topMargin: 26
            width: 28
            height: 28
            text: ""
            display: AbstractButton.IconOnly
            icon.source: "qrc:/icon/close.png"
            icon.width: 26
            icon.height: 26
            icon.color: "transparent"
            padding: 0
            onClicked: {
                Qt.quit()
            }
        }

        ToolButton {
            id: btnMainMax
            anchors.right: btnMainExit.left
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 26
            width: 28
            height: 28
            text: ""
            display: AbstractButton.IconOnly
            icon.source: mainWindow.visibility === Window.Maximized
                         ? "qrc:/icon/restore.svg" : "qrc:/icon/maximize.svg"
            icon.width: 26
            icon.height: 26
            icon.color: "transparent"
            padding: 0
            hoverEnabled: true
            ToolTip.visible: hovered
            ToolTip.text: mainWindow.visibility === Window.Maximized
                          ? qsTr("还原") : qsTr("最大化")

            onClicked: {
                if (mainWindow.visibility === Window.Maximized)
                    mainWindow.showNormal()
                else
                    mainWindow.showMaximized()
            }
        }

        ToolButton {
            id: btnMainSmall
            anchors.right: btnMainMax.left
            anchors.rightMargin: 20
            anchors.top:parent.top
            anchors.topMargin: 26
            width: 28
            height: 28
            text: ""
            display: AbstractButton.IconOnly
            icon.source: "qrc:/icon/narrow.png"
            icon.width: 26
            icon.height: 26
            icon.color: "transparent"
            padding: 0
            onClicked: {
                mainWindow.showMinimized()
            }

        }

        Text {
            id: element6
            anchors.left:parent.left
            anchors.leftMargin: Math.max(600, mainWindow.width - 250)
            anchors.top:parent.top
            anchors.topMargin: 27
            width: 66
            height: 26
            color: "#f2efef"
            //text: qsTr("admin")
            text:account_edit.text
            font.pixelSize: 24
            font.bold: true
        }
        Flickable {
            id: mainView
            property StackView stack: null
            contentWidth: width
            contentHeight: mainWindow.narrowLayout ? mainWindow.narrowContentHeight : height
            clip: true
            Image {
                id: image_main
                anchors.fill: parent

                Rectangle {
                    id:coloran
                    anchors.fill: parent
                  //  color: "#e6e6e6"
                       border.color: "#999999" //设置边框的颜色
                           border.width: 1       //设置边框的大小
                    Rectangle {
                        id: rectangle
                        x: mainWindow.responsiveGap
                        y: mainWindow.responsiveContentTop
                        width: mainWindow.leftColumnWidth
                        height: mainWindow.panelHeaderHeight
                        color: "#ffffff"
                        border.color: "#f3f7ff"
                        Text {
                            id: element7
                            anchors.fill: parent
                            text: qsTr("快捷控制")
                            anchors.rightMargin: 157
                            anchors.bottomMargin: 31
                            anchors.leftMargin: 10
                            anchors.topMargin: 15
                            font.bold: true
                            font.pixelSize: 24
                        }
                    }

                    Rectangle {
                        id: rectangleT
                        x: mainWindow.responsiveGap
                        y: mainWindow.timerPanelY
                        width: mainWindow.leftColumnWidth
                        height: mainWindow.panelHeaderHeight
                        color: "#ffffff"
                        border.color: "#f3f7ff"
                        Text {
                            id: elementT
                            anchors.left:parent.left
                            anchors.leftMargin: 11
                            anchors.top:parent.top
                            anchors.topMargin: 9
                            text: qsTr("定时任务")
                            font.bold: true
                            font.pixelSize: 24
                        }
                        ToolButton {
                            id: timebntadd
                            anchors.left:parent.left
                            anchors.leftMargin: 113
                            anchors.top:parent.top
                            anchors.topMargin: 9
                            width: 35
                            height: 25
                            text: ""
                            display: AbstractButton.IconOnly
                            icon.source: "qrc:/icon/add.png"
                            icon.width: 18
                            icon.height: 18
                            icon.color: "transparent"
                            padding: 0
                            onClicked: {
                                var AddTimeTaskshow = Qt.createComponent("AddTimeTask.qml").createObject(mainWindow);//建立父类与子类关系
                                AddTimeTaskshow.show()//显示子对话框
                                mainWindow.sendaddtimetaskSignal(0,0,"");//发送定时任务
                            }
                        }
                    }
                    Rectangle {
                        id: rectangle1

                        color: "#f3f7ff"
                    }
                    Rectangle {
                        id: listViewRec
                        x: mainWindow.responsiveGap
                        y: mainWindow.responsiveContentTop + mainWindow.panelHeaderHeight
                        width: mainWindow.leftColumnWidth
                        height: mainWindow.narrowLayout ? 260
                                                        : mainWindow.leftSectionHeight - mainWindow.panelHeaderHeight
                        color: "#ffffff"
                        border.color: "#f3f7ff"
                        CreatQuickControlModel {
                            id: quickControl_id;
                            anchors.topMargin: 13
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            anchors.bottomMargin: 8
                            anchors.fill: parent
                            anchors.centerIn: parent
                            anchors.margins: 18
                        }

                    }
                    Rectangle {
                        id: listViewRect
                        x: mainWindow.responsiveGap
                        y: mainWindow.timerPanelY + mainWindow.panelHeaderHeight
                        width: mainWindow.leftColumnWidth
                        height: mainWindow.narrowLayout ? 240
                                                        : mainWindow.leftSectionHeight - mainWindow.panelHeaderHeight
                        border.color: "#f3f7ff"
                        Rectangle {
                            id: rectangle6
                            x: 1
                            y: 2
                            width: parent.width - 2
                            height: 47
                            color: "#f3f7ff"
                            border.color: "#f3f7ff"
                            Text {
                                id: elemente
                                anchors.fill: parent
                                text: qsTr("序号  任务名称  时间  操作")
                                anchors.rightMargin: 113
                                anchors.bottomMargin: 8
                                anchors.leftMargin: 17
                                anchors.topMargin: 15
                                font.bold: true
                                font.pixelSize: 17
                            }
                        }
                        Rectangle {
                            id: timetaskap5
                            x: 1
                            anchors.top:parent.top
                            anchors.topMargin: 63
                            width: parent.width - 2
                            height: parent.height - y - 8
                            color: "#ffffff"
                            CreatTimetaskModel {
                                id: mode_mtimetaskp5
                                anchors.bottomMargin: 8
                                anchors.fill: parent
                                anchors.centerIn: parent
                                anchors.margins: 5

                            }
                        }
                    }

                    Rectangle {
                        id: rectangle3
                        x: mainWindow.contentColumnX
                        y: mainWindow.devicePanelY
                        width: mainWindow.deviceColumnWidth
                        height: mainWindow.panelHeaderHeight
                        color: "#ffffff"
                        border.color: "#f3f7ff"
                        Text {
                            id: element8
                            text: qsTr("设备列表")
                            font.bold: true
                            anchors.topMargin: 15
                            anchors.fill: parent
                            anchors.rightMargin: 157
                            font.pixelSize: 24
                            anchors.bottomMargin: 8
                            anchors.leftMargin: 17
                        }

                    }

                    Rectangle {
                        id: rectangle4
                        x: mainWindow.contentColumnX
                        y: mainWindow.devicePanelY + mainWindow.panelHeaderHeight
                        width: mainWindow.deviceColumnWidth
                        height: mainWindow.narrowLayout ? 420
                                                        : mainWindow.mediumLayout ? mainWindow.responsiveBodyHeight * 0.60 - mainWindow.panelHeaderHeight
                                                                                  : mainWindow.responsiveBodyHeight - mainWindow.panelHeaderHeight
                        color: "#ffffff"
                        border.color: "#f3f7ff"
                        CreatDevReadDataModel{
                            id: totalModel_id
                            anchors.fill: parent
                            anchors.centerIn: parent
                            anchors.margins: 18
                        }
                    }

                    Rectangle {
                        id: rectangle5
                        x: mainWindow.alarmColumnX
                        y: mainWindow.alarmPanelY
                        width: mainWindow.alarmColumnWidth
                        height: mainWindow.panelHeaderHeight
                        color: "#ffffff"
                        border.color: "#f3f7ff"
                        Text {
                            id: element9
                            text: qsTr("告警列表")
                            font.bold: true
                            anchors.topMargin: 15
                            anchors.fill: parent
                            anchors.rightMargin: 62
                            font.pixelSize: 24
                            anchors.bottomMargin: 8
                            anchors.leftMargin: 17
                        }
                    }
                    Rectangle {
                        id: rectangle78
                        x: mainWindow.alarmColumnX
                        y: mainWindow.alarmPanelY + mainWindow.panelHeaderHeight
                        width: mainWindow.alarmColumnWidth
                        height: mainWindow.narrowLayout ? 320
                                                        : mainWindow.mediumLayout ? mainWindow.responsiveBodyHeight * 0.40 - mainWindow.panelHeaderHeight - mainWindow.responsiveGap
                                                                                  : mainWindow.responsiveBodyHeight - mainWindow.panelHeaderHeight
                        color: "#ffffff"
                        border.color: "#f3f7ff"
                        CreatAlarmListModel{
                            id: creatAlarmList_id
                            anchors.rightMargin: 8
                            anchors.bottomMargin: 8
                            anchors.fill: parent
                            anchors.centerIn: parent
                            anchors.margins: 18
                        }
                    }
                }
            }

        }
    }

    DeviceConfig{
        id:page_areaconfig
        visible: false
    }
    Component.onCompleted: {
        user_tcpserver_qmlobj.QmlModelShowData.connect(showmodeldata);
        user_tcpserver_qmlobj.deleqmlshowmodel.connect(deletemodeldata);
        user_tcpserver_qmlobj.alarmmessagetoqml.connect(alarmmessage);
        user_tcpserver_qmlobj.cppsigneltoqmlhandle.connect(cppdatathroughqmltodev);
        user_tcpserver_qmlobj.chargequiccontrolstate.connect(chargequickcontrolstateshow);
        loginWindow.sendformlogintotimetask.connect(loadertimetskdata)
        loginWindow.sendformlogintoquickcontrol.connect(loaderquickcontrol)
    }
function chargequickcontrolstateshow(index,swstate){
    if(swstate === "1")
    {
     quickControl_id.model.set( Number(index),{devopbnt_icon: "qrc:/icon/Start_D.png",closebnt_icon:"qrc:/icon/Finsh_E.png"})
    }
    else
    {
     quickControl_id.model.set( Number(index),{devopbnt_icon: "qrc:/icon/Start_E.png",closebnt_icon:"qrc:/icon/Finsh_D.png"})
    }

}
    function deletemodeldata(ipstr)//删除设备
    {
        var idstr = sqlitefun_obj.findsqldataID("devdata","dev_ip",ipstr)
        var macstr = sqlitefun_obj.findsqldata("devdata","dev_mac",Number(idstr))
        if(idstr === "FAIL" || idstr === "NONE") return;
         if(macstr === "FAIL" || macstr === "NONE") return;
      //  sqlitefun_obj.deleterow("devdata",Number(idstr));
        for(var ijk = 0; ijk < totalModel_id.count; ijk ++)
        {
            if(totalModel_id.model.get(ijk).mac_text === macstr)
            {
                totalModel_id.model.remove(ijk,1);
            }
        }
    }
    function updataquickmodelshowhandle(namestr,delaytime,modelid,creatoredit){//创建快捷控制
        var needcreat = 1;
       // var plannameid = sqlitefun_obj.findsqldataID("quickcontrol","quickplanname",namestr)
        if(creatoredit === "creat")
        {//创建
            sqlitefun_obj.nOIDinsterweizhidata("quickcontrol","quickplanname",namestr)//插入时间
           var  plannameid = sqlitefun_obj.findsqldataID("quickcontrol","quickplanname",namestr)
            sqlitefun_obj.updaterowdata("quickcontrol","quickdelaytime",delaytime,Number(plannameid))
            sqlitefun_obj.updaterowdata("quickcontrol","quickswstate","0",Number(plannameid))
        }
        else
        {
            sqlitefun_obj.insertrowdata("quickcontrol","quickdelaytime",delaytime,Number(plannameid))
            sqlitefun_obj.updaterowdata("quickcontrol","quickswstate","0",Number(plannameid))
        }

        if(creatoredit === "creat")
        {
             quickControl_id.creatquicModelShow(namestr,"0")//创建
        }
        else
        {
            quickControl_id.model.set( Number(modelid) - 1,{quickconname_text: namestr})
        }

    }
    //删除快捷操作
    function deletequickcontrol(modelname,index1)
    {
        var i
        var sqlid = ""

        quickControl_id.model.remove(index1,1);

        for(i =  index1 + 2; i <= quickControl_id.model.count + 1; i ++)
        {
            quickControl_id.model.get(i-2).reLiSer_text = String(i -1)

        }
        sqlid = sqlitefun_obj.findsqldataID("quickcontrol","quickplanname",modelname)
        if(sqlid === "FAIL" || sqlid === "NONE") return;
         sqlitefun_obj.deleterow("quickcontrol",Number(sqlid));
    }
    //快捷控制
    function quickcontrolswhslothandle(index,swvalue){//快捷操作
        user_tcpserver_qmlobj.quickcontrolqml(quickControl_id.model.get(index).quickconname_text,swvalue,String(index))
    }

    function showmodeldata(qmlcmd,qmlip,qmlmac,arrayData,ledcolor){//设备上线显示设备，更新数据
        var currenttotalvalue = 0;
        var idlont = sqlitefun_obj.findsqldataID("devdata","dev_mac",qmlmac)
        var qmlroomnum = sqlitefun_obj.findsqldata("devdata","dev_name",Number(idlont));
        var qmlmacstr = sqlitefun_obj.traversedata("devdata","dev_mac");
        var qmlkind = sqlitefun_obj.findsqldata("devdata","dev_kind",Number(idlont));

        var arrayvoltcurrinit = ["---"]
         if(idlont === "FAIL" || idlont === "NONE") return;
         if(qmlroomnum === "FAIL" || qmlroomnum === "NONE") return;
         if(qmlmacstr === "FAIL" || qmlmacstr === "NONE") return;
        var qmlmacstrbuf = qmlmacstr.split("&");//设备16-32通道状态
        var creatmodelflag = 0
        for(var tt = 0; tt < totalModel_id.count; tt ++)
        {
            creatmodelflag = 0;
            if(totalModel_id.model.get(tt).mac_text === qmlmac)
            {
                creatmodelflag = 1;
                tt = totalModel_id.count
            }
        }
        if(qmlroomnum.length > 5)
        {
         qmlroomnum = qmlroomnum.substring(0,6) + "...";
        }
        if(creatmodelflag === 0)
        {
            totalModel_id.creatAllModelShow(qmlroomnum,qmlip,qmlmac,arrayvoltcurrinit,ledcolor)//创建
        }
        else
        {
            for(var i = 0; i < totalModel_id.count; i ++)//查询设备传输数据
            {
                if(totalModel_id.model.get(i).mac_text === qmlmac)
                {
                    switch(qmlcmd)
                    {
                    case 1: //电压
                        totalModel_id.model.set( i,{roomvol_text: arrayData[0]})
                        break;

                    case 2:    //电流
                        for(var ikind  = 0; ikind < Number(qmlkind); ikind ++)
                        {
                          //  if(ikind !== 30)
                          //  {
                             currenttotalvalue += Number(arrayData[ikind]);
                         //   }

                        }
                        currenttotalvalue = currenttotalvalue.toFixed(1)
                        totalModel_id.model.set( i,{roomcurr_text: String(currenttotalvalue)})
                        break;

                    case 3:    //温度
                        totalModel_id.model.set( i,{roomtemp_text: arrayData[0]})
                        break;
                    default:

                        break;
                    }

                }
            }
        }


    }

    function mainInterslot(userindexS) {//跳转到信息显示数据
        mode_DeviceInfo.visible = true;
        mode_DeviceInfo.stack = stack;
        stack.push(mode_DeviceInfo)
        mainWindow.sendDeviceInfoSignal(totalModel_id.model.get(userindexS).mac_text);


    }
    function modifModleData(macstr){
        var idlont = sqlitefun_obj.findsqldataID("devdata","dev_mac",macstr)
        var qmlroomnum = sqlitefun_obj.findsqldata("devdata","dev_name",Number(idlont));
        if(idlont === "FAIL" || idlont === "NONE") return;
        if(qmlroomnum === "FAIL" || qmlroomnum === "NONE") return;
        if(qmlroomnum.length > 5)
        {
         qmlroomnum = qmlroomnum.substring(0,6) + "...";
        }
        for(var i = 0; i < totalModel_id.count; i ++)//查询设备传输数据
        {
            if(totalModel_id.model.get(i).mac_text === macstr)
            {
                totalModel_id.model.set(i,{room_text: qmlroomnum})
            }

        }
    }



    DeviceInfo{
        id:mode_DeviceInfo
        visible: false
    }


 //   CppSingletoQml{
 //       id:cppSingletoQml
  //      visible: false
 //   }
function loaderquickcontrol(){
    var quickcontrolid = sqlitefun_obj.traversedata("panlist","id");
       if(quickcontrolid === "" || quickcontrolid === "NONE" || quickcontrolid === "FAIL")return;
    var quickcontrolidbuf = quickcontrolid.split("&");
    var sqltaskname=""
    var sqltime = ""
    for(var i = 0; i < quickcontrolidbuf.length; i ++)
    {
        sqltaskname = sqlitefun_obj.findsqldata("panlist","panname",Number(quickcontrolidbuf[i]))
         quickControl_id.creatquicModelShow(sqltaskname,"0")//创建
    }
}

    function loadertimetskdata(){

     var timeid = sqlitefun_obj.traversedata("timingtaskdelay","id");
        if(timeid === "" || timeid === "NONE" || timeid === "FAIL")return;
     var timeidbuf = timeid.split("&");
     var sqltaskname=""
     var sqltime = ""
     for(var i = 0; i < timeidbuf.length; i ++)
     {
         sqltaskname = sqlitefun_obj.findsqldata("timingtaskdelay","tasknamed",Number(timeidbuf[i]))
         sqltime = sqlitefun_obj.findsqldata("timingtaskdelay","timed",Number(timeidbuf[i]))
           mainWindow.hcreattimetasklisth(sqltaskname,sqltime,i + 1,1);//创建

     }

    }

    function alarmmessage(alarmname,Placestr,alarmvalue,alarmtime){

        creatAlarmList_id.creatalarmlistShow(alarmname,Placestr,alarmvalue,alarmtime)//创建

    }
    function cppdatathroughqmltodev(macstr,regaddr,cmd,regnum,value,token){//设备上线显示设备，更新数据

             user_tcpserver_qmlobj.serversocket_Send_WriteData(macstr,regaddr,cmd,regnum,value,token);
        }
    function deletimetaskslot(index1) {//删除时间
        var i
        var sqlid = ""
        sqlid = sqlitefun_obj.findsqldataID("timingtask","taskname",mode_mtimetaskp5.model.get(index1).timetaskname_text)
        if(sqlid === "FAIL" || sqlid === "NONE") return;
        mode_mtimetaskp5.model.remove(index1,1);
        sqlitefun_obj.deleterow("timingtask",Number(sqlid));
        for(i =  index1 + 2; i <= mode_mtimetaskp5.model.count + 1; i ++)
        {
            mode_mtimetaskp5.model.get(i-2).timetaskseri_text = String(i -1)

        }
        sqlitefun_obj.deleterow("timingtaskdelay",Number(sqlid));


    }


    function editimetaskslot(index1,tasktimename) {//编辑时间预案
        var AddTimeTaskshow = Qt.createComponent("AddTimeTask.qml").createObject(mainWindow);//建立父类与子类关系
        AddTimeTaskshow.show()//显示子对话框
        mainWindow.sendaddtimetaskSignal(1,index1 + 1,tasktimename);//发送信号将动态复选框添加

    }
    function hcreattimetasklisth(taskname,delaytime,idcode,cmdkind){//创建/更新预案列表

        if(cmdkind === 1)//创建
        {
            mode_mtimetaskp5.creattimeModelShow(String(mode_mtimetaskp5.count + 1),taskname,delaytime);
        }
        else//更新
        {
            mode_mtimetaskp5.model.set( idcode,{timetaskname_text: taskname})
            mode_mtimetaskp5.model.set( idcode,{timetasktime_text: delaytime})
        }

    }
    function deletalarmlistfun(index1){//
        var i
        var sqlid = ""
        // sqlid = sqlitefun_obj.findsqldataID("alarmthreshold","alarmdevname",mode_alarmvalueListp3.model.get(index1).alarmdevname_text)
        creatAlarmList_id.model.remove(index1,1);
        //  sqlitefun_obj.deleterow("alarmthreshold",Number(sqlid));

    }
}
