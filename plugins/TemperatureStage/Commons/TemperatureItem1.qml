// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import UM 1.3 as UM
import Cura 1.1 as Cura

// We show a nice overlay on the 3D viewer when the current output device has no monitor view

Rectangle{
        id: container
        width: 80
        height: 240

        property string text: "Button"
        property string number: ""
        property string state: "待定"
        property double t_bottom: 0.0
        property double t_top: 0.0
        signal clicked()
        signal inputTemp(string content)      //qml文件传递参数的方式
        signal inValidator()
        Text
            {
                id: title
                text: container.text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                width: contentWidth
                anchors{
                    top: parent.top
                    topMargin: 5
                    left: parent.left
                    leftMargin: 5
                }
            }

            Text
            {
                id: labelHJ
                text: "实时温度"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                width: contentWidth
                anchors{
                    top: title.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
            }


            Rectangle
            {
                id: rectHJSS
                color: UM.Theme.getColor("main_background")
                width: 60
                height:30
                anchors{
                    top: labelHJ.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }

                Label
                {
                    id: labelHJSS
                    text: container.number
                    font: UM.Theme.getFont("medium")
                    color: UM.Theme.getColor("machine_selector_printer_icon")
                    width: contentWidth
                    anchors{
                        centerIn: parent
                    }
                }
            }

            Text
            {
                id: labelHJS
                text: "设置温度"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                width: contentWidth
                anchors{
                    top: rectHJSS.bottom
                    topMargin: 15
                    horizontalCenter: parent.horizontalCenter
                }
            }



            TextField {
                id: textField1
                anchors{
                    top: labelHJS.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                 }
                 style: UM.Theme.styles.text_field
                 width: 60
                 height: 30
                 //validator: DoubleValidator {bottom: container.t_bottom; top: container.t_top;}
                 //focus: true
                 //placeholderText: qsTr("请输入温度")
                 onEditingFinished:
                {
                    var text = textField1.text;
                    if(text != '') {
                        if( parseFloat(text) < t_bottom || parseFloat(text) >t_top) {
                            container.inValidator()
                        }else {
                            container.inputTemp(text)
                        }

                    }
                }
             }


            CommonButton{
                id:button
                text:container.state
                anchors{
                    top: textField1.bottom
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                 }
                width: 60
                height: 30
                onClicked: container.clicked()
             }

}




