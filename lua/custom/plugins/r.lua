-- File: lua/custom/plugins/nvimR.lua

return {
  'jalvesaq/Nvim-R',
  event = 'BufEnter *.r',
  ft = 'r',
  dependencies = {
    -- 'ncm2/ncm2',
    'gaalcaras/ncm-R',
    -- 'sirver/Ultisnips',
    -- 'ncm2/ncm2-ultisnips',
  },
}
