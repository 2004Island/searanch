# Contributing Guide

Thank you for your interest in contributing to our documentation!

## Quick Start with Docker

1. **Fork** this repository on GitHub
2. **Clone** your fork:
```bash
   git clone https://github.com/YOUR-USERNAME/my-hugo-site.git
   cd my-hugo-site
```
3. **Start the development server**:
```bash
   docker-compose up
```
4. **Visit** http://localhost:1313 in your browser

## Adding New Documentation

### File Structure

Content is organized under `content/docs/`:
```
content/
└── docs/
    ├── _index.md              (Main docs page)
    ├── getting-started/
    │   ├── _index.md
    │   └── introduction.md
    └── contributing/
        ├── _index.md
        ├── writing-guide.md
        └── how-to-contribute.md
```

### Creating a New Page

1. Create a new `.md` file in the appropriate directory
2. Add front matter:
```yaml
   ---
   title: "Your Page Title"
   weight: 1
   ---
```
3. Write your content in Markdown
4. The page will automatically appear in the menu

### Creating a New Section

1. Create a new directory under `content/docs/`
2. Add an `_index.md` file:
```yaml
   ---
   title: "Section Name"
   weight: 10
   bookCollapseSection: false
   ---
   
   # Section Name
   
   Section introduction...
```

## Pull Request Process

1. Create a new branch: `git checkout -b your-branch-name`
2. Make your changes
3. Test locally with `docker-compose up`
4. Commit: `git commit -m "Description of changes"`
5. Push: `git push origin your-branch-name`
6. Open a Pull Request on GitHub

## Content Guidelines

- Use clear, concise language
- Include code examples where relevant
- Add images to `static/images/` if needed
- Use proper Markdown formatting
- Check spelling and grammar

## Questions?

Open an issue on GitHub if you need help!
