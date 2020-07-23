// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4

import UM 1.3 as UM
import Cura 1.1 as Cura
import "./Commons"

// We show a nice overlay on the 3D viewer when the current output device has no monitor view
Rectangle
{
    id: tempMain
    color: UM.Theme.getColor("viewport_overlay")
    anchors.fill: parent

    property int m_top : 30
    property var child

    //防止页面鼠标滚动时，影响3D展示页面图变大变小
    MouseArea
    {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onWheel: wheel.accepted = true
    }

    //打印方式选择框
    CommonCombox {
                  id: print_method
                  model: print_method_list
                  width: 80
                  height: 30
                  anchors{
                      top: parent.top
                      topMargin: 50
                      left: parent.left
                      leftMargin: 30
                  }
              }

    ListModel
            {
                id:print_method_list
                ListElement{modelData:"低温"}
                ListElement{modelData:"高温"}
                ListElement{modelData:"光固化"}
            }


     Image {
          id: right_arror1
          source: "images/right_arror.png"
          width: 50
          height:40
          anchors{
              left: print_method.right
              leftMargin: 20
              verticalCenter: print_method.verticalCenter
          }

      }

      //喷头抓取操作
      CommonButton
      {
            id: grabButton
            width: 80
            height: 30
            anchors
            {
                verticalCenter: print_method.verticalCenter
                left: right_arror1.right
                leftMargin: 20
            }
            text: "抓取喷头"
            onClicked:Cura.Temperature.temp.gotoGrabNozzle()

      }

      Image {
          id: right_arror2
          source: "images/right_arror.png"
          width: 50
          height:40
          anchors{
              left: grabButton.right
              leftMargin: 20
              verticalCenter: print_method.verticalCenter
          }
      }

      Text {
          id: tips
          text: "请在温控模块进行设置"
          width: 60
          height:40
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
          font.family: "Helvetica"
          font.pixelSize: 13
          wrapMode: Text.WordWrap
          color: "#200000"
          anchors{
              left: right_arror2.right
              leftMargin: 20
              verticalCenter: print_method.verticalCenter
          }
      }

      Image {
          id: right_arror3
          source: "images/right_arror.png"
          width: 50
          height:40
          anchors{
              left: tips.right
              leftMargin: 20
              verticalCenter: print_method.verticalCenter
          }
      }

      //针头定位
      CommonButton
      {
            id: locationButton
            width: 80
            height: 30
            anchors
            {
                verticalCenter: print_method.verticalCenter
                left: right_arror3.right
                leftMargin: 20
            }
            text: "针头定位"
            onClicked:Cura.Temperature.temp.gotoNozzleLocation()

      }

      Image {
          id: right_arror4
          source: "images/right_arror.png"
          width: 50
          height:40
          anchors{
              left: locationButton.right
              leftMargin: 20
              verticalCenter: print_method.verticalCenter
          }
      }

      //拨片定位
      CommonButton
      {
            id: planeButton
            width: 80
            height: 30
            anchors
            {
                verticalCenter: print_method.verticalCenter
                left: right_arror4.right
                leftMargin: 20
            }
            text: "拨片定位"
            onClicked:Cura.Temperature.temp.gotoPlaneLocation()

      }

    TemperatureMainCommons{
        id: tempComRect
        anchors {
              top: parent.top
              topMargin: 120
              horizontalCenter: parent.horizontalCenter
        }
        onOpenView:{
            //tempComRect.visible = false
            var comp = Qt.createComponent("System/TemperatureMainSystem.qml")
            child = comp.createObject(tempMain)
        }
     }

    //系统温控页面关闭后温控页面重新开启timer
     Connections{
        target: child
        onCloseView:{
            tempComRect.restartTimer()
        }
    }

    // 防止拖入模型响应事件
    DropArea
    {
        anchors.fill: parent
    }


}