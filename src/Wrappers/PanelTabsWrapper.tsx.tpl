{{=<% %>=}}
import React from 'react';
import type { FC } from 'react';
import { useHistory } from 'umi';
import PanelTabs from '@@/plugin-panel-tabs/PanelTabs';
// @ts-ignore
import { KeepAlive } from 'react-activation';
import { IRoute } from '@umijs/core';

const PanelTabsWrapper: FC<{ route: IRoute; children: React.ReactNode }> = ({
  route,
  children,
}) => {
  const history = useHistory();

  return (
    <>
      <PanelTabs />
      <KeepAlive name={route.name} location={history.location} saveScrollPosition="screen">
        <div style={{ marginTop: 50 }}>{children}</div>
      </KeepAlive>
    </>
  );
};

export default PanelTabsWrapper;
<%={{ }}=%>
