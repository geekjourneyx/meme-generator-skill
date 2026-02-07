# Meme Generation Examples

Practical examples for creating memes with various templates.

## Table of Contents

- [Basic Examples](#basic-examples)
- [Text-Only Memes](#text-only-memes)
- [Image-Based Memes](#image-based-memes)
- [Advanced Usage](#advanced-usage)
- [Common Workflows](#common-workflows)

---

## Basic Examples

### Petpet Meme (Most Popular)

The petpet template creates a petting animation.

```bash
# Using a local image
meme generate petpet --images avatar.jpg

# Save to file
meme generate petpet --images avatar.jpg > petpet.gif

# With circular crop
meme generate petpet --images avatar.jpg --circle > petpet_circle.gif
```

**Requirements**: 1 image, 0 text
**Optional**: `--circle` flag for circular image

---

### Slap Meme

Creates a slapping animation.

```bash
meme generate slap --images target.jpg > slap.gif
```

**Requirements**: 1 image, 0 text

---

### Hug Meme

Creates a hugging animation.

```bash
meme generate hug --images friend.jpg > hug.gif
```

**Requirements**: 1 image, 0 text

---

### Rub/Nuzzle Meme

Creates a nuzzling animation.

```bash
meme generate rub --images person.jpg > rub.gif
```

**Requirements**: 1 image, 0 text

---

## Text-Only Memes

### 5000兆 (Big/Small Contrast)

Creates a big/small text contrast meme.

```bash
meme generate 5000choyen --texts "IMPORTANT" "ignore this"
```

**Requirements**: 0 images, 2 text (big, small)

**Example output**:
```
IMPORTANT
    ignore this
```

---

### Always Meme

Creates an "always" format meme.

```bash
meme generate always --texts "the answer is 42"
```

**Requirements**: 0 images, 1 text

---

### YouTube Style

Creates a YouTube-style thumbnail.

```bash
meme generate youtube --texts "Video Title" "Channel Name"
```

**Requirements**: 0 images, 2 text

---

### Good News Header

Creates a "good news" header.

```bash
meme generate good_news --texts "Project completed!"
```

**Requirements**: 0 images, 1 text

---

### Bad News Header

Creates a "bad news" header.

```bash
meme generate bad_news --emails "Deployment failed"
```

**Requirements**: 0 images, 1 text

---

### Shock Meme

Creates a shocked reaction.

```bash
meme generate shock --texts "What?!"
```

**Requirements**: 0 images, 1 text

---

## Image-Based Memes

### Petpet (Multiple Variants)

```bash
# Standard petpet
meme generate petpet --images photo.jpg

# Circular crop
meme generate petpet --images photo.jpg --circle

# With custom output name
meme generate petpet --images photo.jpg > my_petpet.gif
```

---

### Slap

```bash
meme generate slap --images target.jpg
```

---

### Pat

```bash
meme generate pat --images head.jpg
```

---

### Pinch

```bash
meme generate pinch --images face.jpg
```

---

### Kiss

```bash
meme generate kiss --images partner.jpg
```

---

### Hug

```bash
meme generate hug --images friend.jpg
```

---

### Stare

```bash
meme generate stare_at_you --images person.jpg
```

---

## Advanced Usage

### Using the Wrapper Script

The wrapper script simplifies the generate command with better error handling.

```bash
# Basic usage
{baseDir}/scripts/meme_wrapper.sh petpet avatar.jpg output.gif

# With default output (meme_output.gif)
{baseDir}/scripts/meme_wrapper.sh petpet avatar.jpg

# The script outputs MEDIA: prefix for auto-attachment
```

**Script features**:
- Validates template exists before generating
- Validates input file exists
- Outputs `MEDIA:` prefix for OpenClaw auto-attachment
- Clear error messages

---

### Batch Processing

Generate multiple memes at once:

```bash
# Create petpet variants for all images
for img in *.jpg; do
    meme generate petpet --images "$img" > "petpet_$(basename $img .jpg).gif"
done

# Create slap variants
for img in faces/*.jpg; do
    meme generate slap --images "$img" > "slap_$(basename $img .jpg).gif"
done
```

---

### Custom Parameters (Abstinence Example)

Some templates have optional parameters:

```bash
# Check available parameters
meme info abstinence

# Generate with time parameter
meme generate abstinence --images user.jpg --time "30d"
```

---

### Multiple Images

Some templates accept multiple images:

```bash
# Check template requirements first
meme info <template>

# Generate with multiple images (if supported)
meme generate <template> --images img1.jpg img2.jpg img3.jpg
```

---

### Text + Image Templates

Templates that accept both images and text:

```bash
# Check requirements
meme info high_eq

# Generate with both
meme generate high_eq --images reaction.jpg --texts "Low EQ" "High EQ description"
```

---

## Common Workflows

### Workflow 1: Discovery -> Preview -> Generate

When you don't know which template to use:

```bash
# 1. Search for templates by keyword
meme search "pet"

# 2. Preview the template to see what it looks like
meme preview petpet

# 3. Check requirements
meme info petpet

# 4. Generate the meme
meme generate petpet --images photo.jpg > output.gif
```

---

### Workflow 2: List -> Filter -> Generate

When browsing all templates:

```bash
# 1. List all templates and filter
meme list | grep -i "hug"

# 2. Get detailed info
meme info hug

# 3. Generate
meme generate hug --images friend.jpg > hug.gif
```

---

### Workflow 3: Quick Generate (Known Template)

When you already know the template:

```bash
# Generate directly
meme generate petpet --images photo.jpg > petpet.gif

# Or use the wrapper script
{baseDir}/scripts/meme_wrapper.sh petpet photo.jpg petpet.gif
```

---

### Workflow 4: Text Meme Generation

For text-based memes:

```bash
# 1. Find a text template
meme search "text"

# 2. Check if it needs images
meme info 5000choyen

# 3. Generate with text
meme generate 5000choyen --texts "BIG" "small"
```

---

## Template-Specific Examples

### Anime/Game Characters

```bash
# Anya likes
meme generate anya_suki --images photo.jpg

# Genshin eating
meme generate genshin_eat --images character.jpg

# Lu Xun quote
meme generate luxun_say --texts "鲁迅说过"
```

---

### Reactions/Emotions

```bash
# Applause
meme generate applaud --images clapping.jpg

# Shocked
meme generate shock --texts "震惊!"

# Speechless
meme generate speechless --images expression.jpg

# Clown
meme generate clown --images face.jpg
```

---

### Visual Effects

```bash
# Pixelate
meme generate pixelate --images photo.jpg

# 3D Rotate
meme generate rotate_3d --images object.jpg

# Symmetric
meme generate symmetric --images face.jpg

# Kaleidoscope
meme generate kaleidoscope --images pattern.jpg
```

---

## Tips and Tricks

### Saving Output

Always redirect output to save the file:

```bash
# Good - saves to file
meme generate petpet --images photo.jpg > output.gif

# Bad - outputs to terminal (binary garbage)
meme generate petpet --images photo.jpg
```

---

### Checking Requirements First

Always check template info before generating:

```bash
# See what the template needs
meme info <template>

# This tells you:
# - How many images are required
# - How many text arguments are needed
# - What optional parameters are available
```

---

### Using Preview

Preview templates before committing:

```bash
# Generate a preview to see the template structure
meme preview petpet
```

---

### Downloading Resources

If templates are missing resources:

```bash
# Download all required assets
meme download
```

---

## Troubleshooting Examples

### Template Not Found

```bash
# Verify template exists
meme list | grep petpet

# Search for similar templates
meme search "pet"

# Case matters - use lowercase
meme generate PetPet --images photo.jpg  # Wrong
meme generate petpet --images photo.jpg  # Correct
```

---

### Missing Images

```bash
# Verify image exists
ls -la photo.jpg

# Use absolute path if needed
meme generate petpet --images /full/path/to/photo.jpg
```

---

### Permission Issues

```bash
# Make script executable
chmod +x {baseDir}/scripts/meme_wrapper.sh

# Make output directory writable
mkdir -p output
chmod +w output
```

---

### Network Issues (Download Failed)

If `meme download` fails:

```bash
# Typical error:
# WARN Failed to download: Connection timed out (os error 110)
# The CLI cannot reach cdn.jsdelivr.net

# Solution: Try generating directly - some templates work offline
meme generate petpet --images photo.jpg > test.gif

# Alternative: Download resources manually from GitHub releases
# https://github.com/MemeCrafters/meme-generator-rs/releases
```

**Note**: Some templates have built-in assets and work without downloading resources.

---

## Output Format

Generated memes are typically in GIF format for animations and PNG for static images.

### For OpenClaw Integration

Use the wrapper script which outputs `MEDIA:` prefix:

```bash
{baseDir}/scripts/meme_wrapper.sh petpet photo.jpg output.gif
# Outputs: MEDIA:/path/to/output.gif
```

This allows OpenClaw to automatically attach the generated file to responses.
