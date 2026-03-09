# HiringApp - Documentacao Tecnica

## 1. Objetivo
Aplicativo iOS UIKit para autenticacao de usuario, consulta de portas e listagem de eventos por porta, consumindo API HTTP com autenticacao via token.

## 2. Arquitetura
A base do projeto segue separacao por responsabilidades:

- `App Core`: ciclo de vida do app e orquestracao de fluxo global.
- `DependencyInjection`: fabrica de telas e montagem de dependencias.
- `APIClient`: definicao de endpoint, cliente HTTP e fachada de casos de uso.
- `Scenes`: implementacao das telas (`View`, `ViewController`, `FlowDelegate`).
- `Model`: modelos de dominio e pagina.
- `Managers`: concerns de infraestrutura (token/keychain).
- `Components`: biblioteca de componentes de UI internos.

## 3. Estrutura de diretorios

### 3.1 Raiz
- `README.md`: guia rapido de setup, estrutura e RocketSim.
- `PROJECT_DOCUMENTATION.md`: referencia tecnica detalhada.
- `HiringApp.xcodeproj`: configuracao do projeto Xcode.

### 3.2 App Core (`HiringApp/`)
- `AppDelegate.swift`: entrypoint do app e bootstrap de integracao RocketSim (debug).
- `SceneDelegate.swift`: inicializa a janela e injeta fluxo principal.
- `HiringAppFlowController.swift`: coordenador de navegacao do app.
- `Info.plist`: configuracoes do bundle.
- `Assets.xcassets`: assets visuais.

### 3.3 Features (`HiringApp/Sources/Features/`)

#### APIClient (`APIClient/`)
- `Endpoint.swift`: contrato de endpoint e transformacao para `URLRequest`.
- `HTTPMethod.swift`: metodos HTTP suportados.
- `Client.swift`: execucao de requests com `URLSession`, parse e tratamento de erro.
- `Service.swift`: operacoes de alto nivel usadas pelas telas.
- `DTO/`: modelos de request/response (`SignInDTO`, `SignUpDTO`, `DoorDTO`).
- `Endpoints/`: implementacao por dominio (`AuthEndpoint`, `DoorsEndpoint`, `EventsEndpoint`).

#### Scenes (`Scenes/`)
- `Splash/`: decisao da rota inicial com base em token.
- `SignIn/`: autenticacao e navegacao para cadastro/lista de portas.
- `SignUp/`: cadastro e retorno para login.
- `Doors/`: listagem paginada e menu de acoes.
- `DoorSearch/`: busca paginada por nome.
- `DoorDetail/`: eventos paginados por porta.

Cada cena segue padrao consistente:
- `*View.swift`: composicao da interface.
- `*ViewController.swift`: estado, integracao de rede, navegacao.
- `ViewModel/*FlowDelegate.swift`: contrato de transicao entre fluxos.

#### Model (`Model/`)
- `PaginatedResponse.swift`: pagina generica (`content`, `page`, `size`, `totalElements`, `totalPages`, `last`).
- `Doors/Doors.swift`: alias de pagina para `DoorDTO`.
- `Doors/DoorEvent.swift`: modelo de evento da porta.

#### Managers (`Managers/`)
- `AuthTokenKeychainManager.swift`: persistencia segura do token.

#### DependencyInjection (`DependencyInjection/`)
- `ViewControllersFactoryProtocol.swift`: contrato da fabrica.
- `ViewControllersFactory.swift`: montagem concreta das telas.

#### Components (`Components/`)
- `DSButton/`, `DSTextField/`, `DSLabel/`: componentes reutilizaveis com estilo e acessibilidade.

#### Cross-cutting
- `Extensions/UIViewController+Ext.swift`: utilitarios de layout para controllers.
- `Utils/Constants.swift`: configuracao global (`BASE_URL`).

## 4. Fluxo de navegacao
1. App inicia em `SplashViewController`.
2. `Splash` consulta token no keychain.
3. Se token existe: abre `Doors`.
4. Se token nao existe: abre `SignIn`.
5. Em `SignIn`: autentica ou navega para `SignUp`.
6. Em `SignUp`: cria conta e retorna para `SignIn`.
7. Em `Doors`: abre detalhe da porta, busca por nome ou logout.
8. Em `DoorDetail`: carrega eventos paginados da porta.

Orquestracao principal: `HiringAppFlowController`.

## 5. Fluxo de rede

### 5.1 Endpoints de autenticacao
- `POST /users/signin`
- `POST /users/signup`

### 5.2 Endpoints de portas
- `GET /doors?page={page}&size={size}`
- `GET /doors/find?name={name}&page={page}&size={size}`
- `GET /doors/{doorId}/events?page={page}&size={size}`

### 5.3 Encadeamento
- Tela -> `Service` -> `Client` -> `Endpoint` -> API.
- `Service` devolve DTO/modelos prontos para uso na camada de cena.

## 6. Autenticacao e seguranca
- Token armazenado por `AuthTokenKeychainManager`.
- Endpoints de login/cadastro nao exigem header bearer.
- Endpoints protegidos usam `Authorization: Bearer <token>` quando token estiver disponivel.

## 7. Suporte a payload criptografado
O `Client` suporta fluxo de decrypt quando `endpoint.isEncrypted == true`:
- gera chave efemera `P256` no cliente;
- envia `X-Client-Public-Key` no request;
- consome `X-Server-Public-Key` no response;
- deriva chave simetrica com ECDH + HKDF;
- descriptografa payload com AES.GCM.

Esse fluxo depende de contrato alinhado com backend para formato de payload criptografado.

## 8. Integracao com RocketSim
A integracao esta no `AppDelegate.swift` com carregamento dinamico do linker do RocketSim em `DEBUG`:

- path esperado: `/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework`
- sucesso no console: `RocketSim Connect successfully linked`
- falha no console: `Failed to load linker framework`

### 8.1 Objetivo da integracao
Permitir instrumentacao do app em simulador (inspecao de rede, logs, storage e outros recursos do RocketSim) sem acoplar build de producao.

### 8.2 Regras de uso
- O carregamento ocorre apenas em `DEBUG`.
- Build `Release` nao deve depender do RocketSim.
- Se o app nao estiver em `/Applications`, o linker nao sera encontrado.
