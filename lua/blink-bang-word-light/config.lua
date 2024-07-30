local config = {}

config.settings = {
  max_word_length = 100,
  min_word_length = 2,
  excluded = {
    filetypes = {},
    buftypes = {
      "prompt",
      "terminal",
    },
    patterns = {},
  },
  highlight = {
    underline = true,
    guifg = nil,
    guibg = nil,
  },
  enabled = true,
}

local highlight = require('blink-bang-word-light.highlight')

local function get_config_path()
  return vim.fn.stdpath('data') .. '/blink_bang_word_light_cache'
end

local function save_config()
  local config_path = get_config_path()
  local file = io.open(config_path, "w")
  if file then
    file:write(config.settings.enabled and "true" or "false")
    file:close()
  else
    vim.api.nvim_err_writeln("Failed to save config to " .. config_path)
  end
end

local function load_config()
  local config_path = get_config_path()
  local file = io.open(config_path, "r")
  if file then
    local content = file:read("*a")
    file:close()
    if content == "true" then
      config.settings.enabled = true
    elseif content == "false" then
      config.settings.enabled = false
    end
  else
    save_config()
  end
end

function config.setup(user_config)
  config.settings = vim.tbl_deep_extend('force', config.settings, user_config or {})
  load_config()
end

function config.enable()
  config.settings.enabled = true
  save_config()
  require('blink-bang-word-light.init').enable_autocmds()
  highlight.set_highlight(config.settings.highlight)
end

local function clear_match()
  local w = vim.w
  local fn = vim.fn
  if w.blink_bang_word_light ~= nil then
    pcall(fn.matchdelete, w.blink_bang_word_light)
    w.blink_bang_word_light = nil
  end
end

function config.disable()
  config.settings.enabled = false
  clear_match()
  save_config()
  require('blink-bang-word-light.init').disable_autocmds()
end

function config.toggle()
  if config.settings.enabled then
    config.disable()
  else
    config.enable()
  end
end

return config
