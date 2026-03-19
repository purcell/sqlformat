# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is `sqlformat.el`, an Emacs package that provides commands and a minor mode for reformatting SQL using external formatters: `sqlformat`, `pgformatter`, `sqlfluff`, `sql-formatter`, and `sqlfmt`. It is a single-file package built on top of the `reformatter` library.

## Build Commands

```bash
# Run all checks (compile + package-lint)
make all

# Byte-compile only
make compile

# Run package-lint only
make package-lint

# Use a specific Emacs version
EMACS=/path/to/emacs make compile
```

## Architecture

The entire package is in `sqlformat.el`. It uses `reformatter-define` (from the `reformatter` dependency) to generate `sqlformat-buffer`, `sqlformat-region`, and `sqlformat-on-save-mode`. A wrapper `sqlformat` command adds paragraph-based formatting when no region is active. The `sqlformat-command` custom variable selects which external formatter to use, and `sqlformat-args` passes extra CLI arguments.

## Key Constraints

- Must support Emacs 24.3+ (per `Package-Requires`)
- CI tests byte-compilation across Emacs 24.4 through snapshot
- Only runtime dependency is `reformatter` (>= 0.3)
