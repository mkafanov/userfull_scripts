import paramiko 

Настройки подключения 
hostname = "your-server.com"
port = 22
username = "your_username"
password = "your_password"  # или используй ключ вместо пароля 

Локальный и удалённый пути 
local_file = "local_file.txt"
remote_file = "/remote/path/local_file.txt" 

Создаём SSH-клиент 
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy()) 

try:
    ssh.connect(hostname, port=port, username=username, password=password) 

# Открываем SFTP-сессию и загружаем файл
sftp = ssh.open_sftp()
sftp.put(local_file, remote_file)
sftp.close()

print("Файл успешно загружен!")
except Exception as e:
    print(f"Ошибка: {e}")
finally:
    ssh.close()
