import qs.config
import qs.shared

import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
  id: root

  Background {
    anchors.fill: parent
  }

  Process {
    id: launcher
    running: false
    command: []
  }

  function openYazi(folder) {
    var proc = Qt.createQmlObject(`
      import Quickshell.Io
      Process {
        running: true
        command: ["${Config.scriptsDir}/openfilemanager.sh", "${Config.homeShortcutDir}/${folder}"]
      }
    `, root);
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
    spacing: 0
    clip: true
    model: dirModel
    interactive: false
    anchors.fill: parent
    anchors.topMargin: 10
    anchors.bottomMargin: 10

    delegate: Item {
      height: 50
      width: list.width

      StyledText {
        text: model.icon
        font.pixelSize: 17
        anchors.centerIn: parent
      }

      MouseArea {
        anchors.fill: parent
        onClicked: root.openYazi(`${model.folder}`)
      }
    }
  }
}
