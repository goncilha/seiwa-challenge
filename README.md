# README

## Setup
#### Requisitos:
    - Ruby 3.3.5
    - Postgresql

Após clonar o projeto, rode:
```
bundle
```

Para rodar a aplicação basta seguir o setup de qualquer aplicação Rails.
Configure suas credenciais de banco de dados, ou apenas use as varíaveis de ambiente `POSTGRES_USER` e `POSTGRES_PASSWORD`
Após isso rode o comando:
```
POSTGRES_USER=<your_postgres_user> POSTGRES_PASSWORD=<your_postgres_password> rails db:create
```
Em seguida:
```
POSTGRES_USER=<your_postgres_user> POSTGRES_PASSWORD=<your_postgres_password> rails db:migrate
```
Após rodar as migrações, o banco de dados estará pronto e já com dados.

### Authentication
Você vai precisar setar uma varíavel de ambiente chamada `JWT_SECRET`, ela é a chave para criptografar os JWT.
Você vai precisar dele em todos os requests. Para esse projeto eu não implementei um endpoint para fazer login, mas
você pode gerar um jwt usando `rails console`, com o seguinte comando:
```
POSTGRES_USER=<your_postgres_user> POSTGRES_PASSWORD=<your_postgres_password> JWT_SECRET=<your_secret> rails c
```
Em seguida:
```
SeiwaAuth::Token.new.encode(User.last.id)
```
A o resultado desse comando é uma string que é o token gerado, use esse valor em um header chamado `Authorization`
nas requisições

### Iniciando o servidor
Para iniciar o servidor basta rodar esse comando:
```
POSTGRES_USER=<your_postgres_user> POSTGRES_PASSWORD=<your_postgres_password> JWT_SECRET=<your_secret> rails s
```
E então a aplicação ficará disponível em http://localhost:3000

### Unit Tests
A aplicação contém testes unitários feitos utilizando o Minitest, eles se encontrar dentro da pasta `test/`.
Para rodar os testes:
```
POSTGRES_USER=<your_postgres_user> POSTGRES_PASSWORD=<your_postgres_password> rails test
```
Ou use algum outro método de sua preferência.

### RSpec e Swagger
A aplicação também contém testes de request feitos com RSpec, eles se encontram dentro da paste `spec`, que também são utilizados para gerar a documentação no formato
Openapi, com a Gem `rswag`.
Parar rodar as specs:
```
POSTGRES_USER=<your_postgres_user> POSTGRES_PASSWORD=<your_postgres_password> rails spec
```
Ou use algum outro método de sua preferência.

Parar gerar a documentação, basta rodar:
```
POSTGRES_USER=<your_postgres_user> POSTGRES_PASSWORD=<your_postgres_password> JWT_SECRET=<your_secret> rake rswag
```
Ela fica acessível em http://localhost:3000/api-docs/

### Tratamento de erros e exceções
Todas as exceções são tratadas e uma string com a mensagem da exceção é retornada.
Todas as entidades possuem validações, devidamente testadas.

### Segurança
Para garantir segurança para os dados, foi feita uma autenticação utilizando JWT.
Todos os requests são autenticados, e caso o token fornecido no header seja inválido, a requisição é bloqueada.
Também há uma verificação para o status de usuário no banco, caso algum usuário que esteja desabilitado tente acessar
o sistema, a requisição também é bloqueada.

Todos os parametros são tratados nos controllers, nenhum parametro não permitido pode ser recebido nas requisições.

A entidade `User` utiliza o método do `rails` `has_secure_password` que utiliza a `gem bcrypt` para criptografar
passwords no banco de dados.
A modelagem de dados feita para esse projeto foi pensada para ser imutável, nas partes sensíveis do sistema nenhum dado deve ser alterado,
sempre se gera um dado novo.