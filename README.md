# Bills

Projeto desenvolvido usando [Sqlite](https://www.sqlite.org/index.html), [ASP.NET Core](https://docs.microsoft.com/pt-br/aspnet/core/introduction-to-aspnet-core?view=aspnetcore-3.1) 
e [Flutter](https://flutter.dev/docs/get-started/install), com o intuito de realizar o gerenciamento básico do pagamento de contas.


Status do projeto: Finalizado.

### Objetivo e Resumo

Esse projeto tem como objetivo realizar o cadastro de contas a pagar e visualização das contas cadastradas. 
É, um serviço [REST](https://www.devmedia.com.br/rest-tutorial/28912), desenvolvido em ASP.NET Core, com utilização do [Entity Framework Core](https://docs.microsoft.com/pt-br/ef/core/) 
e do Sqlite.
Para facilitar a manipulação do projeto, resolvi fazer o deploy do serviço REST no [Heroku](https://www.heroku.com/), para isso, aprendi alguns conceitos relacionados
ao [Docker](https://www.docker.com/), como a geração de imagem e contâiner para que fosse possível subir o serviço para o Heroku e contar com o banco de dados(Sqlite) 
fora do ambiente local.

Seguindo nessa linha, foi criado um projeto junto ao serviço REST, em Flutter para web, para que fosse possível manipular(adicionar novas contas e visualizar) 
os dados de uma forma mais amigável.

### Features

O projeto conta com 2 features principais: O cadastro de contas a pagar e a listagem de contas cadastradas.
Não é possível editar ou excluir as contas.

#### Cadastro de contas a pagar

Essa feature consiste no envio, através de um POST, para o serviço REST, de um objeto com as informações relacionadas à conta, como Nome, Valor da conta, Data de Pagamento e Data de Vencimento.
Todos esses campos são obrigatórios para a aplicação e há tratamento de erro para situações adversas.

#### Listagem de contas cadastradas
Após a inserção de uma conta, ela fica disponível, através de requisição GET. Quando os dados são retornados, há mais informações disponíveis, tais como Dias em atraso e Valor corrigido.
O valor corrigido segue a seguinte regra:

Para atraso de até 3 dias, são aplicados 2% de multa sobre o valor original e 0,1% de juros por dia de atraso sobre o valor original.

Para atrasos entre 4 e 5 dias, são aplicados 3% de multa sobre o valor original e 0,2% de juros por dia de atraso sobre o valor original.

Para atrasos superiores a 5 dias, são aplicados 5% de multa sobre o valor original e  0,3% de juros por dia de atraso sobre o valor original.


### Testes
Nesse projeto, foram utilizados testes usando [xUnit](https://xunit.net/) e verificação de requisições via [Postman](https://www.postman.com/), além de testes seguindo os padrões do Clean Architecture 
utilizado no Flutter (tendo como base os vídeos e tutorias do [Reso Coder](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)).
Todos os testes estão salvos no projeto.

Para alguns testes, como os que utilizam xUnit, busquei tutoriais que trouxessem testes mais voltados para o backend.
Esses foram os links de apoio, [Testes usando ASP.NET Core, EF Core e Sqlite](https://raaaimund.github.io/tech/2019/05/07/aspnet-core-unit-testing-inmemory/) e
[Validação de modelo](http://www.jondavis.net/techblog/post/2010/12/01/Testing-Basic-ASPNET-MVC-View-Model-Validation-With-Brevity.aspx), além das documentações oficiais
da Microsoft.

### Deploy no Heroku e Contâiner Docker
Esse foi um grande desafio nesse projeto, nunca havia utilizado Docker e os deploys que eu havia feito usando o Heroku tinham sido na época de faculdade, e poucas vezes.
Quebrei bastante a cabeça até que tudo funcionasse corretamente. O problema do "funciona na minha máquina, mas não em outros lugares" estava bem presente durante o desenvolvimento
desse projeto. Após muitas buscas e tentativas, encontrei a solução para os problemas que eu estava passando [aqui](https://habr.com/en/post/450904/), além de estar seguindo esse tutorial
[aqui](https://www.treinaweb.com.br/blog/publicando-uma-aplicacao-asp-net-core-no-heroku/). Há um problema em relação à porta que será usada na aplicação; o Heroku não 
aceita configuração de porta(pelo menos não encontrei nada sobre isso) e algumas modificações no projeto ASP.NET Core são necessárias para que se gere o Docker corretamente.
Deve-se atentar que a cada atualização do contâiner Docker e consequente deploy no Heroku, a base é resetada, pois ela sobe novamente com a aplicação, em seu estado inicial.

### Pré-requisitos

Para rodar essa aplicação localmente, você deve ter o amiente .NET e o ambiente Flutter (caso queira usar a interface desenvolvida, atentando que a interface em Flutter faz
comunicação com o serviço hospedado no Heroku).

Essa interface está disponível através do Github Pages, que pode ser acessado por este [link](https://matheusschipper.github.io/#/).
A documentação da API foi feita utilizando o [Swagger](https://swagger.io/) e está disponível [aqui](https://msdbillsapi.herokuapp.com/swagger/index.html).


### Tecnologias

 - [Flutter](https://flutter.dev/)
 - [ASP.NET Core](https://docs.microsoft.com/pt-br/aspnet/core/introduction-to-aspnet-core?view=aspnetcore-3.1) 
 - [Entity Framework Core]()
 - [Sqlite](https://www.sqlite.org/index.html)
 - [xUnit](https://xunit.net/)
 - [Heroku](https://www.heroku.com/)
 - [Docker](https://www.docker.com/)
 - [Swagger](https://swagger.io/)
 

### Autor
Desenvolvido por Matheus Schipper. Quaisquer dúvidas/reclamações/sugestões, entre em contato comigo!

[![Linkedin Badge](https://img.shields.io/badge/-Matheus_Schipper-blue?style=flat-square&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/matheusschipper/)](https://www.linkedin.com/in/matheusschipper/)
