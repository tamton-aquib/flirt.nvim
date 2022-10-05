# Flirt.nvim

Animations for floating windows in neovim.<br />
Was about to name this float.nvim but god said "no".

> **WARNING** Highly experimental. <br />
> Overrides the default `nvim_open_win` to achieve the open animation effect.

### Showcase


### Installation
```lua
use { 'tamton-aquib/flirt.nvim' }
```

### Usage
```lua
require("flirt").setup()
```

<details>
<summary>Click here to see default configuration</summary>

```lua
require("flirt").setup {
    override_open = true,
    close_command = 'Q',
    default_mappings = true, -- <C-arrows> to move floats
    -- more options on the way.
}
```

If you want to map to different keys:
```lua
local f = require("flirt")

vim.keymap.set('n', '<leader><left>', function() f.move("left") end, {})
vim.keymap.set('n', '<leader><up>', function() f.move("up") end, {}) -- etc
```

</details>

### NOTES
- its a single file with approximately 150LOC
- Contributions are welcome for improvement.
- Extracted from [stuff.nvim](https://github.com/tamton-aquib/stuff.nvim)

### Credits
- [aloof](https://github.com/vsedov) for the idea.
- [vhyrro](https://github.com/vsedov) for helping.
- [bryant](https://github.com/bryant-the-coder/) for the name.
