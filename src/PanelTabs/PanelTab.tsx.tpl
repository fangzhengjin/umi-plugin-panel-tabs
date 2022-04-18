import React, { useEffect, useRef, useState } from 'react';
{{{ #useI18n }}}
import { useIntl, useHistory, useLocation } from 'umi';
{{{ /useI18n }}}
{{{ ^useI18n }}}
import { useHistory, useLocation } from 'umi';
{{{ /useI18n }}}
// @ts-ignore
import type { CachingNode } from 'react-activation';
import { Badge, Dropdown, Menu, Tag } from 'antd';
import usePanelTab from './PanelTabHook';

const PanelTab: React.FC<{ node: CachingNode }> = ({ node }) => {
  {{{ #useI18n }}}
  const intl = useIntl();
  {{{ /useI18n }}}
  const panelTabRef = useRef<HTMLSpanElement>();
  const { close, closeOther, refresh, closeAll } = usePanelTab();
  const history = useHistory();
  const location = useLocation();
  const [nodeCache, setNodeCache] = useState<{ name: string; path: string }>({
    name: node.name!!,
    path: node.location.pathname,
  });

  const isActive = location.pathname === node.location.pathname;

  // 第二次打开同名但是不同地址的页签时, 刷新页签内容
  useEffect(() => {
    if (nodeCache.name === node.name && nodeCache.path !== node.location.pathname) {
      setNodeCache({ name: node.name!!, path: node.location.pathname });
      refresh({ name: node.name, location: node.location });
    }
    if (isActive && panelTabRef.current) {
      // 父元素信息
      const parentNode = panelTabRef.current?.parentElement;
      // 获取元素信息
      const parentNodeBCR = parentNode?.getBoundingClientRect();
      const currentNodeBCR = panelTabRef.current?.getBoundingClientRect();
      // 元素被遮挡在左侧, 向右滚动
      if (currentNodeBCR.left < parentNodeBCR.left) {
        parentNode.scrollLeft -= parentNodeBCR.left - currentNodeBCR.left + currentNodeBCR.width;
      }
      // 元素被遮挡在右侧, 向左滚动
      if (currentNodeBCR.right > parentNodeBCR.right) {
        parentNode.scrollLeft += currentNodeBCR.right - parentNodeBCR.right + currentNodeBCR.width;
      }
    }
  }, [node.location.pathname]);

  return (
    <Dropdown
      overlay={
        <Menu>
          <Menu.Item
            style={{ fontSize: '12px', padding: '0px 12px' }}
            key="closeSelf"
            onClick={() => close({ name: node.name!!, location: node.location })}
          >
            {{{ #useI18n }}}
            {intl.formatMessage({id: 'panelTab.close', defaultMessage: '关闭'})}
            {{{ /useI18n }}}
            {{{ ^useI18n }}}
            关闭
            {{{ /useI18n }}}
          </Menu.Item>
          <Menu.Item
            style={{ fontSize: '12px', padding: '0px 12px' }}
            key="closeOther"
            onClick={() => closeOther({ name: node.name!!, location: node.location })}
          >
            {{{ #useI18n }}}
            {intl.formatMessage({id: 'panelTab.closeOther', defaultMessage: '关闭其他'})}
            {{{ /useI18n }}}
            {{{ ^useI18n }}}
            关闭其他
            {{{ /useI18n }}}
          </Menu.Item>
          <Menu.Item
            style={{ fontSize: '12px', padding: '0px 12px' }}
            key="closeAll"
            onClick={closeAll}
          >
            {{{ #useI18n }}}
            {intl.formatMessage({id: 'panelTab.closeAll', defaultMessage: '关闭所有'})}
            {{{ /useI18n }}}
            {{{ ^useI18n }}}
            关闭所有
            {{{ /useI18n }}}
          </Menu.Item>
          <Menu.Divider style={{ fontSize: '12px', padding: '0px 12px' }} />
          <Menu.Item
            style={{ fontSize: '12px', padding: '0px 12px' }}
            key="refreshSelf"
            onClick={() => refresh({ name: node.name!!, location: node.location })}
          >
            {{{ #useI18n }}}
            {intl.formatMessage({id: 'panelTab.refresh', defaultMessage: '刷新'})}
            {{{ /useI18n }}}
            {{{ ^useI18n }}}
            刷新
            {{{ /useI18n }}}
          </Menu.Item>
        </Menu>
      }
      trigger={['contextMenu']}
    >
      <Tag
        ref={panelTabRef}
        style={{
          height: '26px',
          marginTop: '5px',
          textAlign: 'center',
          lineHeight: '23px',
          fontSize: '12px',
          cursor: 'default',
        }}
        color={isActive ? '{{{tabsTagColor}}}' : 'default'}
        onClick={() => history.push(node.location)}
        closable
        onClose={(e) => {
          e.preventDefault();
          close({ name: node.name!!, location: node.location });
        }}
      >
        {isActive && <Badge color="#FFFFFF" dot />}
        {node.name}
      </Tag>
    </Dropdown>
  );
};

export default PanelTab;
