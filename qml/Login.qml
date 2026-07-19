import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
Window {

    id:loginWindow
    title: qsTr("登录")

    visible: true
    flags: Qt.Window | Qt.FramelessWindowHint //去标题栏
    property StackView stack: null
    property var mainInterfaceWindow: null
    width: 436
    height: 350
     signal sendformlogintotimetask();
     signal sendformlogintoquickcontrol();//
      signal sendlogaccout(var account);//

    function openMainInterface() {
        if (mainInterfaceWindow) {
            mainInterfaceWindow.show()
            loginWindow.hide()
            return
        }

        const component = Qt.createComponent("MainInterface.qml")
        if (component.status !== Component.Ready) {
            console.error("Failed to create MainInterface:", component.errorString())
            return
        }

        mainInterfaceWindow = component.createObject(null, { "transientParent": null })
        if (!mainInterfaceWindow) {
            console.error("Failed to instantiate MainInterface")
            return
        }

        mainInterfaceWindow.show()
        loginWindow.sendformlogintotimetask()
        loginWindow.sendformlogintoquickcontrol()
        loginWindow.hide()
    }

    Rectangle {
      id:clorolde
                  anchors.fill: parent
      border.color: "#999999" //设置边框的颜色
      border.width: 1       //设置边框的大小
    Rectangle {
        id: rectangle
        width: 436
        height: 97
        color: "#2a5298"

        Text {
            id: device_name_s1
            anchors.left:parent.left
            anchors.leftMargin: 96
            anchors.top:parent.top
            anchors.topMargin: 49
            color: "#f3f7ff"
            text: qsTr("电力优化管控系统")
            font.bold: true
            font.family: "宋体"
            font.pointSize: 22
        }

        ToolButton {
            id: loginbtn
            anchors.left:parent.left
            anchors.leftMargin: 402
            anchors.top:parent.top
            anchors.topMargin: 10
            width: 28
            height: 22
            text: qsTr("Tool Button")
            icon.source: "qrc:/icon/close.png"
            onClicked: {
                Qt.quit()
            }
        }


    }

    Image {
        id: image
        anchors.left:parent.left
        anchors.leftMargin: 46
        anchors.top:parent.top
        anchors.topMargin: 134
        width: 34
        height: 20
        source: "qrc:/icon/login_account.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: image1
        anchors.left:parent.left
        anchors.leftMargin: 46
        anchors.top:parent.top
        anchors.topMargin: 183
        width: 34
        height: 20
        source: "qrc:/icon/login_password.png"
        fillMode: Image.PreserveAspectFit
    }

    CheckBox {
        id: autopass
        anchors.left:parent.left
        anchors.leftMargin: 55
        anchors.top:parent.top
        anchors.topMargin: 226
        width: 69
        height: 34
        text: qsTr("记住密码")
        onClicked: {
            var loagid = sqlitefun_obj.findsqldataID("userlog","account",account_edit.text)
            var passautoflag = "";
            var logautoflag = "";
            if(loagid === "FAIL" || loagid === "NONE" || loagid === "")
            {
                if(autopass.checked)
                {
                  passautoflag = "1";
                }
                if(passautolog.checked)
                {
                  logautoflag = "1";
                }
             sqlitefun_obj.nOIDinsterlogindata(passautoflag,logautoflag,password_edit.text,account_edit.text)
            }
            else
            {
                if(autopass.checked)
                {
                  passautoflag = "1";
                }

                if(passautolog.checked)
                {
                  logautoflag = "1";
                }
                sqlitefun_obj.updaterowdata("userlog","logauto",logautoflag,Number(loagid))
                sqlitefun_obj.updaterowdata("userlog","password",password_edit.text,Number(loagid))
                sqlitefun_obj.updaterowdata("userlog","account",account_edit.text,Number(loagid))
            }
        }
    }

    CheckBox {
        id: passautolog
        anchors.left:parent.left
        anchors.leftMargin: 282
        anchors.top:parent.top
        anchors.topMargin: 227
        width: 69
        height: 34
        text: qsTr("自动登录")
        onClicked: {
            var loagid = sqlitefun_obj.findsqldataID("userlog","account",account_edit.text)
            var passautoflag = "";
            var logautoflag = "";
            if(loagid === "FAIL" || loagid === "NONE" || loagid === "")
            {
                if(autopass.checked)
                {
                  passautoflag = "1";
                }
                if(passautolog.checked)
                {
                  logautoflag = "1";
                }
             sqlitefun_obj.nOIDinsterlogindata(passautoflag,logautoflag,password_edit.text,account_edit.text)
            }
            else
            {
                if(autopass.checked)
                {
                  passautoflag = "1";
                }

                if(passautolog.checked)
                {
                  logautoflag = "1";
                }

             //   sqlitefun_obj.updaterowdata("userlog","passauto",passautoflag,Number(loagid))

                sqlitefun_obj.updaterowdata("userlog","logauto",logautoflag,Number(loagid))
                sqlitefun_obj.updaterowdata("userlog","password",password_edit.text,Number(loagid))
                sqlitefun_obj.updaterowdata("userlog","account",account_edit.text,Number(loagid))
            }
        }
    }
    Timer{
        id:countbowm
        repeat: true
        interval: 3000
        triggeredOnStart: true
        running:true
        onTriggered: {
            var logautoid = sqlitefun_obj.findsqldataID("userlog","account",account_edit.text)
            var  passwordl = sqlitefun_obj.findsqldata("userlog","password",Number(logautoid))
            var passauto = sqlitefun_obj.findsqldata("userlog","passauto",Number(logautoid))
            var logauto = sqlitefun_obj.findsqldata("userlog","logauto",Number(logautoid))
            if(passauto === "1")
            {
             autopass.checked = true
            }
            if(logauto === "1")
            {
             passautolog.checked = true
            }
            if(loginitflag.text == "initstate")
            {
             loginitflag.text = "initok";
            }
            else
            {

                countbowm.running = false
                    if(passwordl === password_edit.text && logauto === "1")
                    {
                        for(var ijm1 = 0; ijm1 < 50; ijm1 ++)
                        {
                           sqlitefun_obj.deleterow("quickcontrol",ijm1);
                        }
                        var lineid = sqlitefun_obj.traversedata("devdata","id")
                        var lineidbuf = lineid.split("&")
                        for(var linne_i = 0; linne_i < lineidbuf.length; linne_i ++)
                        {
                              sqlitefun_obj.updaterowdata("devdata","dev_linestate","0",Number(lineidbuf[linne_i]))
                        }
                        user_tcpserver_qmlobj.tcpServerListen()
                       loginWindow.openMainInterface()
                    }
            }

        }

    }
    Button {
        id: loginSubmitButton
        anchors.left:parent.left
        anchors.leftMargin: 55
        anchors.top:parent.top
        anchors.topMargin: 266
        width: 297
        height: 36
        text: "登录"
        background: Rectangle {
            implicitWidth: 297
            implicitHeight: 30
            color: "#568bfb"
            border.width: loginSubmitButton.down ? 5 : 3
            border.color: (loginSubmitButton.hovered || loginSubmitButton.down)
                          ? "green" : "#568bfb"
        }

         onClicked: {

             var loagidtotall = sqlitefun_obj.traversedata("userlog","id")
             var loagidtotalbufl = loagidtotall.split('&')
             var accountl = ""
             var passwordl = ""
             countbowm.running = false

             for(var iii = 0; iii < loagidtotalbufl.length; iii ++)
             {
                accountl = sqlitefun_obj.findsqldata("userlog","account",Number(loagidtotalbufl[iii]))
                passwordl = sqlitefun_obj.findsqldata("userlog","password",Number(loagidtotalbufl[iii]))
                 if(accountl === account_edit.text && passwordl === password_edit.text)
                 {
                     for(var ijm1 = 0; ijm1 < 50; ijm1 ++)
                     {
                        sqlitefun_obj.deleterow("quickcontrol",ijm1);
                     }
                     var lineid = sqlitefun_obj.traversedata("devdata","id")
                     var lineidbuf = lineid.split("&")
                     for(var linne_i = 0; linne_i < lineidbuf.length; linne_i ++)
                     {
                           sqlitefun_obj.updaterowdata("devdata","dev_linestate","0",Number(lineidbuf[linne_i]))
                     }
                     user_tcpserver_qmlobj.tcpServerListen()
                        loginWindow.openMainInterface()
                 }
             }
             addloginMsg1.openMsg()
             return;

         }
    }

    Text {
        id: element2
        anchors.left:parent.left
        anchors.leftMargin: 53
        anchors.top:parent.top
        anchors.topMargin: 147
        width: 299
        height: 17
        color: "#b9b9b9"
        text: qsTr("_________________________________________________")
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 12
    }

    Text {
        id: element3
        anchors.left:parent.left
        anchors.leftMargin: 55
        anchors.top:parent.top
        anchors.topMargin: 197
        width: 299
        height: 17
        color: "#b9b9b9"
        text: qsTr("_________________________________________________")
        font.pixelSize: 12
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignLeft
    }

    TextEdit {
        id: account_edit
        anchors.left:parent.left
        anchors.leftMargin: 80
        anchors.top:parent.top
        anchors.topMargin: 137
        width: 199
        height: 20
        text: qsTr("admin")
        selectByMouse: true
        font.pixelSize: 15
    }

    TextInput {
        id: password_edit
        anchors.left:parent.left
        anchors.leftMargin: 80
        anchors.top:parent.top
        anchors.topMargin: 187
        width: 199
        height: 20
        selectByMouse: true
        text: qsTr("admin")
        font.pixelSize: 15
        echoMode: TextInput.PasswordEchoOnEdit
    }

    Text {
        id: loginitflag
        x: 0
        y: 97
        color: "#f3f7ff"
        text: qsTr("initstate")
        font.pixelSize: 1
    }
    }

    MsgDialog {
        id: addloginMsg1
        tipText: qsTr("账户名或密码不正确")
    }
}

