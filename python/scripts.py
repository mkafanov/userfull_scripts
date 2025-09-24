# обработка сообщений из консоли
import sys
import logging

logger = logging.getLogger(__name__)
logging.basicConfig(filename="output.log", level=logging.INFO)

def handle_uncaught_exception(exc_type, exc_value, exc_traceback):
    logger.critical(
        "Uncaught exception. Application will terminate.",
        exc_info=(exc_type, exc_value, exc_traceback)
    )

sys.excepthook = handle_uncaught_exception

logger.info("Application started")

#использование sql в pandas
import pandas as pd 
from pandasql import sqldf

data = {
    'product_id': [1, 2, 1, 3, 2, 3, 1],
    'sale_date': ['2023-01-01', '2023-01-02', '2023-01-03', '2023-01-01', '2023-01-02', '2023-01-03', '2023-01-04'],
    'amount': [100, 200, 150, 300, 250, 350, 400]
}

df = pd.DataFrame(data)

# логика с pandas (фильтруем по датам, группируем по product_id, считаем агрегат суммы по полю amount и сортируем по нему же)
result_df = (
    df[df['sale_date'].between('2023-01-02', '2023-01-03')]
    .groupby('product_id', as_index=False)['amount']
    .sum()
    .sort_values(by='amount', ascending=False)
)

# или применяя sqldf
query = """
    SELECT product_id, SUM(amount) as total_amount
    FROM df
    WHERE sale_date BETWEEN '2023-01-02' AND '2023-01-03'
    GROUP BY product_id
    ORDER BY total_amount DESC
"""

sql_result = sqldf(query, globals())


#Загрузка данных в БД из большого файла

import pandas as pd
import sqlalchemy as sa

DB = dict(
    user="",
    password="",
    host="",
    port=5432,
    dbname="",
)
engine = sa.create_engine(
    f"postgresql+psycopg2://{DB['user']}:{DB['password']}@{DB['host']}:{DB['port']}/{DB['dbname']}",
)

#  параметры CSV
csv_path   = "big_file.csv"
chunk_rows = 100_000 # будем грузить по 100K строк
table_name = "example_csv"
schema     = "raw"

# создаём таблицу один раз с нужными колонками
with engine.begin() as conn:
    conn.exec_driver_sql(f"""
        CREATE SCHEMA IF NOT EXISTS {schema};
        DROP TABLE IF EXISTS {schema}.{table_name};
        CREATE TABLE {schema}.{table_name} (
            col_0 text, col_1 text, col_2 text, col_3 text, col_4 text,
            col_5 text, col_6 text, col_7 text, col_8 text, col_9 text
        );
    """)

# грузим чанками
reader = pd.read_csv(
    csv_path,
    chunksize=chunk_rows,
    iterator=True,
    header=0,
)

for i, chunk in enumerate(reader, 1):
    chunk.to_sql(
        name=table_name,
        con=engine,
        schema=schema,
        if_exists="append",
        index=False,
        method="multi",
    )
    print(f"Чанк {i}: {len(chunk)} строк залито")

#Поиск по регулярным выражениям в pandas DF
pattern = r'\b(?:ИИ|искусственный интеллект|AI|Artificial intelligence|нейросет|машинное обучение)\b' 

df_final = df[
    df['title'].str.contains(pattern, case=False, regex=True, na=False) |
    df['domain'].str.contains(pattern, case=False, regex=True, na=False)
]



#Генерация безопасного пароля
import secrets
import string

alphabet = string.ascii_letters + string.digits + "!@#$%^&*"
password = ''.join(secrets.choice(alphabet) for i in range(16))
print(password)

#Алерты в телеграм бот
python  
requests.post(f"https://api.telegram.org/botTOKEN/sendMessage",  
              json={"chat_id": "ID", "text": "🚨 CPU > 90%!"})  


