// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import QtQuick.Scene3D 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

import UM 1.3 as UM
import Cura 1.1 as Cura
import "./Move"
import "../TemperatureStage/Commons"


// We show a nice overlay on the 3D viewer when the current output device has no monitor view
Rectangle
{
    id: tempMain
    color: UM.Theme.getColor("viewport_overlay")
    anchors.fill: parent

    //防止页面鼠标滚动时，影响3D展示页面图变大变小
    MouseArea
    {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onWheel: wheel.accepted = true
    }


     MoveMain{
        id: moveRect
        width: 140
        height: 260
        anchors{
            top: parent.top
            topMargin: 30
            right: parent.right
            rightMargin: 30
        }
        color: UM.Theme.getColor("viewport_overlay")
        border.width: UM.Theme.getSize("default_lining").width
        border.color: UM.Theme.getColor("machine_selector_printer_icon")
     }


     Feeding{
        id: feedingRect
        width: 140
        height: 120
        anchors{
            top: moveRect.bottom
            topMargin: 30
            right: parent.right
            rightMargin: 30
        }
        color: UM.Theme.getColor("viewport_overlay")
        border.width: UM.Theme.getSize("default_lining").width
        border.color: UM.Theme.getColor("machine_selector_printer_icon")
     }


    Rectangle {
          id: frame
          clip: true
          width: 250
          height: 400
          border.color: "black"
          anchors{
                top: parent.top
                topMargin: 40
                left: parent.left
                leftMargin: 30
          }
          focus: true

          Keys.onUpPressed: vbar.decrease()
          Keys.onDownPressed: vbar.increase()
          TextEdit {
              id: textEdit
              text: ""
              font.pointSize: 8
              height: contentHeight + 40

              width: frame.width - vbar.width
              y: -vbar.position * textEdit.height
              wrapMode: TextEdit.Wrap
              selectByKeyboard: true
              selectByMouse: true
              focus: true

              MouseArea{
                  anchors.fill: parent
                  onWheel: {
                      if (wheel.angleDelta.y > 0) {
                          vbar.decrease();
                      }
                      else {
                          vbar.increase();
                      }
                  }
                  onClicked: {
                      textEdit.forceActiveFocus();
                      textEdit.cursorPosition = textEdit.positionAt(mouse.x,mouse.y)  //通过鼠标点击（x，y）值获得鼠标应该移动到的具体位置
                  }
              }

              CommonButton{
                id:loadContent
                text:"加载更多"
                anchors{
                    bottom: parent.bottom
                    bottomMargin: 10
                    horizontalCenter: parent.horizontalCenter
                }
                width:60
                height:30
                onClicked:{
                      Cura.PrintControl.print.readFile()

                }
            }
          }

          ScrollBar {
              id: vbar
              hoverEnabled: true
              active: true
              orientation: Qt.Vertical
              size: frame.height / textEdit.height
              stepSize :frame.height / (textEdit.height *1.1)     //设置翻页时的幅度大小
              width: 10
              anchors.top: parent.top
              anchors.right: parent.right
              anchors.bottom: parent.bottom

          }

    }


    CommonButton{
        id:button
        text:"添加文件"
        anchors{
            top: parent.top
            topMargin: 40
            left: frame.right
            leftMargin: 30
        }
        width:60
        height:30
        onClicked:{
           Cura.Actions.openShow.trigger()
           qmlToggleButton.stopPrint()
           cqmlToggleButton.stopPrint()
           Cura.PrintControl.print.pramClear()
        }
    }

    CommonButton{
        id:gotoPlace
        text:"回断点位置"
        anchors{
            verticalCenter: button.verticalCenter
            left: button.right
            leftMargin: 20
        }
        width:60
        height:30
        onClicked:{
             Cura.PrintControl.print.gotoPosition()
        }
    }

    //CommonButton{
        //id:guzhangButton
        //text:"故障解除"
        //anchors{
            //verticalCenter: button.verticalCenter
            //left: gotoPlace.right
            //leftMargin: 20
        //}
        //width:60
        //height:30
        //onClicked:{
            // Cura.PrintControl.print.gotoPosition()
        //}
    //}

     Label{
          id: tip2
          text: "打印速度"
          font: UM.Theme.getFont("medium")
          color: UM.Theme.getColor("machine_selector_printer_icon")
          width: contentWidth
          anchors{
              top: button.bottom
              topMargin: 25
              left: frame.right
              leftMargin: 30
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
                        Cura.PrintControl.print.settingSpeedValue(textField.text)
                    }
                }
     }

    Label{
          id: speedlabel
          text: "初始速度："
          font: UM.Theme.getFont("medium")
          color: UM.Theme.getColor("machine_selector_printer_icon")
          width: contentWidth
          anchors{
              verticalCenter: tip2.verticalCenter
              left: textField.right
              leftMargin: 20
          }
     }

    Label{
          id: modellabel
          text: "模型打印："
          font: UM.Theme.getFont("medium")
          color: UM.Theme.getColor("machine_selector_printer_icon")
          width: contentWidth
          anchors{
              top: textField.bottom
              topMargin: 30
              left: frame.right
              leftMargin: 30

          }
    }

    QmlToggleButton{
        id: qmlToggleButton
        anchors{
            verticalCenter: modellabel.verticalCenter
            left: modellabel.right
            leftMargin: 20
        }
        height: 26
        width: 70
        leftString: qsTr("停止")
        rightString: qsTr("打印")
        state : Cura.PrintControl.print.getPrintState(0)
        onToggleLeft: Cura.PrintControl.print.stopPrintModel(0)
        onToggleRight: Cura.PrintControl.print.printModel(0)
    }


    Label{
          id: cmodellabel
          text: "分层打印："
          font: UM.Theme.getFont("medium")
          color: UM.Theme.getColor("machine_selector_printer_icon")
          width: contentWidth
          anchors{
              top: modellabel.bottom
              topMargin: 30
              left: frame.right
              leftMargin: 30

          }
    }

    QmlToggleButton{
        id: cqmlToggleButton
        anchors{
            verticalCenter: cmodellabel.verticalCenter
            left: cmodellabel.right
            leftMargin: 20
        }
        height: 26
        width: 70
        leftString: qsTr("停止")
        rightString: qsTr("打印")
        state : Cura.PrintControl.print.getPrintState(1)
        onToggleLeft: Cura.PrintControl.print.stopPrintModel(1)
        onToggleRight: Cura.PrintControl.print.printModel(1)
    }

    TextField {
                id: textFieldlayer
                anchors{
                    verticalCenter: cqmlToggleButton.verticalCenter
                    left: cqmlToggleButton.right
                    leftMargin: 10
                }
                 style: UM.Theme.styles.text_field
                 width: 60
                 height: 30
                 onEditingFinished:
                {
                    var text = textFieldlayer.text;
                    if(textFieldlayer.text != '') {
                        Cura.PrintControl.print.setStopLayer(textFieldlayer.text)
                    }
                }
     }

     ProgressBar{
            id:progress
            minimumValue: 0;
            maximumValue: 100;
            value: 0;
            width: 150;
            height: 20;

            anchors{
                top: cqmlToggleButton.bottom
                topMargin: 30
                left: frame.right
                leftMargin: 30
          }

          Text{
                id:progressLabel
                text:"0%"
                height:10
                width: contentWidth
                anchors.centerIn:progress

          }
     }

     Label{
        id:countLabel
        text:"当前打印层数："+ Cura.PrintControl.print.getLayer()
        height:30
        width: contentWidth
        anchors{
            top: progress.bottom
            topMargin: 20
            left: frame.right
            leftMargin: 30
        }
    }

    Timer{
            id: timer
            interval:150;running:true; repeat:false
            onTriggered:{
                var percent =  Cura.PrintControl.print.getCurrentFile()
                progress.value = percent
                progressLabel.text = percent +"%"
            }
    }


    Scene3D
    {
        //anchors.fill: parent
        anchors{
            top: countLabel.bottom
            topMargin: 10
            left: frame.right
            leftMargin: 30
        }
        height:200
        width: 200

        aspects: ["input", "logic"]
        cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

        Entity
        {
            id: sceneRoot

            Camera
            {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 150
                aspectRatio: 4/3
                nearPlane : 0.1
                farPlane : 2000.0
                position: Qt.vector3d(-8.0, 20.0, 70.0 )
                upVector: Qt.vector3d( 0.0, 0.0, 0.0 )
                viewCenter: Qt.vector3d( 0.0, 100.0, 0.0 )
            }

            OrbitCameraController
            {
                camera: camera
            }

            components: [
                RenderSettings
                {
                    activeFrameGraph: ForwardRenderer
                    {
                        clearColor: Qt.rgba(0, 0.5, 1, 1)
                        camera: camera
                    }
                },
                InputSettings
                {
                }
            ]

            Entity
            {
                id: monkeyEntity
                components: [
                    SceneLoader
                    {
                        id: sceneLoader
                    }
                ]
            }
        }
    }


    // 防止拖入模型响应事件
    DropArea
    {
        anchors.fill: parent
    }

    Connections
    {
        target: Cura.PrintControl.print
        onReadFinished:
        {
            textEdit.text = fileContent
            //countLabel.text = "当前打印层数：" +textEdit.lineCount
            //textEdit.append(fileContent)
        }


        onPrintProgress:
        {
            progress.value = value
            progressLabel.text = value +"%"
            countLabel.text = "当前打印层数：" + layer
        }

        onPrintFinished:
        {
            progress.value = 100
            progressLabel.text = 100 +"%"
            qmlToggleButton.stopPrint()
            cqmlToggleButton.stopPrint()
            Cura.PrintControl.print.pramClear()
        }

        onPrintLayerFinished:
        {
            cqmlToggleButton.stopLayerPrint()
            Cura.PrintControl.print.stopLayerPrint(1)
        }

        onPrintError:
        {
            progress.value = 0
            progressLabel.text = 0 +"%"
            qmlToggleButton.stopPrint()
            cqmlToggleButton.stopPrint()
            Cura.PrintControl.print.pramClear()
        }

        onPrintSpeed:
        {
            speedlabel.text = "初始速度：" + speed
        }
    }

    Connections          //弹出文件选择框的响应事件
    {
        target: Cura.Actions.openShow
        onTriggered: openDialog.open()
    }


    FileDialog
    {
        id: openDialog;

        //: File open dialog title
        title: catalog.i18nc("@title:window","Open file(s)")           //对话框标题
        modality: UM.Application.platform == "linux" ? Qt.NonModal : Qt.WindowModal;
        selectMultiple: true             //多选
        nameFilters: UM.MeshFileHandler.supportedReadFileTypes;
        folder: CuraApplication.getDefaultPath("dialog_load_path")       //用户选择的文件目录
        onAccepted:
        {
            // Because several implementations of the file dialog only update the folder
            // when it is explicitly set.
            var f = folder;
            folder = f;

            CuraApplication.setDefaultPath("dialog_load_path", folder);

            //Cura.PrintControl.print.openFile(fileUrl);
            sceneLoader.source = openDialog.fileUrl

        }
    }

}