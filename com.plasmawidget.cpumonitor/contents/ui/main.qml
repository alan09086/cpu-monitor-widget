import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as P5Support
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property var cpuData: ({
        cpu_percent: 0,
        cpu_freq: 0,
        cpu_count: 0,
        mem_total_gb: 0,
        mem_used_gb: 0,
        mem_percent: 0,
        top_processes: []
    })

    preferredRepresentation: fullRepresentation

    // Function to get color based on CPU usage (for text)
    function getUsageColor(percent) {
        if (percent < 50) {
            return "#00FF41"  // Bright Matrix green
        } else if (percent < 80) {
            return Kirigami.Theme.neutralTextColor   // Orange/Yellow
        } else {
            return Kirigami.Theme.negativeTextColor  // Red
        }
    }

    // Function to get bar color by index
    function getBarColor(index) {
        const colors = [
            "#00FF41",  // Matrix green
            "#00D4FF",  // Cyan
            "#FF00FF",  // Magenta
            "#FFD700",  // Gold
            "#FF6B35",  // Orange-red
            "#7B68EE"   // Medium slate blue
        ]
        return colors[index % colors.length]
    }

    // Use Plasma5Support for running commands
    P5Support.DataSource {
        id: commandSource
        engine: "executable"
        connectedSources: []
        interval: 0

        onNewData: function(source, data) {
            disconnectSource(source)
            if (data["exit code"] === 0) {
                try {
                    cpuData = JSON.parse(data.stdout)
                } catch (e) {
                    console.log("Error parsing CPU data:", e)
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var scriptPath = Qt.resolvedUrl("../code/cpuinfo.py").toString().replace("file://", "")
            commandSource.connectSource("python3 " + scriptPath)
        }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 18
        Layout.preferredWidth: Kirigami.Units.gridUnit * 20

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: -Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.smallSpacing

            // Header with overall CPU info
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                PlasmaComponents.Label {
                    text: "CPU Monitor"
                    font.bold: true
                    font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.2
                }
            }

            RowLayout {
                Layout.fillWidth: true

                PlasmaComponents.Label {
                    text: "Total Usage:"
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 6
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 0.6
                    color: Qt.rgba(0.2, 0.2, 0.2, 0.5)
                    radius: 3

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * (cpuData.cpu_percent / 100)
                        color: root.getBarColor(0)
                        radius: 3
                    }
                }

                PlasmaComponents.Label {
                    text: cpuData.cpu_percent.toFixed(1) + "%"
                    font.bold: true
                    color: root.getUsageColor(cpuData.cpu_percent)
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                }
            }

            RowLayout {
                Layout.fillWidth: true

                PlasmaComponents.Label {
                    text: "Frequency:"
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 6
                }

                PlasmaComponents.Label {
                    text: (cpuData.cpu_freq / 1000).toFixed(2) + " GHz"
                }

                Item { Layout.fillWidth: true }

                PlasmaComponents.Label {
                    text: "Cores: " + cpuData.cpu_count
                }
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                Layout.topMargin: Kirigami.Units.smallSpacing
                Layout.bottomMargin: Kirigami.Units.smallSpacing
            }

            // Memory info
            RowLayout {
                Layout.fillWidth: true

                PlasmaComponents.Label {
                    text: "Memory:"
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 6
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 0.6
                    color: Qt.rgba(0.2, 0.2, 0.2, 0.5)
                    radius: 3

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * (cpuData.mem_percent / 100)
                        color: root.getBarColor(5)
                        radius: 3
                    }
                }

                PlasmaComponents.Label {
                    text: cpuData.mem_used_gb.toFixed(1) + " / " + cpuData.mem_total_gb.toFixed(1) + " GB"
                    font.bold: true
                    color: root.getUsageColor(cpuData.mem_percent)
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 6
                }
            }

            // Top 5 Processes (moved inside same layout)
            PlasmaComponents.Label {
                text: "Top 5 Processes"
                font.bold: true
                Layout.topMargin: Kirigami.Units.smallSpacing
            }

            Repeater {
                model: cpuData.top_processes || []

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    required property int index
                    required property var modelData

                    PlasmaComponents.Label {
                        text: parent.modelData.name || ""
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 6
                        elide: Text.ElideRight
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 0.5
                        color: Qt.rgba(0.2, 0.2, 0.2, 0.5)
                        radius: 3

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: parent.width * ((parent.parent.modelData.cpu_percent || 0) / 100)
                            color: root.getBarColor(parent.parent.index + 1)
                            radius: 3
                        }
                    }

                    PlasmaComponents.Label {
                        text: (parent.modelData.cpu_percent || 0).toFixed(1) + "%"
                        color: root.getUsageColor(parent.modelData.cpu_percent || 0)
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 2.5
                        horizontalAlignment: Text.AlignRight
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                    }

                    PlasmaComponents.Label {
                        text: (parent.modelData.mem_mb || 0) >= 1024
                              ? ((parent.modelData.mem_mb || 0) / 1024).toFixed(1) + " GB"
                              : (parent.modelData.mem_mb || 0).toFixed(0) + " MB"
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 3.5
                        horizontalAlignment: Text.AlignRight
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        opacity: 0.8
                    }
                }
            }
        }
    }
}
