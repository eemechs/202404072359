# Considerações Gerais

Seguindo as melhores práticas de para imagens docker, o arquivo Dockerfile foi guiado pela documentação abaixo:

https://snyk.io/blog/10-docker-image-security-best-practices/


# Etapa de construção
FROM python:3.9.7-slim-buster AS build

WORKDIR /app

# Instalar dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o restante do código
COPY . .

# Etapa de produção
FROM python:3.9.7-slim-buster

# Criar usuário não-root
RUN useradd -m appuser
USER appuser

WORKDIR /app

# Copiar arquivos da etapa de construção
COPY --from=build /app .

# Expor a porta, se necessário
EXPOSE 8000

# Comando padrão para executar o aplicativo
CMD ["gunicorn", "--log-level", "debug", "api:app"]
