import pandas as pd
import numpy as np
from faker import Faker
import os

fake = Faker()
input_file = 'seeds/raw_retail_data.csv'

if not os.path.exists(input_file):
    print(f"Error: {input_file} not found. Please ensure the CSV is in the seeds folder.")
else:
    print("Reading real retail data...")
    df_real = pd.read_csv(input_file, encoding='ISO-8859-1', low_memory=False)
    
    # 1. CLEAN THE COLUMNS (Removes hidden spaces)
    df_real.columns = df_real.columns.str.strip()
    print(f"Found columns: {list(df_real.columns)}")

    # 2. FIND THE CUSTOMER ID COLUMN DYNAMICALLY
    # This checks for common variations like 'CustomerID', 'Customer ID', etc.
    id_col = None
    for col in df_real.columns:
        if 'customer' in col.lower() and 'id' in col.lower():
            id_col = col
            break

    if id_col is None:
        print("CRITICAL ERROR: Could not find a Customer ID column. Please check your CSV header names.")
    else:
        print(f"Using '{id_col}' as the unique identifier.")
        unique_customers = df_real[id_col].dropna().unique()
        print(f"Found {len(unique_customers)} unique customers. Generating silos...")

        # 3. GENERATE CRM DATA
        support_data = []
        for cid in unique_customers:
            if np.random.rand() > 0.8:
                support_data.append({
                    'ticket_id': fake.uuid4()[:8],
                    'customer_id': cid,
                    'issue_type': np.random.choice(['Delivery Delay', 'Damaged Goods', 'Size Exchange']),
                    'status': 'resolved',
                    'created_at': fake.date_between(start_date='-1y', end_date='today')
                })
        pd.DataFrame(support_data).to_csv('seeds/crm_support_tickets.csv', index=False)

        # 4. GENERATE MARKETING DATA
        marketing_data = [{'customer_id': cid, 'is_subscribed': True} for cid in unique_customers]
        pd.DataFrame(marketing_data).to_csv('seeds/marketing_email_stats.csv', index=False)

        print("\nSuccess! Silo files created in the seeds folder.")