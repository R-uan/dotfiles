import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent.width
  height: layout.implicitHeight + 10

  ColumnLayout {
    id: layout
    anchors.centerIn: parent
    spacing: Config.spacing + 5
    implicitWidth: parent.width

    Network {}
  }
}
