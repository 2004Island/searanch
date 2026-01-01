---
title: "Writing Guide"
weight: 1
---

# Writing Guide

## Creating a New Page

1. Create a new markdown file in the appropriate section under `content/docs/`
2. Add front matter at the top:
```yaml
---
title: "Your Page Title"
weight: 1
---
```

3. Write your content in Markdown

## Markdown Basics

### Headers
```markdown
# H1 Header
## H2 Header
### H3 Header
```

### Links
```markdown
[Link text](https://example.com)
```

### Code Blocks

Use triple backticks for code:
def hello():
    print("Hello, world!")
```
```

### Images
```markdown
![Alt text](/images/image.png)
```

## Organizing Content

The Book theme uses the file structure to create the menu. Files are ordered by the `weight` parameter in the front matter (lower numbers appear first).

### Example Structure
```
content/
└── docs/
    ├── _index.md (Section homepage)
    ├── section-1/
    │   ├── _index.md
    │   ├── page-1.md
    │   └── page-2.md
    └── section-2/
        ├── _index.md
        └── page-1.md
```
