local modules = {
  'options',
  'plugins',
  'mappings',
}

for _, m in ipairs(modules) do
  local ok, err = pcall(require, m)
  if not ok then
    error("Error loading " .. m .. "\n\n" .. err)
  end
end
