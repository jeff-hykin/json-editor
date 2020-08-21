module.exports = function (api) {
  api.cache(true);

  const presets = [  ];
  const plugins = [ "@babel/plugin-proposal-export-default-from", "@babel/plugin-syntax-dynamic-import" ];

  return {
    presets,
    plugins
  };
}