local vim = vim
local w, fn, api = vim.w, vim.fn, vim.api
local hl, autocmd, get_line, get_cursor, matchstrpos, matchadd =
    api.nvim_set_hl,
    api.nvim_create_autocmd,
    api.nvim_get_current_line,
    api.nvim_win_get_cursor,
    fn.matchstrpos,
    fn.matchadd

local PLUG_NAME = "blink-bang-word-light"
local prev_line = -1
local prev_start_column = math.huge
local prev_end_column = -1
local prev_visual_text = nil

local M = {}

function M.clear_match()
  if w.blink_bang_word_light ~= nil then
    pcall(fn.matchdelete, w.blink_bang_word_light)
    w.blink_bang_word_light = nil
    prev_start_column = math.huge
    prev_end_column = -1
  end
  -- Also clear visual mode match
  M.clear_visual_match()
end

function M.set_highlight(highlight)
  local hl_options = {}
  for key, value in pairs(highlight) do
    if key == 'guifg' then
      hl_options['fg'] = value
    elseif key == 'guibg' then
      hl_options['bg'] = value
    elseif key == 'underline' then
      hl_options['underline'] = value
    else
      hl_options[key] = value
    end
  end

  hl(0, PLUG_NAME, hl_options)
end

function M.on_cursor_moved(configs)
  if not configs.enabled then
    M.clear_match()
    return
  end

  -- In exclusive mode and in visual mode, skip cursor word highlight
  if configs.visual_highlight.mode == "exclusive" and fn.mode():match('[vV\x16]') then
    if w.blink_bang_word_light ~= nil then
      pcall(fn.matchdelete, w.blink_bang_word_light)
      w.blink_bang_word_light = nil
      prev_start_column = math.huge
      prev_end_column = -1
    end
    return
  end

  local cursor_pos = get_cursor(0)
  local cursor_column = cursor_pos[2]
  local cursor_line = cursor_pos[1]

  if prev_line == cursor_line and cursor_column >= prev_start_column and cursor_column < prev_end_column then
    return
  end
  prev_line = cursor_line

  M.clear_match()

  local line = get_line()
  if fn.type(line) == vim.v.t_blob then
    return
  end

  local matches = matchstrpos(line:sub(1, cursor_column + 1), [[\w*$]])
  local word = matches[1]

  if word ~= "" then
    prev_start_column = matches[2]
    matches = matchstrpos(line, [[^\w*]], cursor_column + 1)
    word = word .. matches[1]
    prev_end_column = matches[3]

    local word_len = #word
    if word_len < configs.min_word_length or word_len > configs.max_word_length then
      return
    end

    w.blink_bang_word_light =
        matchadd(PLUG_NAME, [[\(\<\|\W\|\s\)\zs]] .. word .. [[\ze\(\s\|[^[:alnum:]_]\|$\)]], -1)
  end
end

function M.on_buf_enter(configs)
  if not configs.enabled then
    return
  end
  local disabled = M.check_disabled(configs.excluded, 0)
  if not disabled then M.on_cursor_moved(configs) end
end

function M.check_disabled(excluded, bufnr)
  local arr_contains = function(tbl, value)
    for _, v in ipairs(tbl) do
      if v == value then return true end
    end
    return false
  end

  local matches_file_patterns = function(file_name, file_patterns)
    for _, pattern in ipairs(file_patterns) do
      if file_name:match(pattern) then return true end
    end
    return false
  end

  return arr_contains(excluded.buftypes, api.nvim_get_option_value("buftype", { buf = bufnr or 0 }))
      or arr_contains(excluded.filetypes, api.nvim_get_option_value("filetype", { buf = bufnr or 0 }))
      or matches_file_patterns(api.nvim_buf_get_name(bufnr or 0), excluded.patterns)
end

-- Visual mode selection text retrieval
local function get_visual_text()
  if fn.has('nvim-0.10') == 1 and fn.mode():match('[vV\x16]') then
    -- In visual mode, use 'v' mark (start of visual) and current cursor position
    local start_pos = fn.getpos("v")
    local end_pos = fn.getpos(".")

    -- Check if marks are valid (line number > 0)
    if start_pos[2] == 0 or end_pos[2] == 0 then
      return nil
    end

    local region = fn.getregion(
      start_pos,
      end_pos,
      {type = fn.mode()}
    )
    return table.concat(region, "\n")
  end
  return nil
end

-- Visual mode selection validation
local function validate_selection(text, configs)
  if not text or text == "" then
    return false
  end

  if #text > configs.visual_highlight.max_selection_length then
    return false
  end

  local line_count = select(2, text:gsub('\n', '\n')) + 1
  if line_count > configs.visual_highlight.max_selection_lines then
    return false
  end

  return true
end

-- Clear visual mode match
function M.clear_visual_match()
  if w.blink_bang_visual_light ~= nil then
    pcall(fn.matchdelete, w.blink_bang_visual_light)
    w.blink_bang_visual_light = nil
    prev_visual_text = nil
  end
end

-- Visual mode selection highlight handler
function M.on_visual_selection(configs)
  if not configs.visual_highlight.enabled then
    M.clear_visual_match()
    return
  end

  local mode = fn.mode()
  if not mode:match('[vV\x16]') then
    M.clear_visual_match()
    return
  end

  local selected_text = get_visual_text()

  if not validate_selection(selected_text, configs) then
    M.clear_visual_match()
    return
  end

  -- Cache check
  if selected_text == prev_visual_text then
    return
  end
  prev_visual_text = selected_text

  M.clear_visual_match()

  -- In exclusive mode, also clear cursor word match
  if configs.visual_highlight.mode == "exclusive" then
    M.clear_match()
  end

  -- Escape and highlight
  local escaped = fn.escape(selected_text, [=[\/.*$^~[]]=])
  w.blink_bang_visual_light = matchadd(PLUG_NAME, escaped, -1)
end

return M
