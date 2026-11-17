import QtQuick 2.12
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

Item {
    Plasmoid.status: PlasmaCore.Types.ActiveStatus
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.toolTipSubText: "Удерживайте левую кнопку, затем отпустите"

    PlasmaCore.DataSource {
        id: launcher
        engine: "executable"
        readonly property string command: "/usr/bin/mos-screen-lock --lock"
        onNewData: disconnectSource(sourceName)
    }

    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        source: "system-lock-screen"
        active: mouse.containsMouse

        // Plasma 5's tray connects the first full-size MouseArea it finds
        // directly to its context menu. Keep the gesture in a child item.
        Item {
            anchors.fill: parent

            MouseArea {
                id: mouse
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                hoverEnabled: true
                preventStealing: true
                pressAndHoldInterval: 700
                property bool held: false

                onPressed: held = false
                onPressAndHold: held = true
                onCanceled: held = false
                onReleased: {
                    if (held && containsMouse)
                        launcher.connectSource(launcher.command)
                    held = false
                }
            }
        }
    }
}
