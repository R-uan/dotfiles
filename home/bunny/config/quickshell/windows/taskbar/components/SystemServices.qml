import qs.shared
import qs.config
import qs.services

import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: layout.implicitHeight + 6

  ColumnLayout {
    id: layout
    anchors.centerIn: parent
    spacing: 2
    implicitWidth: parent.width

    AudioButton {}
    Network {}
    BluetoothButton {}
    NotificationButton {}
  }
}
