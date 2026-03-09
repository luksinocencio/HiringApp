# HiringApp - Documentacao do Projeto

## 1. Visao Geral
Este projeto e um aplicativo iOS UIKit com fluxo de autenticacao e navegacao para listagem de portas (`doors`), busca de portas e detalhes de eventos por porta.

Tecnologias principais:
- Swift
- UIKit
- URLSession
- Keychain (persistencia de token)
- Arquitetura por camadas (`APIClient`, `Scenes`, `Model`, `Managers`, `DependencyInjection`)

## 2. Arquitetura
O projeto segue uma separacao simples por responsabilidade:
- `APIClient`: define endpoints, DTOs, cliente HTTP e servico de alto nivel.
- `Scenes`: telas e componentes visuais (`View`, `ViewController`, `FlowDelegate`).
- `Model`: modelos de dominio usados na UI e respostas paginadas.
- `Managers`: utilitarios de infraestrutura (ex.: Keychain).
- `DependencyInjection`: fabrica de view controllers.
- `HiringAppFlowController`: coordena fluxo de navegacao global.

## 3. Estrutura de Pastas e Arquivos

### 3.1 Camada de API
Diretorio: `HiringApp/HiringApp/Sources/Features/APIClient`

#### DTO
- `DTO/DoorDTO.swift`: modelo de porta retornado pela API (`id`, `name`, `address`, `battery`, etc.).
- `DTO/SignInDTO.swift`: request e response do login (`email`, `password`, `token`).
- `DTO/SignUpDTO.swift`: request e response do cadastro (`firstName`, `lastName`, `email`, `createdAt`, etc.).

#### Endpoints
- `Endpoints/AuthEndpoint.swift`: endpoints de autenticacao (`users/signin`, `users/signup`).
- `Endpoints/DoorsEndpoint.swift`: endpoints de portas (`doors`, `doors/find`).
- `Endpoints/EventsEndpoint.swift`: endpoint de eventos por porta (`doors/{id}/events`).

#### Infra de rede
- `Endpoint.swift`: contrato base de endpoint (path, method, query, headers, body, auth, encrypted) e conversao para `URLRequest`.
- `HTTPMethod.swift`: enum de metodos HTTP.
- `Client.swift`: cliente de rede que executa request com `URLSession`, valida resposta e decodifica payload.
  Tambem contem suporte a payload criptografado via CryptoKit quando `isEncrypted = true`.
- `Service.swift`: facade de casos de uso de rede consumidos pelas telas (`signIn`, `signUp`, `getAllDoors`, `listDoorEvents`, `listDoorByName`).

### 3.2 Dependency Injection
Diretorio: `HiringApp/HiringApp/Sources/Features/DependencyInjection`

- `ViewControllersFactoryProtocol.swift`: contrato da fabrica de view controllers.
- `ViewControllersFactory.swift`: implementacao da fabrica para montar telas e injetar delegates.

### 3.3 Extensoes
Diretorio: `HiringApp/HiringApp/Sources/Features/Extensions`

- `UIViewController+Ext.swift`: helper para pinagem de `contentView` nas bordas/safe area.

### 3.4 Managers
Diretorio: `HiringApp/HiringApp/Sources/Features/Managers`

- `AuthTokenKeychainManager.swift`: salva, busca e remove token no Keychain.

### 3.5 Modelos
Diretorio: `HiringApp/HiringApp/Sources/Features/Model`

- `Doors/Doors.swift`: alias de resposta paginada de `DoorDTO`.
- `Doors/DoorEvent.swift`: modelo do evento da porta e dados adicionais (`additionalData`).
- `PaginatedResponse.swift`: modelo generico de pagina (`content`, `page`, `size`, `totalElements`, `totalPages`, `last`).

### 3.6 Scenes
Diretorio: `HiringApp/HiringApp/Sources/Features/Scenes`

#### Splash
- `Splash/SplashView.swift`: layout da splash.
- `Splash/SplashViewController.swift`: decide rota inicial (SignIn ou Doors) com base no token.
- `Splash/ViewModel/SplashFlowDelegate.swift`: contrato de navegacao da splash.

#### SignIn
- `SignIn/SignInView.swift`: UI de login (campos, botoes, acessibilidade, visual atualizado).
- `SignIn/SignInViewController.swift`: valida formulario, chama `Service.signIn`, trata estado de loading e erro.
- `SignIn/ViewModel/SignInFlowDelegate.swift`: contrato de navegacao (`SignUp` e `Doors`).

#### SignUp
- `SignUp/SignUpView.swift`: UI de cadastro (campos, botao principal, acessibilidade, visual atualizado).
- `SignUp/SignUpViewController.swift`: valida formulario, chama `Service.signUp`, trata sucesso/erro.
- `SignUp/ViewModel/SignUpFlowDelegate.swift`: contrato de retorno para SignIn.

#### Doors
- `Doors/DoorsView.swift`: container visual da lista de portas.
- `Doors/DoorsViewController.swift`: lista paginada de portas, menu de opcoes (pesquisar/sair), navega para detalhe.
- `Doors/DoorTableViewCell.swift`: celula custom moderna para exibir `name`, `address` e `battery`.
- `Doors/ViewModel/DoorsFlowDelegate.swift`: contrato de logout.

#### DoorSearch
- `DoorSearch/DoorSearchView.swift`: tela com `UISearchBar` e tabela de resultados.
- `DoorSearch/DoorSearchViewController.swift`: busca paginada por nome (`/doors/find`), debounce e navegacao para detalhe.

#### DoorDetail
- `DoorDetail/DoorDetailView.swift`: container da lista de eventos da porta.
- `DoorDetail/DoorDetailViewController.swift`: lista paginada de eventos (`/doors/{id}/events`).
- `DoorDetail/DoorDetailEventTableViewCell.swift`: celula custom de evento (`logType`, `logNumber`, `timestamp`, `additionalData`).

### 3.7 App Core
Diretorio: `HiringApp/HiringApp`

- `AppDelegate.swift`: configuracao de ciclo de vida legado do app.
- `SceneDelegate.swift`: bootstrap da janela e root controller no ciclo moderno.
- `HiringAppFlowController.swift`: coordenador de navegacao global do aplicativo.
- `Info.plist`: configuracoes gerais do app.
- `Assets.xcassets`: catalogo de recursos visuais.

### 3.8 Utilitarios
Diretorio: `HiringApp/HiringApp/Sources/Features/Utils`

- `Constants.swift`: constantes globais de configuracao (ex.: URL base).

## 4. Fluxo de Navegacao
1. App inicia em `SplashViewController`.
2. Splash verifica token no Keychain.
3. Com token: navega para `Doors`.
4. Sem token: navega para `SignIn`.
5. Em `SignIn`, usuario pode:
   - entrar e ir para `Doors`
   - ir para `SignUp`
6. Em `SignUp`, ao sucesso, retorna para `SignIn`.
7. Em `Doors`, usuario pode:
   - abrir detalhes de uma porta
   - abrir tela de busca de portas
   - sair (logout)
8. Em `DoorDetail`, usuario visualiza eventos paginados da porta.

## 5. Fluxo de Rede
### 5.1 SignIn
- Endpoint: `POST /users/signin`
- Request DTO: `SignInRequest`
- Response DTO: `SignInResponse`
- Pos-processamento: token salvo no Keychain.

### 5.2 SignUp
- Endpoint: `POST /users/signup`
- Request DTO: `SignUpRequest`
- Response DTO: `SignUpResponse`

### 5.3 Doors
- Endpoint: `GET /doors?page={page}&size={size}`
- Response: `Doors` (`PaginatedResponse<DoorDTO>`)

### 5.4 Door Search
- Endpoint: `GET /doors/find?name={name}&page={page}&size={size}`
- Response: `Doors`

### 5.5 Door Events
- Endpoint: `GET /doors/{doorId}/events?page={page}&size={size}`
- Response: `PaginatedResponse<DoorEvent>`

## 6. Autenticacao
- O token e persistido por `AuthTokenKeychainManager`.
- Endpoints de auth (`signIn` e `signUp`) nao exigem `Authorization`.
- Endpoints protegidos recebem `Authorization: Bearer <token>` quando token existe.

## 7. Criptografia de Payload (opcional por endpoint)
`Client` suporta fluxo de decrypt quando `endpoint.isEncrypted = true`:
- Gera chave efemera cliente (`P256`).
- Envia chave publica no header `X-Client-Public-Key`.
- Le `X-Server-Public-Key` da resposta.
- Deriva chave simetrica com ECDH + HKDF.
- Descriptografa payload (AES.GCM).

Observacao: para usar em producao, payload criptografado deve conter todos os campos necessarios (ex.: `iv`, `ciphertext`, `tag`) de forma consistente com o backend.

## 8. Boas Praticas Atuais no Projeto
- Separacao clara de camadas e responsabilidades.
- Uso de delegates para fluxo de navegacao.
- Paginacao incremental nas listas.
- Cuidado com acessibilidade em formularios principais.
- Celulas custom para melhorar leitura e hierarquia visual.

## 9. Possiveis Melhorias Futuras
- Padronizar erros de API com mensagens mais descritivas (status code + body).
- Padronizar idioma de textos da interface.
- Extrair formatadores (datas, valores de bateria, labels de evento).
- Cobertura de testes unitarios para `Service` e parsing de modelos.
- Criar testes de UI para fluxos criticos (login, cadastro, doors, busca).

## 10. Como Onboardar Rapido
1. Entender `HiringAppFlowController` para o fluxo principal.
2. Ler `Service`, `Client`, `Endpoint` para entender rede.
3. Rodar fluxo completo: Splash -> SignIn -> Doors -> DoorDetail.
4. Ler `DoorsViewController` e `DoorSearchViewController` para padrao de paginacao.
5. Seguir o padrao `View + ViewController + FlowDelegate` ao criar novas telas.
