{{=<% %>=}}
import React from 'react';
import type { FC } from 'react';
// @ts-ignore
import { useAliveController } from 'react-activation';
import PanelTab from './PanelTab';

const PanelTabs: FC = () => {
  const { getCachingNodes } = useAliveController();
  const cachingNodes = getCachingNodes();

  return (
    <div
      style={{
        backgroundColor: 'white',
        width: '100%',
        position: 'fixed',
        height: 'auto',
        zIndex: 9,
        borderTop: '1px solid #d8dce5',
        borderBottom: '1px solid #d8dce5',
        boxShadow: '0 1px 3px 0 rgba(0,0,0,.12),0 0 3px 0 rgba(0,0,0,.04)',
        padding: '0 0 5px 5px',
      }}
    >
      {cachingNodes.map((node, idx) => (
        <PanelTab key={idx} node={node} />
      ))}
    </div>
  );
};

export default PanelTabs;
<%={{ }}=%>
