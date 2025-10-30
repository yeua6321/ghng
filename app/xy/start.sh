#!/bin/bash

# XY 代理服务器启动脚本

echo "Starting XY Proxy Server..."

# 检查 Node.js 是否安装
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed. Please install Node.js first."
    exit 1
fi

# 检查 npm 是否安装
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed. Please install npm first."
    exit 1
fi

# 检查是否已安装依赖
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install dependencies."
        exit 1
    fi
fi

# 检查环境变量文件
if [ ! -f ".env" ]; then
    echo "Warning: .env file not found. Using default environment variables."
    echo "You can copy .env.example to .env and customize it."
fi

# 启动服务器
echo "Starting server..."
npm start