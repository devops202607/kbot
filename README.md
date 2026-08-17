# kbot

Telegram-bot

[Cobra](https://github.com/spf13/cobra)

[telebot](https://gopkg.in/telebot.v3)

**Bot link:** <https://t.me/dmytrozaiets_kbot>

## CI/CD Workflow

```mermaid
flowchart TD
    A[Developer] -->|push| B{Branch?}

    B -->|develop| C[build-develop.yml]
    B -->|tag v*| D[build-image.yml]

    C --> C1[Build image<br/>v1.0.x-HASH-linux-amd64]
    C1 --> C2[Push to GHCR]
    C2 --> C3[Update helm/kbot/values.yaml]
    C3 --> C4[Commit & push tag update]

    D --> D1[Build image<br/>v1.0.x-HASH-linux-amd64]
    D1 --> D2[Push to GHCR]

    C2 --> E[ghcr.io/devops202607/kbot]
    D2 --> E

    E --> F[Helm deploy to K8s]

    style C fill:#4caf50,color:#fff
    style D fill:#2196f3,color:#fff
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
