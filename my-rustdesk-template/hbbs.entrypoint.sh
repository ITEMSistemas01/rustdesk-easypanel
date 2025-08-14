#!/bin/bash

# Diretório para os dados do hbbs
DATA_DIR="/data"

# Arquivo da chave pública
PUB_KEY_FILE="$DATA_DIR/id_ed25519.pub"

# Verifique se a chave pública já existe
if [ ! -f "$PUB_KEY_FILE" ]; then
  echo "Chave pública não encontrada. Gerando nova chave..."
  
  # O servidor hbbs precisa ser executado uma vez para gerar as chaves
  /root/hbbs -r "${RELAY_SERVER_DOMAIN}" &
  
  # Espere um momento para que as chaves sejam geradas
  sleep 5
  
  # Mate o processo hbbs que foi iniciado apenas para gerar as chaves
  killall hbbs
  echo "Chaves geradas e salvas em $PUB_KEY_FILE."
fi

# Agora inicie o servidor hbbs de fato com a chave gerada
/root/hbbs -r "${RELAY_SERVER_DOMAIN}" &

# Inicie o servidor de retransmissão hbbr
/root/hbbr &

# Aguarde a finalização dos processos
wait -n