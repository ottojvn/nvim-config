# JDTLS Exit Code 13 Fix

## Problem
JDTLS was exiting with code 13 due to warnings about incubator modules:
```
WARNING: Using incubator modules: jdk.incubator.vector
```

## Root Cause
The previous configuration was **explicitly enabling** incubator modules with:
- `--enable-preview`
- `--add-modules jdk.incubator.vector`

These flags were intended to support Java 21+ features but were actually causing the warnings that led to exit code 13.

## Solution
1. **Removed problematic flags** that enable incubator modules
2. **Added suppression flags** to prevent the warnings:
   - `-Xlog:module=off` for Java 21+ to suppress module warnings
   - Kept existing `-Djdk.incubator.vector.VECTOR_ACCESS_OOB_CHECK=0`
3. **Improved log filtering** with safer error handling and more patterns

## Files Changed
- `lua/utils/jdtls.lua`: Updated JVM flags configuration
- `lua/utils/java_config.lua`: Enhanced log filtering patterns

## Testing
To verify the fix works:
1. Open a Java project in Neovim
2. Check that JDTLS starts without exit code 13
3. Verify LSP functionality (completion, go-to-definition, etc.) still works
4. Check LSP logs (`~/.local/state/nvim/lsp.log`) for absence of incubator warnings

## Key Insight
Sometimes the solution to suppressing warnings is **not enabling the feature** rather than trying to suppress it after enabling it.