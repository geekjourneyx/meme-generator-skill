# Changelog

All notable changes to the meme-generator-skill project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Remove `emotional-companion` skill - decided to keep the skill simple and let OpenClaw handle emotional intelligence directly
- Remove `meme_wrapper.sh` script - use `meme` CLI directly for better flexibility
- Remove ClawHub references - not currently supported
- Update SKILL.md to reference `meme-generator-rs` (correct repo name)
- Simplify README.md to remove obsolete script references

### Added
- Auto-install meme CLI in install script - detects platform and installs from GitHub Releases
- Auto-download templates - runs `meme download` if resources not found

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
