import hvac
import os

client = hvac.Client(
    url=os.getenv('VAULT_ADDR'),
    token=os.getenv('VAULT_TOKEN')
)

# Чтение секретов
secret = client.secrets.kv.v2.read_secret_version(
    path='app/database'
)
db_password = secret['data']['data']['password']
