FROM node:19

# Define o diretório de trabalho
WORKDIR /app

# Instala dependências do sistema para compilar pacotes nativos
RUN apt-get update && apt-get install -y \
    dos2unix \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copia o script wait-for-it.sh
COPY wait-for-it.sh /app/wait-for-it.sh

# Converte o script para formato Unix e ajusta permissões
RUN apt-get update && apt-get install -y dos2unix \
    && dos2unix /app/wait-for-it.sh && chmod +x /app/wait-for-it.sh

# Copia os arquivos package.json
COPY package*.json ./

# Instala dependências
RUN npm install --force
RUN npm rebuild

# Copia o restante dos arquivos
COPY . .

# Expõe a porta 3000
EXPOSE 3000

# Comando padrão ao iniciar o contêiner
CMD ["npm", "start"]
