# fireboom 启动脚本

## 适用范围

当前脚本仅适用于 mac 系统，其他系统后续支持

## 安装

```shell
git clone https://github.com/fireboomio/fb-init-simple.git
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

## 调试钩子

1. 前往配置修改钩子的启动模式为默认不启动（TODO:待实现该配置）

2. 打开./wundergraph/package.json 文件

3. 鼠标悬浮在 scripts.hook 上，点击`调试脚本`

4. 前往 wundergraph/.wundergraph/generated/bundle/server.js 中打断点

## 更新

```shell
./fireboom.sh update
```

## 展示版本

```shell
./fireboom.sh version
```

## 快速使用

### 1. 设置数据源

- 数据源
  - GraphQL: https://countries.trevorblades.com

### 2. 新建 API

API 名称：GetCountry

```gql
query MyQuery($code: ID!) @rbac(requireMatchAll: [REVIEWER]) {
  country: countries_country(code: $code) {
    capital
    code
    currency
    emoji
    emojiU
    native
    phone
    name
  }
}
```

### 3. 扩展 API

mutatingPostResolve.ts

```typescript
import type { Context } from "@wundergraph/sdk";
import type { User } from "generated/wundergraph.server";
import type { InternalClient } from "generated/wundergraph.internal.client";
import { InjectedGetCountryInput, GetCountryResponse } from "generated/models";

// 在左侧引入当前包
import axios from "axios";

export default async function mutatingPostResolve(
  ctx: Context<User, InternalClient>,
  input: InjectedGetCountryInput,
  response: GetCountryResponse
): Promise<GetCountryResponse> {
  // TODO: 在此处添加代码
  var country = response.data?.country;
  if (country) {
    country.phone = "fireboom/test"; //这里可以修改返回值
  }
  ctx.log.info("test");

  //触发一个post请求，给企业机器人发送一个消息
  var res = await axios.post(
    "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=69aa957f-7c05-49b3-9e9d-8859a53ea692",
    {
      msgtype: "markdown",
      markdown: {
        content: `<font color="warning">${
          ctx.clientRequest.method
        }</font>/n输入：${JSON.stringify(input)}/n响应：${JSON.stringify(
          response
        )}`,
      },
    }
  );
  ctx.log.info("mutatingPostResolve SUCCESS:", res.data);
  return response;
}
```

### 4. 身份验证（待完善提供前端示例）

### 5. 角色鉴权（待完善提供前端示例）

## TODO

[ ] 启动脚本支持 linux 和 windows

[ ] 优化目录结构

    [ ] OIDC 相关的目录整理在一起（如 oauth_default.db 和 oidc、oauth 等）

    [ ] fireBooom-DB和static/config以及static/operateapi等合并在一起？

[ ] 提供前端示例（启动后用来走完整的登录鉴权逻辑）

[ ] gitpod 支持（提供跳转连接，一键运行到 gitpod 中）
