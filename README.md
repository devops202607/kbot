# kbot

Telegram-bot

[Cobra](https://github.com/spf13/cobra)

[telebot](https://gopkg.in/telebot.v3)

**Bot link:** <https://t.me/dmytrozaiets_kbot>

## CI/CD Workflow

```mermaid
flowchart TD
    A[Developer] -->|push to develop| B[build.yml]

    subgraph ci [CI]
        B --> C[Build image<br/>v1.0.x-HASH]
        C --> D[Push to GHCR]
    end

    D -->|needs.ci| E[cd]

    subgraph cd [CD]
        E --> F[Update helm chart<br/>values.yaml + Chart.yaml]
        F --> G[Commit & push]
    end

    G --> H[Git repository]
    H -->|pull & sync| I[ArgoCD]
    I -->|deploy| J[K8s cluster]

    D --> K[ghcr.io/devops202607/kbot]

    style ci fill:#2196f3,color:#fff
    style cd fill:#4caf50,color:#fff
    style I fill:#ff9800,color:#fff
```

## Build

```bash
git clone https://github.com/devops202607/kbot.git
cd kbot
make linux
```

## Usage

```bash
export TELE_TOKEN="your-telegram-bot-token"
./kbot start
```

### CLI commands

`kbot start` - start bot

`kbot version` - show version

### Command for bot in Telegram

`hello` - say Hello, show version

Example:
```
User: hello
KBot: Hello, I'm KBot v1.0.3!
```
