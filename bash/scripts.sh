# сгруппировать файлы по их расширениям с помощью команды
ls -X
# Как фиксировать зависимости
pip freeze > requirements.txt
# Восстановить зависимости
pip install -r requirements.txt
#таймаут для скрипта, через 30 секунд если скрипт не отработает, bash его убьет.
timeout 30s ./myscript.sh
#Проверка связи со шлюзом и получение его ip
ping _gateway
#путь к файлу терминального процесса
tty
#Проверка скрипта на синтаксические ошибки:
bash -n scriptname
#Проверка использования дискового пространства
df -h | awk '$5+0 > 80 {print}' #80 - 80% занимает процесс, можно снизить.
#Получение публичного ip адреса
curl -s ifconfig.me
#cron на первый рабочий день месяца
0 8 1-3 * * [ "$(date +\%u)" -lt 6 ] && [ "$(curl -s https://isdayoff.ru/$(date +\%Y\%m\%d))" = "0" ] && /usr/local/sbin/bashdays.sh
#Установка и запуск фичи для поиска свободного домена
curl https://sh.rustup.rs -sSf | sh
. "$HOME/.cargo/env"
cargo install domain-check

domain-check linuxfactory -t ru,com,io,dev # заменить linuxfactory на поиск свободного домена.
#Очистка логов по ssh ключам
ssh-keygen -R 192.168.1.107

#Удаление лог.файлов старше 30 дней
LOG_DIR="/var/log"  
find "$LOG_DIR" -type f -name "*.log" -mtime +30 -delete  
