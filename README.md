# umi-plugin-panel-tabs

[![NPM version](https://img.shields.io/npm/v/umi-plugin-panel-tabs.svg?style=flat)](https://npmjs.org/package/umi-plugin-panel-tabs) [![NPM downloads](http://img.shields.io/npm/dm/umi-plugin-panel-tabs.svg?style=flat)](https://npmjs.org/package/umi-plugin-panel-tabs) [![Netlify Status](https://api.netlify.com/api/v1/badges/10453ec4-945e-41c7-844e-4e7e6a2027b2/deploy-status)](https://app.netlify.com/sites/vibrant-leakey-d5b34a/deploys)

## 演示地址 [https://vibrant-leakey-d5b34a.netlify.app]

![image](https://user-images.githubusercontent.com/12680972/147438313-e73a3148-1bc0-438a-9e6f-28d1bad8a25a.png)

![image](https://user-images.githubusercontent.com/12680972/147438343-a1999972-cd47-4959-8fb7-5ecbaa523ca3.png)

![image](https://user-images.githubusercontent.com/12680972/147438276-7cf13dad-1145-416b-a441-6d9bc3305431.png)

## 如何使用

安装依赖即可, 以`umi-plugin`开头的插件会被自动加载

## 配置项

在 config/config.ts - defineConfig 方法中进行配置

```js
export default defineConfig({
  panelTab: {
    use404: true,
    useAuth: true,
    autoI18n: true,
    tabsLimit: 10,
    tabsLimitWait: 500,
    tabsLimitWarnTitle: '提示',
    tabsLimitWarnContent: '您当前打开页面过多, 请关闭不使用的页面以减少卡顿!',
  },
});
```

| 配置项 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| use404 | boolean | true | 使用内置的 404 页面, 该页面会在 tab 中显示 |
| useAuth | boolean | false | 使用内置的 403 页面, 加载内置的权限判断 wrapper, 该页面会在 tab 中显示 |
| autoI18n | boolean | true | 自动开启国际化, 仅当 ant-design-pro 的 locale 不为 false 且不为空时生效 |
| tabsLimit | number | 10 | 用户打开多少页签时弹出提示 |
| tabsLimitWait | number | 500 | 页签数量检查防抖时间, 如果一次弹出了多个提示框, 可以适当延长此时间, 单位毫秒 |
| tabsLimitWarnTitle | string | 提示 | [配置国际化后此项不生效] 页签数量超限弹窗的标题 |
| tabsLimitWarnContent | string | 您当前打开页面过多, 请关闭不使用的页面以减少卡顿! | [配置国际化后此项不生效] 页签数量超限弹窗的内容 |

## 国际化配置项

| 国际化配置 key | 国际化配置 value |
| --- | --- |
| panelTab.403.subTitle | 抱歉，你无权访问该页面 |
| panelTab.404.subTitle | 抱歉，您访问的页面不存在 |
| panelTab.closePage | 关闭页面 |
| panelTab.close | 关闭 |
| panelTab.closeOther | 关闭其他 |
| panelTab.closeAll | 关闭所有 |
| panelTab.refresh | 刷新 |
| panelTab.tabsLimitWarnTitle | 提示 |
| panelTab.tabsLimitWarnContent | 您当前打开页面过多, 请关闭不使用的页面以减少卡顿! |

## 额外的配置项

在`config/route.ts`中所有具有 name 属性的路由默认都会在标签页中显示, 如果不希望在标签也中出现此路由有两种方式:

1. 移除 route 中此路由配置的 name 属性
2. 在该路由中配置属性`hideInPanelTab`, 将其设置为`true`, 此路由就不会在标签页中显示
3. 开启后路由里配置的菜单名会被当作菜单名国际化的 key，插件会去 locales 文件中查找 menu.[key]对应的文案，默认值为该 key, 配置可参照 [ant-design-pro 菜单国际化](https://pro.ant.design/zh-CN/docs/layout#%E8%8F%9C%E5%8D%95%E5%9B%BD%E9%99%85%E5%8C%96)

```js
export default [
  {
    path: '/welcome',
    name: 'welcome',
    icon: 'smile',
    component: './Welcome',
    hideInPanelTab: true,
  },
];
```

## 自定义场景使用

提供了 hook 方便在其他组件中使用

```tsx
import { Button, Result } from 'antd';
import React from 'react';
import { usePanelTab } from 'umi';

export default () => {
  const {
    close,
    closeCurrent,
    closeOther,
    refresh,
    refreshCurrent,
    closeAll,
  } = usePanelTab();
  return (
    <Result
      status="404"
      title="404"
      subTitle="抱歉，您访问的页面不存在。"
      extra={
        <Button type="primary" onClick={closeCurrent}>
          关闭页面
        </Button>
      }
    />
  );
};
```

## 常见问题

Q: 有示例代码吗?

A: 演示代码在 [demo 分支](https://github.com/fangzhengjin/umi-plugin-panel-tabs/tree/demo)

Q: 配置后标签栏位置出现了偏移

A: 请在 app.tsx 的 layout 方法中添加 `disableContentMargin: true` 配置

Q: 登录页出现了标签页怎么办？

A: 登录页不要在路由写 name, 有 name 就有标签页，或者在 name 下方再加一个配置，hideInPanelTab: true,也可以在标签中隐藏

Q: 需要自定义控制缓存?

A: 请参阅依赖 [umi-plugin-keep-alive](https://github.com/alitajs/umi-plugin-keep-alive) 与 [react-activation](https://github.com/CJY0208/react-activation)

## LICENSE

MIT
