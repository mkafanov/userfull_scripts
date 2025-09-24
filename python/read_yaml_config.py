import yaml  # pip install PyYAML

with open("config.yaml", "r") as f:
    config = yaml.safe_load(f)

# Теперь доступ к параметрам прост и безопасен
db_host = config['database']['host']
timeout = config['api']['timeout_seconds']
