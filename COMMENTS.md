# Documentação da Solução

## Visão Geral

Esta solução aborda o problema proposto de implantação da aplicação de Comentários em versão API (backend) usando ferramentas open source. A solução automatiza a infraestrutura na AWS utilizando Terragrunt, provisionando uma instância EC2. A configuração do host EC2 é feita por meio de um arquivo de template Terraform. A aplicação é executada em um contêiner Docker, definido no arquivo compose.yaml dentro do diretório "app".

## Estrutura do Projeto

A estrutura do projeto é a seguinte:

- **Diretório `app/`**: Contém os arquivos relacionados à aplicação.
  - **`compose.yaml`**: Define a configuração do Docker Compose para execução da aplicação.
  - **Diretório `image/`**: Contém os arquivos relacionados à imagem Docker da aplicação.
    - **`Dockerfile`**: Define a construção da imagem Docker.
    - **`requirements.txt`**: Lista de dependências Python da aplicação.
    - **Diretório `src/`**: Contém os arquivos fonte da aplicação.
      - **`api.py`**: Código fonte da API.

- **`COMMENTS.md`**: Documenta detalhes da solução e decisões tomadas durante o desenvolvimento.

- **Diretório `dev/`**: Contém os arquivos de desenvolvimento, incluindo configurações específicas para a infraestrutura na AWS.
  - **Diretório `us-east-1/`**: Configurações específicas da região da AWS.
    - **Diretório `ec2/`**: Configurações para instâncias EC2.
      - **Diretório `comment-api/`**: Configurações específicas da aplicação de comentários.
        - **`local.tfvars`**: Variáveis locais para a configuração do host EC2.
        - **Diretório `template/`**: Contém o arquivo de template Terraform para configuração do host EC2.
          - **`api_server.tpl`**: Template Terraform para configuração do host EC2.
        - **`terragrunt.hcl`**: Arquivo de configuração do Terragrunt para provisionamento da infraestrutura na AWS.

- **`README.md`**: Documentação geral do projeto.

- **`terragrunt.hcl`**: Arquivo de configuração do Terragrunt para a infraestrutura na AWS.

## Tecnologias Utilizadas

- **Terragrunt**: Utilizado para provisionar e gerenciar a infraestrutura na AWS.
- **Terraform**: Utilizado para definir a configuração da infraestrutura na AWS.
- **Docker Compose**: Utilizado para definir e executar a configuração da aplicação em contêineres Docker.
- **Docker**: Utilizado para empacotar a aplicação em contêineres.
- **Python**: Utilizado para desenvolvimento da aplicação API.

## Automação da Infraestrutura (IaaS)

A infraestrutura na AWS é provisionada utilizando Terragrunt, com as configurações definidas no diretório "dev". O arquivo "terragrunt.hcl" na raiz do projeto define as configurações gerais do Terragrunt.

## Automação de Setup e Configuração (IaC)

A configuração do host EC2 na AWS é feita utilizando Terraform, com o auxílio de um arquivo de template. O arquivo "api_server.tpl" dentro do diretório "template" no diretório "dev" define a configuração do host EC2.

## Considerações Finais

Esta solução oferece uma abordagem estruturada e automatizada para a implantação da aplicação de Comentários em versão API. A utilização de ferramentas como Terragrunt, Terraform e Docker facilita a criação, configuração e execução da infraestrutura e da aplicação de forma consistente e escalável.
