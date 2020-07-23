// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4

import UM 1.3 as UM
import Cura 1.1 as Cura
import "../Commons"

// We show a nice overlay on the 3D viewer when the current output device has no monitor view
Rectangle
{
    id: tempSysMain
    color: UM.Theme.getColor("viewport_overlay")
    anchors.fill: parent

    property int m_top : 25
    signal closeView()

    Rectangle{
        id: tempSetRect
        width: 720
        height: 410
        anchors{
            top: parent.top
            topMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
        color: UM.Theme.getColor("viewport_overlay")
        border.width: UM.Theme.getSize("default_lining").width
        border.color: "#666666"
        radius :3

        Text
            {
                id: title
                text: "系统设置"
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
                    horizontalCenter: parent.horizontalCenter
                }
            }


        TemperatureItemSys1{
            id: hjSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: parent.left
                leftMargin: 20
            }
            text: "环境"
            onClicked: Cura.Temperature.temp.setSystemTemp(1,limitup,limitdown,fixtemp,hold,speed,timeh)
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width

        }


        TemperatureItemSys1{
            id: hwtSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: hjSetRect.right
                leftMargin: 20
            }
            text: "恒温台"
            onClicked: Cura.Temperature.temp.setSystemTemp(2,limitup,limitdown,fixtemp,hold,speed,timeh)
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width
        }


        TemperatureItemSys1{
            id: dwzgSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: hwtSetRect.right
                leftMargin: 20
            }
            text: "低温针管"
            onClicked: Cura.Temperature.temp.setSystemTemp(3,limitup,limitdown,fixtemp,hold,speed,timeh)
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width
        }

        TemperatureItemSys1{
            id: dwztSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: dwzgSetRect.right
                leftMargin: 20
            }
            text: "低温针头"
            onClicked: Cura.Temperature.temp.setSystemTemp(4,limitup,limitdown,fixtemp,hold,speed,timeh)
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width
        }


        TemperatureItemSys1{
            id: gwzgSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: dwztSetRect.right
                leftMargin: 20
            }
            text: "高温针管"
            onClicked: Cura.Temperature.temp.setSystemTemp(5,limitup,limitdown,fixtemp,hold,speed,timeh)
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width
        }

    }


    CommonButton
    {
        id: closeButton
        text: "返回"
        width:60
        height: 20
        anchors{
            right: parent.right
            rightMargin: 20
            top: parent.top
            topMargin: 5
         }
         onClicked:{
              tempSysMain.destroy();
              tempSysMain.closeView()
         }

    }


}