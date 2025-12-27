#!/bin/bash

# Скрипт проверяет место на диске, нагрузку и память

ALERT=90  # Порог для алерта (%)

# Проверка диска
df -h | awk -v alert=$ALERT '$5+0 > alert {print "Диск почти полон:", $0}'

# Проверка памяти
free -m | awk 'NR==2 {if ($3/$2 * 100 > 85) print "Мало свободной памяти!"}'

# Проверка нагрузки
uptime | awk -F 'load average:' '{print "Нагрузка:", $2}'

#Кто имеет доступ на сервер
cat /etc/passwd | grep '/bin/bash'

#Что запущено на сервере
ps aux --sort=-%mem | head -n 10

#Очистка диска
echo "Начинается уборка..."
docker system prune -f
find /var/log -name "*.log" -type f -mtime +7 -delete
find /tmp -type f -atime +1 -delete
echo "Уборка завершена. Свободно: $(df -h / | awk 'NR==2 {print $4}')"
