# umi-plugin-panel-tabs

[![NPM version](https://img.shields.io/npm/v/umi-plugin-panel-tabs.svg?style=flat)](https://npmjs.org/package/umi-plugin-panel-tabs) [![NPM downloads](http://img.shields.io/npm/dm/umi-plugin-panel-tabs.svg?style=flat)](https://npmjs.org/package/umi-plugin-panel-tabs)

## Usage

安装依赖即可, 以`umi-plugin`开头的插件会被自动加载

## Options

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

## LICENSE

MIT
