import qs.config
import qs.shared

import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
  id: root
  width: 500
  height: Math.max(listLeft.height, listCenter.height, listRight.height)

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
    id: dirModelLeft
    ListElement { icon: "code";      folder: "code"      }
    ListElement { icon: "desktop";   folder: "desktop"   }
    ListElement { icon: "documents"; folder: "documents" }
  }

  ListModel {
    id: dirModelCenter
    ListElement { icon: "downloads"; folder: "downloads" }
    ListElement { icon: "dotfiles";  folder: "dotfiles"  }
  }

  ListModel {
    id: dirModelRight
    ListElement { icon: "images"; folder: "images" }
    ListElement { icon: "music";  folder: "music"  }
  }

  Row {
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 4

    ListView {
      id: listLeft
      width: (parent.width - parent.spacing * 2) / 3
      height: contentHeight + topMargin + bottomMargin
      spacing: 0
      clip: true
      model: dirModelLeft
      interactive: false
      topMargin: 10
      bottomMargin: 10
      delegate: dirDelegate
    }

    ListView {
      id: listCenter
      width: (parent.width - parent.spacing * 2) / 3
      height: contentHeight + topMargin + bottomMargin
      spacing: 0
      clip: true
      model: dirModelCenter
      interactive: false
      topMargin: 10
      bottomMargin: 10
      delegate: dirDelegate
    }

    ListView {
      id: listRight
      width: (parent.width - parent.spacing * 2) / 3
      height: contentHeight + topMargin + bottomMargin
      spacing: 0
      clip: true
      model: dirModelRight
      interactive: false
      topMargin: 10
      bottomMargin: 10
      delegate: dirDelegate
    }
  }

  Component {
    id: dirDelegate
    Item {
      implicitHeight: 50
      width: ListView.view.width
      StyledText {
        text: model.icon
        font.pixelSize: 17
        anchors.centerIn: parent
      }
      MouseArea {
        anchors.fill: parent
        onClicked: root.openYazi(model.folder)
      }
    }
  }
}
