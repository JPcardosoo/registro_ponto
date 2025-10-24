# Aplicativo de Registro de Ponto com Geolocalização

## Descrição do Projeto
- Este documento detalha a implementação de um aplicativo móvel desenvolvido em Flutter como parte do processo de avaliação da disciplina.
- O objetivo do aplicativo é permitir que funcionários registrem seu ponto de trabalho de forma segura e precisa, utilizando geolocalização para validar o local do registro.
- A aplicação foi construída com integração ao Firebase para autenticação de usuários e armazenamento de dados, seguindo as melhores práticas de desenvolvimento mobile.

## Funcionalidades Implementadas
- Autenticação de Usuário via Firebase Authentication.
- Registro de Ponto através de um Mapa Interativo.
- Verificação de Geolocalização para garantir que o ponto selecionado esteja dentro de um raio de 100 metros do local de trabalho.
- Armazenamento dos Registros de Ponto no Cloud Firestore, incluindo ID do usuário, data, hora e coordenadas exatas.
- Interface de Usuário clara com feedback visual para o usuário, incluindo a exibição do raio permitido no mapa.

## Arquitetura e Decisões de Design
- O projeto foi estruturado seguindo uma arquitetura limpa, baseada em Controller e Services, para separar as responsabilidades do código.
- Models: Classes que representam a estrutura dos dados (ex: PontoModel para o registro de ponto).
- Views: Camada de interface do usuário, responsável por exibir os dados e capturar as interações do usuário (ex: HomeView com o mapa).
- Controllers: Orquestram a lógica de negócio, conectando a View aos serviços e ao backend (ex: PontoController).
- Services: Classes especializadas em tarefas únicas, como a comunicação com APIs externas (ex: GeolocationService).
A escolha desta arquitetura visa facilitar a manutenção, a testabilidade e a escalabilidade do código, cumprindo os objetivos de boas práticas de desenvolvimento.

## Detalhes Técnicos de Implementação

### Integração com Firebase
- Firebase Authentication: Utilizado para gerenciar o login dos usuários (NIF/senha ou email/senha). Cada registro de ponto é vinculado ao UID do usuário autenticado.
- Cloud Firestore: Utilizado como banco de dados NoSQL para armazenar os registros de ponto. Foi criada uma coleção registros_ponto, onde cada documento representa um ponto batido e contém campos como userId, timestamp (data e hora) e location (GeoPoint).

### Uso de APIs e Pacotes Externos
- geolocator: Essencial para o cálculo da distância entre o ponto selecionado pelo usuário e as coordenadas do local de trabalho.
- flutter_map e latlong2: Utilizados para renderizar o mapa interativo, exibir marcadores e a camada de círculo que delimita a área permitida para o registro.
- firebase_core, firebase_auth, cloud_firestore: Pacotes oficiais do Firebase para integração com a plataforma.

## Desafios Encontrados e Soluções

### Desafio 1: Integração da Autenticação Biométrica
- Descrição: Durante o desenvolvimento, foi encontrada uma dificuldade persistente na integração do pacote local_auth no ambiente Android. O erro no_fragment_activity persistiu mesmo após a aplicação das soluções padrão, como a alteração para FlutterFragmentActivity, limpeza completa de cache (flutter clean, gradlew clean) e testes em diferentes emuladores.
- Solução: Para garantir a estabilidade e a entrega de um produto funcional dentro do prazo, foi tomada a decisão estratégica de remover a funcionalidade de biometria. O foco foi direcionado para solidificar o fluxo principal do aplicativo, que consiste na seleção do ponto no mapa, verificação de distância e salvamento no Firestore.

### Desafio 2: Precisão na Verificação de Geolocalização
- Descrição: A funcionalidade de verificação de raio inicialmente retornava resultados incorretos, informando que o ponto estava fora da área permitida mesmo quando o clique era feito visualmente dentro dela.
- Solução: O problema foi diagnosticado como uma imprecisão nas coordenadas do local de trabalho. A solução implementada foi dupla: primeiro, obter as coordenadas exatas através do Google Maps; segundo, adicionar uma camada visual (CircleLayer) no mapa do aplicativo para desenhar o raio de 100 metros. Isso forneceu um feedback visual imediato tanto para o desenvolvedor durante os testes quanto para o usuário final, resolvendo o problema de precisão.

## Guia de Instalação e Configuração

### Pré-requisitos
- Flutter SDK instalado (versão 3.x ou superior).
- Um editor de código como VS Code ou Android Studio.
- Um emulador Android ou um dispositivo físico.

### Configuração do Firebase
- Crie um novo projeto no console do Firebase.
- Adicione um aplicativo Android ao seu projeto Firebase, seguindo as instruções para registrar o nome do pacote.
- No console do Firebase, habilite os seguintes serviços:
- Authentication (habilite o provedor "E-mail/senha").
- Cloud Firestore (inicie no modo de teste para facilitar o desenvolvimento).

### Configuração do Projeto Local
- Clone o repositório do projeto.
- Abra o projeto em seu editor e execute flutter pub get no terminal para instalar as dependências.
- Navegue até o arquivo lib/services/geolocation_service.dart e altere as variáveis workLatitude e workLongitude para as coordenadas do seu local de trabalho.
- Faça o mesmo no arquivo lib/views/home_view.dart para a variável localTrabalho.

### Executando o Aplicativo
- Conecte um dispositivo ou inicie um emulador.
- Execute o comando flutter run no terminal.

### Como Usar o Aplicativo
- Abra o aplicativo e realize o login com as credenciais de usuário.
- A tela principal exibirá um mapa centrado no local de trabalho, com um círculo azul indicando a área permitida para o registro.
- Toque em qualquer ponto dentro do círculo azul. Um marcador verde aparecerá no local do toque.
- Clique no botão flutuante de "Salvar" no canto inferior direito.
- O aplicativo irá verificar a distância e salvar o ponto no Firebase.
- Um marcador vermelho aparecerá no local, confirmando que o ponto foi salvo permanentemente.