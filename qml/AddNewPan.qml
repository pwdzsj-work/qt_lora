import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
AdaptiveWindow {
    id: addnewpanWindow
    designWidth: 504
    designHeight: 500
    width: 504
    height: 500
    opacity: 1
    title: qsTr("电力优化管控系统")
    visible: false
    modality: Qt.ApplicationModal
    property int i :0
    flags: Qt.Window | Qt.FramelessWindowHint
    MouseArea { //为窗口添加鼠标事件
        width: 504
        height: 60
        acceptedButtons: Qt.LeftButton //只处理鼠标左键
        property point clickPos: "0,0"

        onPressed: { //接收鼠标按下事件
            clickPos  = Qt.point(mouse.x,mouse.y)
        }
        onPositionChanged: { //鼠标按下后改变位置
            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)

            //如果mainwindow继承自QWidget,用setPos
            addnewpanWindow.setX(addnewpanWindow.x+delta.x)
            addnewpanWindow.setY(addnewpanWindow.y+delta.y)
        }
    }

    Rectangle {
        id:addnewidarm

        width: 504
        height: 500
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
                text: "新增预案"
                font.bold: true
                font.pointSize: 20
                anchors.centerIn: parent
            }
            ToolButton {
                id: addnewpan_bntclose
                anchors.top:parent.top
                anchors.topMargin: 15
                anchors.left:parent.left
                anchors.leftMargin: 470
                width: 29
                height: 28
                text: qsTr("2")
                icon.source: "qrc:/icon/close.png"
                icon.color: "transparent"
                display: AbstractButton.TextUnderIcon
                icon.width: 50
                icon.height: 32
                onClicked: {
                    addnewpanWindow.destroy();
                }
            } //去标题栏


        }

        Text {
            id: yamcpan
            anchors.top:parent.top
            anchors.topMargin: 95
            anchors.left:parent.left
            anchors.leftMargin: 50
            width: 98
            height: 31
            text: qsTr("预案名称")
            font.pixelSize: 23
        }

        TextField {
            id: intputlistnp
            anchors.top:parent.top
            anchors.topMargin: 95
            anchors.left:parent.left
            anchors.leftMargin: 165
            width: 268
            height: 31
            text: qsTr("请输入预案名称")
            font.capitalization: Font.MixedCase
            font.pointSize: 14
            selectByMouse: true
        }

        Text {
            id: elementdevlist
            anchors.top:parent.top
            anchors.topMargin: 148
            anchors.left:parent.left
            anchors.leftMargin: 50
            width: 110
            height: 29
            text: qsTr("电源通道")
            font.pixelSize: 23
        }
        Text {
            id: pankindope
            anchors.top:parent.top
            anchors.topMargin: 95
            anchors.left:parent.left
            anchors.leftMargin: 450
            width: 110
            height: 29
            text: pankindope_tex
            color:"#ffffff"
            font.pixelSize: 2
        }
        Text {
            id: modellistid
            anchors.top:parent.top
            anchors.topMargin: 95
            anchors.left:parent.left
            anchors.leftMargin: 451
            width: 110
            height: 29
            text: modellistid_tex
            color:"#ffffff"
            font.pixelSize: 2
        }
        Rectangle {
            id: rectangle1
            anchors.top:parent.top
            anchors.topMargin: 148
            anchors.left:parent.left
            anchors.leftMargin: 165
            width: 268
            height: 236
            color: "#ffffff"
            border.color: "#ebedf2"
            Rectangle {
                id: rectangle2
                width: 268
                height: 33
                color: "#f3f7ff"
                Text {
                    id: element3
                    width: 110
                    height: 29
                    text: qsTr("设备名称")
                    font.pixelSize: 21
                }
                Text {
                    id: element4
                    anchors.top:parent.top
                    anchors.topMargin: 2
                    anchors.left:parent.left
                    anchors.leftMargin: 170
                    width: 110
                    height: 29
                    text: qsTr("通道选择")
                    font.pixelSize: 21
                }
            }
            Rectangle {
                id: addnewrgdi
                anchors.top:parent.top
                anchors.topMargin: 35
                width: 268
                height: 201
                color: "#ffffff"
                border.color: "#ebedf2"
                Component{     //代理
                    id:delegate

                        Row{
                            x:8;
                          y:20;
                           spacing: 10
                            Text{
                                id: devnamepanu
                                    anchors.top:parent.top
                                    anchors.topMargin: 8
                                   width: 135
                                   height: 30
                                   text: name
                                   font.family: "宋体"
                                   font.pointSize: 16
                                   color:"#000000"
                            }
                            Text{
                                id: devmac
                               // anchors.left:devnamepanu.right
                               // anchors.leftMargin: 1
                                width: 1
                                height: 1
                                 text: mac_textp
                                font.family: "宋体"
                                font.pointSize: 1
                                color:"#f8f8ff"
                            }
                            RectangleCheckbox{
                                cbmodel:cbmode
                            }
                        }

                }
                ListView{  //视图
                    width:parent.width;
                    height:parent.height
                    delegate:delegate  //关联代理
                  //  highlight:highlight  //关联高亮条
                    focus:true  //可以获得焦点，这样就可以响应键盘了
                    model: ListModel{  //数据模型
                        id:listModel

                    }
                }


            }


        }
        Text {
            id: elementpantk
            anchors.top:parent.top
            anchors.topMargin: 400
            anchors.left:parent.left
            anchors.leftMargin: 50
            width: 139
            height: 29
            text: qsTr("开关动作延时")
            font.pixelSize: 23
        }

        TextField {
            id: pandelaysinput
            anchors.top:parent.top
            anchors.topMargin: 400
            anchors.left:parent.left
            anchors.leftMargin: 208
            width: 68
            height: 32
            text: qsTr("0")
            inputMask: "00"
            font.pixelSize: 24
            selectByMouse: true
        }

        Text {
            id: element5
            x: 296
            anchors.top:parent.top
            anchors.topMargin: 400
            anchors.left:parent.left
            anchors.leftMargin: 296
            width: 33
            height: 29
            text: qsTr("秒")
            font.pixelSize: 23
        }
        ToolButton {
            id: toolButtonpan1
            anchors.top:parent.top
            anchors.topMargin: 430
            anchors.left:parent.left
            anchors.leftMargin: 314
            width: 60
            height: 35
            text: qsTr("1")
            icon.source:   "qrc:/icon/cancle_D.png"
            icon.color: "transparent"
            icon.height: 35
            icon.width: 66
            display: AbstractButton.IconOnly
            onClicked: {
                 addnewpanWindow.destroy();
            }
        }
        ToolButton {
            id: toolButtonpan2
            anchors.top:parent.top
            anchors.topMargin: 430
            anchors.left:parent.left
            anchors.leftMargin: 383
            width: 60
            height: 35
            text: qsTr("2")
            icon.source: "qrc:/icon/ok_E.png"
            icon.color: "transparent"
            icon.height: 35
            icon.width: 66
            display: AbstractButton.IconOnly
            onClicked: {
                saveplandatatoconfig();


            }
        }
    }
    Component.onCompleted: {
        deviceconfigpage.sendaddpanSignal.connect(creatpalnchildm);//deviceconfigpageplan是本qml的父类
    }

    //创建新增界面的子模块
    function creatpalnchildm(planenflag,planid,editorcreat,panname){
        var alldev_linestate = sqlitefun_obj.traversedata("devdata","dev_linestate")
        var alldev_linestatebuf = alldev_linestate.split("&")
        var alldevmacback = sqlitefun_obj.traversedata("devdata","dev_mac")
        var alldevmacbackbuf = alldevmacback.split("&");
        var alldevmac = ""
        var allchtotalback = sqlitefun_obj.traversedata("devdata","dev_chname")
        var allchtotalbackbuf = allchtotalback.split("&");
        var allchtotal = ""
        var devdataid
        var devname
        var alldevmacbuf
        var editalldevmac
        var editalldevmacbuf
        var allchtotalbuf
        var allchtotalpbuf
        var editmacid
        var dev_chnamebuf
        var dev_devchnamebuf
        var panchchose_p//选中通道
        var panchchose_pbuf
        var panchchose_ppbuf
        var pandevchose_p//选中设备
        var pandevchose_pbuf
        var pandevchose_ppbuf
        var cin = 0;
        modellistid.text = String(planid);
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
            var plannamedtid = sqlitefun_obj.findsqldataID("panlist","panname",panname)
            pankindope.text = plannamedtid
            intputlistnp.text = sqlitefun_obj.findsqldata("panlist","panname",Number(plannamedtid));
            pandelaysinput.text = sqlitefun_obj.findsqldata("panlist","swworkdelay",Number(plannamedtid));
            panchchose_p = sqlitefun_obj.findsqldata("panlist","panchchose",Number(plannamedtid));
            pandevchose_p = sqlitefun_obj.findsqldata("panlist","pandevname",Number(plannamedtid));
            editalldevmac =  sqlitefun_obj.findsqldata("panlist","pandevmac",Number(plannamedtid));
            if(panchchose_p !== "FAIL")
            {
                panchchose_pbuf = panchchose_p.split("&");//设备通道buf
            }
            if(pandevchose_p !== "FAIL")
            {
                pandevchose_pbuf = pandevchose_p.split("&");//设备通道buf
            }
            if(editalldevmac !== "FAIL")
            {
                editalldevmacbuf = editalldevmac.split("&");//设备mac
            }
            for(var ji = 0; ji < editalldevmacbuf.length; ji ++)
            {
                if(editalldevmacbuf[ji] === "")continue;
                devdataid = sqlitefun_obj.findsqldataID("devdata","dev_mac",editalldevmacbuf[ji])
                allchtotal = sqlitefun_obj.findsqldata("devdata","dev_chname",Number(devdataid));
                allchtotalbuf = allchtotal.split("#");//设备通道名字
                devname = sqlitefun_obj.findsqldata("devdata","dev_name",Number(devdataid));
                for(var i = 0;i < allchtotalbuf.length; i ++)
                {
                    panchchose_ppbuf = panchchose_pbuf[ji].split("#");
                    cin = 1;
                    for(var j = 0; j < panchchose_ppbuf.length;j ++)
                    {

                        if(allchtotalbuf[i] === panchchose_ppbuf[j])
                        {
                            if(i === 0 && j === 0)
                            {
                               listModel.append({name:devname,mac_textp :editalldevmacbuf[ji], cbmode:[{nText:allchtotalbuf[0],nCheck: true}]})
                            }
                            else
                            {
                            listModel.get(ji).cbmode.append({nText: allchtotalbuf[i],nCheck : true})
                            }
                            cin = 0;
                        }
                        else
                        {
                            if(i === 0 && j === 0)
                            {
                               listModel.append({name:devname,mac_textp :editalldevmacbuf[ji],cbmode:[{nText:allchtotalbuf[0],nCheck: false}]})
                                 cin = 0;
                            }


                        }

                    }
                    if(cin === 1)
                    {
                         listModel.get(ji).cbmode.append({nText: allchtotalbuf[i],nCheck : false})

                    }

                }
            }
        }
        else
        {//创建

            pankindope.text = "NONE"
            if(alldevmac !== "FAIL")
            {
                alldevmacbuf = alldevmac.split("&");//设备名字
            }
            if(allchtotal !== "FAIL")
            {
                dev_chnamebuf = allchtotal.split("&");//设备通道名字
            }


            for(var m = 0; m < alldevmacbuf.length; m ++)
            {
                devdataid = sqlitefun_obj.findsqldataID("devdata","dev_mac",alldevmacbuf[m])
                devname = sqlitefun_obj.findsqldata("devdata","dev_name",Number(devdataid));
                dev_devchnamebuf = dev_chnamebuf[m].split("#");
                listModel.append({name:devname,mac_textp :alldevmacbuf[m],cbmode:[{nText:dev_devchnamebuf[0],nCheck: false}]})
                for(var n = 1; n < dev_devchnamebuf.length; n ++)
                {
                   listModel.get(m).cbmode.append({nText:dev_devchnamebuf[n],nCheck: false})

                }
            }

        }

    }

    //保存数据到数据库一种是创建一种是修改
    function saveplandatatoconfig(){
        var flag = 0
        var getdevname = ""//获取设备名称
        var getdevnamebuf
        var getdevmac = ""//获取设备名称
        var getdevmacbuf
        var gerdevchen=[]//勾选的通道
        var datafalseflag = 0
        var sqlpandevname = ""
        var sqlpanchchose = ""
        var sqlpanmac = ""
        for(var i = 0; i < listModel.count; i ++)//搜索有多少行获取数据
        {
            getdevname += listModel.get(i).name//获取设备名称
            getdevmac += listModel.get(i).mac_textp//获取设备mac
            gerdevchen[i] = ""
            for(var j = 0; j < listModel.get(i).cbmode.count; j ++)
            {
                if(listModel.get(i).cbmode.get(j).nCheck===true)//数据为真
                {
                    gerdevchen[i] += listModel.get(i).cbmode.get(j).nText;
                    gerdevchen[i] += "#"
                    datafalseflag = 1
                    flag = 1
                }
            }
            if(flag === 1)
            {
                gerdevchen[i] = gerdevchen[i].substring(0, gerdevchen[i].lastIndexOf('#'));
            }
            var getpanlistid = sqlitefun_obj.findsqldataID("panlist","panname",intputlistnp.text)
            if(i !== listModel.count - 1)
            {
              getdevname += "#"
              getdevmac += "#"
            }
        }

        if(datafalseflag === 0)
        {
            addnewpanmMsg1.tipText = "配置参数不正确"
            addnewpanmMsg1.openMsg()
            return;
        }
        if(pankindope.text !== "NONE")
        {
            deviceconfigpage.singletoMainQuick(intputlistnp.text,pandelaysinput.text,pankindope.text,"edit");
        }
        else
        {
            deviceconfigpage.singletoMainQuick(intputlistnp.text,pandelaysinput.text,pankindope.text,"creat");
        }
        getdevnamebuf = getdevname.split("#");
        getdevmacbuf = getdevmac.split("#");
        if( pankindope.text !== "NONE")//为真就是修改
        {    for(var u = 0; u < gerdevchen.length; u ++)
            {
                if(gerdevchen[u] === "")continue;
                    sqlpandevname += getdevnamebuf[u]

                    if(u !== getdevnamebuf.length - 1)
                    {
                        sqlpandevname += "&"
                    }
                    sqlpanchchose += gerdevchen[u]
                    if(u !== getdevnamebuf.length - 1)
                    {
                        sqlpanchchose += "&"
                    }
            }
            for(var ut = 0; ut < gerdevchen.length; ut ++)
             {
                 if(gerdevchen[ut] === "")continue;
                sqlpanmac += getdevmacbuf[ut]
                if(u !== getdevmacbuf.length - 1)
                {
                    sqlpanmac += "&"
                }

            }

            if(pankindope.text === "NONE")
            {
                deviceconfigpage.hcreatnewplanlisth(intputlistnp.text,pandelaysinput.text,Number(getpanlistid)-1,0);
                sqlitefun_obj.updaterowdata("panlist","panname",intputlistnp.text,Number(getpanlistid));
                sqlitefun_obj.updaterowdata("panlist","pandevname",sqlpandevname,Number(getpanlistid));
                sqlitefun_obj.updaterowdata("panlist","pandevmac",sqlpanmac,Number(getpanlistid));
                sqlitefun_obj.updaterowdata("panlist","panchchose",sqlpanchchose,Number(getpanlistid));
                sqlitefun_obj.updaterowdata("panlist","swworkdelay",pandelaysinput.text,Number(getpanlistid));
            }
            else
            {
                deviceconfigpage.hcreatnewplanlisth(intputlistnp.text,pandelaysinput.text,Number(modellistid.text)-1,0);
                sqlitefun_obj.updaterowdata("panlist","panname",intputlistnp.text,Number(pankindope.text));
                sqlitefun_obj.updaterowdata("panlist","pandevname",sqlpandevname,Number(pankindope.text));
                sqlitefun_obj.updaterowdata("panlist","pandevmac",sqlpanmac,Number(getpanlistid));
                sqlitefun_obj.updaterowdata("panlist","panchchose",sqlpanchchose,Number(pankindope.text));
                sqlitefun_obj.updaterowdata("panlist","swworkdelay",pandelaysinput.text,Number(pankindope.text));
            }
        }
        else
        {
            var getplannamestr = sqlitefun_obj.traversedata("panlist","panname")
          var getplannamestrbuf = getplannamestr.split("&");//设备名字
          var chognming = 0;
          for(var tt = 0; tt < getplannamestrbuf.length; tt ++)
          {
              if(getplannamestrbuf[tt] === intputlistnp.text)
              {
              chognming = 1;
              }

          }
          if(chognming === 1)//重名
          {
              addnewpanmMsg1.tipText = "预案名称已存在"
              addnewpanmMsg1.openMsg()
              return;
          }
            for(var ur = 0; ur < gerdevchen.length; ur ++)
            {
                   if(gerdevchen[ur] === "")continue;
                    sqlpandevname += getdevnamebuf[ur]
                    if(ur !== getdevnamebuf.length - 1)
                    {
                        sqlpandevname += "&"
                    }
                    sqlpanchchose += gerdevchen[ur]
                    if(ur !== getdevnamebuf.length - 1)
                    {
                        sqlpanchchose += "&"
                    }
            }
            for(var utmac = 0; utmac < gerdevchen.length; utmac ++)
             {
               if(gerdevchen[utmac] === "")continue;
                sqlpanmac += getdevmacbuf[utmac]
                if(utmac !== getdevmacbuf.length - 1)
                {
                    sqlpanmac += "&"
                }

            }
            sqlitefun_obj.nOIDinsterpandata(intputlistnp.text,sqlpandevname,sqlpanchchose,pandelaysinput.text,sqlpanmac);
            deviceconfigpage.hcreatnewplanlisth(intputlistnp.text,pandelaysinput.text,Number(pankindope.text),1);

        }


        addnewpanWindow.destroy();

    }

    MsgDialog {
        id: addnewpanmMsg1
        tipText: qsTr("QML  debugging is enabled. Only use this in a safe eenvironment.")
    }
}
