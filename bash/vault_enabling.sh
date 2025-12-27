# Установка
wget https://releases.hashicorp.com/vault/1.15.0/vault_1.15.0_linux_amd64.zip
unzip vault_1.15.0_linux_amd64.zip
sudo mv vault /usr/local/bin/

# Запуск в dev режиме (для тестирования)
vault server -dev -dev-root-token-id="root"

# Настройка окружения
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'



# Включение движка секретов
vault secrets enable -path=secret kv-v2

# Запись секретов
vault kv put secret/app/database \
  username="app_user" \
  password="s3cr3t-p@ssw0rd" \
  host="db.example.com"

# Чтение секретов
vault kv get secret/app/database

# Генерация динамических секретов для БД
vault secrets enable database
vault write database/config/postgres \
  plugin_name=postgresql-database-plugin \
  connection_url="postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable" \
  allowed_roles="app"

vault write database/roles/app \
  db_name=postgres \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';" \
  default_ttl="1h" \
  max_ttl="24h"


# Создание политики
vault policy write app app-policy.hcl

# Создание токена с политикой
vault token create -policy=app




