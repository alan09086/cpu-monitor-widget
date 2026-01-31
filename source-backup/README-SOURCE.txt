================================================================================
                    CPU MONITOR WIDGET - SOURCE FILES
================================================================================

This directory contains clean copies of all source files for reference.

FILES
-----
1. metadata.json  - Widget metadata and KDE Plasma configuration
2. cpuinfo.py     - Python backend (data collection)
3. main.qml       - QML frontend (user interface)

USAGE
-----
These files are backups of the source code from:
  com.plasmawidget.cpumonitor/

To modify the widget:
1. Edit files in the main com.plasmawidget.cpumonitor/ directory
2. Rebuild the package: zip -r cpu-monitor.plasmoid com.plasmawidget.cpumonitor/
3. Reinstall: plasmapkg2 --upgrade cpu-monitor.plasmoid

ARCHITECTURE
------------

┌─────────────────────────────────────────────────────────────┐
│                        main.qml                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Timer (every 2 seconds)                               │  │
│  │   ↓                                                    │  │
│  │ Execute: python3 cpuinfo.py                           │  │
│  │   ↓                                                    │  │
│  │ Parse JSON output                                     │  │
│  │   ↓                                                    │  │
│  │ Update UI components (bars, labels, colors)          │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            ↑
                            │ JSON data
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      cpuinfo.py                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Import psutil                                         │  │
│  │   ↓                                                    │  │
│  │ Collect CPU usage, frequency, core count             │  │
│  │   ↓                                                    │  │
│  │ Collect memory statistics                            │  │
│  │   ↓                                                    │  │
│  │ Get all processes, measure CPU usage                 │  │
│  │   ↓                                                    │  │
│  │ Sort by CPU, get top 5                               │  │
│  │   ↓                                                    │  │
│  │ Output JSON to stdout                                │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘

DATA STRUCTURE
--------------
The Python script outputs JSON in this format:

{
  "cpu_percent": 45.2,        // Overall CPU usage (0-100)
  "cpu_freq": 3600.0,         // Current frequency in MHz
  "cpu_count": 8,             // Number of CPU cores
  "mem_total_gb": 16.0,       // Total RAM in GB
  "mem_used_gb": 8.5,         // Used RAM in GB
  "mem_percent": 53.1,        // Memory usage percentage
  "top_processes": [
    {
      "name": "firefox",
      "cpu_percent": 12.5,    // Normalized to 0-100 range
      "mem_mb": 1024.5        // Memory in MB
    },
    // ... 4 more processes
  ]
}

CUSTOMIZATION POINTS
--------------------

cpuinfo.py:
  - Line 8:  CPU sampling interval (default: 0.5 seconds)
  - Line 34: Process measurement wait (default: 0.1 seconds)
  - Line 54: Number of top processes (default: 5)

main.qml:
  - Line 67:   Update timer interval (default: 2000ms)
  - Line 24-32: CPU usage color thresholds
  - Line 35-45: Progress bar color palette
  - Line 79-80: Widget dimensions

metadata.json:
  - Line 13: Widget version number
  - Line 9:  Widget description

COLOR SCHEME
------------
The widget uses these hex colors:

Primary Indicators:
  #00FF41 - Matrix green (< 50% usage)
  Theme color - Yellow/orange (50-80% usage)
  Theme color - Red (> 80% usage)

Process Bars:
  #00FF41 - Matrix green (Process 1)
  #00D4FF - Cyan (Process 2)
  #FF00FF - Magenta (Process 3)
  #FFD700 - Gold (Process 4)
  #FF6B35 - Orange-red (Process 5)
  #7B68EE - Medium slate blue (Memory bar)

DEPENDENCIES
------------
Python libraries:
  - psutil: System and process information

Qt/QML imports:
  - QtQuick
  - QtQuick.Layouts
  - org.kde.plasma.plasmoid
  - org.kde.plasma.plasma5support
  - org.kde.plasma.components
  - org.kde.kirigami

VERSION HISTORY
---------------
v1.0 (2026-01-31) - Initial release
  - Real-time CPU and memory monitoring
  - Top 5 processes display
  - Color-coded usage indicators
  - Plasma 6 compatibility

================================================================================
