import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4
Page {
    id: cpptoqmlid
    Component.onCompleted:{
        user_tcpserver_qmlobj.cppsigneltoqmlhandle.connect(cppdatathroughqmltodev);
    }
   function cppdatathroughqmltodev(macstr,regaddr,cmd,regnum,value,token){//设备上线显示设备，更新数据

            user_tcpserver_qmlobj.serversocket_Send_WriteData(macstr,regaddr,cmd,regnum,value,token);
       }

}

