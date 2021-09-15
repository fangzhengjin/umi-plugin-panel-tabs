import { Button, Result } from 'antd';
import React from 'react';
import { usePanelTab } from 'umi';

export default () => {
  const { closeCurrent } = usePanelTab();
  return (
    <Result
      status="404"
      title="404"
      subTitle="抱歉，您访问的页面不存在"
      extra={
        <Button type="primary" onClick={closeCurrent}>
          关闭页面
        </Button>
      }
    />
  );
};
