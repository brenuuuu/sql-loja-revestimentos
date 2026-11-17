#!/usr/bin/env bash
# Cria o banco e roda todos os scripts em ordem.
# Uso: ./executar.sh [nome_do_banco]   (padrao: loja_revestimentos)
set -e
BANCO=${1:-loja_revestimentos}

createdb "$BANCO" 2>/dev/null || true
for arquivo in sql/0*.sql; do
    echo ">> $arquivo"
    psql -v ON_ERROR_STOP=1 -q -d "$BANCO" -f "$arquivo"
done
