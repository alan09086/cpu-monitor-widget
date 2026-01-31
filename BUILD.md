# Building the CPU Monitor Widget

Quick reference for rebuilding the widget after making changes.

## Building the Package

```bash
cd ~/projects/cpu-monitor
zip -r cpu-monitor.plasmoid com.plasmawidget.cpumonitor/
```

This creates `cpu-monitor.plasmoid` from the source directory.

## Source Files

The widget consists of three main files:

### 1. metadata.json
Widget metadata and KDE Plasma configuration.

### 2. contents/code/cpuinfo.py
Python backend that collects system information:
- CPU usage and frequency
- Memory statistics
- Top 5 processes by CPU usage

**Dependencies**: `psutil`

### 3. contents/ui/main.qml
QML/Qt frontend that displays the data:
- Visual progress bars
- Color-coded indicators
- 2-second auto-refresh timer

## Installing/Updating

### Fresh Install
```bash
plasmapkg2 --install cpu-monitor.plasmoid
```

### Update Existing
```bash
plasmapkg2 --upgrade cpu-monitor.plasmoid
```

### Remove
```bash
plasmapkg2 --remove com.plasmawidget.cpumonitor
```

## Testing Changes

After modifying source files:

```bash
# 1. Rebuild package
zip -r cpu-monitor.plasmoid com.plasmawidget.cpumonitor/

# 2. Upgrade
plasmapkg2 --upgrade cpu-monitor.plasmoid

# 3. Restart Plasma (choose one):
killall plasmashell && plasmashell &
# OR log out and back in
```

## Quick Development Cycle

```bash
# Make changes to files in com.plasmawidget.cpumonitor/
# Then run:
cd ~/projects/cpu-monitor
zip -r cpu-monitor.plasmoid com.plasmawidget.cpumonitor/ && \
plasmapkg2 --upgrade cpu-monitor.plasmoid && \
killall plasmashell && plasmashell &
```

## Debugging

### Test Python Script
```bash
python3 com.plasmawidget.cpumonitor/contents/code/cpuinfo.py
```
Should output JSON with CPU/memory data.

### View Plasma Logs
```bash
journalctl --user -f | grep -i plasma
```

### Check Widget Installation
```bash
plasmapkg2 --list | grep cpu
```

## File Structure

```
com.plasmawidget.cpumonitor/
├── metadata.json              # Widget info (name, version, ID)
└── contents/
    ├── code/
    │   └── cpuinfo.py        # Data collection (Python + psutil)
    └── ui/
        └── main.qml          # User interface (QML/Qt)
```

## Common Modifications

### Change Update Interval
Edit `contents/ui/main.qml`:
```qml
Timer {
    interval: 2000  // milliseconds (2000 = 2 seconds)
```

### Change Number of Processes
Edit `contents/code/cpuinfo.py`:
```python
top_processes = sorted(...)[:5]  # Change 5 to desired number
```

### Change Colors
Edit `contents/ui/main.qml` - `getBarColor()` function (lines 35-45)

## Version Bumping

When releasing a new version:

1. Update `metadata.json`:
   ```json
   "Version": "1.1",
   "X-KDE-PluginInfo-Version": "1.1"
   ```

2. Update README.md changelog

3. Rebuild package

## Distribution

To share with others:
1. Build the `.plasmoid` file (zip archive)
2. Distribute `cpu-monitor.plasmoid` + `README.md`
3. Users install with `plasmapkg2 --install`

## Notes

- The `.plasmoid` file is just a renamed `.zip` archive
- All paths in QML are relative to the widget directory
- Python script must be executable or called with `python3`
- Widget ID must match directory name: `com.plasmawidget.cpumonitor`
