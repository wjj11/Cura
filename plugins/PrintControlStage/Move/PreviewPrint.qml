// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4

import UM 1.3 as UM
import Cura 1.1 as Cura

// We show a nice overlay on the 3D viewer when the current output device has no monitor view
Rectangle
{
    id: tempMain
    property int m_top : 25
    property int m_width : 50


   Label
       {
            id: title
            text: "预打印"
            font: UM.Theme.getFont("medium")
            color: UM.Theme.getColor("machine_selector_printer_icon")
            width: contentWidth
            anchors{
                top: parent.top
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }
        Label
        {
             id: labelBP
             text: "边长"
             font: UM.Theme.getFont("medium")
             color: UM.Theme.getColor("machine_selector_printer_icon")
             width: contentWidth
             anchors{
                 top: title.bottom
                 topMargin: 20
                 horizontalCenter: textField1.horizontalCenter
             }
         }



        TextField {
            id: textField1
            anchors{
                top: labelBP.bottom
                topMargin: 5
                left: parent.left
                leftMargin:15
             }
             style: UM.Theme.styles.text_field
             width: m_width
             height: m_top

         }


         Label{
            id: labelBPh
            text: "间隙"
            font: UM.Theme.getFont("medium")
            color: UM.Theme.getColor("machine_selector_printer_icon")
            width: contentWidth
            anchors{
                top: title.bottom
                topMargin: 20
                horizontalCenter: textField2.horizontalCenter
            }
        }

        TextField {
            id: textField2
            anchors{
                top: labelBPh.bottom
                topMargin: 5
                right: parent.right
                rightMargin:15
            }
             style: UM.Theme.styles.text_field
             width: m_width
             height: m_top

         }

         Label
            {
                id: labelZJ
                text: "层高"
                font: UM.Theme.getFont("medium")
                color: UM.Theme.getColor("machine_selector_printer_icon")
                width: contentWidth
                anchors{
                    top: textField2.bottom
                    topMargin: 10
                    horizontalCenter: textField3.horizontalCenter
                }
            }

         TextField {
                id: textField3
                anchors{
                    top: labelZJ.bottom
                    topMargin: 5
                    left: parent.left
                    leftMargin:15
                 }
                 style: UM.Theme.styles.text_field
                 width: m_width
                 height: m_top

             }


          Label
            {
                id: labelBZ
                text: "层数"
                font: UM.Theme.getFont("medium")
                color: UM.Theme.getColor("machine_selector_printer_icon")
                width: contentWidth
                anchors{
                    top: textField2.bottom
                    topMargin: 10
                    horizontalCenter: textField4.horizontalCenter
                }
            }

           TextField {
                id: textField4
                anchors{
                    top: labelBZ.bottom
                    topMargin: 5
                    right: parent.right
                    rightMargin:15
                 }
                 style: UM.Theme.styles.text_field
                 width: m_width
                 height: m_top

             }

         Label
            {
                id: labelSD
                text: "速度"
                font: UM.Theme.getFont("medium")
                color: UM.Theme.getColor("machine_selector_printer_icon")
                width: contentWidth
                anchors{
                    top: textField3.bottom
                    topMargin: 10
                    horizontalCenter: textField5.horizontalCenter
                }
            }

         TextField {
                id: textField5
                anchors{
                    top: labelSD.bottom
                    topMargin: 5
                    left: parent.left
                    leftMargin:15
                 }
                 style: UM.Theme.styles.text_field
                 width: m_width
                 height: m_top

             }


            Button{
                id:button
                text:"预打印"
                anchors{
                    top: textField5.bottom
                    topMargin: 15
                    horizontalCenter: parent.horizontalCenter
                 }
                style:ButtonStyle{ // 可以不要 style 直接 background
                    background:Rectangle{
                    implicitWidth:80
                    implicitHeight:30
                    color:"lightgray"
                    border.width:control.press?4:2
                    border.color:(control.hovered||control.pressed)?"blue":"green"
                    }
                }
                onClicked:{
                    if(textField1.text == "" || textField2.text == "" || textField3.text == "" || textField4.text == ""|| textField5.text == "") {
                        labelTips.text = "请将参数输入完整"
                    }else {
                        var obj =  Cura.PrintControl.print.gotoPrePrint()
                        if(obj =="ok"){
                            labelTips.text = ""
                        }else {
                            labelTips.text = obj
                        }

                    }

                }
             }

            Label
            {
                id: labelTips
                font: UM.Theme.getFont("medium")
                color: UM.Theme.getColor("machine_selector_printer_icon")
                width: contentWidth
                anchors{
                    top: button.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
            }

}