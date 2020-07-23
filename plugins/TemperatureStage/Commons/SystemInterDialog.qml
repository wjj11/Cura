// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4

import UM 1.1 as UM
import Cura 1.1 as Cura

Item
{

    signal openSysView()

    CommonButton{
        id:button
        text:"系统设置"
        width: 60
        height: 25
        onClicked:{
               popup.opened ? popup.close() : popup.open()
         }
    }

    Popup
    {
        id: popup

        y: -40
        x: -320
        width: 300
        height: 350

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent          //设置关闭方式

        opacity: opened ? 0.8 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
        padding: 0
        Rectangle
        {

            anchors.fill: parent
            //radius: 10
            color: "#888888"
            Text
            {
                id: title
                text: "系统设置登录"
                font: UM.Theme.getFont("large")
                color: "black"
                width: contentWidth
                anchors{
                    top: parent.top
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
            }


            TextField {
                id: textField1
                focus: true
                anchors{
                    top: parent.top
                    topMargin: 100
                    horizontalCenter: parent.horizontalCenter
                    }
                style: UM.Theme.styles.text_field
                width: 80
                height: 30
                placeholderText: qsTr("请输入密码")

            }


            Label
                {
                    id: interResult
                    font: UM.Theme.getFont("medium")
                    color: UM.Theme.getColor("machine_selector_printer_icon")
                    width: contentWidth
                    anchors{
                        top: textField1.bottom
                        topMargin: 40
                        horizontalCenter: parent.horizontalCenter
                    }
                }

            CommonButton
            {
                id: closeButton
                text: "登录"
                anchors{
                    bottom: parent.bottom
                    bottomMargin: 20
                    horizontalCenter: parent.horizontalCenter
                    }
                width: 60
                height:30
                onClicked:{
                     var obj = Cura.Temperature.temp.systemInter(textField1.text)      //向python文件的槽传递信息时带的参数
                     if(obj =="ok"){
                        popup.close()
                        openSysView()
                     }else {
                        interResult.text = obj
                     }

                }
            }

        }

    }


}
