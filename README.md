# Blink-Bang-Word-Light

💎 Blink-Bang-Word-Light is a Neovim plugin that highlights the word under the cursor throughout the buffer. The plugin provides commands to enable, disable, and toggle the highlighting.

<img src="https://github.com/user-attachments/assets/c01dd446-918d-4e99-a07d-f40545760729" alt="bbwl" width="800"/>


## ☀️ Features

- Highlights the word under the cursor throughout the buffer.
- Customizable highlight settings including foreground color, background color, and underline.
- Commands to enable, disable, and toggle highlighting.

## 📥 Installation

### Using [Lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
    'mei28/blink-bang-word-light.nvim',
    event = { 'VeryLazy' },
    config = function()
        require('blink-bang-word-light').setup({
            -- if you want to customize, see Usage!
        })
    end
}

```

### 🧰 Usage
```lua
require('blink-bang-word-light').setup({
  max_word_length = 100, -- if cursorword length > max_word_length then not highlight
  min_word_length = 2, -- if cursorword length < min_word_length then not highlight
  excluded = {
      filetypes = {
          "TelescopePrompt",
      },
      buftypes = {
          -- "nofile",
          -- "terminal",
      },
      patterns = { -- the pattern to match with the file path
          -- "%.png$",
          -- "%.jpg$",
          -- "%.jpeg$",
          -- "%.pdf$",
          -- "%.zip$",
          -- "%.tar$",
          -- "%.tar%.gz$",
          -- "%.tar%.xz$",
          -- "%.tar%.bz2$",
          -- "%.rar$",
          -- "%.7z$",
          -- "%.mp3$",
          -- "%.mp4$",
      },
  },
  highlight = {
    underline = true,
    guifg = '#ffcc00', -- Foreground color
    guibg = '#333333', -- Background color
  },
  enabled = true,
})
``````

## ⚙️ Configuration
You can customize the plugin settings by calling the setup function in your init.vim or init.lua. Here is an example configuration:

```lua
require('blink-bang-word-light').setup({
  max_word_length = 100, -- if cursorword length > max_word_length then not highlight
  min_word_length = 2, -- if cursorword length < min_word_length then not highlight
  excluded = {
      filetypes = {
          "TelescopePrompt",
      },
      buftypes = {
          -- "nofile",
          -- "terminal",
      },
      patterns = { -- the pattern to match with the file path
          -- "%.png$",
          -- "%.jpg$",
          -- "%.jpeg$",
          -- "%.pdf$",
          -- "%.zip$",
          -- "%.tar$",
          -- "%.tar%.gz$",
          -- "%.tar%.xz$",
          -- "%.tar%.bz2$",
          -- "%.rar$",
          -- "%.7z$",
          -- "%.mp3$",
          -- "%.mp4$",
      },
  },
  highlight = {
    underline = true,
    guifg = '#ffcc00', -- Foreground color
    guibg = '#333333', -- Background color
  },
  enabled = true,
})
```

### Default configuration

```lua
{
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
```

## 📖 Commands

The following commands are available to control the highlighting:

- `:BlinkBangWordLight enable` or `:BBWL enable`: Enable the highlighting.
- `:BlinkBangWordLight disable` or `:BBWL disable`: Disable the highlighting.
- `:BlinkBangWordLight toggle` or `:BBWL toggle`: Toggle the highlighting.

## License
This plugin is licensed under the MIT License.

## Similar plugins
- [nvim-cursorword](https://github.com/xiyaowong/nvim-cursorword)
- [stcursorword](https://github.com/sontungexpt/stcursorword)
- [vim-illuminate](https://github.com/RRethy/vim-illuminate)
