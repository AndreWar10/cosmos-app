# Cosmos

Aplicativo Flutter sobre o universo — imagem astronômica do dia, notícias espaciais, lançamentos de foguetes, sistema solar interativo, observatórios brasileiros e quiz espacial.

## Features

| Feature | Descrição |
|---|---|
| **Home** | APOD (imagem astronômica do dia), sistema solar interativo, carrossel de notícias, observatórios e próximos lançamentos com pull-to-refresh |
| **News** | Feed de notícias espaciais com busca e paginação infinita, tela de detalhe com webview integrada |
| **Quiz** | 4 categorias, ~50 perguntas PT/EN, timer de 30s, efeitos sonoros e hápticos, ranking por categoria |
| **Settings** | Tema dark/light, idioma (PT/EN) e efeitos sonoros com persistência em cache |
| **APOD Detail** | Navegação por data (anterior/próximo dia) com fallback automático |
| **Planet Detail** | Dados orbitais, satélites, temperatura e gravidade com modelo 3D interativo |
| **Launch Detail** | Patch da missão, status, links para webcast/Wikipedia/artigo via webview |
| **Observatórios** | 7 observatórios brasileiros com detalhes, avaliação e links para sites/maps |

## Screenshots

*Em breve*

## Stack

| | Tecnologia |
|---|---|
| Framework | Flutter |
| Estado | BLoC / Cubit (`flutter_bloc`) |
| DI | `get_it` |
| HTTP | `dio` |
| Cache | `shared_preferences` |
| Imagens | `cached_network_image` |
| 3D | `flutter_cube` |
| WebView | `webview_flutter` |
| Áudio | `audioplayers` |
| Env | `flutter_dotenv` |
| i18n | ARB + `flutter gen-l10n` |
| Testes | `flutter_test`, `bloc_test`, `mocktail` |

## Arquitetura

Feature-based com **Clean Architecture**. Cada feature segue a separação em três camadas:

```
lib/
├── core/                  # Abstrações compartilhadas
│   ├── cache/             # AppCache (SharedPreferences wrapper)
│   ├── di/                # GetIt service locator
│   ├── env/               # AppEnv (dotenv)
│   ├── locale/            # LocaleCubit + persistence
│   ├── navigation/        # NavigationCubit + RootPage
│   ├── network/           # AppNetwork (Dio), interceptors, error helpers
│   ├── routes/            # Named routes
│   ├── theme/             # AppTheme, ThemeCubit, AppColors
│   └── widgets/           # Widgets reutilizáveis (NoInternetWidget, WebView, etc.)
│
├── features/
│   ├── home/              # Home (APOD, sistema solar, carrosséis)
│   │   ├── data/          # DataSources, Models, Repositories impl
│   │   ├── domain/        # Entities, Repository contracts, UseCases
│   │   └── presentation/  # Pages, Widgets, Cubits
│   ├── news/              # Feed de notícias
│   ├── launches/          # Lançamentos de foguetes
│   ├── quiz/              # Quiz espacial
│   ├── settings/          # Configurações
│   ├── apod/              # Detalhe do APOD com navegação por data
│   ├── solar_system/      # Detalhe dos planetas (3D + dados orbitais)
│   └── observatories/     # Observatórios brasileiros
│
├── i18n/                  # ARB files + gerados
└── main.dart
```

## API

Consome a [Cosmos API](https://github.com/AndreWar10/cosmos-back) — backend proxy que agrega dados da NASA, Spaceflight News e Launch Library 2 com tradução para português.

| Endpoint | Descrição |
|---|---|
| `GET /api/apod` | Imagem astronômica do dia (suporta `?date=`) |
| `GET /api/news` | Notícias espaciais (paginadas com `limit`, `offset`, `search`) |
| `GET /api/launches` | Lançamentos (paginados com `limit`, `offset`, `upcoming`, `status`) |

Dados locais (sem API): sistema solar, observatórios e quiz são carregados de assets JSON locais para performance.

## Internacionalização

O app suporta **Português** e **Inglês**, configurável em Settings.

- Arquivos ARB em `lib/i18n/`
- Classe gerada `AppLocalizations` via `flutter gen-l10n`
- Acesso nos widgets via `context.translate` (extension)
- Idioma padrão: idioma do sistema (se suportado), senão inglês
- Interceptor Dio adiciona prefixo `/pt/` automaticamente quando necessário

## Requisitos

| | Versão |
|---|---|
| Flutter | 3.44.6 (stable) |
| Dart | 3.12.2 |

## Setup

```bash
git clone https://github.com/AndreWar10/cosmos-app.git
cd cosmos-app

# Criar .env na raiz
echo "BASE_URL=https://cosmos-back.onrender.com" > .env

# Instalar dependências e gerar i18n
flutter pub get
flutter gen-l10n

# Rodar
flutter run
```

## Testes

```bash
# Rodar testes
flutter test

# Gerar coverage HTML
flutter test --coverage
# (requer coverde: dart pub global activate coverde)
dart pub global run coverde report -i coverage/lcov.info
```

### Resumo: 167 testes

| Camada | Arquivos testados | Coverage |
|---|---|---|
| **Domain** (Entities, UseCases) | `quiz_result`, `quiz_stats`, `get_apod_usecase`, `get_news_usecase`, `get_launches_usecase`, `get_planet_info_usecase`, `quiz_usecases` (x4) | **95–100%** |
| **Data** (Models, DataSources, Repositories) | `apod_model`, `launch_model`, `article_model`, `news_response_model`, `home_remote_datasource`, `launches_remote_datasource`, `all repository_impl` | **80–100%** |
| **BLoCs / Cubits** | `launches_bloc`, `news_bloc`, `home_cubit`, `quiz_game_cubit`, `quiz_hub_cubit`, `apod_detail_cubit`, `planet_detail_cubit`, `theme_cubit`, `locale_cubit`, `navigation_cubit` | **81–100%** |
| **Presentation** (Pages, Widgets) | `home_page`, `news_page`, `launches_page`, `settings_page`, `root_page`, `launch_card`, `news_article_card`, `news_error_widget`, `launch_status_badge`, etc. | **65–100%** |
| **Core** | `app_bottom_navigation`, `root_page`, `locale_cubit`, `theme_cubit` | **88–100%** |

> O coverage geral de linha (~30%) inclui widgets de UI puro, código gerado (i18n) e infraestrutura (DI, routes, env) que não possuem lógica testável. A camada de **lógica de negócio** (domain + data + blocs) possui cobertura de **90%+**.

O relatório HTML completo está disponível em `coverage/html/index.html`.

## Recursos do app

- **Tema**: Dark (padrão) e Light com persistência
- **Orientação**: Bloqueada em portrait
- **No Internet**: Feedback amigável com retry em todas as telas
- **Haptic Feedback**: Feedback tátil nas interações do quiz
- **Efeitos Sonoros**: Sons para acerto, erro, tempo e conclusão do quiz (configurável)
- **App Icon**: Ícone personalizado para Android e iOS

## Desenvolvido por

**WarCode** — Prova técnica para desenvolvedor Flutter mid-level.

Desenvolvido com auxílio do **Cursor AI**. Convenções e regras documentadas em `.cursor/rules/`.
