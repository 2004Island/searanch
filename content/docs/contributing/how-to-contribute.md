---
title: "How to Contribute"
weight: 2
---

# How to Contribute

## Prerequisites

- A GitHub account
- Docker installed on your computer
- Git installed on your computer

## Step-by-Step Process

### 1. Fork the Repository

Click the "Fork" button at the top right of the GitHub repository page.

### 2. Clone Your Fork
```bash
git clone https://github.com/YOUR-USERNAME/my-hugo-site.git
cd my-hugo-site
```

### 3. Run Locally with Docker
```bash
docker-compose up
```

Visit http://localhost:1313 to see your local version.

### 4. Create a New Branch
```bash
git checkout -b add-my-documentation
```

### 5. Add Your Content

Create a new markdown file in the appropriate section under `content/docs/`.

Example:
```bash
# Create a new file
nano content/docs/my-section/my-page.md
```

Add this content:
```markdown
---
title: "My New Page"
weight: 1
---

# My New Page

Your content here...
```

### 6. Test Your Changes

The site should automatically reload at http://localhost:1313. Check that your page appears in the menu and looks correct.

### 7. Commit Your Changes
```bash
git add .
git commit -m "Add documentation about XYZ"
```

### 8. Push to Your Fork
```bash
git push origin add-my-documentation
```

### 9. Create a Pull Request

1. Go to your fork on GitHub
2. Click "Pull requests" → "New pull request"
3. Select your branch
4. Add a description of your changes
5. Click "Create pull request"

## What Happens Next?

- GitHub Actions will automatically build your changes to verify they work
- A maintainer will review your pull request
- Once approved and merged, your changes will be automatically deployed!
