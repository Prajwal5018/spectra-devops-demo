// ============================================================
//  SPECTRA – Jenkins Declarative Pipeline
//  Stages: Checkout → Build (Maven) → Push to GitHub → Pull from GitHub
// ============================================================

pipeline {

  agent any   // Run on any available Jenkins agent

  // ── Environment variables ──────────────────────────────────
  environment {
    GITHUB_REPO    = "https://github.com/<YOUR_USERNAME>/<YOUR_REPO>.git"
    GITHUB_BRANCH  = "main"
    GIT_USER_EMAIL = "jenkins@yourdomain.com"
    GIT_USER_NAME  = "Jenkins CI"

    // Jenkins credential ID that stores your GitHub Personal Access Token (PAT)
    // Go to: Jenkins → Manage Jenkins → Credentials → Add → Secret text
    GH_TOKEN = credentials('github-pat')
  }

  // ── Triggers ──────────────────────────────────────────────
  triggers {
    pollSCM('H/5 * * * *')   // Poll GitHub every 5 minutes
  }

  stages {

    // ── Stage 1: Checkout source code ──────────────────────
    stage('Checkout') {
      steps {
        echo '▶ Checking out source code from GitHub...'
        git branch: "${GITHUB_BRANCH}",
            credentialsId: 'github-pat',
            url: "${GITHUB_REPO}"
      }
    }

    // ── Stage 2: Validate & Build with Maven ───────────────
    stage('Maven Build') {
      steps {
        echo '▶ Running Maven clean package...'
        sh '''
          mvn --version
          mvn clean package -B
        '''
      }
      post {
        success {
          echo '✅ Maven build succeeded. Artifact in target/'
          archiveArtifacts artifacts: 'target/*.zip', fingerprint: true
        }
        failure {
          echo '❌ Maven build failed. Check pom.xml and src/ files.'
        }
      }
    }

    // ── Stage 3: Push to GitHub ────────────────────────────
    stage('Push to GitHub') {
      steps {
        echo '▶ Configuring git identity and pushing...'
        sh '''
          # Configure git user inside Jenkins workspace
          git config user.email "${GIT_USER_EMAIL}"
          git config user.name  "${GIT_USER_NAME}"

          # Set remote URL with embedded token for auth (HTTPS push)
          REPO_WITH_TOKEN=$(echo "${GITHUB_REPO}" | sed "s|https://|https://${GH_TOKEN}@|")
          git remote set-url origin "$REPO_WITH_TOKEN"

          # Stage any generated/changed files (e.g., updated build artifacts)
          git add -A

          # Commit only if there are staged changes
          if ! git diff --cached --quiet; then
            git commit -m "ci: automated build by Jenkins [Build #${BUILD_NUMBER}]"
            git push origin ${GITHUB_BRANCH}
            echo "✅ Code pushed to GitHub branch: ${GITHUB_BRANCH}"
          else
            echo "ℹ️  Nothing new to commit – skipping push."
          fi
        '''
      }
    }

    // ── Stage 4: Pull from GitHub (simulate deploy) ────────
    stage('Pull from GitHub') {
      steps {
        echo '▶ Pulling latest code from GitHub to simulate deploy...'
        sh '''
          # In a real scenario this step would SSH into your server
          # and do a `git pull` there. Here we do it in the workspace.
          git fetch origin
          git reset --hard origin/${GITHUB_BRANCH}
          echo "✅ Latest code pulled from ${GITHUB_BRANCH}"
          echo "--- Files in workspace ---"
          ls -lh src/
        '''
      }
    }

  } // end stages

  // ── Post pipeline actions ─────────────────────────────────
  post {
    always {
      echo '🏁 Pipeline finished.'
    }
    success {
      echo '🎉 All stages passed! Site is live on GitHub.'
    }
    failure {
      echo '🚨 Pipeline failed. Check stage logs above.'
    }
  }

} // end pipeline
