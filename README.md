# umi-plugin-panel-tabs

[![NPM version](https://img.shields.io/npm/v/umi-plugin-panel-tabs.svg?style=flat)](https://npmjs.org/package/umi-plugin-panel-tabs) [![NPM downloads](http://img.shields.io/npm/dm/umi-plugin-panel-tabs.svg?style=flat)](https://npmjs.org/package/umi-plugin-panel-tabs)

## 如何使用

安装依赖即可, 以`umi-plugin`开头的插件会被自动加载

## 配置项

在 config/config.ts - defineConfig 方法中进行配置
```js
export default defineConfig({
  panelTab: {
    use404: true,
    useAuth: true,
  },
})
```

配置项 | 类型 | 默认值 | 说明
 --- | --- | --- | ---
use404 | boolean | true | 使用内置的404页面, 该页面会在tab中显示
useAuth | boolean | false | 使用内置的403页面, 加载内置的权限判断wrapper, 该页面会在tab中显示

## 额外的配置项

在`config/route.ts`中所有具有name属性的路由默认都会在标签页中显示, 如果不希望在标签也中出现此路由有两种方式:
1. 移除route中此路由配置的name属性
2. 在该路由中配置属性`hideInPanelTab`, 将其设置为`true`, 此路由就不会在标签页中显示
```js
export default [
 {
   path: '/welcome',
   name: 'welcome',
   icon: 'smile',
   component: './Welcome',
   hideInPanelTab: true,
 }
];
```

## LICENSE

MIT
