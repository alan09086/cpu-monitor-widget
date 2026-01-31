# CPU Monitor Widget - User Description

## What is this?

A beautiful, real-time system monitoring widget for your KDE Plasma desktop. Keep an eye on your computer's performance with vibrant, color-coded visual feedback.

## At a Glance

**See instantly:**
- 🔥 CPU usage percentage
- ⚡ Current processor frequency
- 🧠 Memory consumption (RAM)
- 📊 Your 5 most resource-hungry programs
- 🎨 Color-coded warnings (green = good, yellow = moderate, red = high)

## Perfect For

- **Gamers** - Monitor performance while gaming without alt-tabbing
- **Developers** - Track which processes are eating your CPU during builds
- **Power Users** - Keep tabs on system health at a glance
- **Anyone** - Who wants to know what their computer is doing

## Why This Widget?

- **Lightweight**: Uses less than 0.5% CPU itself
- **Beautiful**: Cyberpunk-inspired color scheme (Matrix green, cyan, magenta)
- **Informative**: More detailed than default system monitors
- **Fast**: Updates every 2 seconds
- **Free**: No cost, no ads, no tracking

## What You'll See

### Main Display
- A progress bar showing total CPU usage across all cores
- Current frequency in GHz and total core count
- Memory usage bar with GB values

### Top Processes
Each of the 5 most active programs shows:
- Program name
- CPU usage (percentage)
- Memory usage (MB or GB)
- Color-coded visual bar

### Smart Colors
The widget changes colors based on load:
- **Bright Green** (< 50%) - System running smoothly
- **Orange/Yellow** (50-80%) - Working hard, but fine
- **Red** (> 80%) - High load, might want to investigate

## Requirements

- KDE Plasma 6.0 or newer
- Python 3.x (already installed on most Linux systems)
- `psutil` Python package (install with: `pip install psutil`)

## Installation (Quick Start)

```bash
# 1. Install the dependency
pip install psutil

# 2. Install the widget
plasmapkg2 --install cpu-monitor.plasmoid

# 3. Add to desktop
# Right-click desktop → Add Widgets → Search "CPU Monitor" → Drag to desktop
```

That's it! Your widget is ready to use.

## Screenshots

![CPU Monitor Widget](screenshot.png)

*Live CPU and memory monitoring with colorful, easy-to-read bars*

## Who Made This?

Created by Alan for the KDE Plasma community. Built with Qt/QML and Python.

## Want More Details?

See [README.md](README.md) for:
- Full installation instructions
- Customization options
- Technical documentation
- Troubleshooting guide
- Development information

## License

Free to use, modify, and share. No restrictions.

---

**Enjoy monitoring your system in style!** 🚀
