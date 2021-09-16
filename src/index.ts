// ref:
// - https://umijs.org/plugins/api
import { IApi } from '@umijs/types';
import { IRoute } from '@umijs/core';
import _ from '@umijs/deps/compiled/lodash';
import { utils } from 'umi';
import { readFileSync } from 'fs';
import { join } from 'path';

const add404 = (routes: IRoute[]) =>
  routes.push({
    name: '页面未找到',
    component: '@@/plugin-panel-tabs/Result/404',
    wrappers: ['@@/plugin-panel-tabs/Wrappers/PanelTabsWrapper'],
  });

const generatorWrappers = (useAuth: boolean) => {
  if (useAuth) {
    return ['@@/plugin-panel-tabs/Wrappers/PanelTabsAndRouteAuthWrapper'];
  }
  return ['@@/plugin-panel-tabs/Wrappers/PanelTabsWrapper'];
};

const modifyRoutes = (
  routes: IRoute[],
  topRoute: boolean,
  use404: boolean,
  useAuth: boolean,
) => {
  routes.forEach((x) => {
    if (x.hideInPanelTab !== true && x.name) {
      if (x.wrappers && x.wrappers.length > 0) {
        x.wrappers.push(...generatorWrappers(useAuth));
      } else {
        x.wrappers = generatorWrappers(useAuth);
      }
    }
    if (x.routes) {
      x.routes = modifyRoutes(x.routes, false, use404, useAuth);
    }
  });
  if (!topRoute) {
    if (use404) {
      add404(routes);
    }
  }
  return routes;
};

export default function (api: IApi) {
  api.describe({
    key: 'panelTab',
    config: {
      default: {
        use404: true,
        useAuth: false,
      },
      schema(joi) {
        return joi.object({
          use404: joi.boolean(),
          useAuth: joi.boolean(),
        });
      },
      onChange: api.ConfigChangeType.regenerateTmpFiles,
    },
    enableBy: api.EnableBy.register,
  });

  api.addDepInfo(() => {
    const pkg = require('../package.json');
    return [
      {
        name: 'umi-plugin-keep-alive',
        range:
          api.pkg.dependencies?.['umi-plugin-keep-alive'] ||
          api.pkg.devDependencies?.['umi-plugin-keep-alive'] ||
          pkg.peerDependencies['umi-plugin-keep-alive'],
      },
    ];
  });
  api.modifyRoutes((routes: IRoute[]) =>
    modifyRoutes(
      _.clone(routes),
      true,
      api.config.panelTab.use404,
      api.config.panelTab.useAuth,
    ),
  );
  api.addUmiExports(() => [
    {
      exportAll: true,
      source: '../plugin-panel-tabs',
    },
  ]);
  api.onGenerateFiles(async () => {
    api.writeTmpFile({
      path: 'plugin-panel-tabs/index.ts',
      content: utils.Mustache.render(
        readFileSync(join(__dirname, 'index.ts.tpl'), 'utf-8'),
        {},
      ),
    });
    api.writeTmpFile({
      path: 'plugin-panel-tabs/PanelTabs/index.tsx',
      content: utils.Mustache.render(
        readFileSync(join(__dirname, 'PanelTabs', 'index.tsx.tpl'), 'utf-8'),
        {},
      ),
    });
    api.writeTmpFile({
      path: 'plugin-panel-tabs/PanelTabs/PanelTab.tsx',
      content: utils.Mustache.render(
        readFileSync(join(__dirname, 'PanelTabs', 'PanelTab.tsx.tpl'), 'utf-8'),
        {},
      ),
    });
    api.writeTmpFile({
      path: 'plugin-panel-tabs/PanelTabs/PanelTabHook.ts',
      content: utils.Mustache.render(
        readFileSync(
          join(__dirname, 'PanelTabs', 'PanelTabHook.ts.tpl'),
          'utf-8',
        ),
        {},
      ),
    });
    api.writeTmpFile({
      path: 'plugin-panel-tabs/Wrappers/PanelTabsWrapper.tsx',
      content: utils.Mustache.render(
        readFileSync(
          join(__dirname, 'Wrappers', 'PanelTabsWrapper.tsx.tpl'),
          'utf-8',
        ),
        {},
      ),
    });
    api.writeTmpFile({
      path: 'plugin-panel-tabs/Wrappers/PanelTabsAndRouteAuthWrapper.tsx',
      content: utils.Mustache.render(
        readFileSync(
          join(__dirname, 'Wrappers', 'PanelTabsAndRouteAuthWrapper.tsx.tpl'),
          'utf-8',
        ),
        {},
      ),
    });
    api.writeTmpFile({
      path: 'plugin-panel-tabs/Wrappers/RouteAuthWrapper.tsx',
      content: utils.Mustache.render(
        readFileSync(
          join(__dirname, 'Wrappers', 'RouteAuthWrapper.tsx.tpl'),
          'utf-8',
        ),
        {},
      ),
    });
    api.writeTmpFile({
      path: 'plugin-panel-tabs/Result/404.tsx',
      content: utils.Mustache.render(
        readFileSync(join(__dirname, 'Result', '404.tsx.tpl'), 'utf-8'),
        {},
      ),
    });
  });
}
