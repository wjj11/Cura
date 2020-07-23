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
          text: "寸动模式"
          font: UM.Theme.getFont("medium")
          color: UM.Theme.getColor("machine_selector_printer_icon")
          width: contentWidth
          anchors{
              top: parent.top
              topMargin: 10
              horizontalCenter: parent.horizontalCenter
          }
     }

    Button{
         id:button1
         anchors{
              top: title.bottom
              topMargin: 15
              horizontalCenter: parent.horizontalCenter
         }
         style:ButtonStyle{ // 可以不要 style 直接 background
              background:Rectangle{
                    implicitHeight: 35
                    implicitWidth:  30

                    color: "transparent"  //设置背景透明，否则会出现默认的白色背景

                    BorderImage{
                        anchors.fill: parent
                        source: "../images/up.png"

                    }
              }
         }

         MouseArea {
            anchors.fill: parent
            onPressed: Cura.PrintControl.print.gotoCMove(0)
            onReleased: Cura.PrintControl.print.gotoStop()
        }
    }

    Button{
         id:button2
         anchors{
              top: button1.bottom
              topMargin: 10
              left: parent.left
              leftMargin: 10
         }
         style:ButtonStyle{ // 可以不要 style 直接 background
              background:Rectangle{
                    implicitHeight: 30
                    implicitWidth:  35

                    color: "transparent"  //设置背景透明，否则会出现默认的白色背景

                    BorderImage{
                        anchors.fill: parent
                        source: "../images/left.png"

                    }
              }
         }

         MouseArea {
            anchors.fill: parent
            onPressed: Cura.PrintControl.print.gotoCMove(1)
            onReleased: Cura.PrintControl.print.gotoStop()
        }
    }

     Button{
         id:button11
         anchors{
              verticalCenter: button2.verticalCenter
              horizontalCenter: button1.horizontalCenter
         }
         style:ButtonStyle{ // 可以不要 style 直接 background
              background:Rectangle{
                    implicitHeight: 35
                    implicitWidth:  35

                    color: "transparent"  //设置背景透明，否则会出现默认的白色背景

                    BorderImage{
                        anchors.fill: parent
                        source: "../images/center.png"

                    }
              }
         }
         onClicked:  Cura.PrintControl.print.goHome()

    }

    Button{
         id:button3
         anchors{
              top: button1.bottom
              topMargin: 10
              right: parent.right
              rightMargin: 10
         }
         style:ButtonStyle{ // 可以不要 style 直接 background
              background:Rectangle{
                    implicitHeight: 30
                    implicitWidth:  35

                    color: "transparent"  //设置背景透明，否则会出现默认的白色背景

                    BorderImage{
                        anchors.fill: parent
                        source: "../images/right.png"

                    }
              }
         }

         MouseArea {
            anchors.fill: parent
            onPressed: Cura.PrintControl.print.gotoCMove(2)
            onReleased: Cura.PrintControl.print.gotoStop()
        }
    }

    Button{
         id:button4
         anchors{
              top: button2.bottom
              topMargin: 10
              horizontalCenter: parent.horizontalCenter
         }
         style:ButtonStyle{ // 可以不要 style 直接 background
              background:Rectangle{
                    implicitHeight: 35
                    implicitWidth:  30

                    color: "transparent"  //设置背景透明，否则会出现默认的白色背景

                    BorderImage{
                        anchors.fill: parent
                        source: "../images/down.png"

                    }
              }
         }

         MouseArea {
            anchors.fill: parent
            onPressed: Cura.PrintControl.print.gotoCMove(3)
            onReleased: Cura.PrintControl.print.gotoStop()
        }
    }


    Button{
         id:button5
         anchors{
              top: button4.bottom
              topMargin: 15
              horizontalCenter: parent.horizontalCenter
         }
         style:ButtonStyle{ // 可以不要 style 直接 background
              background:Rectangle{
                    implicitHeight: 35
                    implicitWidth:  30

                    color: "transparent"  //设置背景透明，否则会出现默认的白色背景

                    BorderImage{
                        anchors.fill: parent
                        source: "../images/up.png"

                    }
              }
         }

         MouseArea {
            anchors.fill: parent
            onPressed: Cura.PrintControl.print.gotoCMove(4)
            onReleased: Cura.PrintControl.print.gotoStop()
        }
    }

    Button{
         id:button6
         anchors{
              top: button5.bottom
              topMargin: 10
              horizontalCenter: parent.horizontalCenter
         }
         style:ButtonStyle{ // 可以不要 style 直接 background
              background:Rectangle{
                    implicitHeight: 35
                    implicitWidth:  30

                    color: "transparent"  //设置背景透明，否则会出现默认的白色背景

                    BorderImage{
                        anchors.fill: parent
                        source: "../images/down.png"

                    }
              }
         }

         MouseArea {
            anchors.fill: parent
            onPressed: Cura.PrintControl.print.gotoCMove(5)
            onReleased: Cura.PrintControl.print.gotoStop()
        }
    }


}