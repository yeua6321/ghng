# XY 代理服务器

这是一个基于 Node.js Express 的代理服务器，支持多种代理协议和自动配置功能。

## 功能特性

- 支持 VLESS、VMess、Trojan 等代理协议
- 自动下载和配置依赖文件
- 支持 Cloudflare Argo 隧道
- 支持哪吒监控
- 自动上传节点或订阅
- 自动保活功能
- 跨平台支持 (ARM/AMD)

## 安装和使用

### 1. 安装依赖

```bash
npm install
```

### 2. 配置环境变量

复制 `.env.example` 文件为 `.env` 并根据需要修改配置：

```bash
# Linux/macOS
cp .env.example .env

# Windows
copy .env.example .env
```

### 3. 启动服务器

#### 方法一：使用启动脚本（推荐）

```bash
# Linux/macOS
./start.sh

# Windows
start.bat
```

#### 方法二：使用 npm 命令

```bash
# 生产环境
npm start

# 开发环境（需要安装 nodemon）
npm run dev
```

启动脚本会自动检查依赖并安装缺失的包，然后启动服务器。

## 环境变量说明

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `UPLOAD_URL` | 节点或订阅自动上传地址 | 空 |
| `PROJECT_URL` | 项目分配的URL | 空 |
| `AUTO_ACCESS` | 是否开启自动保活 | false |
| `FILE_PATH` | 运行目录 | ./tmp |
| `SUB_PATH` | 订阅路径 | sub |
| `SERVER_PORT` | HTTP服务端口 | 3000 |
| `UUID` | 用户UUID | 9afd1229-b893-40c1-84dd-51e7ce204913 |
| `NEZHA_SERVER` | 哪吒服务器地址 | 空 |
| `NEZHA_PORT` | 哪吒端口 | 空 |
| `NEZHA_KEY` | 哪吒密钥 | 空 |
| `ARGO_DOMAIN` | 固定隧道域名 | 空 |
| `ARGO_AUTH` | 固定隧道密钥 | 空 |
| `ARGO_PORT` | 固定隧道端口 | 8001 |
| `CFIP` | 优选域名或IP | cdns.doon.eu.org |
| `CFPORT` | 优选端口 | 443 |
| `NAME` | 节点名称 | 空 |

## API 接口

### 根路径
```
GET /
```
返回 "Hello world!"

### 订阅路径
```
GET /{SUB_PATH}
```
返回 base64 编码的订阅信息

## 项目结构

```
app/xy/
├── server.js          # 主服务器文件
├── package.json        # 项目依赖配置
├── config.json        # 配置文件（会被动态生成）
├── .env.example       # 环境变量示例
└── README.md          # 项目说明文档
```

## 项目文件说明

- `server.js` - 主服务器文件
- `package.json` - 项目依赖配置
- `.env.example` - 环境变量示例文件
- `start.sh` - Linux/macOS 启动脚本
- `start.bat` - Windows 启动脚本
- `README.md` - 项目说明文档

## 注意事项

### 本地运行注意事项
1. 服务器会自动创建临时目录并下载必要的依赖文件
2. 配置文件会在运行时动态生成
3. 90秒后会自动清理临时文件
4. 支持跨平台运行，会自动检测系统架构
5. Windows 系统需要确保有 PowerShell 支持
6. Linux/Unix 系统需要确保已安装 curl 命令
7. 首次运行时会自动下载依赖文件，请确保网络连接正常

### Docker 运行注意事项
1. Docker 镜像基于 Alpine Linux，体积小且安全
2. 容器内已预装所有必要的系统依赖
3. 使用非 root 用户运行，提高安全性
4. 支持健康检查，便于监控
5. 日志文件输出到 `/var/log/supervisor/` 目录
6. 建议通过 volume 挂载日志目录以便持久化

### 性能优化
1. 使用多阶段构建减少镜像大小
2. 启用构建缓存提高构建速度
3. 支持 AMD64 和 ARM64 架构
4. 使用 Node.js Alpine 镜像优化性能

## 许可证

ISC