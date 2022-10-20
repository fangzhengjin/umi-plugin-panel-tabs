export default [
  {
    target: 'node',
    cjs: 'babel',
    disableTypeCheck: true,
    extraBabelPlugins: [
      [
        'babel-plugin-import',
        { libraryName: 'antd', libraryDirectory: 'es', style: true },
        'antd',
      ],
    ],
  },
];
