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
    signal clicked()

    Button
    {
        id: homeButton

        anchors.verticalCenter: parent.verticalCenter
        width: 85
        height: 30
        onClicked: container.clicked()
        hoverEnabled: true

        background: Rectangle
        {
            radius: UM.Theme.getSize("action_button_radius").width
            color: homeButton.hovered ? UM.Theme.getColor("primary_text") : UM.Theme.getColor("main_window_header_background")
            border.width: UM.Theme.getSize("default_lining").width
            border.color: UM.Theme.getColor("primary_text")
        }

        contentItem: Label
        {
            id: label
            text: container.text
            font.pixelSize: 20
            color: homeButton.hovered ? UM.Theme.getColor("main_window_header_background") : UM.Theme.getColor("primary_text")
            width: contentWidth
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            renderType: Text.NativeRendering
        }
    }

}
