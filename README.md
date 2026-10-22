<div align="center">

# 💡 InnovaTracker | IdeaToImpact

![Java](https://img.shields.io/badge/Java-25-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-4.1.0-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![JWT](https://img.shields.io/badge/JWT-JJWT_0.12.6-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)
![Swagger](https://img.shields.io/badge/Swagger-springdoc_3.1.1-85EA2D?style=for-the-badge&logo=swagger&logoColor=black)

[![Swagger local](https://img.shields.io/badge/Swagger-localhost%3A7777-85EA2D?style=for-the-badge&logo=swagger&logoColor=black)](http://localhost:7777/swagger-ui.html)
[![GitHub](https://img.shields.io/badge/GitHub-joaogabrieldev-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/joaogabrieldev)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-joaogabrielrocha-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/joaogabrielrocha)

API REST para gestão de ideias e projetos de inovação, com Java 25, Virtual Threads, autenticação JWT e documentação Swagger.

</div>

---

## 📑 Índice

- [🌐 Deploy](#-deploy)
- [📖 Sobre](#-sobre)
- [🧱 Padrões e Fundamentos](#-padrões-e-fundamentos)
- [🛠️ Tecnologias e Bibliotecas](#️-tecnologias-e-bibliotecas)
- [🗂️ Estrutura do Projeto](#️-estrutura-do-projeto)
- [⚙️ Como rodar localmente](#️-como-rodar-localmente)
- [📌 Evento](#-evento)
- [👨‍💻 Contato](#-contato)

---

## 🌐 Deploy

O projeto ainda não tem deploy público: é uma API de estudo que roda na sua máquina. Com a aplicação no ar (veja [⚙️ Como rodar localmente](#️-como-rodar-localmente)), a documentação interativa fica em:

### 🔗 [http://localhost:7777/swagger-ui.html](http://localhost:7777/swagger-ui.html)

A especificação OpenAPI em JSON fica em `http://localhost:7777/v3/api-docs` e pode ser importada no Postman.

---

## 📖 Sobre

O **InnovaTracker** (IdeaToImpact) é o backend de uma plataforma corporativa de inovação. Colaboradores, organizados por departamento, submetem ideias classificadas por categoria. As ideias recebem avaliações com nota e parecer, as mais promissoras viram projetos com gerente e equipe alocada, e cada membro aponta as horas trabalhadas.

O que a API faz hoje:

- **Diagnóstico do sistema:** mostra se a requisição está rodando em uma Virtual Thread, gera um token JWT de teste e exporta uma planilha Excel com Apache POI;
- **Autenticação stateless:** login com e-mail e senha (BCrypt) que devolve um token JWT, e rota `/me` com os dados da pessoa autenticada;
- **CRUD completo de categorias:** listagem paginada, busca por ID, por sigla e por nome, criação, atualização e exclusão, com validação e regras de negócio;
- **Erros padronizados:** toda falha volta no mesmo formato JSON (`ApiError`), com status, mensagem e os campos inválidos;
- **Persistência validada:** 8 entidades JPA conferidas contra o banco a cada inicialização (`ddl-auto: validate`);
- **Testes de console:** programas de linha de comando para incluir, consultar e excluir registros sem precisar da API web.

### 🗃️ Modelo de dados

O banco usa o schema `innova` e segue um dicionário de dados com prefixos padronizados.

| Tabela | Tipo | Conteúdo |
|---|---|---|
| `td_departamento` | Domínio | Departamentos da organização |
| `td_categoria` | Domínio | Categorias temáticas das ideias |
| `tb_pessoa` | Básica | Colaboradores, com e-mail único e senha em hash BCrypt |
| `tb_ideia` | Básica | Ideias submetidas, com orçamento e status (`B`, `M`, `A`, `D`) |
| `ta_avaliacao` | Associativa | Avaliação de uma ideia por uma pessoa (nota de 1 a 10 e parecer) |
| `tb_projeto` | Básica | Projeto originado de uma ideia, com gerente, datas e status (`R`, `A`, `P`, `E`, `C`, `X`) |
| `ta_projeto_pessoa` | Associativa | Alocação de pessoas em projetos, com papel e data |
| `tb_apontamento` | Básica | Horas apontadas por alocação (de 1 a 1000) |

**Prefixos de tabela:** `tb_` (básica), `td_` (domínio), `ta_` (associativa).

**Prefixos de coluna:**

| Prefixo | Significado | Prefixo | Significado |
|---|---|---|---|
| `idt_` | chave primária | `cod_` | chave estrangeira |
| `nme_` | nome | `dsc_` | descrição |
| `txt_` | texto longo | `eml_` | e-mail |
| `dta_` | data | `dtt_` | data e hora |
| `vlr_` | valor decimal | `qtd_` | quantidade inteira |
| `sgl_` | sigla | `sts_` | status |
| `flg_` | booleano | | |

### 🔌 Endpoints

| Método | Rota | Acesso | Descrição |
|---|---|---|---|
| `GET` | `/api/diagnostic/thread-info` | Público | Dados da thread atual (comprova a Virtual Thread) |
| `POST` | `/api/diagnostic/generate-test-token?username=` | Público | Gera um JWT de teste |
| `GET` | `/api/diagnostic/export-excel` | Público | Baixa uma planilha `.xlsx` gerada com Apache POI |
| `POST` | `/api/auth/login` | Público | Recebe e-mail e senha e devolve o token JWT |
| `GET` | `/api/auth/me` | 🔒 JWT | Dados da pessoa dona do token |
| `GET` | `/api/categorias` | 🔒 JWT | Lista paginada (`?page=0&size=20&sort=nmeCategoria`) |
| `GET` | `/api/categorias/todas` | 🔒 JWT | Lista simples, sem paginação |
| `GET` | `/api/categorias/{id}` | 🔒 JWT | Busca por ID |
| `GET` | `/api/categorias/sigla/{sigla}` | 🔒 JWT | Busca pela sigla |
| `GET` | `/api/categorias/pesquisa?nome=` | 🔒 JWT | Pesquisa por trecho do nome |
| `POST` | `/api/categorias` | 🔒 JWT | Cria (devolve `201` e o cabeçalho `Location`) |
| `PUT` | `/api/categorias/{id}` | 🔒 JWT | Atualiza |
| `DELETE` | `/api/categorias/{id}` | 🔒 JWT | Exclui (`204`; `409` se houver ideias vinculadas) |
| `GET` | `/actuator/health`, `/actuator/info`, `/actuator/metrics` | 🔒 JWT | Saúde e métricas da aplicação |

O Swagger UI (`/swagger-ui.html`) e a especificação (`/v3/api-docs`) são públicos.

### 🚨 Formato dos erros

Todas as falhas tratadas pelo `GlobalExceptionHandler` voltam neste formato:

```json
{
  "timestamp": "2026-10-22T11:30:00",
  "status": 409,
  "erro": "Violação de regra de negócio",
  "mensagem": "Já existe uma categoria com a sigla: INOV",
  "path": "/api/categorias"
}
```

| Status | Quando acontece |
|---|---|
| `400` | Campos inválidos no corpo (com a lista `campos`) ou parâmetro com tipo errado |
| `401` | E-mail ou senha incorretos. Token ausente ou inválido também devolve `401`, mas sem corpo, porque é barrado no filtro de segurança antes de chegar ao controller |
| `403` | Usuário inativo ou sem permissão |
| `404` | Registro não encontrado |
| `409` | Sigla ou nome duplicado, ou exclusão bloqueada por registros vinculados |
| `500` | Erro inesperado (detalhes só no log do servidor) |

---

## 🧱 Padrões e Fundamentos

O projeto segue fundamentos importantes de arquitetura:

- **Arquitetura em camadas** (o `controller` cuida do HTTP, o `service` das regras de negócio e das transações, o `repository` da persistência);
- **DTOs imutáveis com Java `record`** (a API nunca expõe as entidades JPA nem campos como o hash da senha);
- **Validação na borda** (Bean Validation com `@Valid`, `@NotBlank` e `@Size` antes de chegar ao serviço);
- **Banco como contrato** (o schema é criado pelos scripts versionados em `db/`, e o Hibernate só valida o mapeamento com `ddl-auto: validate`);
- **Autenticação stateless com JWT** (um filtro `OncePerRequestFilter` valida o token a cada requisição, sem sessão no servidor, e as senhas ficam em hash BCrypt);
- **Tratamento global de exceções** (`@RestControllerAdvice` converte exceções em respostas `ApiError` padronizadas, sem expor stack trace);
- **Integridade referencial no serviço** (`flush()` explícito na exclusão para transformar violação de chave estrangeira em erro de negócio `409`);
- **Virtual Threads do Java 25** (`spring.threads.virtual.enabled: true`: cada requisição roda em uma thread leve);
- **Configuração externalizada** (a senha do banco vem da variável de ambiente `DB_PASSWORD` e nunca é versionada);
- **Menos código repetitivo** com Lombok (`@Data`, `@Builder`, `@RequiredArgsConstructor`, `@Slf4j`).

---

## 🛠️ Tecnologias e Bibliotecas

<div align="center">
  <img src="https://skillicons.dev/icons?i=java,spring,postgres,maven,idea,git,github" alt="Stack principal" />
</div>

### 🚀 Stack principal

- **Java** (`25`)
- **Spring Boot** (`4.1.0`)
- **PostgreSQL** (`18`; também funciona com a versão 16 ou mais nova)
- **Hibernate ORM** (`7.4.1.Final`)
- **Spring Security** (`7.1.0`)

### 📚 Bibliotecas utilizadas

- **Web e API**: `spring-boot-starter-web`, `spring-boot-starter-validation`, `spring-boot-starter-actuator`
- **Persistência**: `spring-boot-starter-data-jpa`, `postgresql` (`42.7.11`), `HikariCP`
- **Segurança**: `spring-boot-starter-security`, `jjwt-api`, `jjwt-impl`, `jjwt-jackson` (`0.12.6`), `BCryptPasswordEncoder`
- **Documentação**: `springdoc-openapi-starter-webmvc-ui` (`3.1.1`, Swagger UI)
- **Arquivos**: `poi` e `poi-ooxml` (`5.3.0`)
- **Produtividade**: `lombok` (`1.18.46`)

### 🧪 Dev tooling

- `IntelliJ IDEA`, `DBeaver`
- `Maven Wrapper` (Maven `3.9.16`), `Git` + `GitHub`
- `spring-boot-starter-test`, `spring-security-test`
- `Swagger UI` para testes manuais da API

### 🧩 Ícones das stacks

<div align="center">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg" width="44" height="44" alt="Java" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/spring/spring-original.svg" width="44" height="44" alt="Spring" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" width="44" height="44" alt="PostgreSQL" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/hibernate/hibernate-original.svg" width="44" height="44" alt="Hibernate" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/maven/maven-original.svg" width="44" height="44" alt="Maven" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/intellij/intellij-original.svg" width="44" height="44" alt="IntelliJ IDEA" />
  <img src="https://cdn.simpleicons.org/swagger/85EA2D" width="44" height="44" alt="Swagger" />
  <img src="https://cdn.simpleicons.org/jsonwebtokens/000000" width="44" height="44" alt="JWT" />
  <img src="https://cdn.simpleicons.org/dbeaver/382923" width="44" height="44" alt="DBeaver" />
</div>

---

## 🗂️ Estrutura do Projeto

```bash
projeto-innovatracker/
├── db/                                  # scripts do banco (rodar no DBeaver, nesta ordem)
│   ├── 00-criar-banco.sql               # cria o banco innovatracker
│   ├── 01-ddl-innovatracker.sql         # cria o schema innova e as 8 tabelas
│   ├── 02-seed-innovatracker.sql        # dados de exemplo
│   ├── 03-senha-login.sql               # grava a senha real (BCrypt) das pessoas
│   └── 99-conferir-banco.sql            # diagnóstico do banco
├── src/
│   ├── main/
│   │   ├── java/hiragi/innovatracker/
│   │   │   ├── InnovatrackerApplication.java   # classe principal (sobe a API)
│   │   │   ├── config/        # OpenApiConfig (Swagger + JWT), SecurityConfig
│   │   │   ├── controller/    # AuthController, DiagnosticController, TdCategoriaController
│   │   │   ├── dto/           # records de entrada e saída (Login, PessoaResumo, Categoria...)
│   │   │   ├── exception/     # BusinessException, ResourceNotFoundException, ApiError, GlobalExceptionHandler
│   │   │   ├── model/         # 8 entidades JPA (Td*, Tb*, Ta*)
│   │   │   ├── repository/    # Spring Data JPA (categoria, departamento, pessoa, ideia)
│   │   │   ├── security/      # JwtTokenProvider, JwtAuthenticationFilter
│   │   │   ├── service/       # AuthService, TdCategoriaService, ReportGeneratorService
│   │   │   └── test/          # testes de console (TdCategoriaTest, TbPessoaTest, TbIdeiaTest...)
│   │   └── resources/
│   │       ├── application.yaml        # configuração (senha via DB_PASSWORD)
│   │       └── application.properties
│   └── test/java/hiragi/innovatracker/
│       └── InnovatrackerApplicationTests.java
├── .mvn/wrapper/                        # Maven Wrapper
├── mvnw / mvnw.cmd
├── pom.xml
└── README.md
```

---

## ⚙️ Como rodar localmente

### Pré-requisitos

- **JDK 25** (por exemplo, Eclipse Temurin 25)
- **PostgreSQL** 16 ou mais novo, rodando em `localhost:5432`
- **IntelliJ IDEA** 2025.2 ou mais novo (Community ou Ultimate)
- **DBeaver**, para criar o banco e rodar os scripts
- **Git**

### Passos

#### 1. Clonar o repositório

```bash
git clone https://github.com/joaogabrieldev/projeto-innovatracker.git
cd projeto-innovatracker
```

#### 2. Criar o banco no DBeaver

1. Crie uma conexão PostgreSQL com `localhost`, porta `5432`, banco `postgres`, usuário `postgres` e a sua senha.
2. Confira se o modo de transação da barra está em **Auto** (auto-commit). Depois, abra o `db/00-criar-banco.sql` e rode com **Ctrl+Enter**.
3. Aponte a conexão para o banco novo: botão direito na conexão → **Editar conexão** → aba **Principal** → campo **Banco de dados** = `innovatracker` → **OK**. Em seguida, botão direito → **Desconectar** e depois **Conectar**.
4. Confira se a barra do editor mostra **`@innovatracker`** antes de cada script.
5. Rode com **Alt+X**, nesta ordem:
   - `db/01-ddl-innovatracker.sql`: cria o schema `innova` e as 8 tabelas;
   - `db/02-seed-innovatracker.sql`: carrega os dados de exemplo.
6. Rode o `db/99-conferir-banco.sql`. O esperado é `innovatracker | innova | 8` e os totais `8 | 12 | 5 | 8 | 19 | 3 | 14 | 15`.

> Os scripts escrevem cada tabela como `innova.xxx`, então funcionam mesmo que o DBeaver esteja com outro schema ativo. Rodar o `01` de novo **apaga os dados**: nesse caso, rode o `02` e o `03` em seguida.

#### 3. Criar a variável de ambiente `DB_PASSWORD` (Windows)

A senha do banco não fica no repositório. O `application.yaml` lê o valor da variável `DB_PASSWORD`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/innovatracker?currentSchema=innova
    username: postgres
    password: ${DB_PASSWORD}
```

**Pela tela do Windows:**
1. Menu Iniciar → digite **variáveis de ambiente** → **Editar as variáveis de ambiente para sua conta**.
2. Em *Variáveis de usuário*, clique em **Novo...** e preencha:
   - Nome: `DB_PASSWORD`
   - Valor: a senha do seu PostgreSQL
3. Clique em **OK** e em **OK** de novo.

**Ou pelo PowerShell:**

```powershell
setx DB_PASSWORD "sua_senha"
```

Para conferir, abra um **PowerShell novo** e rode `$env:DB_PASSWORD`. Depois, **feche o IntelliJ por completo** (*File → Exit*) e abra de novo: ele só lê as variáveis do Windows quando inicia.

#### 4. Abrir no IntelliJ

1. **File → Open** → selecione a pasta do projeto → **Trust Project**.
2. **File → Project Structure → Project** → SDK **25** e *Language level* **25**.
3. Se o seu usuário do Windows tiver acento ou espaço no nome (por exemplo, `C:\Users\João`), configure o repositório do Maven fora da pasta de usuário. Abra **Settings → Build, Execution, Deployment → Build Tools → Maven** → *Local repository* → marque **Override** → `C:\m2\repository`. Para valer em projetos futuros, repita em **File → New Projects Setup → Settings for New Projects**.
4. Clique em **Load Maven Changes** (Ctrl+Shift+O). Na janela **Maven**, rode **Lifecycle → clean** e depois **compile**. O esperado é `BUILD SUCCESS`.

> Avisos de `sun.misc.Unsafe ... lombok.permit.Permit` durante o build são normais: são avisos do Lombok no Java 25, não erros.

#### 5. Subir a API

1. Abra `src/main/java/hiragi/innovatracker/InnovatrackerApplication.java`.
2. Clique no **▶** ao lado da classe → **Run 'InnovatrackerApplication.main()'** (ou Shift+F10).
3. Espere estas linhas no console:

```bash
Tomcat started on port 7777 (http)
Started InnovatrackerApplication in X seconds
```

Aplicação local: `http://localhost:7777` · Swagger: `http://localhost:7777/swagger-ui.html`

> Rode a `InnovatrackerApplication`, não as classes da pasta `test/`. Elas também têm `main`, mas são os testes de console.

#### 6. Gravar a senha real do login

O seed tem hashes fictícios. Para gerar o hash real da senha de teste `654321`:

1. No Swagger, faça o `POST /api/auth/login` com o corpo abaixo. Vai dar **401**, e é o esperado:

```json
{ "email": "carlos.silva@innovatracker.com", "senha": "654321" }
```

2. No console do IntelliJ, copie o valor da linha `Hash gerado pelo Java: $2a$10$...`.
3. Abra o `db/03-senha-login.sql`, cole o hash no lugar de `COLE_AQUI_O_HASH` e rode com **Alt+X**. As 12 linhas devem mostrar `$2a$10$` e tamanho `60`.
4. Repita o login: agora volta **200** com o token. Todas as pessoas do seed passam a usar a senha `654321`.

### 🔐 Testando no Swagger

1. Faça o `POST /api/auth/login` e copie o valor de `token`, sem as aspas.
2. Clique em **Authorize 🔓**, cole o token e clique em **Authorize** e depois em **Close**.
3. Teste as rotas protegidas:

| Teste | Esperado |
|---|---|
| `GET /api/auth/me` | `200` com os dados do Carlos |
| `GET /api/categorias` | `200` com as 5 categorias paginadas |
| `GET /api/categorias/sigla/IA_AUTOM` | `200` |
| `GET /api/categorias/pesquisa?nome=processos` | `200` com "Otimização de Processos" |
| `POST /api/categorias` com `{"sglCategoria":"INOV","nmeCategoria":"Inovação Aberta","dscCategoria":"Parcerias externas"}` | `201` com cabeçalho `Location` |
| O mesmo `POST` de novo | `409`: sigla duplicada |
| `POST /api/categorias` com `"sglCategoria": ""` | `400` com a lista `campos` |
| `GET /api/categorias/999` | `404` |
| `GET /api/categorias/abc` | `400`: parâmetro inválido |
| `DELETE /api/categorias/1` | `409`: existem ideias usando a categoria |
| `DELETE` na categoria `INOV` criada acima | `204` |
| Login com senha errada | `401` |
| **Authorize → Logout** e depois `GET /api/auth/me` | `401` |

Para conferir no banco, rode `SELECT * FROM innova.td_categoria ORDER BY idt_categoria;` no DBeaver.

### 🖥️ Testes de console

As classes de `src/main/java/hiragi/innovatracker/test/` sobem só a camada de dados (sem servidor web) e mostram um menu no console do IntelliJ:

- `TdCategoriaTest`: incluir, consultar, excluir e pesquisar categorias por nome;
- `TbPessoaTest`: incluir, consultar e excluir pessoas;
- `TbIdeiaTest`: incluir, consultar e excluir ideias;
- `TdDepartamentoTest`: menu de departamentos (no momento, ainda opera sobre categorias).

Para rodar, clique no **▶** ao lado do `main` da classe e digite as opções no console. Pode rodar com a API ligada.

> Ao incluir uma ideia, use os status aceitos pelo banco (`B`, `M`, `A` ou `D`). Registros do seed que estão vinculados a outras tabelas não podem ser excluídos.

### Scripts úteis

Pelo IntelliJ, use a janela **Maven → Lifecycle**:

- `clean` -> apaga a pasta `target/`
- `compile` -> compila o projeto
- `test` -> roda os testes automatizados
- `package` -> gera o `.jar` em `target/`

Pelo terminal (PowerShell, com a `DB_PASSWORD` já criada):

```powershell
.\mvnw.cmd "-Dmaven.repo.local=C:\m2\repository" clean compile
.\mvnw.cmd "-Dmaven.repo.local=C:\m2\repository" spring-boot:run
```

### 🧯 Solução de problemas

| Mensagem | Causa | Solução |
|---|---|---|
| `Could not create local repository at C:\Users\Jo?o ...` | Acento no nome do usuário do Windows | Override do repositório Maven para `C:\m2\repository` (passo 4.3) |
| `release version 25 not supported` | O Maven está usando outro JDK | **Settings → Build Tools → Maven → Runner → JRE** = *Use Project JDK* |
| `Could not resolve placeholder 'DB_PASSWORD'` | O IntelliJ não leu a variável | Feche pelo *File → Exit* e abra de novo (feche também o JetBrains Toolbox, se usar) |
| `password authentication failed for user "postgres"` | Valor errado na `DB_PASSWORD` | Corrija a variável e reinicie o IntelliJ |
| `Schema-validation: missing table [...]` | Tabelas fora do schema `innova` | Rode o `db/99-conferir-banco.sql`. Se estiverem em `public`, use `ALTER TABLE public.<tabela> SET SCHEMA innova;` ou rode o `01` e o `02` de novo |
| `Connection to localhost:5432 refused` | PostgreSQL parado | Inicie o serviço do PostgreSQL |
| `Port 7777 was already in use` | Já existe uma instância rodando | Pare a anterior (quadrado vermelho ou Ctrl+F2) |
| `current transaction is aborted` (DBeaver) | Um comando anterior falhou dentro de uma transação | Rode `ROLLBACK;` e execute de novo |
| `relation "td_departamento" does not exist` (DBeaver) | Conexão no banco errado | Confira se a barra mostra `@innovatracker` |
| Login devolve `401` mesmo depois do `03` | Hash colado errado ou transação sem commit | Repita o `03` e confira se a barra está em **Auto** ou clique em **Commit** |
| `The bean 'securityConfig' ... could not be registered` | Existem dois `SecurityConfig` | Mantenha só o de `config/` |

### 🚀 E em produção?

Em produção, a senha continua fora do código, e a aplicação continua lendo `${DB_PASSWORD}`. O que muda é quem fornece a variável:

- **Plataformas como Render, Koyeb, Heroku ou Railway:** em *Environment Variables*, nas configurações do serviço;
- **Nuvem:** em um cofre de segredos (AWS Secrets Manager, GCP Secret Manager ou Azure Key Vault);
- **Containers:** em Docker secrets ou Kubernetes Secrets;
- **Deploy automatizado:** nos *Secrets* do GitHub Actions.

Boas práticas para essa etapa:
- crie um usuário de banco próprio para a aplicação, com acesso só ao schema `innova` (nunca o `postgres`);
- tire o segredo do JWT (`app.jwt.secret`) do arquivo e leia de uma variável `JWT_SECRET`;
- troque as senhas periodicamente.

O Spring Boot também lê variáveis pelo nome da propriedade: `SPRING_DATASOURCE_PASSWORD` substitui `spring.datasource.password` sem precisar alterar o yaml.

---

## 📌 Evento

**Evento/curso relacionado:** `Engenharia de Software (CEUB): projeto da disciplina, com tutoriais do professor Gilberto de Oliveira Hiragi`

### 📚 Trilha de aulas

| Aula | Tema | Entrega no projeto |
|---|---|---|
| 01 | Java 25 moderno, Virtual Threads e estrutura inicial do Spring Boot | Projeto Spring Boot 4, `pom.xml` e `application.yaml` |
| 02 | Configurações, JWT e OpenAPI | `OpenApiConfig`, `JwtTokenProvider`, `DiagnosticController` |
| 03 | Preparação do ambiente e modelagem relacional | DDL, seed e consultas SQL |
| 04 | Persistência e mapeamento de entidades (JPA/Hibernate) | 8 entidades em `model/` |
| 05 | Repositórios de tabela de domínio | `TdCategoriaRepository`, `TdDepartamentoRepository`, testes de console |
| 06 | Repositórios de tabela forte | `TbPessoaRepository`, `TbIdeiaRepository`, testes de console |
| 07 | Segurança, autenticação e JWT | Login, `/me`, `JwtAuthenticationFilter`, `SecurityConfig` |
| 08 | Camada de serviços, controladores e tratamento global de exceções | CRUD de categorias, `GlobalExceptionHandler`, `ApiError` |

### 🔧 Ajustes em relação ao material

Ajustes feitos para o projeto compilar e rodar com as versões atuais:

- `springdoc-openapi` na versão **3.1.1** (a 2.x do material é a linha do Spring Boot 3);
- `annotationProcessorPaths` do Lombok no `pom.xml`, porque o JDK 23 ou mais novo não roda annotation processors sem essa configuração no build do Maven;
- `?currentSchema=innova` na URL do banco, para o `ddl-auto: validate` encontrar as tabelas;
- `TEMPLATE = template0` no `CREATE DATABASE`;
- rota `/error` liberada no `SecurityConfig`, para que um erro `400` não vire `401`;
- `@SecurityRequirements` no `/login` (sem cadeado no Swagger) e `@Operation` no `/me`;
- scripts SQL com o schema escrito em cada tabela (`innova.xxx`), independentes do schema ativo no DBeaver;
- senha do banco lida da variável `DB_PASSWORD`, sem nenhuma senha no repositório.

---

## 👨‍💻 Contato

<div align="center">

### João Gabriel R. Rocha

[![GitHub](https://img.shields.io/badge/GitHub-joaogabrieldev-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/joaogabrieldev)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-joaogabrielrocha-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/joaogabrielrocha)
[![Portfólio](https://img.shields.io/badge/Site-joaogabriel.dev-0A0A0A?style=for-the-badge&logo=googlechrome&logoColor=white)](https://joaogabriel.dev)

</div>

---

<div align="center">
Feito com ❤️, Spring Boot e muito café.
</div>
