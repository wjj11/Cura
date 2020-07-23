// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.1

import UM 1.1 as UM
import Cura 1.1 as Cura

UM.Dialog
{
    id: base

    //: About dialog title
    title: catalog.i18nc("@title:window","Error Tips")

    minimumWidth: 400 * screenScaleFactor
    minimumHeight: 300 * screenScaleFactor
    width: minimumWidth
    height: minimumHeight

    Rectangle
    {
        id: header
        width: parent.width + 2 * margin // margin from Dialog.qml
        height: childrenRect.height + topPadding

        anchors.top: parent.top
        anchors.topMargin: -margin
        anchors.horizontalCenter: parent.horizontalCenter

        property real topPadding: UM.Theme.getSize("wide_margin").height

        color: UM.Theme.getColor("main_window_header_background")

        Image
        {
            id: logo
            width: (base.minimumWidth * 0.85) | 0
            height: (width * (UM.Theme.getSize("logo").height / UM.Theme.getSize("logo").width)) | 0
            source: UM.Theme.getImage("logo")
            sourceSize.width: width
            sourceSize.height: height

            anchors.top: parent.top
            anchors.topMargin: parent.topPadding
            anchors.horizontalCenter: parent.horizontalCenter

            UM.I18nCatalog{id: catalog; name: "cura"}
        }

        Label
        {
            id: version

            text: catalog.i18nc("@label","version: %1").arg(UM.Application.version)
            font: UM.Theme.getFont("large_bold")
            color: UM.Theme.getColor("button_text")
            anchors.right : logo.right
            anchors.top: logo.bottom
            anchors.topMargin: (UM.Theme.getSize("default_margin").height / 2) | 0
        }
    }

    Label
    {
        id: description
        width: parent.width

        //: About dialog application description
        text: catalog.i18nc("@label","请检查接口线是否插牢，点击connect会自动重新连接")
        font: UM.Theme.getFont("system")
        wrapMode: Text.WordWrap
        anchors.top: header.bottom
        anchors.topMargin: UM.Theme.getSize("default_margin").height
    }



    rightButtons: Button
    {
        //: Close about dialog button
        id: closeButton
        text: catalog.i18nc("@action:button","connect");
        onClicked:{
            Cura.API.account.reConnect();
        }
    }
}
