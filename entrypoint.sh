#!/usr/bin/env sh

# 设置时区
export TZ=${TZ:-Asia/Shanghai}

# 设置默认环境变量
export UUID=${UUID:-9afd1229-b893-40c1-84dd-51e7ce204913}
export CFIP=${CFIP:-cdns.doon.eu.org}
export CFPORT=${CFPORT:-443}
export ARGO_PORT=${ARGO_PORT:-8001}
export FILE_PATH=${FILE_PATH:-/app/tmp}
export PORT=${PORT:-3000}
export SUB_PATH=${SUB_PATH:-sub}

# 创建临时目录（如果不存在）
if [ ! -d "$FILE_PATH" ]; then
    mkdir -p $FILE_PATH
fi

# 如果有 .env.example 文件，复制为 .env（如果 .env 不存在）
# 注意：这个操作应该在 Dockerfile 中以 root 权限完成，这里只是检查
if [ -f "/app/.env.example" ] && [ ! -f "/app/.env" ]; then
    echo "Warning: .env file not found. Please ensure it was created during Docker build."
    echo "You can manually copy .env.example to .env and customize it."
fi

# 显示启动信息
echo "==================================="
echo "XY Proxy Server Starting..."
echo "Timezone: $TZ"
echo "UUID: $UUID"
echo "Port: $PORT"
echo "Temp Path: $FILE_PATH"
echo "==================================="

# 执行传入的命令
exec "$@"
