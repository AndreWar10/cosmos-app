# Cosmos App — Arquitetura

## Visão geral

Cosmos é um aplicativo Flutter que consome a [Cosmos API](https://github.com/AndreWar10/cosmos-back) para exibir conteúdo sobre o universo: imagem astronômica do dia, notícias espaciais, lançamentos de foguetes, planetas do sistema solar e asteroides próximos da Terra.

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Framework | Flutter |
| Estado | BLoC / Cubit (`flutter_bloc`) |
| Injeção de dependências | `get_it` |
| HTTP | `dio` (via `AppNetwork`) |
| Cache local | `shared_preferences` (via `AppCache`) |
| Variáveis de ambiente | `flutter_dotenv` (via `AppEnv`) |
| Fonte | Exo 2 (`google_fonts`) |
| Internacionalização | ARB + `flutter gen-l10n` |
| Testes | `flutter_test`, `bloc_test`, `mocktail` |

## Arquitetura

Separação por features com Clean Architecture em cada feature:

```
lib/
├── core/                         # Código compartilhado
│   ├── cache/                    # AppCache
│   ├── network/                  # AppNetwork (Dio wrapper)
│   ├── env/                      # AppEnv (dotenv)
│   ├── di/                       # Injection container (GetIt)
│   ├── extensions/               # BuildContext extensions (translate)
│   ├── locale/                   # LocaleCubit
│   ├── routes/                   # Rotas nomeadas
│   ├── theme/                    # Tema, cores, ThemeCubit
│   ├── navigation/               # Navegação principal
│   │   └── presentation/
│   │       ├── cubit/            # NavigationCubit
│   │       └── pages/            # RootPage (Scaffold + BottomNav)
│   ├── widgets/                  # Widgets reutilizáveis (AppBottomNavigation)
│   └── app.dart                  # MaterialApp + rotas + tema + i18n
│
├── i18n/                         # Internacionalização
│   ├── app_en.arb                # Template (source of truth)
│   ├── app_pt.arb                # Traduções português
│   └── generated/                # Gerado por flutter gen-l10n (NÃO editar)
│
├── features/
│   ├── home/                     # APOD + Sistema Solar + previews
│   │   ├── data/
│   │   │   ├── datasources/      # Remote/Local data sources
│   │   │   ├── models/           # DTOs (JSON ↔ Model)
│   │   │   └── repositories/     # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/         # Entidades puras
│   │   │   ├── repositories/     # Contratos (abstract classes)
│   │   │   └── usecases/         # Casos de uso
│   │   └── presentation/
│   │       ├── bloc/             # BLoC / Cubit + Events + States
│   │       ├── pages/            # Telas
│   │       └── widgets/          # Widgets da feature
│   ├── news/
│   ├── launches/
│   ├── planets/
│   └── settings/                 # Tema e idioma
│
└── main.dart                     # Bootstrap (dotenv, DI, runApp)
```

## Fluxo de dados

```
API (Cosmos Backend)
  ↓
DataSource (HTTP via AppNetwork → Model)
  ↓
Repository (Model → Entity)
  ↓
UseCase (lógica de negócio)
  ↓
BLoC (gerencia estado)
  ↓
Page / Widgets (UI)
```

## Regras de dependência

```
presentation → domain ✅
data → domain ✅
presentation → data ❌
domain → data ❌
domain → Flutter ❌ (Dart puro)
```

## API consumida

| Endpoint | Feature |
|----------|---------|
| `GET /api/pt/apod` | Home — Imagem do dia |
| `GET /api/pt/news` | News — Notícias espaciais |
| `GET /api/pt/launches` | Launches — Lançamentos |
| `GET /api/pt/neo` | Home — Asteroides próximos |

Documentação completa da API: [cosmos-back/docs/API.md](https://github.com/AndreWar10/cosmos-back/blob/main/docs/API.md)

## Testes

Toda feature tem testes nas três camadas:

| Camada | O que testar | Ferramentas |
|--------|-------------|-------------|
| DataSource | Chamadas HTTP, parsing de JSON, tratamento de erros | `mocktail` |
| Repository | Delegação ao DataSource, mapeamento Model → Entity | `mocktail` |
| UseCase | Lógica de negócio | `mocktail` |
| BLoC / Cubit | Transições de estado para cada evento | `bloc_test` |
| Widgets | Renderização, interações, callbacks | `flutter_test` |

### Estrutura de testes

```
test/
├── helpers/
│   └── pump_app.dart                  # Helper: wraps widget com MaterialApp + i18n + BLoCs
├── core/
│   ├── theme/
│   │   └── theme_cubit_test.dart
│   ├── locale/
│   │   └── locale_cubit_test.dart
│   ├── navigation/
│   │   └── navigation_cubit_test.dart
│   └── widgets/
│       └── app_bottom_navigation_test.dart
└── features/
    ├── home/presentation/pages/
    │   └── home_page_test.dart
    ├── news/presentation/pages/
    │   └── news_page_test.dart
    ├── launches/presentation/pages/
    │   └── launches_page_test.dart
    └── settings/presentation/
        ├── pages/
        │   └── settings_page_test.dart
        └── widgets/
            ├── theme_toggle_tile_test.dart
            ├── locale_toggle_tile_test.dart
            └── settings_section_test.dart
```

## Internacionalização (i18n)

O app suporta **Português** (padrão) e **Inglês** via ARB + `flutter gen-l10n`.

```
app_en.arb + app_pt.arb
        │
        ▼
  flutter gen-l10n
        │
        ▼
  lib/i18n/generated/app_localizations.dart
        │
        ▼
  MaterialApp (delegates + supportedLocales)
        │
        ▼
  context.translate.chave
```

### Regras de uso por camada

| Camada | Usa `context.translate`? |
|--------|------------------------|
| presentation/pages | Sim |
| presentation/widgets | Sim |
| domain/usecases | Não (Dart puro) |
| data/datasources | Não |
| data/models | Não |

### Convenção de chaves ARB

Keys seguem `featureContexto`: `navHome`, `settingsDarkTheme`, `launchesTitle`, `errorNoConnection`.

## Ferramentas de desenvolvimento

Este projeto utiliza **Cursor AI** como assistente de desenvolvimento. As regras de arquitetura, padrões e convenções estão documentadas em `.cursor/rules/` para garantir consistência na geração de código.
