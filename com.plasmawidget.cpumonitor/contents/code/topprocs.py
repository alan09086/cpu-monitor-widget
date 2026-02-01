#!/usr/bin/env python3
"""
Lightweight top processes monitor using /proc directly.
Only handles process CPU usage - main stats use ksysguard sensors.
"""
import json
import os
import time

def get_process_cpu_times(pid):
    """Read process CPU times from /proc/[pid]/stat"""
    try:
        with open(f'/proc/{pid}/stat', 'r') as f:
            stat = f.read()
        start = stat.index('(')
        end = stat.rindex(')')
        name = stat[start+1:end]
        parts = stat[end+2:].split()
        utime = int(parts[11])
        stime = int(parts[12])
        return name, utime + stime
    except:
        return None, 0

def get_process_memory(pid):
    """Read process memory from /proc/[pid]/statm"""
    try:
        with open(f'/proc/{pid}/statm', 'r') as f:
            parts = f.read().split()
        rss_pages = int(parts[1])
        return rss_pages * 4096 / (1024 * 1024)
    except:
        return 0

def main():
    cpu_count = os.cpu_count() or 1
    clk_tck = os.sysconf('SC_CLK_TCK')

    # Get list of PIDs
    pids = [int(p) for p in os.listdir('/proc') if p.isdigit()]

    # First pass: collect initial CPU times
    proc_times1 = {}
    for pid in pids:
        name, cpu_time = get_process_cpu_times(pid)
        if name:
            proc_times1[pid] = (name, cpu_time)

    # Brief measurement interval
    time.sleep(0.1)

    # Second pass: calculate CPU percentages
    process_data = []
    for pid, (name, time1) in proc_times1.items():
        _, time2 = get_process_cpu_times(pid)
        if time2:
            cpu_delta = time2 - time1
            cpu_pct = (cpu_delta / clk_tck) / 0.1 * 100 / cpu_count
            mem_mb = get_process_memory(pid)
            process_data.append({
                'name': name[:20],
                'cpu_percent': round(cpu_pct, 1),
                'mem_mb': round(mem_mb, 1)
            })

    # Sort and return top 5
    top_processes = sorted(process_data, key=lambda x: x['cpu_percent'], reverse=True)[:5]
    print(json.dumps(top_processes))

if __name__ == '__main__':
    main()
