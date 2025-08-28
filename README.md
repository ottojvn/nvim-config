# Neovim Configuration - Generic Setup

This is a **generic Neovim configuration** that works for any user without hardcoded paths or user-specific settings.

## ✅ Issues Fixed

### 1. **Deprecation Warnings Resolved**
- ✅ Replaced `vim.loop.fs_stat` with `vim.uv.fs_stat` in all files
- ✅ Eliminated the warning: `vim.validate is deprecated`
- ✅ Fixed future compatibility issues with Neovim 1.0

### 2. **Made Configuration Generic**
- ✅ Removed hardcoded `/home/ottojvn/` paths from all scripts
- ✅ Updated scripts to use `${XDG_CONFIG_HOME:-$HOME/.config}/nvim`
- ✅ Removed user-specific files (chezmoi-related, verification scripts)
- ✅ Configuration now works for any user out of the box

### 3. **Improved JDTLS Setup**
- ✅ Added better error handling for JDTLS configuration
- ✅ Improved JVM options to reduce exit code 13 issues:
  - Reduced memory allocation from 4GB to 2GB 
  - Changed log level from WARNING to ERROR
  - Added G1GC garbage collector for better performance
  - Added proper validation for JDTLS installation
- ✅ Added safer startup with proper error reporting

### 4. **Cleaned Up Repository**
- ✅ Removed unnecessary user-specific scripts
- ✅ Kept only essential configuration files
- ✅ Maintained all core functionality

## 📁 File Structure

```
nvim-config/
├── init.lua                    # Main configuration entry point
├── lua/
│   ├── core/                   # Core neovim settings
│   │   ├── options.lua         # Editor options and settings
│   │   ├── keymaps.lua         # Key mappings
│   │   └── autocmds.lua        # Auto commands
│   ├── plugins/                # Plugin configurations
│   │   ├── init.lua            # Plugin manager setup
│   │   └── configs/            # Individual plugin configs
│   └── utils/                  # Utility functions
│       ├── jdtls.lua           # Java LSP configuration
│       └── ...
├── scripts/                    # Helper scripts (generic)
└── formatters/                 # Code formatters
```

## 🚀 Installation

1. **Clone this repository** to your Neovim configuration directory:
   ```bash
   git clone https://github.com/ottojvn/nvim-config ~/.config/nvim
   ```

2. **Start Neovim** - plugins will be automatically installed via lazy.nvim:
   ```bash
   nvim
   ```

3. **For Java development**, install JDTLS via Mason:
   ```
   :MasonInstall jdtls
   ```

## ⚙️ Key Features

- **Plugin Manager**: lazy.nvim with automatic installation
- **LSP Support**: Mason + nvim-lspconfig for multiple languages
- **Java Development**: Full JDTLS integration with debugging and testing
- **Code Completion**: nvim-cmp with snippets
- **File Explorer**: nvim-tree
- **Fuzzy Finding**: Telescope
- **Git Integration**: Integrated git tools
- **Theme**: Rose-pine (customizable)

## 🔧 Testing

Run the included test script to verify the configuration:
```bash
lua test_config.lua
```

## 📝 Notes

- **Generic Paths**: All paths now use environment variables and standard locations
- **Cross-Platform**: Works on Linux, macOS, and Windows
- **No User Dependencies**: No hardcoded usernames or paths
- **Future-Proof**: Uses modern Neovim APIs (vim.uv instead of vim.loop)

## 🐛 Troubleshooting

### JDTLS Issues
If you encounter JDTLS exit code 13:
1. Ensure Java 17+ is installed
2. Run `:MasonInstall jdtls` to reinstall
3. Check `:checkhealth` for any missing dependencies

### Plugin Issues
- Run `:Lazy sync` to update plugins
- Use `:checkhealth` to diagnose issues
- Check `:Lazy` for plugin status

## 🤝 Contributing

This configuration is designed to be generic and reusable. When contributing:
- Avoid hardcoded paths
- Use environment variables for user-specific locations
- Test on multiple systems
- Keep changes minimal and focused