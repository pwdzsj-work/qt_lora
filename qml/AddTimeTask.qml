import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

AdaptiveWindow {
    id: addtimetaskWindow
    designWidth: 480
    designHeight: 420
    width: 480
    height: 420
    opacity: 0.9
    title: qsTr("定时任务")
    modality: Qt.ApplicationModal
    property int i :0
    flags: Qt.Window | Qt.FramelessWindowHint
    MouseArea { //为窗口添加鼠标事件
        width: 480
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
            addtimetaskWindow.setX(addtimetaskWindow.x+delta.x)
            addtimetaskWindow.setY(addtimetaskWindow.y+delta.y)
        }
    }
    Rectangle {
        id:timetaskidarm
        width: 480
        height: 420
        border.color: "#999999" //设置边框的颜色
            border.width: 1       //设置边框的大小
    Rectangle {
        id: rectangle
        width: 480
        height: 41
        color: "#2a5298"
        Text{
            id:addnewarea_name
            width: 117
            height: 22
            color: "#fffff9"
            text: "定时任务"
            font.bold: true
            font.pointSize: 20
            anchors.centerIn: parent
        }
        ToolButton {
            id: addnewarea_bntclose
            anchors.top:parent.top
            anchors.topMargin: 8
            anchors.left:parent.left
            anchors.leftMargin: 450
            width: 29
            height: 28
            text: qsTr("2")
            icon.source: "qrc:/icon/close.png"
            icon.color: "transparent"
            display: AbstractButton.TextUnderIcon
            onClicked: {
               addtimetaskWindow.destroy();
            }

        } //去标题栏


    }

    Text {
        id: element
        anchors.top:parent.top
        anchors.topMargin: 56
        anchors.left:parent.left
        anchors.leftMargin: 38
        width: 110
        height: 32
        text: qsTr("任务名称")
        font.pixelSize: 25
    }

    TextField{               //用户名输入
        anchors.top:parent.top
        anchors.topMargin: 53
        anchors.left:parent.left
        anchors.leftMargin: 168
        id:timetaskname
        width:200
        height:34
        text: "早间体操"
        font.capitalization: Font.MixedCase
        font.pointSize: 14
        selectByMouse: true
    }
    Text {
        id: planoldnameid
        anchors.left:timetaskname.right
        anchors.leftMargin: 38
        width: 1
        height: 1
        text: planoldname
        font.pixelSize: 1
         color:"#f8f8ff"
    }

    Text {
        id: element1
        anchors.top:parent.top
        anchors.topMargin: 116
        anchors.left:parent.left
        anchors.leftMargin: 38
        width: 110
        height: 32
        text: qsTr("时间")
        font.pixelSize: 25
    }

    TextField {
        id: timetasktime
        anchors.top:parent.top
        anchors.topMargin: 113
        anchors.left:parent.left
        anchors.leftMargin: 168
        width: 200
        height: 34
        text: "08:00"
        inputMask: "00:00"
        font.capitalization: Font.MixedCase
        font.pointSize: 14
        selectByMouse: true
    }

    Text {
        id: element2
        anchors.top:parent.top
        anchors.topMargin: 174
        anchors.left:parent.left
        anchors.leftMargin: 38
        width: 110
        height: 32
        text: qsTr("频率")
        font.pixelSize: 25
    }

    ComboBox {
        id: comboBoxc
        anchors.top:parent.top
        anchors.topMargin: 169
        anchors.left:parent.left
        anchors.leftMargin: 168
        width: 200
        height: 40
        model: ListModel {
            ListElement { checkBoxetime_text: "周一"; uboolarltime: false }
            ListElement { checkBoxetime_text: "周二"; uboolarltime: false }
            ListElement { checkBoxetime_text: "周三"; uboolarltime: false }
            ListElement { checkBoxetime_text: "周四"; uboolarltime: false }
            ListElement { checkBoxetime_text: "周五"; uboolarltime: false }
            ListElement { checkBoxetime_text: "周六"; uboolarltime: false }
            ListElement { checkBoxetime_text: "周日"; uboolarltime: false }
        }
        delegate:ItemDelegate{
            id : comboxzdele
            Rectangle{
                id :comboxzdeleee
                width: 100
                height: 30
                color:"#f9ffed"
                CheckBox {
                    id: checkBoxetimetext
                    width: 200
                    height: 30
                    checked: uboolarltime
                    text:  checkBoxetime_text
                    onClicked: {
                        uboolarltime = checkBoxetimetext.checked
                    }
                }
            }
        }
    }

    CheckBox {
        id: checkBoxtimeen
        anchors.top:parent.top
        anchors.topMargin: 221
        anchors.left:parent.left
        anchors.leftMargin: 167
        width: 142
        height: 19
        text: qsTr("法定节假日不执行")
        checked: checktimeen
        onClicked: {
            checktimeen = checkBoxtimeen.checked
        }
    }

    Text {
        id: element3
        anchors.top:parent.top
        anchors.topMargin: 271
        anchors.left:parent.left
        anchors.leftMargin: 38
        width: 110
        height: 32
        text: qsTr("预案名称")
        font.pixelSize: 25
    }

    ComboBox {
        id: comboBoxtime
        anchors.top:parent.top
        anchors.topMargin: 271
        anchors.left:parent.left
        anchors.leftMargin: 168
        width: 200
        height: 40
        currentIndex: 1
        model: ListModel {

        }
        delegate:ItemDelegate{
            id : timeplanname
            Rectangle{
                id :timeplannamerec
                width: 100
                height: 30
                color:"#f9ffed"
                CheckBox {
                    id: checktimeplantext
                    width: 200
                    height: 30
                    checked: timeplacheck
                    text:  checktimeplan_text
                    onClicked: {
                        timeplacheck = checktimeplantext.checked
                    }
                }
            }
        }
    }
    Text {
        id: timekindope
        anchors.top:parent.top
        anchors.topMargin: 271
        anchors.left:parent.left
        anchors.leftMargin: 280
        width: 110
        height: 29
        text: timeindope_tex
        color:"#ffffff"
        font.pixelSize: 2
    }
    Text {
        id: modelistser
        anchors.top:parent.top
        anchors.topMargin: 271
        anchors.left:parent.left
        anchors.leftMargin: 281
        width: 110
        height: 29
        text: tmodelistser_tex
        color:"#ffffff"
        font.pixelSize: 2
    }
    Text {
        id: element4
        anchors.top:parent.top
        anchors.topMargin: 334
        anchors.left:parent.left
        anchors.leftMargin: 38
        width: 110
        height: 32
        text: qsTr("动作")
        font.pixelSize: 25
    }

    SwitchDelegate {
        id: switchDelegate
        anchors.top:parent.top
        anchors.topMargin: 334
        anchors.left:parent.left
        anchors.leftMargin: 168
        width: 97
        height: 33

        ColorAnimation {
            from: "white"
            to: "red"
            duration: 200
        }
        text: qsTr("关")
    }

    Text {
        id: element5
        anchors.top:parent.top
        anchors.topMargin: 343
        anchors.left:parent.left
        anchors.leftMargin: 260
        width: 19
        height: 16
        color: "#636465"
        text: qsTr("开")
        font.pixelSize: 14
    }

    ToolButton {
        id: toolButton
        anchors.top:parent.top
        anchors.topMargin: 365
        anchors.left:parent.left
        anchors.leftMargin: 310
        width: 60
        height: 35
        padding: 2
        font.pointSize: 0
        icon.source: "qrc:/icon/cancle_D.png"
        icon.color: "transparent"
        icon.height: 35
        icon.width: 66
        display: AbstractButton.TextUnderIcon
        onClicked: {
            addtimetaskWindow.destroy();
        }
    }

    ToolButton {
        id: toolButton1
        anchors.top:parent.top
        anchors.topMargin: 365
        anchors.left:parent.left
        anchors.leftMargin: 394
        width: 60
        height: 35
        padding: 2
        font.pointSize: 0
        icon.source: "qrc:/icon/ok_E.png"
        icon.color: "transparent"
        icon.height: 35
        icon.width: 66
        display: AbstractButton.IconOnly
        onClicked: {
            savtimetasktomaininter();

        }
    }
    }
    Component.onCompleted: {
        mainWindow.sendaddtimetaskSignal.connect(creattimetasknchild);//mainWindow是本qml的父类
    }
    function creattimetasknchild(planenflag,planid,timename){//创建子控件
        var totlaplanname = "";
        var totlaplannamebuf = "";
        var planname = "";
        var plannamebuf = "";
        var freastr = ""
        var freqstrbuf
        var fdjjrvalue
        var swstatestr
        var gudingfrebuf = ["周一","周二","周三","周四","周五","周六","周日"]
        var jdjd = 0
        modelistser.text = String(planid);
        if(planenflag)//编辑的时候使用
        {
            var timegtaskid = sqlitefun_obj.findsqldataID("timingtask","taskname",timename)
            timekindope.text = timegtaskid
            totlaplanname = sqlitefun_obj.traversedata("panlist","panname");

            timetaskname.text = sqlitefun_obj.findsqldata("timingtask","taskname",Number(timegtaskid));
            timetasktime.text = sqlitefun_obj.findsqldata("timingtask","time",Number(timegtaskid));
            freastr = sqlitefun_obj.findsqldata("timingtask","freq",Number(timegtaskid));
            fdjjrvalue = sqlitefun_obj.findsqldata("timingtask","statutorytimeen",Number(timegtaskid));
            planname = sqlitefun_obj.findsqldata("timingtask","planname",Number(timegtaskid));
            swstatestr = sqlitefun_obj.findsqldata("timingtask","swstate",Number(timegtaskid));

            if(fdjjrvalue === "1")
            {
                checkBoxtimeen.checked = true
            }
            else
            {
                checkBoxtimeen.checked = false
            }
            if(swstatestr === "1")
            {
                switchDelegate.checked = true
            }
            else
            {
                switchDelegate.checked = false
            }
            if(totlaplanname !== "FAIL")
            {
                totlaplannamebuf = totlaplanname.split("&");//选中频率
            }
            if(freastr !== "FAIL")
            {
                freqstrbuf = freastr.split("&");//选中频率
            }
            if(planname !== "FAIL")
            {
                plannamebuf = planname.split("&");//项目
            }
            for(var t = 0; t < 7; t ++)
            {
                jdjd = 0
                for(var gg = 0; gg < freqstrbuf.length; gg ++)
                {
                    if(gudingfrebuf[t] === freqstrbuf[gg])
                    {
                        jdjd = 1
                        comboBoxc.model.get(t).uboolarltime = true
                    }
                }

                if(jdjd === 0)
                {
                    comboBoxc.model.get(t).uboolarltime = false
                }
            }
            for(var rt = 0; rt < totlaplannamebuf.length; rt ++)
            {
                jdjd = 0
                for(var ie = 0; ie < plannamebuf.length; ie ++)
                {
                    if(totlaplannamebuf[rt] === plannamebuf[ie])
                    {
                        jdjd = 1
                        comboBoxtime.model.append({checktimeplan_text: totlaplannamebuf[rt],timeplacheck:true})
                    }

                }
                if(jdjd === 0)
                {
                        comboBoxtime.model.append({checktimeplan_text: totlaplannamebuf[rt],timeplacheck:false})
                }
            }
            planoldnameid.text = timetaskname.text
        }
        else
        {
            timekindope.text = "NONE"
            planname = sqlitefun_obj.traversedata("panlist","panname")
            if(planname !== "FAIL")
            {
                plannamebuf = planname.split("&");//获取新预案名称
            }
            for(var ig = 0;ig < plannamebuf.length; ig ++)
            {
                comboBoxtime.model.append({checktimeplan_text: plannamebuf[ig],timeplacheck :false})
            }
        }


    }
    function savtimetasktomaininter(){//保存数据
        var timetasktimestr = ""
        var timeplannametimestr = ""
        var cin = 0
        var checkBoxtimeenstr = "0"
        var switchDelegatestr = "0"
        var gettimetasklistid = sqlitefun_obj.findsqldataID("timingtask","taskname",planoldnameid.text)
        var planname = sqlitefun_obj.traversedata("panlist","panname")//获取预案名字
        var plannamebuf = "";
        var operkind = "";
        if(planname !== "FAIL")
        {
            plannamebuf = planname.split("&");//获取新预案名称
        }
        for(var j = 0; j < plannamebuf.length; j ++)
        {
            if(comboBoxtime.model.get(j).timeplacheck === true)
            {
                timeplannametimestr +=  comboBoxtime.model.get(j).checktimeplan_text;
                timeplannametimestr += "&"
                cin = 1
            }
        }
        if(cin === 1)
        {
            cin = 0;
            timeplannametimestr = timeplannametimestr.substring(0, timeplannametimestr.lastIndexOf('&'))
        }


        for(i = 0; i < 7; i ++)
        {
            if(comboBoxc.model.get(i).uboolarltime === true)
            {
                timetasktimestr +=  comboBoxc.model.get(i).checkBoxetime_text;
                timetasktimestr += "&"
                cin = 1
            }
        }
        if(cin === 1)
        {
            cin = 0;
            timetasktimestr = timetasktimestr.substring(0, timetasktimestr.lastIndexOf('&'))
        }

        if(timeplannametimestr === "" || timetasktimestr === ""){
            timetaskMsg.tipText = "配置参数不正确"
            timetaskMsg.openMsg()
            return;
        }

        if( timekindope.text !== "FAIL" && timekindope.text !== "NONE")//为真就是修改
        {
               operkind = "edit";
            if(checkBoxtimeen.checked === true)
            {
                checkBoxtimeenstr= "1"
            }
            if(switchDelegate.checked === true)
            {
                switchDelegatestr= "1"
            }

            if(timekindope.text === "NONE")
            {
                mainWindow.hcreattimetasklisth(timetaskname.text,timetasktime.text,Number(gettimetasklistid)-1,0);
                sqlitefun_obj.updaterowdata("timingtask","taskname",timetaskname.text,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","time",timetasktime.text,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","freq",timetasktimestr,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","statutorytimeen",checkBoxtimeenstr,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","planname",timeplannametimestr,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","swstate",switchDelegatestr,Number(gettimetasklistid));
            }
            else
            {
                mainWindow.hcreattimetasklisth(timetaskname.text,timetasktime.text,Number(modelistser.text)-1,0);
                sqlitefun_obj.updaterowdata("timingtask","taskname",timetaskname.text,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","time",timetasktime.text,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","freq",timetasktimestr,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","statutorytimeen",checkBoxtimeenstr,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","planname",timeplannametimestr,Number(gettimetasklistid));
                sqlitefun_obj.updaterowdata("timingtask","swstate",switchDelegatestr,Number(gettimetasklistid));
            }
        }
        else
        {//创建
            var gettimetasknamestr = sqlitefun_obj.traversedata("timingtask","taskname")
          var gettimetasknamestrbuf = gettimetasknamestr.split("&");//设备名字
          var chognming = 0;
          for(var tt = 0; tt < gettimetasknamestrbuf.length; tt ++)
          {
              if(gettimetasknamestrbuf[tt] === timetaskname.text)
              {
              chognming = 1;
              }

          }
          if(chognming === 1)//重名
          {
              timetaskMsg.tipText = "预案名称已存在"
              timetaskMsg.openMsg()
              return;
          }

            operkind = "creat";
            if(checkBoxtimeen.checked === true)
            {
                checkBoxtimeenstr= "1"
            }
            if(switchDelegate.checked === true)
            {
                switchDelegatestr= "1"
            }
            sqlitefun_obj.nOIDinstertimetaskdata(timetaskname.text,timetasktime.text,timetasktimestr,checkBoxtimeenstr,timeplannametimestr,switchDelegatestr);
            mainWindow.hcreattimetasklisth(timetaskname.text,timetasktime.text,Number(timekindope.text),1);

        }
        addtimetaskWindow.destroy();
        var weekstrqml = sqlitefun_obj.traversedata("timingtask","freq");//星期
        var timest2rqml = sqlitefun_obj.traversedata("timingtask","time");//时间
        var holiddaysqml = sqlitefun_obj.traversedata("timingtask","statutorytimeen");//法定节假日是否使能
        var swstateqml = sqlitefun_obj.traversedata("timingtask","swstate");//开关状态
        var plannameqml = sqlitefun_obj.traversedata("timingtask","planname");//预案名字
        user_tcpserver_qmlobj.timetasktotrigger(timetaskname.text,plannameqml,weekstrqml,timest2rqml,holiddaysqml,swstateqml,operkind,planoldnameid.text);
    }
    MsgDialog {
        id: timetaskMsg
        tipText: qsTr("QML  debugging is enabled. Only use this in a safe eenvironment.")
    }

}
