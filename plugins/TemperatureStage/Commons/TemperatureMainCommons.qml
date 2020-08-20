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
    color: UM.Theme.getColor("viewport_overlay")
    anchors.fill: parent

    property int m_top : 40
    signal openView()

    Rectangle{
        id: tempSetRect
        width: 520
        height: 300
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        color: UM.Theme.getColor("viewport_overlay")
        border.width: UM.Theme.getSize("default_lining").width
        border.color: "#666666"
        radius :3

        Text
            {
                id: title
                text: "温控模块"
                width: 60
                height:30
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                anchors{
                    top: parent.top
                    //topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
            }


        TemperatureItem1{
            id: hjSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: parent.left
                leftMargin: 20
            }
            text: "环境"
            state: Cura.Temperature.temp.getState(1)
            t_bottom:-5.0
            t_top:45.0
            onClicked: hjSetRect.state = Cura.Temperature.temp.setRunOrStop(1)
            onInputTemp:  Cura.Temperature.temp.setTemp(content, 1)
            onInValidator : Cura.Temperature.temp.inValidator()
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width

        }


        TemperatureItem1{
            id: hwtSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: hjSetRect.right
                leftMargin: 20
            }
            text: "恒温台"
            state: Cura.Temperature.temp.getState(2)
            t_bottom:-5.0
            t_top:80.0
            onClicked: hwtSetRect.state = Cura.Temperature.temp.setRunOrStop(2)
            onInputTemp:  Cura.Temperature.temp.setTemp(content ,2)
            onInValidator : Cura.Temperature.temp.inValidator()
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width
        }


        TemperatureItem1{
            id: dwzgSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: hwtSetRect.right
                leftMargin: 20
            }
            text: "低温针管"
            state: Cura.Temperature.temp.getState(3)
            t_bottom:0.0
            t_top:100.0
            onClicked: dwzgSetRect.state = Cura.Temperature.temp.setRunOrStop(3)
            onInputTemp:  Cura.Temperature.temp.setTemp(content ,3)
            onInValidator : Cura.Temperature.temp.inValidator()
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width
        }

        TemperatureItem1{
            id: dwztSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: dwzgSetRect.right
                leftMargin: 20
            }
            text: "低温针头"
            state: Cura.Temperature.temp.getState(4)
            t_bottom:10.0
            t_top:45.0
            onClicked: dwztSetRect.state = Cura.Temperature.temp.setRunOrStop(4)
            onInputTemp:  Cura.Temperature.temp.setTemp(content, 4)
            onInValidator : Cura.Temperature.temp.inValidator()
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width
        }


        TemperatureItem1{
            id: gwzgSetRect
            anchors{
                top: parent.top
                topMargin: m_top
                left: dwztSetRect.right
                leftMargin: 20
            }
            text: "高温针管"
            state: Cura.Temperature.temp.getState(5)
            t_bottom:80.0
            t_top:500.0
            onClicked: gwzgSetRect.state = Cura.Temperature.temp.setRunOrStop(5)
            onInputTemp:  Cura.Temperature.temp.setTemp(content, 3)
            onInValidator : Cura.Temperature.temp.inValidator()
            color: UM.Theme.getColor("viewport_overlay")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#c7c7c7"
            radius: UM.Theme.getSize("action_button_radius").width
        }

        SystemInterDialog         //登录按钮
            {
                id: dialog
                anchors{
                    right: tempSetRect.right
                    rightMargin: 70
                    top: parent.top
                    topMargin: 4
                 }
            }
    }


    Timer{
            id: timer
            interval:1500;running:true; repeat:false
            onTriggered:{
                //var list =  Cura.Temperature.temp.getCurrentTemp()
                //hjSetRect.number = list[0]/10
               // hwtSetRect.number = list[1]/10
                if(Cura.Temperature.temp.getPrintNozzleGrad() == 0) {
                    dwzgSetRect.number = list[2]/10
                    dwztSetRect.number = list[3]/10
                    gwzgSetRect.number = ""
                }else if(Cura.Temperature.temp.getPrintNozzleGrad() == 1){
                    gwzgSetRect.number = list[2]/10
                    dwzgSetRect.number = ""
                    dwztSetRect.number = ""
                }else {
                    dwzgSetRect.number = ""
                    dwztSetRect.number = ""
                    gwzgSetRect.number = ""
                }

            }
    }


    Connections{
        target: dialog
        onOpenSysView:{
            openView()
            timer.stop()
        }
    }

    function restartTimer(){
        timer.start()
    }
}

