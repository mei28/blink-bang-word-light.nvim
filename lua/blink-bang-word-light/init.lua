local M = {}

local config = require('blink-bang-word-light.config')
local highlight = require('blink-bang-word-light.highlight')
require('blink-bang-word-light.commands')

M.config = config

local group_name = 'BlinkBangWordLight'
local autocmd_group_id

function M.enable_autocmds()
  if not autocmd_group_id then
    autocmd_group_id = vim.api.nvim_create_augroup(group_name, { clear = true })
  end

  vim.api.nvim_create_autocmd('ColorScheme', {
    group = autocmd_group_id,
    callback = function()
      if config.settings.enabled then
        highlight.set_highlight(config.settings.highlight)
      else
        highlight.clear_match()
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
    group = autocmd_group_id,
    callback = function()
      highlight.on_buf_enter(config.settings)
    end,
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = autocmd_group_id,
    callback = function()
      highlight.on_cursor_moved(config.settings)
    end,
  })
end

function M.disable_autocmds()
  if autocmd_group_id then
    vim.api.nvim_clear_autocmds({ group = autocmd_group_id })
  end
end

function M.setup(user_config)
  config.setup(user_config)
  M.enable_autocmds()

  -- Initial highlight setup
  if config.settings.enabled then
    highlight.set_highlight(config.settings.highlight)
  else
    highlight.clear_match()
  end
end

return M
