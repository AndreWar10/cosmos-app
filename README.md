# Cosmos

Aplicativo Flutter sobre o universo — imagem astronômica do dia, notícias espaciais, lançamentos de foguetes, sistema solar e asteroides próximos da Terra.

## Screenshots

_Em breve._

## Features

- **Home** — APOD (imagem astronômica do dia), carousel do sistema solar, preview de notícias, próximo lançamento e asteroides próximos
- **News** — Feed de notícias espaciais com busca e paginação
- **Launches** — Lançamentos de foguetes com filtros (futuros/passados) e countdown
- **Planet Detail** — Dados detalhados de cada planeta do sistema solar

## Stack

| | Tecnologia |
|---|---|
| Framework | Flutter |
| Estado | BLoC (`flutter_bloc`) |
| DI | `get_it` |
| HTTP | `dio` |
| Env | `flutter_dotenv` |
| Testes | `flutter_test`, `bloc_test`, `mocktail` |

## Arquitetura

Feature-based com Clean Architecture. Veja [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) para detalhes.

```
lib/
├── core/          # Abstrações compartilhadas
├── features/      # Features (home, news, launches, planets)
│   └── feature/
│       ├── data/           # DataSources, Models, Repositories impl
│       ├── domain/         # Entities, Contracts, UseCases
│       └── presentation/   # Pages, Widgets, BLoCs
├── app.dart
└── main.dart
```

## API

Consome a [Cosmos API](https://github.com/AndreWar10/cosmos-back) — backend proxy que agrega dados da NASA, Spaceflight News e Launch Library 2 com tradução para português.

## Setup

```bash
# Clonar
git clone https://github.com/AndreWar10/cosmos-app.git
cd cosmos-app

# Criar .env na raiz
echo "BASE_URL=https://cosmos-back.onrender.com" > .env

# Instalar dependências
flutter pub get

# Rodar
flutter run
```

## Testes

```bash
flutter test
```

## Desenvolvimento com IA

Este projeto foi desenvolvido com auxílio do **Cursor AI**. As convenções, padrões de arquitetura e regras de código estão documentadas em:

- `.cursor/rules/` — Regras para o assistente de IA
- `docs/ARCHITECTURE.md` — Documentação da arquitetura
