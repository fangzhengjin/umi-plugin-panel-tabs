import React from 'react';
import type { FC } from 'react';
import { useAccess } from '@@/plugin-access/access';
import type { IBestAFSRoute } from '@umijs/plugin-layout';
import { PanelTabsWrapper } from '@@/plugin-panel-tabs';
import { Button, Result } from 'antd';
import { history, usePanelTab } from 'umi';

const PanelTabsAndRouteAuthWrapper: FC<{ route: IBestAFSRoute; children: React.ReactNode }> = ({
  route,
  children,
}) => {
  const { closeCurrent } = usePanelTab();
  const access = useAccess();
  let renderContent = children;

  if (route.access && access[route.access] !== true) {
    renderContent = (
      <Result
        status="403"
        title="403"
        subTitle="抱歉，你无权访问该页面"
        extra={
          <Button type="primary" onClick={closeCurrent}>
            关闭页面
          </Button>
        }
      />
    );
  }

  return <PanelTabsWrapper route={route} children={renderContent} />;
};

export default PanelTabsAndRouteAuthWrapper;
