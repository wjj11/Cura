// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4

import UM 1.3 as UM
import Cura 1.1 as Cura
import "../"

// We show a nice overlay on the 3D viewer when the current output device has no monitor view
Rectangle
{
    id: tempMain

     Label{
          id: title
          text: "气动设置"
          font: UM.Theme.getFont("medium")
          color: UM.Theme.getColor("machine_selector_printer_icon")
          width: contentWidth
          anchors{
              top: parent.top
              topMargin: 10
              horizontalCenter: parent.horizontalCenter
          }
     }


    Label{
          id: tip1
          text: "气动开关"
          font: UM.Theme.getFont("medium")
          color: UM.Theme.getColor("machine_selector_printer_icon")
          width: contentWidth
          anchors{
              top: title.bottom
              topMargin: 20
              left: parent.left
              leftMargin:10
          }
     }

     QmlToggleButton{
        id: qidonglButton
        anchors{
            verticalCenter: tip1.verticalCenter
            left: tip1.right
            leftMargin: 10
        }
        height: 22
        width: 60
        leftString: qsTr("关闭")
        rightString: qsTr("打开")
        state : Cura.PrintControl.print.getGongState()
        onToggleLeft: Cura.PrintControl.print.changeGongState(0,0)
        onToggleRight: Cura.PrintControl.print.changeGongState(0,1)
    }

    Label{
          id: tip2
          text: "设置气压"
          font: UM.Theme.getFont("medium")
          color: UM.Theme.getColor("machine_selector_printer_icon")
          width: contentWidth
          anchors{
              top: tip1.bottom
              topMargin: 25
              left: parent.left
              leftMargin:10
          }
     }

     TextField {
                id: textField
                anchors{
                    verticalCenter: tip2.verticalCenter
                    left: tip2.right
                    leftMargin: 10
                }
                 style: UM.Theme.styles.text_field
                 width: 60
                 height: 30
                 onEditingFinished:
                {
                    var text = textField.text;
                    if(textField.text != '') {
                        Cura.PrintControl.print.settingFeedValue(textField.text)
                    }
                }
     }
}