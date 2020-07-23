// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.4 as UM
import Cura 1.1 as Cura

Item
{
    id: container
    height: homeButton.height
    width: homeButton.width

    property string text: "Button"
    property string color: UM.Theme.getColor("primary_text")
    signal clicked()

    Button
    {
        id: button

        width: parent.width
        height: parent.height

        hoverEnabled: true

        background: Rectangle
        {
            id: back
            radius: 4
            color: container.color //button.hovered ? UM.Theme.getColor("primary_text") : UM.Theme.getColor("main_window_header_background")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: "#200000"
        }

        contentItem: Label
        {
            id: label
            text: container.text
            font: UM.Theme.getFont("default")
            color: "#200000" //button.hovered ? UM.Theme.getColor("main_window_header_background") : UM.Theme.getColor("primary_text")
            width: contentWidth
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            renderType: Text.NativeRendering
        }

        MouseArea {
            anchors.fill: parent
            onPressed:{
                container.clicked();
                if(container.text != "添加文件") {
                    container.color = "#157efb"
                }
            }
            onReleased: {
                container.color = UM.Theme.getColor("primary_text")
            }
        }
    }

}
