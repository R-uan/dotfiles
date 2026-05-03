import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.shared

Item {
  id: root

  SolidBackground {
    anchors.fill: parent
  }

  Process {
    id: launcher
    running: false
    command: []
  }

  function openYazi(path) {
    launcher.command = ["kitty", "--", "bash", "-c",
      "yazi '" + path + "'; exec bash"]
    launcher.running = true
  }

  ListModel {
    id: dirModel
    ListElement {
      icon: "code"
      folder: "code"
    }
    ListElement {
      icon: "desktop"
      folder: "desktop"
    }
    ListElement {
      icon: "documents"
      folder: "documents"
    }
    ListElement {
      icon: "downloads"
      folder: "downloads"
    }
    ListElement {
      icon: "dotfiles"
      folder: "dotfiles"
    }
    ListElement {
      icon: "images"
      folder: "images"
    }
    ListElement {
      icon: "music"
      folder: "music"
    }
  }

  ListView {
    id: list
    anchors.fill: parent
    anchors.topMargin: 10
    anchors.bottomMargin: 10
    model: dirModel
    spacing: 0
    interactive: false
    clip: true

    delegate: Item {
      width: list.width
      height: 50

      CommonText {
        font.pixelSize: 17
        text: model.icon
        anchors.centerIn: parent
      }

      MouseArea {
        anchors.fill: parent
        onClicked: root.openYazi(Configuration.dirPath + "/" + model.folder)
      }
    }
  }
}
