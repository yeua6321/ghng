FROM node:18-alpine AS builder

WORKDIR /app

# 复制 package 文件
COPY app/xy/package*.json ./

# 安装依赖
RUN npm ci --only=production

# 复制源代码
COPY app/xy/ ./

# 设置权限
RUN chmod +x start.sh

############################################################

FROM node:18-alpine

LABEL org.opencontainers.image.source="https://github.com/vevc/one-node"

# 设置环境变量
ENV TZ=Asia/Shanghai \
    NODE_ENV=production \
    FILE_PATH=/app/tmp \
    PORT=3000

# 安装系统依赖
RUN apk add --no-cache \
    tzdata \
    curl \
    ca-certificates \
    wget \
    unzip \
    supervisor \
    && rm -rf /var/cache/apk/*

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 创建应用目录
WORKDIR /app

# 从构建阶段复制文件
COPY --from=builder /app ./

# 创建临时目录
RUN mkdir -p /app/tmp && chmod 777 /app/tmp

# 复制 supervisor 配置
COPY app/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 创建非 root 用户
RUN addgroup -g 1000 -S nodejs && \
    adduser -S nodejs -u 1000

# 更改文件所有权
RUN chown -R nodejs:nodejs /app

# 切换到非 root 用户
USER nodejs

# 暴露端口
EXPOSE 3000

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# 启动应用
ENTRYPOINT ["/app/start.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
