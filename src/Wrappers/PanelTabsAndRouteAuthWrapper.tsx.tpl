import React from 'react';
import type { FC } from 'react';
import { useAccess } from '@@/plugin-access/access';
import type { IBestAFSRoute } from '@umijs/plugin-layout';
import { PanelTabsWrapper } from '@@/plugin-panel-tabs';
import { Button, Result } from 'antd';
{{{ #useI18n }}}
import { useIntl, usePanelTab } from 'umi';
{{{ /useI18n }}}
{{{ ^useI18n }}}
import { usePanelTab } from 'umi';
{{{ /useI18n }}}

const PanelTabsAndRouteAuthWrapper: FC<{ route: IBestAFSRoute; children: React.ReactNode }> = ({
  route,
  children,
}) => {
  {{{ #useI18n }}}
  const intl = useIntl();
  {{{ /useI18n }}}
  const { closeCurrent } = usePanelTab();
  const access = useAccess();
  let renderContent = children;

  if (route.access && access[route.access] !== true) {
    renderContent = (
      <Result
        status="403"
        title="403"
        {{{ #useI18n }}}
        subTitle={intl.formatMessage({id: 'panelTab.403.subTitle', defaultMessage: '抱歉，你无权访问该页面'})}
        {{{ /useI18n }}}
        {{{ ^useI18n }}}
        subTitle="抱歉，你无权访问该页面"
        {{{ /useI18n }}}
        extra={
          <Button type="primary" onClick={closeCurrent}>
            {{{ #useI18n }}}
            {intl.formatMessage({id: 'panelTab.closePage', defaultMessage: '关闭页面'})}
            {{{ /useI18n }}}
            {{{ ^useI18n }}}
            关闭页面
            {{{ /useI18n }}}
          </Button>
        }
      />
    );
  }

  return <PanelTabsWrapper route={route} children={renderContent} />;
};

export default PanelTabsAndRouteAuthWrapper;
