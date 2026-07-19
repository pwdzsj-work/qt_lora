import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    id: mainWindow
    visible: true
    width: 1200
    height: 800
    title: qsTr("电力优化管控系统")
    property int i :0
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
        width: 1199
        height: 83
        color: "#2a5298"
    }
    MouseArea { //为窗口添加鼠标事件
        width: 1199
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
            mainWindow.setX(mainWindow.x+delta.x)
            mainWindow.setY(mainWindow.y+delta.y)
        }

        Text {
            id: element
            anchors.left:parent.left
            anchors.leftMargin: 24
            anchors.top:parent.top
            anchors.topMargin: 26
            width: 257
            height: 36
            color: "#f2efef"
            text: qsTr("电力优化管控系统")
            font.bold: true
            font.pixelSize: 30
        }
        MouseArea { //为窗口添加鼠标事件
            id:mouseid
            anchors.left:parent.left
            anchors.leftMargin: 360
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
            anchors.leftMargin: 493
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
            anchors.leftMargin: 326
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
            anchors.leftMargin: 457
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
            anchors.left:parent.left
            anchors.leftMargin: 1147
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
            id: btnMainSmall
            anchors.left:parent.left
            anchors.leftMargin: 1100
            anchors.top:parent.top
            anchors.topMargin: 28
            width: 27
            height: 25
            text: ""
            display: AbstractButton.IconOnly
            icon.source: "qrc:/icon/narrow.png"
            icon.width: 24
            icon.height: 24
            icon.color: "transparent"
            padding: 0
            onClicked: {
                mainWindow.showMinimized()
            }

        }

        Text {
            id: element6
            anchors.left:parent.left
            anchors.leftMargin: 950
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
        Page {
            id: mainView
            property StackView stack: null
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
                        anchors.left:parent.left
                        anchors.leftMargin: 9
                        anchors.top:parent.top
                        anchors.topMargin: 94
                        width: 271
                        height: 48
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
                        anchors.left:parent.left
                        anchors.leftMargin: 8
                        anchors.top:parent.top
                        anchors.topMargin: 461
                        width: 271
                        height: 44
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
                        anchors.left:parent.left
                        anchors.leftMargin: 8
                        anchors.top:parent.top
                        anchors.topMargin: 148
                        width: 271
                        height: 304
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
                        x: 8
                        y: 512
                        width: 271
                        height: 280
                        border.color: "#f3f7ff"
                        Rectangle {
                            id: rectangle6
                            x: 1
                            y: 2
                            width: 257
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
                            width: 257
                            height: 209
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
                        x: 285
                        y: 94
                        width: 583
                        height: 48
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
                        anchors.left:parent.left
                        anchors.leftMargin: 285
                        anchors.top:parent.top
                        anchors.topMargin: 148
                        width: 583
                        height: 644
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
                        anchors.left:parent.left
                        anchors.leftMargin: 879
                        anchors.top:parent.top
                        anchors.topMargin: 94
                        width: 313
                        height: 48
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
                        anchors.left:parent.left
                        anchors.leftMargin: 879
                        anchors.top:parent.top
                        anchors.topMargin: 148
                        width: 313
                        height: 644
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
