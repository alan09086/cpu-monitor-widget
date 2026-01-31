#!/usr/bin/env python3
import psutil
import json
import time

def get_cpu_info():
    # Get CPU usage percentage
    cpu_percent = psutil.cpu_percent(interval=0.5)

    # Get CPU frequency
    cpu_freq = psutil.cpu_freq()
    freq_current = cpu_freq.current if cpu_freq else 0

    # Get memory info
    mem = psutil.virtual_memory()
    mem_total_gb = mem.total / (1024 ** 3)
    mem_used_gb = mem.used / (1024 ** 3)
    mem_percent = mem.percent

    # Calculate total CPU cores
    cpu_count = psutil.cpu_count()

    # Get top 5 processes by CPU usage
    # First pass: start measuring CPU for all processes
    processes = []
    for proc in psutil.process_iter(['pid', 'name']):
        try:
            proc.cpu_percent()  # Start measurement
            processes.append(proc)
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass

    # Wait a bit for measurement
    time.sleep(0.1)

    # Second pass: get actual CPU percentages and memory usage
    process_data = []
    for proc in processes:
        try:
            cpu_pct = proc.cpu_percent()
            mem_info = proc.memory_info()
            mem_mb = mem_info.rss / (1024 ** 2)  # Convert to MB
            # Normalize to 0-100% range by dividing by number of cores
            normalized_pct = cpu_pct / cpu_count
            process_data.append({
                'name': proc.info['name'],
                'cpu_percent': normalized_pct,
                'mem_mb': round(mem_mb, 1)
            })
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            pass

    # Sort by CPU usage and get top 5
    top_processes = sorted(process_data, key=lambda x: x['cpu_percent'] or 0, reverse=True)[:5]

    result = {
        'cpu_percent': round(cpu_percent, 1),
        'cpu_freq': round(freq_current, 0),
        'cpu_count': cpu_count,
        'mem_total_gb': round(mem_total_gb, 1),
        'mem_used_gb': round(mem_used_gb, 1),
        'mem_percent': round(mem_percent, 1),
        'top_processes': top_processes
    }

    print(json.dumps(result))

if __name__ == '__main__':
    get_cpu_info()
