# fireboom 启动脚本

## 适用范围

当前脚本仅适用于 mac 系统，其他系统后续支持

## 安装

```shell
git clone https://github.com/sx19990201/fireboom-init.git
cd fireboom-init
./fireboom.sh init
```

## 运行

```shell
./fireboom.sh
# or run "./fireboom.sh init" to re-init
```

启动成功日志：

```sh
⇨ http server started on [::]:9123
```

打开控制面板

```
http://localhost:9123
```

## 更新

```shell
./fireboom.sh update
```

## 展示版本

```shell
./fireboom.sh version
```

## 快速使用

1. 设置数据源

2. 新建 API

3. 扩展 API

4. 身份验证

5. 角色鉴权（待完善）

## TODO

[ ] 启动脚本支持 linux 和 windows

[ ] 优化目录结构

    [ ] OIDC 相关的目录整理在一起（如 oauth_default.db 和 oidc、oauth 等）

[ ] 提供前端示例（启动后用来走完整的登录鉴权逻辑）

[ ] gitpod 支持（提供跳转连接，一键运行到 gitpod 中）
