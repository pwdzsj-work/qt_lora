import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls 1.4
Window {
    id: addnewareaWindow2
    width: 504
    height: 480
    opacity: 1
    title: qsTr("电力优化管控系统")
    signal esendconfigSignal();
    property int i :0

    function bridgeAreaConfig(){
                esendconfigSignal();
    }
    Component.onCompleted: {
            esendconfigSignal.connect(deviceConfig_eid.creatregionallist);//发送信号给AddNewArea.qml
    }
    DeviceConfig{
        id:deviceConfig_eid
        visible: false
    }

}

