#!/bin/sh

# 检查 proxy 是否在运行
if pidof proxy >/dev/null 2>&1; then
    echo "running"
    exit 0
else
    echo "stopped"
    exit 1
fi