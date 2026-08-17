# kbot

Telegram-bot

[Cobra](https://github.com/spf13/cobra)

[telebot](https://gopkg.in/telebot.v3)

**Bot link:** <https://t.me/dmytrozaiets_kbot>

## CI/CD Workflow

```mermaid
flowchart TD
    A[Developer] -->|push to develop| B[build.yml]

    subgraph build
        B --> C[Build image<br/>v1.0.x-HASH-linux-amd64]
        C --> D[Push to GHCR]
    end

    D -->|needs.build| E[cd]

    subgraph cd
        E --> F[Update helm/kbot/values.yaml<br/>with yq]
        F --> G[Commit & push]
    end

    D --> H[ghcr.io/devops202607/kbot]
    H --> I[Helm deploy to K8s]

    style build fill:#2196f3,color:#fff
    style cd fill:#4caf50,color:#fff
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
