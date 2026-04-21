# SPECTRA – DevOps Demo Site

A static HTML/CSS/JS website with a complete CI/CD pipeline using **Maven + Jenkins + GitHub**.

---

## 📁 Project Structure

```
mysite/
├── src/
│   ├── index.html       ← The website
│   ├── style.css        ← Styles
│   └── app.js           ← JavaScript
├── scripts/
│   ├── push_to_github.sh   ← One-time manual push
│   └── pull_from_github.sh ← Deploy / pull script
├── pom.xml              ← Maven build config
├── assembly.xml         ← Packages site into a .zip artifact
├── Jenkinsfile          ← Declarative CI/CD pipeline
└── .gitignore
```

---

## 🚀 How to Use

### Prerequisites
| Tool | Purpose |
|------|---------|
| Java 11+ | Required by Maven |
| Maven 3.8+ | Build tool |
| Jenkins (local or server) | CI/CD runner |
| Git | Version control |
| GitHub account + PAT | Remote repo + auth |

---

### Step 1 – Create a GitHub repo

1. Go to [github.com/new](https://github.com/new)
2. Create a repo named `spectra-devops-demo` (public or private)
3. Generate a **Personal Access Token (PAT)**: Settings → Developer Settings → Tokens → Classic → check `repo`

---

### Step 2 – First manual push

Edit `scripts/push_to_github.sh` and fill in:
```bash
GITHUB_USERNAME="your_username"
GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
```

Then run:
```bash
chmod +x scripts/push_to_github.sh
./scripts/push_to_github.sh
```

This will:
1. Run `mvn clean package` (validates files + zips the site)
2. Init git, set remote, commit, and push to GitHub

---

### Step 3 – Configure Jenkins

1. Install Jenkins locally: `brew install jenkins-lts` or use Docker
2. Start Jenkins: `jenkins` or `java -jar jenkins.war`
3. Install plugins: **Git**, **Pipeline**, **GitHub**
4. Add your GitHub PAT as a credential:
   - Jenkins → Manage Jenkins → Credentials → Global → Add → **Secret text**
   - ID: `github-pat`, Secret: your PAT
5. Create a **Pipeline** job:
   - New Item → Pipeline
   - In Pipeline section → Definition: **Pipeline script from SCM**
   - SCM: Git → paste your repo URL → credentials: `github-pat`
   - Script Path: `Jenkinsfile`

---

### Step 4 – Jenkins Pipeline Stages

```
Checkout → Maven Build → Push to GitHub → Pull from GitHub
```

| Stage | What it does |
|-------|-------------|
| **Checkout** | Pulls code from GitHub |
| **Maven Build** | Validates files, packages site to `target/` |
| **Push to GitHub** | Commits build artifacts and pushes |
| **Pull from GitHub** | Simulates a deploy by pulling latest |

---

### Step 5 – Pull on server (deploy)

```bash
chmod +x scripts/pull_from_github.sh
./scripts/pull_from_github.sh
```

---

## 🔧 Maven Commands (manual)

```bash
mvn validate          # Check pom.xml and files
mvn clean package     # Build and zip the site
mvn clean             # Remove target/ directory
```

The artifact is generated at: `target/devops-demo-site-1.0.0.zip`

---

## 📸 Site Preview

The site shows:
- Animated terminal typing effect with real git/maven commands
- CI/CD pipeline diagram (steps 01–04)
- Tech stack cards
- Dark brutalist aesthetic with scanline overlay

---

## ⚠️ Security Note

Never commit your GitHub PAT to the repo. Use Jenkins credentials store or environment variables.
