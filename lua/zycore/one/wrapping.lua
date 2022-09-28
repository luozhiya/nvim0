local ok, wrapping = pcall(require, 'wrapping')
if not ok then
  return
end

wrapping.setup({})
