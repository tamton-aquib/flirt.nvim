# Flirt.nvim

Animations for floating windows in neovim.<br />
Was about to name this float.nvim but god said "no".

> **WARNING**
> Highly experimental. <br />
> Overrides the default `nvim_open_win` to achieve the open animation effect.

### Showcase

https://user-images.githubusercontent.com/77913442/194030746-1918f058-8bdb-486e-a740-e02a2b222f98.mp4

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
    override_open = true, -- experimental
    close_command = 'Q',
    default_move_mappings = true, -- <C-arrows> to move floats
    default_resize_mappings = true, -- <A-arrows> to resize floats
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
- Its a single file with approximately 100LOC
- Contributions are welcome for improvement.
- Extracted from [stuff.nvim](https://github.com/tamton-aquib/stuff.nvim)
- Might work well with [hydra.nvim](https://github.com/anuvyklack/hydra.nvim), havent checked.

### Credits
- [aloof](https://github.com/vsedov) for the idea.
- [vhyrro](https://github.com/vsedov) for helping.
- [bryant](https://github.com/bryant-the-coder/) for the name.
