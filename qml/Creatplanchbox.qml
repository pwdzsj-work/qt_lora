import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    Component.onCompleted: {
        listModel.append({"name":"Bill",
                             "cbmode":[{"nText":"电灯","nCheck": true},
                             {"nText":"电视", "nCheck": false}]})
        listModel.append({"name":"aYgg",
                             "cbmode":[{"nText":"电灯","nCheck": true},
                             {"nText":"电视", "nCheck": false},
                             {"nText":"大门", "nCheck": true}]})
    }

    Component{     //代理
        id:delegate
        Item{

            id:wrapper;
            width:500;
            height:40
            Row{
                x:5;
                y:5;
                spacing: 10
                Text{
                    color: "#242424"
                    width: 63
                    height: 33
                    font {family: "黑体"; pixelSize: 18;}//bold:true;加粗
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text:name
                }
                RectangleCheckbox{
                    cbmodel:cbmode
                }
            }
        }
    }
    Component{   //高亮条
        id:highlight
        Rectangle{color:"lightsteelblue";radius:5}
    }
    ListView{  //视图
        width:parent.width;
        height:parent.height
        delegate:delegate  //关联代理
        highlight:highlight  //关联高亮条
        focus:true  //可以获得焦点，这样就可以响应键盘了
        model: ListModel{  //数据模型
            id:listModel

        }
    }

}
