import qs.shared
import qs.config

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

// One launcher result: an app (themed icon, greyscale until selected), an
// emoji, or a glyph row (action, maths, clipboard, shell, web). A selected
// app shows its desktop actions as chips; Tab moves between them.
Item {
  id: root
  property var item
  property bool selected: false
  property int actionIndex: -1
  signal activated(bool alt)
  signal actionClicked(int index)
  signal hovered()

  implicitHeight: 52

  readonly property color _fg:  Config.darkMode ? ThemeDark.foreground0 : ThemeLight.foreground0
  readonly property color _hi:  Config.darkMode ? ThemeDark.foreground1 : ThemeLight.foreground1
  readonly property color _dim: Config.darkMode ? ThemeDark.primary0    : ThemeLight.primary0
  readonly property var _actions: item?.actions ?? []

  Rectangle {
    anchors.fill: parent
    radius: 12
    color: root.selected ? Qt.rgba(1, 1, 1, 0.09)
         : ma.containsMouse ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
    border.width: 1
    border.color: root.selected && root.actionIndex < 0 ? Qt.rgba(1, 1, 1, 0.12) : "transparent"
    Behavior on color { CAnim {} }
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onPositionChanged: root.hovered()
    // Right click = the Shift+Enter alternative.
    onClicked: (mouse) => root.activated(mouse.button === Qt.RightButton)
  }

  RowLayout {
    anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
    spacing: 12

    // ── Icon ──────────────────────────────────────────────────────────
    Item {
      Layout.preferredWidth: 32
      Layout.preferredHeight: 32
      Layout.alignment: Qt.AlignVCenter

      IconImage {
        id: icon
        anchors.fill: parent
        visible: false
        asynchronous: true
        source: root.item?.icon ? Quickshell.iconPath(root.item.icon, "application-x-executable") : ""
      }
      // Greyscale to match the palette; colour comes back on selection.
      MultiEffect {
        anchors.fill: parent
        visible: !!root.item?.icon
        source: icon
        saturation: root.selected ? 0 : -1
        opacity: root.selected ? 1 : 0.85
        Behavior on saturation { Anim { curve: Motion.effects; duration: Motion.effectsDuration } }
      }

      Text {
        anchors.centerIn: parent
        visible: !!root.item?.emoji
        text: root.item?.emoji ?? ""
        font.family: "Noto Color Emoji"
        font.pixelSize: 24
      }

      Rectangle {
        anchors.fill: parent
        visible: !root.item?.icon && !root.item?.emoji
        radius: 10
        color: Qt.rgba(1, 1, 1, root.selected ? 0.10 : 0.05)
        StyledText {
          anchors.centerIn: parent
          text: root.item?.glyph ?? ""
          font.pixelSize: Config.fontSize + 3
          color: root.selected ? root._hi : root._fg
        }
      }
    }

    // ── Title + description ───────────────────────────────────────────
    ColumnLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter
      spacing: -1

      StyledText {
        Layout.fillWidth: true
        text: root.item?.title ?? ""
        textFormat: Text.StyledText
        font.pixelSize: Config.fontSize
        font.weight: Font.Medium
        color: root.selected ? root._hi : root._fg
        elide: Text.ElideRight
        maximumLineCount: 1
      }
      StyledText {
        Layout.fillWidth: true
        visible: text.length > 0
        text: root.item?.desc ?? ""
        font.pixelSize: Config.fontSize - 4
        color: root._dim
        elide: Text.ElideRight
        maximumLineCount: 1
      }
    }

    // ── Desktop actions of the selected app ───────────────────────────
    Row {
      Layout.alignment: Qt.AlignVCenter
      Layout.maximumWidth: 380
      visible: root.selected && root._actions.length > 0
      spacing: 6
      clip: true

      Repeater {
        model: root.selected ? root._actions.slice(0, 3) : []
        delegate: Rectangle {
          id: chip
          required property var modelData
          required property int index
          readonly property bool on: root.actionIndex === index
          height: 28
          width: Math.min(150, chipText.implicitWidth + 22)
          radius: 14
          color: on ? Qt.rgba(1, 1, 1, 0.88) : chipMa.containsMouse ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(1, 1, 1, 0.06)
          Behavior on color { CAnim {} }

          StyledText {
            id: chipText
            anchors.centerIn: parent
            width: Math.min(implicitWidth, 128)
            text: chip.modelData.name
            font.pixelSize: Config.fontSize - 4
            color: chip.on ? "#151515" : root._fg
            elide: Text.ElideRight
          }
          MouseArea {
            id: chipMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.actionClicked(chip.index)
          }
        }
      }
      StyledText {
        anchors.verticalCenter: parent.verticalCenter
        visible: root._actions.length > 3
        text: "+" + (root._actions.length - 3)
        font.pixelSize: Config.fontSize - 4
        color: root._dim
      }
    }

    // Enter hint on the selected non-app row.
    StyledText {
      Layout.alignment: Qt.AlignVCenter
      visible: root.selected && root._actions.length === 0 && root.item?.kind !== "hint"
      text: "󰌑"
      font.pixelSize: Config.fontSize
      color: root._dim
    }
  }
}
