// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura

Item
{

    Rectangle
    {
        id: temperatureTitle
        color:UM.Theme.getColor("main_background")
        width: 100
        height: parent.height
        anchors.centerIn: parent
        radius: UM.Theme.getSize("default_radius").width


        Label
        {
            id: label
            text: "打印运动控制"
            font: UM.Theme.getFont("medium")
            color: UM.Theme.getColor("machine_selector_printer_icon")
            width: contentWidth
            anchors.centerIn: parent
        }
    }
}