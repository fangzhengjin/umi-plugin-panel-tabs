import React from 'react';
import type { FC } from 'react';
import { useAccess } from '@@/plugin-access/access';
import { Button, Result } from 'antd';
import { history } from 'umi';
import type { IBestAFSRoute } from '@umijs/plugin-layout';

const RouteAuthWrapper: FC<{ route: IBestAFSRoute; children: React.ReactNode }> = ({
  route,
  children,
}) => {
  const access = useAccess();

  if (route.access && access[route.access] !== true) {
    return (
      <Result
        status="403"
        title="403"
        subTitle="抱歉，你无权访问该页面"
        extra={
          <Button type="primary" onClick={() => history.push('/')}>
            返回首页
          </Button>
        }
      />
    );
  }

  return <>{children}</>;
};

export default RouteAuthWrapper;
