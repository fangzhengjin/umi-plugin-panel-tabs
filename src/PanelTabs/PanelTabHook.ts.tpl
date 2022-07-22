import { useHistory, useLocation, History } from 'umi';
// @ts-ignore
import { useAliveController } from 'react-activation';

interface PanelTabNodeProps {
  name: string;
  location?: any;
}

/**
 * PanelTab操作hook
 */
const usePanelTab = () => {
  const history = useHistory();
  const location = useLocation();
  const { getCachingNodes, dropScope, refreshScope, clear } = useAliveController();
  const cachingNodes = getCachingNodes();

  /**
   * 关闭当前打开的页面
   * 如果当前页面关闭后还有其他页面 => 切换到其他页面
   * 如果当前页为最后一个页面 => 打开欢迎页
   */
  const close = (node?: PanelTabNodeProps) => {
    const current = cachingNodes
      .filter((x) => {
        if (node) {
          // 关闭指定页面
          return x.name === node.name;
        }
        // 关闭当前页面
        return x.location.pathname === location.pathname;
      })
      ?.pop();
    if (current) {
      // 如果要关闭的是当前页, 必须先转到其他页面, 不能操作正显示的页面
      if (current.location.pathname === location.pathname) {
        // 前往排除当前 node 后的最后一个 tab
        history.push(
          cachingNodes.filter((cacheNode) => cacheNode.name !== current!!.name).pop()?.location ||
            '/welcome',
        );
      }
      dropScope(current.name!!);
    }
  };

  /**
   * 关闭当前tab
   */
  const closeCurrent = () => close();

  /**
   * 关闭除当前tab外的其他tab
   * @param node 不指定页面默认为当前页面
   */
  const closeOther = (node: PanelTabNodeProps) => {
    history.push(node.location);
    cachingNodes
      .filter((cacheNode) => cacheNode.name !== node.name)
      .forEach((x) => {
        dropScope(x.name!!);
      });
  };

  /**
   * 关闭所有tab并打开欢迎页
   */
  const closeAll = () => {
    history.push('/welcome');
    clear();
  };

  /**
   * 刷新tab
   * @param node 不指定默认刷新当前tab
   */
  const refresh = (node?: PanelTabNodeProps) => {
    if (node) {
      refreshScope(node.name!!);
    } else {
      const current = cachingNodes.filter((x) => x.location.pathname === location.pathname)?.pop();
      if (current) {
        refreshScope(current.name!!);
      }
    }
  };

  /**
   * 刷新当前tab
   */
  const refreshCurrent = () => refresh();

  /**
   * 刷新指定窗口并关闭当前
   */
  const refreshAndCloseCurrent = (config: { refreshPages: string[] }) => {
    config.refreshPages.forEach((name) => refresh({ name }));
    closeCurrent();
  };

  /**
   * 刷新指定窗口 -> 关闭当前 -> 切换至指定已开启的页面
   */
  const refreshAndCloseCurrentAndSwitch = (config: {
    refreshPages: string[];
    callback: (history: History) => void;
  }) => {
    config.refreshPages.forEach((name) => refresh({ name }));
    closeCurrent();
    config.callback(history);
  };
  
   /**
   * 刷新并打开指定页面
   * @param node 
   */
  const refreshAndOpen = (node: Location) => {
    const current = cachingNodes
    .filter((x) => {
      if (node) {
        // 刷新指定页面
        return x.location.pathname === node.pathname;
      }
    })
    ?.pop();
    if(current) {
      refreshScope(current.name!!);
    }
    history.push(node.pathname);
  }
  
    /**
   * 重置打开指定页面
   * @param node 
   */
  const closeAndOpen = (node: Location) => {
    const current = cachingNodes
    .filter((x) => {
      if (node) {
        // 关闭指定页面
        return x.location.pathname === node.pathname;
      }
    })
    ?.pop();
    if(current) {
      dropScope(current.name!!); //這個功能無效？
    }
    history.push(node.pathname);
  }

  return {
    close,
    closeCurrent,
    closeOther,
    refresh,
    refreshCurrent,
    closeAll,
    refreshAndCloseCurrent,
    refreshAndCloseCurrentAndSwitch,
    
    refreshAndOpen,
    closeAndOpen
  };
};

export default usePanelTab;
