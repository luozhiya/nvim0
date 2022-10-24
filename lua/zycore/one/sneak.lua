-- 2-character Sneak (default)

require('leap').add_default_mappings()
-- buggy with alpha
-- require('leap').leap({ target_windows = { vim.fn.win_getid() } })
require('flit').setup({ labeled_modes = 'nv' })
