# HiringApp

Aplicativo iOS (UIKit + Swift) com fluxo de autenticacao, listagem de portas, busca por nome e visualizacao de eventos por porta.

## Stack
- Swift + UIKit
- URLSession
- Keychain (persistencia de token)
- Arquitetura em camadas (APIClient, Scenes, Model, Managers, DependencyInjection)

## Como rodar
1. Abra o projeto `HiringApp.xcodeproj` no Xcode.
2. Selecione um simulador iOS.
3. Execute com `Cmd + R`.

API base atual: `https://hiring-api.samba.dev.assaabloyglobalsolutions.net` (definida em `HiringApp/Sources/Features/Utils/Constants.swift`).

## Estrutura do projeto

### App Core (`HiringApp/`)
- `AppDelegate.swift`: inicializacao do app e carregamento do RocketSim em build DEBUG.
- `SceneDelegate.swift`: criacao da window e bootstrap da navegacao.
- `HiringAppFlowController.swift`: coordenador principal de rotas.

### Features (`HiringApp/Sources/Features/`)
- `APIClient/`: endpoint, cliente HTTP, DTOs e service de consumo da API.
- `Scenes/`: telas (`View`, `ViewController`, `FlowDelegate`) por feature.
- `Model/`: modelos de dominio e resposta paginada.
- `Managers/`: infraestrutura compartilhada (ex.: keychain).
- `DependencyInjection/`: fabrica de telas e injecao de dependencias.
- `Components/`: UI components reutilizaveis (`DSButton`, `DSTextField`, `DSLabel`).
- `Extensions/`: extensoes utilitarias.
- `Utils/`: constantes globais.

## Fluxo funcional
1. `Splash` valida token no keychain.
2. Sem token: `SignIn`.
3. Com token: `Doors`.
4. Em `Doors`: abrir detalhe, buscar porta por nome ou fazer logout.
5. Em `DoorDetail`: listar eventos paginados da porta.

## Uso do RocketSim

O projeto ja possui integracao para debug em `AppDelegate.swift`:
- Em build `DEBUG`, o app tenta carregar o framework:
  `/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework`
- Em caso de sucesso, o console imprime: `RocketSim Connect successfully linked`.

### Pre-requisitos
1. RocketSim instalado em `/Applications/RocketSim.app`.
2. Rodar o app em `Debug`.

### Como validar que esta funcionando
1. Rode o app no simulador pelo Xcode.
2. Abra o console do Xcode.
3. Verifique a mensagem de sucesso do linker.
4. Abra o RocketSim e use os recursos de inspecao (network, logs, storage, deeplink, localizacao etc.) durante a execucao.

### Troubleshooting rapido
- Se aparecer `Failed to load linker framework`, confirme:
  - O app RocketSim esta instalado exatamente em `/Applications`.
  - O nome do app e `RocketSim.app`.
  - A execucao esta em `DEBUG` (nao `Release`).

## Documentacao detalhada
Para detalhes de arquitetura, contratos e fluxo de rede, consulte `PROJECT_DOCUMENTATION.md`.
