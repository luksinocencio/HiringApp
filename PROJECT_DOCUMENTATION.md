# HiringApp - Documentacao Tecnica

## 1. Visao geral
HiringApp e um aplicativo iOS (UIKit) para autenticacao, listagem de portas, consulta de eventos, criacao de permissao, simulacao de permissoes e configuracoes de idioma/tema.

Stack principal:
- UIKit
- URLSession + async/await
- Keychain para token
- Localizacao via `Localizable.strings` (`en` e `pt-BR`)

## 2. Objetivo funcional
- Permitir login e cadastro de usuario.
- Exibir lista paginada de portas.
- Exibir eventos paginados de uma porta.
- Criar permissao para uma porta.
- Simular permissoes por tipo.
- Permitir ajustes de idioma e tema.

## 3. Arquitetura do projeto
Organizacao por feature em `HiringApp/Sources/Features`:

- `APIClient/`
- `Components/`
- `DependencyInjection/`
- `Extensions/`
- `Managers/`
- `Model/`
- `Scenes/`
- `Utils/`

Separacao de responsabilidades:
- `View`: composicao de UI.
- `ViewController`: estado, eventos de UI, chamada de servico e navegacao local.
- `FlowDelegate`: contrato de navegacao entre fluxos principais.
- `Service`: fachada para casos de uso da API.
- `Client`: transporte HTTP e decode de respostas.

## 4. Estrutura relevante de arquivos
### 4.1 Core do app
- `HiringApp/AppDelegate.swift`
- `HiringApp/SceneDelegate.swift`
- `HiringApp/HiringAppFlowController.swift`
- `HiringApp/Info.plist`
- `HiringApp/Assets.xcassets`

### 4.2 API
- `Sources/Features/APIClient/Client.swift`
- `Sources/Features/APIClient/Service.swift`
- `Sources/Features/APIClient/Endpoint.swift`
- `Sources/Features/APIClient/HTTPMethod.swift`
- `Sources/Features/APIClient/Endpoints/*`
- `Sources/Features/APIClient/DTO/*`

### 4.3 Scenes
- `Splash/`
- `SignIn/`
- `SignUp/`
- `Doors/`
- `DoorSearch/`
- `DoorDetail/`
- `CreatePermissions/`
- `SimulatePermissions/`
- `Settings/`

### 4.4 Suporte
- `DependencyInjection/ViewControllersFactory.swift`
- `Managers/AuthTokenKeychainManager.swift`
- `Managers/AppSettingsManager.swift`
- `Managers/AppPreferencesKeychainManager.swift`
- `Extensions/String+Localization.swift`
- `Utils/Constants.swift`

## 5. Fluxo de navegacao
1. App inicia em `SplashViewController`.
2. Splash decide rota inicial com base em token salvo.
3. Sem token: fluxo de autenticacao (`SignIn` -> `SignUp`).
4. Com token: abre `Doors`.
5. Em `Doors`, usuario pode:
- abrir detalhes da porta (`DoorDetail`)
- abrir criacao de permissao (`CreatePermissions`)
- buscar portas (`DoorSearch`)
- simular permissoes (`SimulatePermissions`)
- abrir configuracoes (`Settings`)
- logout

Orquestracao principal feita por `HiringAppFlowController`.

## 6. Fluxo de rede
Encadeamento:
- Scene -> `AppServiceProtocol`/`Service` -> `Client` -> `Endpoint` -> API.

Endpoints utilizados no projeto:
- `POST /users/signin`
- `POST /users/signup`
- `GET /doors?page={page}&size={size}`
- `GET /doors/find?name={name}&page={page}&size={size}`
- `GET /doors/{doorId}/events?page={page}&size={size}`
- Endpoint de criacao de permissao em `DoorsEndpoint.createPermission(...)`
- Endpoint de simulacao de permissao em `DoorsEndpoint.simulatePermissions(...)`

## 7. Estado e paginacao
- Lista de portas e lista de eventos usam pagina (`page`, `size`, `last`).
- Modelo generico: `Model/PaginatedResponse.swift`.
- Controllers com controle de pagina:
- `DoorsViewController`
- `DoorSearchViewController`
- `DoorDetailViewController`

## 8. Token, seguranca e configuracoes
- Token persistido via `AuthTokenKeychainManager`.
- Servicos autenticados usam bearer token quando disponivel.
- `AppSettingsManager` centraliza idioma/tema.
- `AppPreferencesKeychainManager` guarda preferencias sensiveis quando necessario.

## 9. Localizacao
Arquivos:
- `HiringApp/Localizable.strings/en`
- `HiringApp/Localizable.strings/pt-BR`

Convencao de chaves por contexto, por exemplo:
- `common.*`
- `doors.*`
- `door_detail.*`
- `create_permissions.*`
- `settings.*`

## 10. Integracao de desenvolvimento
`AppDelegate` possui carregamento condicional do RocketSim em `DEBUG`:
- Framework esperado: `/Applications/RocketSim.app/.../RocketSimConnectLinker.nocache.framework`
- Em `Release`, nao ha dependencia dessa integracao.

## 11. Observacoes tecnicas atuais
- O projeto possui pontos com warning de isolamento de ator em Swift 6 (`Service.shared` em contexto nao isolado em alguns initializers com argumento default).
- Para evitar isso, a abordagem recomendada e inicializar dependencias `@MainActor` dentro do corpo do init, evitando referencia `Service.shared` no valor default do parametro.

## 12. Sessao final (preencher manualmente)
> Escreva aqui seu texto final, observacoes de entrega, checklist, decisoes de produto ou qualquer anotacao personalizada.

---

Texto livre:



