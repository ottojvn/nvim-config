# GitHub Copilot Instructions - Neovim Configuration

## Project Overview
This is a personal Neovim configuration repository (`nvim-config`) written primarily in Lua. The configuration uses the lazy.nvim plugin manager and follows a modular, well-organized structure for maintainability and extensibility.

## Repository Structure

```
nvim-config/
├── init.lua                    # Main entry point, bootstraps lazy.nvim and loads core modules
├── lua/
│   ├── core/                   # Core Neovim configurations
│   │   ├── options.lua         # Vim options and settings
│   │   ├── keymaps.lua         # Key mappings and shortcuts
│   │   └── autocmds.lua        # Auto commands and events
│   ├── plugins/                # Plugin management
│   │   ├── init.lua            # Main plugin specification file
│   │   └── configs/            # Individual plugin configurations
│   │       ├── lsp.lua         # Language Server Protocol setup
│   │       ├── completion.lua  # Auto-completion configuration
│   │       ├── telescope.lua   # Fuzzy finder setup
│   │       ├── treesitter.lua  # Syntax highlighting
│   │       ├── ui.lua          # UI components (statusline, etc.)
│   │       ├── git.lua         # Git integration
│   │       ├── theme.lua       # Color schemes and themes
│   │       └── ...             # Other plugin configs
│   └── utils/                  # Utility functions and helpers
│       ├── lsp_handlers.lua    # LSP event handlers
│       ├── java_config.lua     # Java-specific configurations
│       └── ...                 # Other utility modules
├── scripts/                    # Maintenance and setup scripts
└── formatters/                 # Code formatting configurations
```

## Coding Conventions and Style

### Language Preferences
- **Code**: Write in English (variable names, function names, comments in code)
- **Comments**: Use Portuguese for user-facing comments and documentation
- **Plugin descriptions**: Use Portuguese for plugin descriptions and user-facing text

### Lua Style Guidelines
- Use 2 spaces for indentation
- Use double quotes for strings: `"example"`
- Use descriptive variable names: `local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"`
- Prefer local variables: `local opt = vim.opt`
- Use early returns to reduce nesting
- Group related configurations together with clear comments

### Plugin Management with lazy.nvim
- All plugins are defined in `lua/plugins/init.lua` using the `{ import = "plugins.configs.module" }` pattern
- Individual plugin configurations are in separate files under `lua/plugins/configs/`
- Use lazy loading when appropriate: `event = "VeryLazy"`, `ft = "lua"`, etc.
- Always include meaningful descriptions for keymaps: `desc = "Description in Portuguese"`

### Configuration Patterns
- Use `safe_require()` function for loading modules to handle errors gracefully
- Prefer `opts = {}` over `config = function()` when simple configuration is sufficient
- Use `keys = {}` tables for plugin-specific keymaps
- Group similar functionality together (LSP, completion, UI, etc.)

## Key Directories and Their Purposes

### `lua/core/`
Core Neovim configurations that don't depend on plugins:
- **options.lua**: Vim options (indentation, search, display, etc.)
- **keymaps.lua**: Basic key mappings and shortcuts
- **autocmds.lua**: Auto commands for events and file types

### `lua/plugins/configs/`
Individual plugin configuration files:
- Each file should contain related plugins grouped by functionality
- Use descriptive comments in Portuguese for complex configurations
- Follow the lazy.nvim specification format
- Include performance optimizations where applicable

### `lua/utils/`
Utility functions and shared code:
- LSP-related utilities
- Language-specific helpers (Java, etc.)
- Common functions used across multiple configurations

## Development Guidelines

### When suggesting new plugins:
1. Check if similar functionality already exists
2. Prefer lightweight, well-maintained plugins
3. Consider lazy loading options
4. Add proper descriptions in Portuguese
5. Include relevant keymaps with descriptive labels

### When modifying existing configurations:
1. Maintain the existing structure and patterns
2. Keep Portuguese comments for user-facing features
3. Test changes don't break lazy.nvim loading
4. Consider performance implications
5. Update related documentation if needed

### Code Organization:
- Keep plugin configs focused on single functionality
- Use imports in `lua/plugins/init.lua` to organize plugin loading
- Separate language-specific configurations (e.g., Java in separate files)
- Use consistent naming conventions across files

## Special Considerations

### lazy.nvim Specifics:
- Don't reload `init.lua` directly (causes "Re-sourcing your config is not supported" error)
- Use `:Lazy sync` to update plugins
- Restart Neovim completely when making structural changes
- Use the `performance.rtp.disabled_plugins` setting to improve startup time

### LSP Configuration:
- Use mason.nvim for automatic server installation
- Configure servers in `lua/plugins/configs/lsp.lua`
- Language-specific configurations go in separate files (e.g., Java extensions)
- Use proper error handling for LSP setup

### Keymaps:
- Use descriptive Portuguese descriptions: `desc = "Comentar/descomentar linha"`
- Group related keymaps together
- Prefer plugin-specific keymaps in plugin configuration files
- Use consistent leader key patterns

This configuration emphasizes modularity, performance, and maintainability while preserving the Portuguese language preference for user-facing elements.