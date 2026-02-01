import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as P5Support
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

PlasmoidItem {
    id: root

    property var topProcesses: []

    preferredRepresentation: fullRepresentation

    // Function to get color based on usage (for text)
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

    // CPU Usage sensor (built-in, no external process)
    Sensors.Sensor {
        id: cpuUsageSensor
        sensorId: "cpu/all/usage"
        updateRateLimit: 2000
    }

    // CPU Frequency sensor
    Sensors.Sensor {
        id: cpuFreqSensor
        sensorId: "cpu/all/averageFrequency"
        updateRateLimit: 2000
    }

    // CPU Core count sensor
    Sensors.Sensor {
        id: cpuCountSensor
        sensorId: "cpu/all/coreCount"
        updateRateLimit: 60000  // Rarely changes
    }

    // Memory total sensor
    Sensors.Sensor {
        id: memTotalSensor
        sensorId: "memory/physical/total"
        updateRateLimit: 60000  // Rarely changes
    }

    // Memory used sensor
    Sensors.Sensor {
        id: memUsedSensor
        sensorId: "memory/physical/used"
        updateRateLimit: 2000
    }

    // Memory percent sensor
    Sensors.Sensor {
        id: memPercentSensor
        sensorId: "memory/physical/usedPercent"
        updateRateLimit: 2000
    }

    // Command source for top processes only
    P5Support.DataSource {
        id: commandSource
        engine: "executable"
        connectedSources: []
        interval: 0

        onNewData: function(source, data) {
            disconnectSource(source)
            if (data["exit code"] === 0) {
                try {
                    topProcesses = JSON.parse(data.stdout)
                } catch (e) {
                    console.log("Error parsing process data:", e)
                }
            }
        }
    }

    // Timer for top processes (every 5 seconds)
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            var scriptPath = Qt.resolvedUrl("../code/topprocs.py").toString().replace("file://", "")
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
                        width: parent.width * ((cpuUsageSensor.value || 0) / 100)
                        color: root.getBarColor(0)
                        radius: 3
                    }
                }

                PlasmaComponents.Label {
                    text: (cpuUsageSensor.value || 0).toFixed(1) + "%"
                    font.bold: true
                    color: root.getUsageColor(cpuUsageSensor.value || 0)
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
                    text: ((cpuFreqSensor.value || 0) / 1000000).toFixed(2) + " GHz"
                }

                Item { Layout.fillWidth: true }

                PlasmaComponents.Label {
                    text: "Cores: " + (cpuCountSensor.value || 0)
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
                        width: parent.width * ((memPercentSensor.value || 0) / 100)
                        color: root.getBarColor(5)
                        radius: 3
                    }
                }

                PlasmaComponents.Label {
                    text: ((memUsedSensor.value || 0) / 1073741824).toFixed(1) + " / " + ((memTotalSensor.value || 0) / 1073741824).toFixed(1) + " GB"
                    font.bold: true
                    color: root.getUsageColor(memPercentSensor.value || 0)
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 6
                }
            }

            // Top 5 Processes
            PlasmaComponents.Label {
                text: "Top 5 Processes"
                font.bold: true
                Layout.topMargin: Kirigami.Units.smallSpacing
            }

            Repeater {
                model: topProcesses || []

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
