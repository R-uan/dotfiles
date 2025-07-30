import QtQuick
import "../components"
import ".."

Item {
    id: root
    property string icon
    property int size
    width: butText.width + 5
    height: butText.height + 10

    CommonText {
        id: butText
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
        text: root.icon
        font.pixelSize: root.size
        color: Theme.accent
    }
}
