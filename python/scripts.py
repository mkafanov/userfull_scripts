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
