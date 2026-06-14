# Call Center Performance Analytics Project

This project demonstrates an end-to-end data analytics workflow, transforming raw operational data into actionable business insights. The goal was to build a comprehensive dashboard that helps management track performance, identify bottlenecks, and improve service quality.

### 🛠️ Tools & Technologies
* **Database:** SQL Server (Data modeling, schema design, and data seeding).
* **Visualization:** Power BI (Reporting, DAX measures, and interactive storytelling).
* **Analytics:** Trend analysis, KPI tracking, and operational efficiency monitoring.

### 🔍 Analytical Queries
To validate the dashboard metrics and perform deep-dive analysis, I have developed a set of SQL queries (`data_analysis.sql`) that cover:
* **Trend Analysis:** Calculating Month-over-Month escalation rates.
* **Agent Performance:** Evaluating handle volume and satisfaction scores per agent.
* **Operational Insights:** Comparing performance across different communication channels.

### 📊 Project Structure
* **Page 1: Overview** - Monitors key KPIs like Total Calls, Escalation Rates, and Agent Performance.
* **Page 2: Channel Overview** - A deep-dive analysis comparing performance metrics (Satisfaction, Resolution, and Escalation rates) across different support channels (Phone, Chat, Email).

### 💡 Key Business Insights
* **Trend Analysis:** Identifies call volume fluctuations to help with shift scheduling.
* **Agent Performance:** Pinpoints outliers in escalation rates to target specific training needs.
* **Channel Efficiency:** Highlights which support channels are the most effective versus those that require process improvements (e.g., analyzing why Resolution Rates vary by channel).

### 📂 Project Contents
* `setup_database.sql`: SQL scripts for database creation and seeding.
* `data_analysis.sql`: Analytical queries for data exploration and validation.
* `Call_Center_Report.pbix`: Power BI file containing the full dashboard and data model.

---
*Created by: Domagoj Maljak*
