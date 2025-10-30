@echo off
chcp 65001 >nul
title XY Proxy Server

echo Starting XY Proxy Server...

REM 检查 Node.js 是否安装
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Node.js is not installed. Please install Node.js first.
    pause
    exit /b 1
)

REM 检查 npm 是否安装
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: npm is not installed. Please install npm first.
    pause
    exit /b 1
)

REM 检查是否已安装依赖
if not exist "node_modules" (
    echo Installing dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo Error: Failed to install dependencies.
        pause
        exit /b 1
    )
)

REM 检查环境变量文件
if not exist ".env" (
    echo Warning: .env file not found. Using default environment variables.
    echo You can copy .env.example to .env and customize it.
)

REM 启动服务器
echo Starting server...
npm start

pause