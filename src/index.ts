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

const modifyRoutes = (
  routes: IRoute[],
  topRoute: boolean,
  use404: boolean = false,
) => {
  routes.forEach((x) => {
    if (x.noUsePanelTab !== true && x.name) {
      if (x.wrappers && x.wrappers.length > 0) {
        x.wrappers.push('@@/plugin-panel-tabs/Wrappers/PanelTabsWrapper');
      } else {
        x.wrappers = ['@@/plugin-panel-tabs/Wrappers/PanelTabsWrapper'];
      }
    }
    if (x.routes) {
      x.routes = modifyRoutes(x.routes, false, use404);
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
      },
      schema(joi) {
        return joi.object({
          use403: joi.boolean(),
          use404: joi.boolean(),
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
    modifyRoutes(_.clone(routes), true, api.config.panelTab.use404),
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
      path: 'plugin-panel-tabs/Result/404.tsx',
      content: utils.Mustache.render(
        readFileSync(join(__dirname, 'Result', '404.tsx.tpl'), 'utf-8'),
        {},
      ),
    });
  });
}
