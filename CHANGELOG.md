# Changelog

All notable changes to the meme-generator-skill project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- One-click installation script (`scripts/install-openclaw.sh`)
- Platform detection and guided installation for meme CLI
- Multi-platform support (Linux/macOS/Windows/Android)
- Network troubleshooting guide for download failures
- Bilingual documentation (Chinese/English)

### Features
- 298+ meme templates with categorized reference
- Progressive disclosure structure (SKILL.md + references/)
- Helper script with validation and friendly errors
- Comprehensive usage examples and workflows

## [1.0.0] - 2025-02-07

### Added
- Initial release of `generating-memes` skill for OpenClaw
- SKILL.md with YAML frontmatter and metadata
- Complete template reference (298 templates categorized)
- Usage examples and common workflows
- Helper script `meme_wrapper.sh` for simplified generation
- Installation script with dependency checks
- README.md with installation and usage instructions

### Documentation
- `references/templates.md` - Categorized template list
- `references/examples.md` - Detailed usage examples
- Network troubleshooting for CDN access issues
- Platform-specific installation guides

### Metadata
- `requires.bins: ["meme"]` for binary check
- `install` instructions in metadata.openclaw
- Emoji: 🎭
- Description with trigger keywords

---

## Version Format

- **Major** (X.0.0): Breaking changes, major restructuring
- **Minor** (0.X.0): New features, template additions
- **Patch** (0.0.X): Bug fixes, documentation updates, typo corrections
