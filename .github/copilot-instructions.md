# Neovim Configuration Repository
Personal Neovim configuration with lazy.nvim plugin management, comprehensive LSP setup with focus on Java development, and utility scripts for Java extension management.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Bootstrap and Setup
- **CRITICAL**: Ensure all required dependencies are installed first:
  - `sudo apt update && sudo apt install -y neovim openjdk-21-jdk maven nodejs npm`
  - **WARNING**: Java 21 is REQUIRED for java-debug compilation. Java 17 will cause build failures.
- **CRITICAL**: Use Java 21 or higher: `export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64`
- **NEVER CANCEL**: Initial Neovim startup with plugin installation takes 10-15 minutes. Set timeout to 20+ minutes.
- Start Neovim normally to trigger lazy.nvim bootstrap and plugin installation:
  - `nvim` (first startup automatically installs all plugins)
  - **TIMEOUT WARNING**: Plugin installation can take 10-15 minutes. NEVER CANCEL during this process.

### Java Extension Compilation
- **CRITICAL**: Java extensions must be compiled after plugin installation for full Java LSP functionality.
- Compile Java debug extension:
  - `bash scripts/compile_java_debug.sh`
  - **NEVER CANCEL**: Maven build takes 45-60 seconds with Java 21, but can take 5+ minutes on slower systems.
  - **FAILURE NOTE**: Will fail with Java 17 due to Eclipse dependency requirements.
- Compile Java test extension:
  - `bash scripts/compile_java_test.sh`  
  - **NEVER CANCEL**: npm install and build takes 30-45 seconds but can take 5+ minutes on slower systems.
  - This script typically succeeds regardless of Java version.

### Build and Validation Steps
- **NO TRADITIONAL BUILD**: This is a Neovim configuration, not a compiled application.
- Validate configuration:
  - `nvim --headless -c 'checkhealth' -c 'quit'` -- health check takes 5-10 seconds
  - `bash scripts/diagnose_jdtls.sh` -- Java LSP diagnostic takes 1-2 seconds
- **VALIDATION SCENARIOS**: Test complete development workflow:
  - Create a simple Java file: `echo 'public class Test { public static void main(String[] args) { System.out.println("Hello"); } }' > Test.java`
  - Open with Neovim: `nvim Test.java`
  - Verify LSP features work: hover, completion, diagnostics
  - Test Java debugging and testing capabilities if java-debug compiled successfully

### Running the Configuration
- **ALWAYS**: Let initial plugin installation complete before making changes
- Start Neovim: `nvim` or `nvim [filename]`
- **FIRST STARTUP**: Takes 10-15 minutes for complete plugin installation. Subsequent startups take 1-2 seconds.
- Access plugin manager: `:Lazy` to view/update plugins
- Access LSP installer: `:Mason` to install language servers

## Validation

### Manual Testing Requirements
- **ALWAYS**: Test Java LSP functionality after any changes to Java configurations
- **CRITICAL**: Verify Mason-installed LSP servers work: `:Mason` should show jdtls as installed
- Test key plugins load correctly:
  - Telescope fuzzy finder: `:Telescope find_files`
  - LSP functionality: Open a Java file and verify hover/completion works
  - Treesitter syntax highlighting: Should show colored syntax in various file types
- **JAVA WORKFLOW**: Create and edit a Java file to verify complete development environment
- **DIAGNOSTIC CHECK**: Always run `bash scripts/diagnose_jdtls.sh` after Java-related changes

### Common Issues and Solutions
- **Plugin installation hangs**: Wait full 15-20 minutes before considering intervention
- **Java debug compilation fails**: Ensure Java 21+ is installed and JAVA_HOME is set correctly
- **LSP not working**: Run `:Mason` and verify jdtls is installed, then `:LspInfo` to check status
- **Slow startup**: Normal on first run due to plugin compilation, subsequent startups are fast

## Common Tasks

### Directory Structure
```
nvim-config/
├── init.lua                 -- Main configuration entry point
├── lua/
│   ├── core/               -- Core Neovim settings
│   │   ├── options.lua     -- Vim options and settings  
│   │   ├── keymaps.lua     -- Key mappings
│   │   └── autocmds.lua    -- Auto commands
│   ├── plugins/            -- Plugin configurations
│   │   ├── init.lua        -- Plugin manager setup
│   │   └── configs/        -- Individual plugin configs
│   └── utils/              -- Utility modules for Java/LSP
├── scripts/                -- Utility bash scripts
│   ├── compile_java_debug.sh    -- Compile java-debug extension
│   ├── compile_java_test.sh     -- Compile vscode-java-test
│   ├── diagnose_jdtls.sh        -- Diagnose Java LSP issues
│   └── [other scripts...]
└── formatters/             -- Java code formatting styles
```

### Key Configuration Files
- `init.lua`: Bootstraps lazy.nvim and loads core modules (56 lines)
- `lua/core/options.lua`: Essential Neovim settings, diagnostics config (73 lines) 
- `lua/plugins/init.lua`: Plugin manager configuration with import statements (72 lines)
- `lua/plugins/configs/lsp.lua`: LSP and Mason configuration with language servers
- `lua/utils/jdtls.lua`: Java LSP configuration with debug/test extension support

### Essential Commands Reference
```bash
# Repository setup
nvim                                    # First startup: 10-15 min plugin install
bash scripts/compile_java_debug.sh     # 45-60 sec Maven build (requires Java 21+)
bash scripts/compile_java_test.sh      # 30-45 sec npm build
bash scripts/diagnose_jdtls.sh         # 1-2 sec diagnostic check

# Inside Neovim
:Lazy                                   # Plugin manager interface
:Mason                                  # LSP server installer
:checkhealth                           # Configuration health check
:LspInfo                               # Show LSP server status
```

### Plugin Categories
- **Plugin Manager**: lazy.nvim with auto-installation and updates
- **LSP**: nvim-lspconfig + mason.nvim for language server management
- **Java Development**: nvim-jdtls + java-debug + vscode-java-test extensions
- **Completion**: nvim-cmp with LSP, buffer, path, and snippet sources
- **UI**: lualine.nvim, nvim-notify, nvim-autopairs, which-key.nvim
- **Fuzzy Finding**: telescope.nvim with fzf native extension
- **Syntax**: nvim-treesitter with textobjects and autotag
- **Git**: gitsigns.nvim for git integration
- **Formatting**: conform.nvim for code formatting

### Performance Notes
- Initial setup: 10-15 minutes (plugin installation + compilation)
- Java debug compilation: 45-60 seconds (Java 21 required)
- Java test compilation: 30-45 seconds  
- Subsequent Neovim startup: 1-2 seconds
- Script execution: Most utility scripts complete in under 5 seconds