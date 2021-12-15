import { Button, Result } from 'antd';
import React from 'react';
{{{ #useI18n }}}
import { useIntl, usePanelTab } from 'umi';
{{{ /useI18n }}}
{{{ ^useI18n }}}
import { usePanelTab } from 'umi';
{{{ /useI18n }}}

export default () => {
  {{{ #useI18n }}}
  const intl = useIntl();
  {{{ /useI18n }}}
  const { closeCurrent } = usePanelTab();
  return (
    <Result
      status="404"
      title="404"
      {{{ #useI18n }}}
      subTitle={intl.formatMessage({id: 'panelTab.404.subTitle', defaultMessage: '抱歉，您访问的页面不存在'})}
      {{{ /useI18n }}}
      {{{ ^useI18n }}}
      subTitle="抱歉，您访问的页面不存在"
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
};
