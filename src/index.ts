import { IApi, IRoute } from 'umi';
import { readFileSync } from 'fs';
import { join } from 'path';
// @ts-ignore
import { lodash, Mustache } from '@umijs/utils';

const ENCODING = 'utf-8';

export default function (api: IApi) {
  const isUmi4 = typeof api.modifyAppData === 'function';

  const UMI3_DIR = 'plugin-panel-tabs';
  const UMI4_DIR = 'plugin-panelTab';

  const add404 = (routes: any[]) =>
    routes.push({
      name: '页面未找到',
      component: `@@/${isUmi4 ? UMI4_DIR : UMI3_DIR}/Result/404`,
      wrappers: [
        `@@/${isUmi4 ? UMI4_DIR : UMI3_DIR}/Wrappers/PanelTabsWrapper`,
      ],
    });

  const generatorWrappers = (useAuth: boolean) => {
    if (useAuth) {
      return [
        `@@/${
          isUmi4 ? UMI4_DIR : UMI3_DIR
        }/Wrappers/PanelTabsAndRouteAuthWrapper`,
      ];
    }
    return [`@@/${isUmi4 ? UMI4_DIR : UMI3_DIR}/Wrappers/PanelTabsWrapper`];
  };

  const modifyRoutes = (
    routes: IRoute[],
    topRoute: boolean,
    use404: boolean,
    useAuth: boolean,
    intlMenuKey: string,
  ) => {
    routes.forEach((x) => {
      if (x.hideInPanelTab !== true && x.name) {
        x.intlMenuKey = `${intlMenuKey}.${x.name}`;
        if (x.wrappers && x.wrappers.length > 0) {
          x.wrappers.push(...generatorWrappers(useAuth));
        } else {
          x.wrappers = generatorWrappers(useAuth);
        }
      }
      if (x.routes) {
        x.routes = modifyRoutes(
          x.routes,
          false,
          use404,
          useAuth,
          x.intlMenuKey || intlMenuKey,
        );
      }
    });
    if (!topRoute) {
      if (use404) {
        add404(routes);
      }
    }
    return routes;
  };

  api.describe({
    key: 'panelTab',
    config: {
      default: {
        use404: true,
        useAuth: false,
        autoI18n: false,
        tabsBarBackgroundColor: '#FFFFFF',
        tabsTagColor: '#1890ff',
        tabsLimit: 10,
        tabsLimitWait: 500,
        tabsLimitWarnTitle: '提示',
        tabsLimitWarnContent:
          '您当前打开页面过多, 请关闭不使用的页面以减少卡顿!',
        closeAllConfirm: false,
        closeAllConfirmTitle: '提示',
        closeAllConfirmContent: '确认要关闭所有标签吗?',
      },
      schema(joi) {
        return joi.object({
          use404: joi.boolean(),
          useAuth: joi.boolean(),
          autoI18n: joi.boolean(),
          tabsBarBackgroundColor: joi.string(),
          tabsTagColor: joi.string(),
          tabsLimit: joi.number(),
          tabsLimitWait: joi.number(),
          tabsLimitWarnTitle: joi.string(),
          tabsLimitWarnContent: joi.string(),
          closeAllConfirm: joi.boolean(),
          closeAllConfirmTitle: joi.string(),
          closeAllConfirmContent: joi.string(),
        });
      },
      onChange: api.ConfigChangeType.regenerateTmpFiles,
    },
    enableBy: api.EnableBy.register,
  });

  api.modifyRoutes((record) => {
    Object.keys(record).forEach((id) => {
      record[id] = modifyRoutes(
        lodash.clone([record[id]]),
        true,
        api.config.panelTab.use404,
        api.config.panelTab.useAuth,
        'menu',
      )[0];
    });
    return record;
  });
  api.onGenerateFiles(async () => {
    api.writeTmpFile({
      path: `${isUmi4 ? '' : UMI3_DIR}index.ts`,
      content: Mustache.render(
        readFileSync(join(__dirname, 'index.ts.tpl'), ENCODING),
        {},
      ),
    });
    api.writeTmpFile({
      path: `${isUmi4 ? '' : UMI3_DIR}PanelTabs/index.tsx`,
      content: Mustache.render(
        readFileSync(join(__dirname, 'PanelTabs', 'index.tsx.tpl'), ENCODING),
        {
          ...api.config.panelTab,
          useI18n: api.userConfig?.locale && api.config.panelTab?.autoI18n,
        },
        {},
        ['{{{', '}}}'],
      ),
    });
    api.writeTmpFile({
      path: `${isUmi4 ? '' : UMI3_DIR}PanelTabs/PanelTab.tsx`,
      content: Mustache.render(
        readFileSync(
          join(__dirname, 'PanelTabs', 'PanelTab.tsx.tpl'),
          ENCODING,
        ),
        {
          ...api.config.panelTab,
          useI18n: api.userConfig?.locale && api.config.panelTab?.autoI18n,
          useAntPrimaryColor:
            // 如果没配置标签颜色，则使用主题色
            api.config.panelTab?.tabsTagColor?.startsWith('#') !== true,
        },
        {},
        ['{{{', '}}}'],
      ),
    });
    api.writeTmpFile({
      path: `${isUmi4 ? '' : UMI3_DIR}PanelTabs/PanelTabHook.ts`,
      content: Mustache.render(
        readFileSync(
          join(__dirname, 'PanelTabs', 'PanelTabHook.ts.tpl'),
          ENCODING,
        ),
        {
          ...api.config.panelTab,
          useI18n: api.userConfig?.locale && api.config.panelTab?.autoI18n,
        },
        {},
        ['{{{', '}}}'],
      ),
    });
    api.writeTmpFile({
      path: `${isUmi4 ? '' : UMI3_DIR}Wrappers/PanelTabsWrapper.tsx`,
      content: Mustache.render(
        readFileSync(
          join(__dirname, 'Wrappers', 'PanelTabsWrapper.tsx.tpl'),
          ENCODING,
        ),
        {
          ...api.config.panelTab,
          useI18n: api.userConfig?.locale && api.config.panelTab?.autoI18n,
          pluginDir: isUmi4 ? UMI4_DIR : UMI3_DIR,
        },
        {},
        ['{{{', '}}}'],
      ),
    });
    api.writeTmpFile({
      path: `${
        isUmi4 ? '' : UMI3_DIR
      }Wrappers/PanelTabsAndRouteAuthWrapper.tsx`,
      content: Mustache.render(
        readFileSync(
          join(__dirname, 'Wrappers', 'PanelTabsAndRouteAuthWrapper.tsx.tpl'),
          ENCODING,
        ),
        {
          useI18n: api.userConfig?.locale && api.config.panelTab?.autoI18n,
          pluginDir: isUmi4 ? UMI4_DIR : UMI3_DIR,
        },
        {},
        ['{{{', '}}}'],
      ),
    });
    api.writeTmpFile({
      path: `${isUmi4 ? '' : UMI3_DIR}Wrappers/RouteAuthWrapper.tsx`,
      content: Mustache.render(
        readFileSync(
          join(__dirname, 'Wrappers', 'RouteAuthWrapper.tsx.tpl'),
          ENCODING,
        ),
        {
          useI18n: api.userConfig?.locale && api.config.panelTab?.autoI18n,
        },
        {},
        ['{{{', '}}}'],
      ),
    });
    api.writeTmpFile({
      path: `${isUmi4 ? '' : UMI3_DIR}Result/404.tsx`,
      content: Mustache.render(
        readFileSync(join(__dirname, 'Result', '404.tsx.tpl'), ENCODING),
        {
          useI18n: api.userConfig?.locale && api.config.panelTab?.autoI18n,
        },
        {},
        ['{{{', '}}}'],
      ),
    });
  });

  api.modifyConfig((memo) => {
    console.log(JSON.stringify(memo));
    if (memo.plugins && !memo.plugins.includes('umi-plugin-keep-alive')) {
      memo.plugins = [...memo.plugins, 'umi-plugin-keep-alive'];
    }
    return memo;
  });
}
