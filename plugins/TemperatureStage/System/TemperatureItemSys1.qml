// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4

import UM 1.3 as UM
import Cura 1.1 as Cura
import "../Commons"
// We show a nice overlay on the 3D viewer when the current output device has no monitor view

Rectangle{
        id: container
        width: 120
        height: 370

        property int text_height : 25
        property string text: "title"
        signal clicked(string limitup,string limitdown,string fixtemp,string hold,string speed,string timeh)

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
                anchors{
                    top: parent.top
                    topMargin: 5
                    left: parent.left
                    leftMargin: 5
                }
            }


        Text
            {
                id: labelSX
                text: "上限报警"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                width: contentWidth
                anchors{
                    top: title.bottom
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                }
            }

            TextField {
                id: textField1
                anchors{
                    top: labelSX.bottom
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                 }
                 style: UM.Theme.styles.text_field
                 width: 60
                 height: text_height
             }

            Text
            {
                id: labelXX
                text: "下限报警"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                width: contentWidth
                anchors{
                    top: textField1.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
            }

            TextField {
                id: textField2
                anchors{
                    top: labelXX.bottom
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                 }
                 style: UM.Theme.styles.text_field
                 width: 60
                 height: text_height
             }

            Text
            {
                id: labelXZ
                text: "修正温度"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                width: contentWidth
                anchors{
                    top: textField2.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
            }

            TextField {
                id: textField3
                anchors{
                    top: labelXZ.bottom
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                 }
                 style: UM.Theme.styles.text_field
                 width: 60
                 height: text_height
             }

            Text
            {
                id: labelBC
                text: "保持参数"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                width: contentWidth
                anchors{
                    top: textField3.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
            }

            TextField {
                id: textField4
                anchors{
                    top: labelBC.bottom
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                 }
                 style: UM.Theme.styles.text_field
                 width: 60
                 height: text_height
             }

            Text
            {
                id: labelSL
                text: "速率参数"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                width: contentWidth
                anchors{
                    top: textField4.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
            }

            TextField {
                id: textField5
                anchors{
                    top: labelSL.bottom
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                 }
                 style: UM.Theme.styles.text_field
                 width: 60
                 height: text_height
             }


            Text
            {
                id: labelZH
                text: "滞后时间"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Helvetica"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                color: "#200000"
                width: contentWidth
                anchors{
                    top: textField5.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
            }

            TextField {
                id: textField6
                anchors{
                    top: labelZH.bottom
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                 }
                 style: UM.Theme.styles.text_field
                 width: 60
                 height: text_height
             }


            CommonButton{
                id:button
                text:"保存"
                anchors{
                    top: textField6.bottom
                    topMargin: 10
                    horizontalCenter: parent.horizontalCenter
                 }
                width:60
                height:25
                onClicked:{
                    container.clicked(textField1.text,textField2.text,textField3.text,textField4.text,textField5.text,textField6.text)
                }
             }

}




