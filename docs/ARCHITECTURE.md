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
│   ├── routes/                   # Rotas nomeadas
│   ├── theme/                    # Tema, cores, tipografia
│   └── widgets/                  # Widgets reutilizáveis
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
│   └── planets/
│
├── app.dart                      # MaterialApp + rotas + tema
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

| Camada | O que testar |
|--------|-------------|
| DataSource | Chamadas HTTP, parsing de JSON, tratamento de erros |
| Repository | Delegação ao DataSource, mapeamento Model → Entity |
| UseCase | Lógica de negócio |
| BLoC | Transições de estado para cada evento |

## Ferramentas de desenvolvimento

Este projeto utiliza **Cursor AI** como assistente de desenvolvimento. As regras de arquitetura, padrões e convenções estão documentadas em `.cursor/rules/` para garantir consistência na geração de código.
