import pandas as pd
import numpy as np

# 1. Load your dataset
order_items_df = pd.read_csv("C:/BalaAbineshwar_MilestoneProject/01_Data_Acquisition/olist_order_items_dataset.csv")

prices = order_items_df['price']


# 1. Mean (Average)
mean_price = prices.mean()
print("1. Mean Price:", mean_price)

# 2. Median (Middle Value)
median_price = prices.median()
print("2. Median Price:", median_price)

# 3. Mode (Most Common Value)
mode_price = prices.mode()[0]
print("3. Mode Price:", mode_price)

# 4. Minimum & Maximum (Range)
min_price = prices.min()
max_price = prices.max()
print("4. Minimum Price:", min_price)
print("4. Maximum Price:", max_price)

# 5. Variance (Measures overall spread using squared differences)
variance_price = prices.var()
print("5. Variance:", variance_price)

# 6. Standard Deviation (Measures typical distance from the mean)
std_dev_price = prices.std()
print("6. Standard Deviation:", std_dev_price)

# 7. Correlation between Price and Freight Value
correlation_value = order_items_df['price'].corr(order_items_df['freight_value'])
print("7. Correlation between Price and Freight Value:", correlation_value)

