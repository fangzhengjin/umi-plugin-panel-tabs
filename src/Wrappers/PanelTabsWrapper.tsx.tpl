import React, { useEffect } from 'react';
import type { FC } from 'react';
{{{ #useI18n }}}
import { useIntl, useHistory } from 'umi';
{{{ /useI18n }}}
{{{ ^useI18n }}}
import { useHistory } from 'umi';
{{{ /useI18n }}}
import PanelTabs from '@@/plugin-panel-tabs/PanelTabs';
// @ts-ignore
import { KeepAlive } from 'react-activation';
import type { IRoute } from '@umijs/core';
import { Modal } from 'antd';
import { useAliveController } from '@@/core/umiExports';
import { useDebounceFn } from 'ahooks';

const PanelTabsWrapper: FC<{ route: IRoute; children: React.ReactNode }> = ({
  route,
  children,
}) => {
  {{{ #useI18n }}}
  const intl = useIntl();
  {{{ /useI18n }}}
  const history = useHistory();
  const { getCachingNodes } = useAliveController();
  const cachingNodes = getCachingNodes();
  const useDebounce = useDebounceFn(
    () =>
      {{{ #useI18n }}}
      Modal.warn({
        title: intl.formatMessage({id: 'panelTab.tabsLimitWarnTitle', defaultMessage: '{{{ tabsLimitWarnTitle }}}'}),
        content: intl.formatMessage({id: 'panelTab.tabsLimitWarnContent', defaultMessage: '{{{ tabsLimitWarnContent }}}'}),
      }),
      {{{ /useI18n }}}
      {{{ ^useI18n }}}
      Modal.warn({
        title: '{{{ tabsLimitWarnTitle }}}',
        content: '{{{ tabsLimitWarnContent }}}',
      }),
      {{{ /useI18n }}}
    { wait: {{{ tabsLimitWait }}} },
  );

  useEffect(() => {
    if (cachingNodes.length > {{{ tabsLimit }}}) {
      useDebounce.run();
    }
  }, [cachingNodes]);

  return (
    <>
      <PanelTabs />
      <KeepAlive
        {{{ #useI18n }}}
        name={intl.formatMessage({id: `menu.${route.name}`, defaultMessage: route.name})}
        {{{ /useI18n }}}
        {{{ ^useI18n }}}
        name={route.name}
        {{{ /useI18n }}}
        location={history.location}
        saveScrollPosition="screen"
      >
        <div style={{ marginTop: 60 }}>{children}</div>
      </KeepAlive>
    </>
  );
};

export default PanelTabsWrapper;
