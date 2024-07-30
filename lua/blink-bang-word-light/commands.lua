local config = require('blink-bang-word-light.config')

local subcommand_tbl = {
  enable = {
    impl = function()
      config.enable()
    end,
  },
  disable = {
    impl = function()
      config.disable()
    end,
  },
  toggle = {
    impl = function()
      config.toggle()
    end,
  },
}

local function blink_bang_word_light_cmd(opts)
  local fargs = opts.fargs
  local subcommand_key = fargs[1]
  local subcommand = subcommand_tbl[subcommand_key]
  if not subcommand then
    vim.notify("Blink-Bang-Word-Light: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
    return
  end
  subcommand.impl()
end

vim.api.nvim_create_user_command("BlinkBangWordLight", blink_bang_word_light_cmd, {
  nargs = "+",
  desc = "Control Blink-Bang-Word-Light",
  complete = function(arg_lead)
    return vim.tbl_filter(function(cmd) return vim.startswith(cmd, arg_lead) end, vim.tbl_keys(subcommand_tbl))
  end,
})

vim.api.nvim_create_user_command("BBWL", blink_bang_word_light_cmd, {
  nargs = "+",
  desc = "Control Blink-Bang-Word-Light",
  complete = function(arg_lead)
    return vim.tbl_filter(function(cmd) return vim.startswith(cmd, arg_lead) end, vim.tbl_keys(subcommand_tbl))
  end,
})

return {}
