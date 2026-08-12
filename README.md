# Cosmos

Aplicativo Flutter sobre o universo — imagem astronômica do dia, notícias espaciais, lançamentos de foguetes, sistema solar interativo e quiz.

## Features

- **Home** — APOD (imagem astronômica do dia), sistema solar interativo, carrossel de notícias recentes e próximos lançamentos com pull-to-refresh
- **News** — Feed de notícias espaciais com busca e paginação infinita
- **Quiz** — Em breve
- **Settings** — Tema dark/light e idioma (PT/EN) com persistência em cache

### Detalhe de features

| Feature | Descrição |
|---|---|
| APOD | Imagem astronômica do dia via NASA API |
| Sistema Solar | Grid de planetas com ícones animados e tela de detalhe com dados orbitais |
| Notícias | Feed paginado com busca, carrossel na Home e listagem completa na tab |
| Lançamentos | Carrossel na Home com "Ver todos" abrindo listagem completa com filtros (próximos/passados/todos) e paginação |
| Tema & Idioma | Persistência via SharedPreferences, tema padrão dark, idioma padrão do sistema |

## Stack

| | Tecnologia |
|---|---|
| Framework | Flutter |
| Estado | BLoC / Cubit (`flutter_bloc`) |
| DI | `get_it` |
| HTTP | `dio` |
| Cache | `shared_preferences` |
| Imagens | `cached_network_image` |
| Env | `flutter_dotenv` |
| i18n | ARB + `flutter gen-l10n` |
| Testes | `flutter_test`, `bloc_test`, `mocktail` |

## Arquitetura

Feature-based com Clean Architecture. Veja [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) para detalhes.

```
lib/
├── core/            # Abstrações compartilhadas (rede, cache, tema, DI, rotas)
├── i18n/            # ARB files + gerados (i18n)
├── features/
│   ├── home/        # Home (APOD, sistema solar, carrosséis)
│   ├── news/        # Feed de notícias
│   ├── launches/    # Lançamentos de foguetes
│   ├── quiz/        # Quiz (em breve)
│   └── settings/    # Configurações (tema, idioma)
└── main.dart
```

## API

Consome a [Cosmos API](https://github.com/AndreWar10/cosmos-back) — backend proxy que agrega dados da NASA, Spaceflight News e Launch Library 2 com tradução para português.

### Endpoints utilizados

| Endpoint | Descrição |
|---|---|
| `/api/apod` | Imagem astronômica do dia |
| `/api/news` | Notícias espaciais (paginadas) |
| `/api/launches` | Lançamentos de foguetes (paginados, filtráveis) |
| `/api/solar-system` | Dados do sistema solar |

## Internacionalização

O app suporta **Português** e **Inglês**, configurável em Settings.

- Arquivos ARB em `lib/i18n/`
- Classe gerada `AppLocalizations` via `flutter gen-l10n`
- Acesso nos widgets via `context.translate` (extension)
- Idioma padrão: idioma do sistema (se suportado), senão inglês

## Setup

```bash
git clone https://github.com/AndreWar10/cosmos-app.git
cd cosmos-app

# Criar .env na raiz
echo "BASE_URL=https://cosmos-back.onrender.com" > .env

# Gerar i18n e instalar dependências
flutter gen-l10n
flutter pub get

# Rodar
flutter run
```

## Testes

```bash
flutter test
```

119 testes cobrindo:
- **Domain**: UseCases (APOD, News, Launches, Planet)
- **Data**: DataSources, Repositories, Models
- **Presentation**: BLoCs/Cubits, Pages, Widgets
- **Core**: Navegação, Tema, Locale

## Desenvolvimento com IA

Este projeto foi desenvolvido com auxílio do **Cursor AI**. As convenções, padrões de arquitetura e regras de código estão documentadas em:

- `.cursor/rules/` — Regras para o assistente de IA
- `docs/ARCHITECTURE.md` — Documentação da arquitetura
