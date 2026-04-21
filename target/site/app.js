// Terminal typing effect
const commands = [
  "mvn clean package",
  "git add -A && git commit -m 'build: v1.0.0'",
  "git push origin main",
  "echo 'Pushed to GitHub ✓'",
  "git pull origin main",
  "echo 'Deployed successfully ✓'",
];

let cmdIdx = 0, charIdx = 0;
const el = document.getElementById("typed");

function typeChar() {
  const cmd = commands[cmdIdx];
  if (charIdx < cmd.length) {
    el.textContent += cmd[charIdx++];
    setTimeout(typeChar, 45 + Math.random() * 30);
  } else {
    setTimeout(clearLine, 1400);
  }
}

function clearLine() {
  el.textContent = "";
  charIdx = 0;
  cmdIdx = (cmdIdx + 1) % commands.length;
  setTimeout(typeChar, 300);
}

typeChar();

// Fade-in on scroll for pipeline steps
const observer = new IntersectionObserver(entries => {
  entries.forEach(e => {
    if (e.isIntersecting) e.target.style.opacity = "1";
  });
}, { threshold: 0.1 });

document.querySelectorAll(".step, .card").forEach(el => observer.observe(el));
