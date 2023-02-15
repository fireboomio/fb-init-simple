# 飞布介绍

## 是什么？

飞布是下一代 API 开发平台，灵活开放、多语言兼容、简单易学，对标 Firebase，但无供应商锁定。 它帮助你构建生产级 WEB API，但无需花时间重复 coding。

产品愿景：极致开发体验，`飞速布署`应用！

[前往官网->](https://www.fireboom.io/)

## 为什么？

飞布主要面向后端开发者，核心目标是快速构建 API，将开发者从重复工作中解放出来，专注更有价值的业务逻辑。

首先，业务型 Web 应用 80% 由样板代码组成，例如增删改查，权限管理，用户管理，消息或者通知。一次又一次的建立这些功能，不仅乏味，而且减少了我们集中在软件与竞争对手不同之处的时间。

- 增删改查：绝大多数偏业务型项目，都是增删改查，复杂点的包括关联查询等
- 验证鉴权：所有生产型项目都需要身份验证和身份鉴权，且实现该功能需要耗费大量人力
- 文件存储：绝大数应用都需要文件存储，用来存储用户头像等，实现文件上传和管理也较为繁琐

其次，除了重复性工作，后端开发者往往还要实现非功能需求，这些需求不仅消耗大量精力，而且有一定的技术门槛。

- N+1 缓存：避免关联查询时重复查询数据的问题，提高应用性能
- 实时推送：对于 IM 聊天等应用，需要实现实时推送功能（传统方式需要使用 websocket 等技术）

最后，当前市场上存在诸多 API 开发框架，但这些框架都基于某种特定编程语言实现，需要开发者掌握特定编程语言才能上手使用。

## 怎么做？

针对上述问题，飞布采用完全不同的思路。飞布采用声明式开发方式，它以 API 为中心，将所有数据抽象为 API，包括 REST API，GraphQL API ，数据库甚至消息队列等，通过统一协议 GraphQL 把他们聚合为“超图”，同时通过可视化界面，从“超图”中选择子集 Operation 作为函数签名，并将其编译为 REST-API。开发者通过界面配置，即可开启某 API 的的缓存或实时推送功能。此外，飞布基于 HTTP 协议实现了 HOOKS 机制，方便开发者采用任何喜欢的语言实现自定义逻辑。

# 在线体验

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/fireboomio/fb-init-simple)

[gitpod 介绍](https://juejin.cn/post/6844903773878386701)

注意：启动成功后，在 gitpod 底部切换到`PORTS`面板，选择 `9123` 端口打开即可

# 本地启动

## 安装

```shell
curl -fsSL https://www.fireboom.io/install.sh | bash -s my-fireboom-project
```

## 运行

```shell
./fireboom dev
```

启动成功日志：

```sh
Web server started on http://localhost:9123
```

打开控制面板

[http://localhost:9123](http://localhost:9123)

## 更新

```shell
# 同时更新命令行和前端资源
curl -fsSL https://www.fireboom.io/update.sh | bash
```

## 钩子服务

```shell
# 依赖安装
./hook.sh install

# 开发时运行
./hook.sh dev

# 生产时运行
./hook.sh start
```

## 快速使用

### 1. 设置数据源

- 数据源
  - GraphQL: https://countries.trevorblades.com

![添加数据源](https://fireboom.oss-cn-hangzhou.aliyuncs.com/img/01-datasource.png)

### 2. 新建 API

![新建API](https://fireboom.oss-cn-hangzhou.aliyuncs.com/img/02-api_create.png)
API 名称：GetCountry

```gql
query MyQuery($code: ID!) {
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

![编写API钩子](https://fireboom.oss-cn-hangzhou.aliyuncs.com/img/02-api_hooks.png)
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

![开启身份验证](https://fireboom.oss-cn-hangzhou.aliyuncs.com/img/02-api_auth.png)

### 5. 角色鉴权（待完善提供前端示例）

![开启角色鉴权](https://fireboom.oss-cn-hangzhou.aliyuncs.com/img/02-api_rbac.png)

### 6.实时 API

![实时API](https://fireboom.oss-cn-hangzhou.aliyuncs.com/img/02-api_live.png)

实时推送数据源：https://hasura.io/learn/graphql/graphiql

```
> graphql 端点:https://hasura.io/learn/graphql
> 请求头：
> Authorization:xxxxxxxxx(前往查看↑)
> content-type:application/json
```

```graphql
# 在测试数据源中插入一条todo，可以看到当前端点会实时拿到新数据
subscription MySubscription {
  todo_todos(order_by: { id: desc }, limit: 10) {
    id
    is_completed
    is_public
  }
}

# 新开页签插入数据
# mutation {
#   insert_todos_one(object: {is_public: false, title: "sssss"}) {
#     id
#   }
# }
```

### 7.其他特性

![API其他特性](https://fireboom.oss-cn-hangzhou.aliyuncs.com/img/02-api_feature.png)

## TODO

[x] 启动脚本支持 linux 和 windows

[ ] 优化目录结构

    [] OIDC 相关的目录整理在一起（如 oauth_default.db 和 oidc、oauth 等）

    [] fireBooom-DB和static/config以及static/operateapi等合并在一起？

[ ] 提供前端示例（启动后用来走完整的登录鉴权逻辑）

[x] gitpod 支持（提供跳转连接，一键运行到 gitpod 中）

[ ] 内置不同类型的数据库和示例数据
