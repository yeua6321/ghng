FROM node:18-alpine AS builder

WORKDIR /app

# 复制 package 文件
COPY app/xy/package*.json ./

# 安装依赖
RUN npm ci --omit=dev

# 复制源代码
COPY app/xy/ ./

# 设置 start.sh 文件权限
RUN chmod +x /app/start.sh && \
    ls -la /app/start.sh

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

# 确保 start.sh 文件存在并设置权限
RUN test -f /app/start.sh || (echo "start.sh not found, copying manually" && exit 1) && \
    chmod +x /app/start.sh && \
    ls -la /app/start.sh && \
    echo "start.sh is ready"

# 创建 supervisor 日志目录（使用应用内目录，避免宿主挂载权限冲突）
RUN mkdir -p /app/logs /var/run

# 创建临时目录
RUN mkdir -p /app/tmp

# 复制 supervisor 配置到主配置文件，确保 supervisord 读取到我们自定义的 pidfile 路径
COPY app/supervisor/supervisord.conf /etc/supervisord.conf

# 创建非 root 用户
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs

# 复制启动脚本（在切换用户之前）
COPY entrypoint.sh /app/entrypoint.sh

# 设置启动脚本权限
RUN chmod +x /app/entrypoint.sh

# 创建 .env 文件（如果不存在）
RUN if [ -f "/app/.env.example" ] && [ ! -f "/app/.env" ]; then \
        cp /app/.env.example /app/.env && \
        echo "Created .env file from .env.example during build"; \
    fi

# 更改文件所有权（但保持启动脚本的执行权限）
RUN chown -R nodejs:nodejs /app && \
    chown -R nodejs:nodejs /app/logs /var/run && \
    chmod +x /app/start.sh && \
    chmod +x /app/entrypoint.sh && \
    # 预先创建 supervisord pid 文件并设置所有权，避免运行时权限问题
    touch /app/supervisord.pid && chown nodejs:nodejs /app/supervisord.pid

# 切换到非 root 用户
USER nodejs

# 暴露端口
EXPOSE 3000

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# 启动应用
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
