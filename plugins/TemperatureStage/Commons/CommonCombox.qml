import QtQuick 2.6
import QtQuick.Controls 2.1
import Cura 1.1 as Cura


ComboBox {
      id: control
      currentIndex :Cura.Temperature.temp.getPrintMethond()
      delegate: ItemDelegate {
          width: control.width -2
          height: 25
          contentItem: Rectangle
          {
              anchors.fill: parent
              color:control.highlightedIndex == index ?"#157efb":"white"
              radius: 3
              Label {
                      id:myText
                      anchors.fill: parent
                      text: modelData
                      color: "#200000"
                      font: control.font
                      verticalAlignment: Text.AlignVCenter
                      horizontalAlignment: Text.AlignHCenter

                  }



          }
          onClicked: Cura.Temperature.temp.setPrintMethond(index)
          highlighted: control.highlightedIndex == index
      }

      indicator: Image {
          id: canvas
          x: control.width - width -8
          y: control.topPadding + (control.availableHeight - height) / 2
          width: 20
          height: 20
          source: "../images/down.png"

          Connections {
              target: control
              //onPressedChanged: content.text = control.displayText
          }

      }

      contentItem: Text {
          id: content
          text: control.displayText == "" ?"打印方式": control.displayText
          font: control.font
          color: "#200000"
          width:  control.width - 20 -8
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter

      }

      background: Rectangle {
          border.color: "#200000"
          radius: 2
      }

      popup: Popup {
          y: control.height
          width: control.width
          implicitHeight: 70
          padding: 1

          contentItem: ListView {
              id: listview
              clip: true
              model: control.popup.visible ? control.delegateModel : null
              currentIndex: control.highlightedIndex
              spacing: 2
              ScrollIndicator.vertical: ScrollIndicator { }

          }

          background: Rectangle {
              border.color: "#200000"
              radius: 2
          }
      }
  }
