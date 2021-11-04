import React, { useEffect } from 'react';
import type { FC } from 'react';
import { useHistory } from 'umi';
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
  const history = useHistory();
  const { getCachingNodes } = useAliveController();
  const cachingNodes = getCachingNodes();
  const useDebounce = useDebounceFn(
    () =>
      Modal.warn({
        title: '{{{ tabsLimitWarnTitle }}}',
        content: '{{{ tabsLimitWarnContent }}}',
      }),
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
      <KeepAlive name={route.name} location={history.location} saveScrollPosition="screen">
        <div style={{ marginTop: 60 }}>{children}</div>
      </KeepAlive>
    </>
  );
};

export default PanelTabsWrapper;
