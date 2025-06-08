# 🖼️ pikchr.nvim

**Live-render [Pikchr](https://pikchr.org/) diagrams in your browser, directly from Neovim.**

`pikchr.nvim` is a Neovim plugin that watches `.pikchr` files and renders them as SVG in your browser using WebAssembly. Every time you save or edit your file, the diagram is automatically updated in real-time.

---

## ✨ Features

- Live preview of `.pikchr` diagrams in your browser
- Automatic reload on file changes
- Uses WebAssembly for fast client-side SVG rendering
- Zero external dependencies beyond a modern browser

---

## 🚀 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
	{
		"Cih2001/pikchr.nvim",
		lazy = false, -- or set true for lazy loading
		cmd = "Pikchr",
		config = function()
			require("pikchr").setup({
				server_port = 1234,
			})
		end,
	},
```

## Usage

- To start the local server run `:Pikchr start` and navigate to "http://localhost:1234"
- To stop the local server run `:Pikchr stop`
