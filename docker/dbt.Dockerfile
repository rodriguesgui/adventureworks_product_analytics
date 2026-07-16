FROM python:3.12
# Definindo o mantenedor
LABEL maintainer="AdventureWorks"

# Atualizando a lista de pacotes e instalando dependências
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    vim \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Criando um diretório de trabalho
WORKDIR /usr/app/dbt

# Instalando DBT e adaptador para o postgresql
RUN pip install dbt-core==1.8.0
RUN pip install dbt-postgres==1.8.0


# Definir o comando padrão para execução quando o container for iniciado
CMD ["tail", "-f", "/dev/null"]
