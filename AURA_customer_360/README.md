# AURA Customer 360 dbt Workspace

This directory contains the transformation layer of the AURA Revenue Intelligence project.

## 🏗️ Model Architecture
1. **Staging (`models/staging`):** Views that clean and rename raw source data for consistency.
2. **Marts (`models/marts`):** The final `dim_customers` table which joins Sales, CRM, and Marketing stats into a unified record.

## 🚀 How to Run
1. Ensure your `profiles.yml` is configured for your local PostgreSQL instance.
2. Install dependencies:

   ```bash
   dbt deps
   ```