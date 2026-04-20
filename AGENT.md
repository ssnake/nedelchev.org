# AI Agent Context File: nedelchev.org

This file provides essential context, architecture details, and rules for any AI agent interacting with this repository.

## Repository Overview
This repository contains the source code for the personal blog of Max Nedelchev (nedelchev.org). It is a static site built with **Jekyll**, utilizing **HAML** for templating, and includes an embedded **v86** (x86 WebAssembly emulator) to run ReactOS and legacy games directly in the browser.

## Tech Stack
- **Static Site Generator:** Jekyll (~> 4.4.1)
- **Language:** Ruby (Targeting 3.3 in CI)
- **Templating:** HAML (via `jekyll-haml` plugin). All layouts in `_layouts/` and many pages (like `404.haml`, `blog.haml`) are written in HAML, not standard HTML.
- **Markdown:** Kramdown (GFM input, Rouge syntax highlighter)
- **Emulator Integration:** v86 (`assets/v86/`) for running a ReactOS virtual machine.

## Directory Structure
- `_layouts/` - HAML templates for pages, posts, and default layouts.
- `_posts/` - Markdown files containing blog posts.
- `assets/css/` - Custom stylesheets.
- `assets/images/` - Standard image assets.
- `assets/v86/` - v86 emulator core files (`v86.wasm`, `libv86.js`, `seabios.bin`) and VM images/states.
- `doc/` - Utility scripts and documentation for creating, managing, compressing, and chunking VM images for the v86 emulator.

## v86 Emulator Integration
The site features an embedded emulator running ReactOS to play a legacy game. Important mechanics:
1. **VM States:** The emulator loads state from a saved snapshot. States are compressed using ZSTD (e.g., `reactos.state.bin.zst`) to drastically reduce download size (~119MB down to ~20MB).
2. **Chunked Disk Images:** To avoid loading massive 2GB disk images into memory at once, the disk image is split into byte-range chunks (e.g., `reactos-0-103809024.img.zst`) using `split-image.py` in the `doc/` folder.
3. **Local Dev Server:** When testing v86 locally, use `python3 doc/serve-test.py` as it supports HTTP range requests which are mandatory for the async disk image loading. Standard Jekyll serve might not handle these requests correctly.

## Deployment
- Deployment is fully automated via GitHub Actions (`.github/workflows/deploy.yml`).
- Pushing to the `master` branch triggers the build process.
- The site is built with `JEKYLL_ENV=production` and deployed directly to GitHub Pages.

## Important Rules for AI Agents
1. **Layout Modifications:** Remember that this site uses HAML. Do not output raw HTML files in the `_layouts/` directory unless instructed to move away from HAML.
2. **Ruby Environment:** Rely on `bundle exec jekyll ...` when running commands locally to respect the `Gemfile.lock`.
3. **Markdown Formatting:** Posts should use standard Jekyll frontmatter. Ensure proper formatting and use Rouge for syntax highlighting in Markdown files.
