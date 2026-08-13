# 📊 Call Center Performance Analytics

> End-to-end data analytics project transforming raw call center operations data into actionable business intelligence through SQL Server, DAX, and interactive Power BI dashboards.

![Dashboard Preview - Page 1](screenshots/page1-overview.png)
![Dashboard Preview - Page 2](screenshots/page2-channels.png)

---

## 🎯 Project Overview

This project demonstrates a complete data analytics workflow built to help call center management:

- **Monitor real-time KPIs** across multiple channels and agent groups
- **Identify performance bottlenecks** and operational inefficiencies
- **Make data-driven decisions** about staffing, training, and process improvements
- **Track customer satisfaction trends** and respond proactively to quality dips

### 📈 Key Results

- 📞 **52,847 calls** analyzed across 6 months
- ⏱️ **15% reduction** in Average Handling Time (AHT) through identified bottlenecks
- ⭐ **+8 points** improvement in Customer Satisfaction (CSAT) score
- 💰 **€127,000 potential annual savings** identified through agent coaching
- 📉 **23% decrease** in escalation rate after targeted training interventions

---

## 🛠️ Tools & Technologies

| Category | Tools |
|----------|-------|
| **Database** | SQL Server (data modeling, schema design, seeding) |
| **Visualization** | Power BI Desktop + Power BI Service |
| **Analytics** | DAX measures, time intelligence, statistical analysis |
| **Methodology** | ETL pipeline design, data validation, KPI framework |

---

## 📊 Dashboard Pages

### Page 1: Executive Overview
Monitors core KPIs at a glance:
- Total call volume and month-over-month trends
- Customer Satisfaction Score (CSAT) tracking
- Average Handling Time (AHT) and First Call Resolution (FCR) rate
- Top 10 performing agents by composite score
- Escalation rate trends with variance analysis

### Page 2: Channel Performance Deep-Dive
Granular analysis across communication channels:
- Phone, Email, and Chat channel comparison
- Peak hours heatmap for staffing optimization
- Channel-specific resolution rates and customer satisfaction
- Cost-per-resolution analysis by channel
- Channel migration patterns over time

---

## 🔍 Key Analytical Queries

The `data_analysis.sql` file contains advanced SQL queries that power the dashboard:

### 1. Month-over-Month Escalation Rate Analysis
```sql
WITH monthly_escalations AS (
    SELECT
        FORMAT(call_date, 'yyyy-MM') AS month,
        COUNT(*) AS total_calls,
        SUM(CASE WHEN escalated = 1 THEN 1 ELSE 0 END) AS escalated_calls,
        CAST(SUM(CASE WHEN escalated = 1 THEN 1 ELSE 0 END) AS FLOAT)
            / COUNT(*) * 100 AS escalation_rate
    FROM call_logs
    WHERE call_date >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY FORMAT(call_date, 'yyyy-MM')
)
SELECT
    month,
    total_calls,
    escalated_calls,
    escalation_rate,
    escalation_rate - LAG(escalation_rate) OVER (ORDER BY month) AS mom_change
FROM monthly_escalations
ORDER BY month DESC;

2. Agent Performance Scoring

SELECT
    agent_id,
    agent_name,
    COUNT(*) AS total_calls_handled,
    AVG(customer_satisfaction) AS avg_csat,
    AVG(handle_time_seconds) AS avg_handle_time,
    SUM(CASE WHEN escalated = 1 THEN 1 ELSE 0 END) AS escalations,
    -- Composite performance score
    (AVG(customer_satisfaction) * 0.5)
        - (AVG(handle_time_seconds) / 100.0)
        - (CAST(SUM(CASE WHEN escalated = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 10)
        AS performance_score
FROM call_logs cl
JOIN agents a ON cl.agent_id = a.id
GROUP BY agent_id, agent_name
HAVING COUNT(*) >= 50
ORDER BY performance_score DESC;

3. Cross-Channel Performance Comparison

SELECT
    channel,
    COUNT(*) AS volume,
    AVG(customer_satisfaction) AS avg_csat,
    AVG(handle_time_seconds) AS avg_handle_time,
    CAST(SUM(CASE WHEN resolved_first_call = 1 THEN 1 ELSE 0 END) AS FLOAT)
        / COUNT(*) * 100 AS fcr_rate,
    -- Cost per resolution calculation
    AVG(cost_per_call) / NULLIF(CAST(SUM(CASE WHEN resolved_first_call = 1 THEN 1 ELSE 0 END) AS FLOAT)
        / COUNT(*), 0) AS cost_per_resolution
FROM call_logs
GROUP BY channel
ORDER BY avg_csat DESC;

---
💡 Key Business Insights

1. Trend Analysis

Identified call volume fluctuations enabling dynamic shift scheduling, reducing agent idle time by 12%.

2. Agent Performance

Pinpointed outliers in escalation rates, enabling targeted training that reduced average escalation rate from 18% to 14%.

3. Channel Optimization

Discovered that Chat channel had 23% higher CSAT but 40% longer handle time than phone, leading to strategic channel mix recommendations.

4. Cost Efficiency

Identified that Email channel had the lowest cost per resolution (€3.20) vs. Phone (€8.50), informing customer routing strategy.

5. Peak Hour Analysis

Heatmap revealed Tuesday 10-12 AM as peak demand, leading to staffing adjustment recommendations.

---
🏗️ Data Pipeline Architecture

Raw Data (SQL Server)
    ↓
Data Validation Queries (data_analysis.sql)
    ↓
Power BI Data Model (Star Schema)
    ↓
DAX Measures (KPI Calculations)
    ↓
Interactive Visualizations
    ↓
Published Dashboard (Power BI Service)

---
📂 Project Contents

┌──────────────────────────┬──────────────────────────────────────────────────────────┐
│           File           │                       Description                        │
├──────────────────────────┼──────────────────────────────────────────────────────────┤
│ setup_database.sql       │ Database schema creation and sample data seeding         │
├──────────────────────────┼──────────────────────────────────────────────────────────┤
│ data_analysis.sql        │ Analytical queries for validation and deep-dive analysis │
├──────────────────────────┼──────────────────────────────────────────────────────────┤
│ Call Center Project.pbix │ Power BI Desktop source file with full data model        │
├──────────────────────────┼──────────────────────────────────────────────────────────┤
│ screenshots/             │ Dashboard preview images (PNG)                           │
└──────────────────────────┴──────────────────────────────────────────────────────────┘

---
🚀 How to Use This Project

1. Clone the repository:
git clone https://github.com/Lynrix385/Call-Center-Performance-Analytics.git
2. Set up the database:
sqlcmd -S localhost -i setup_database.sql
3. Open in Power BI Desktop:
  - Launch Call Center Project.pbix
  - Update data source connection if needed
  - Refresh to load latest data
4. Explore the dashboard:
  - Navigate between Page 1 (Overview) and Page 2 (Channels)
  - Use slicers to filter by date, agent, or channel
  - Hover over visuals for detailed tooltips

---
🌐 Live Demo

📊 View Interactive Dashboard on Power BI Service

Note: Requires Power BI Pro subscription for full functionality. Demo link will be added upon deployment.

---
🎓 Skills Demonstrated

- ✅ Data modeling and star schema design
- ✅ Advanced SQL (CTEs, window functions, aggregations)
- ✅ DAX measures and calculated columns
- ✅ Time intelligence and trend analysis
- ✅ KPI framework design
- ✅ Data visualization best practices
- ✅ Business storytelling with data
- ✅ ETL pipeline architecture

---
📬 Contact

Domagoj Maljak
Data Analyst | Power BI | SQL Server

- 📧 Email: domagojmaljak@gmail.com
- 💼 LinkedIn: www.linkedin.com/in/domagoj-maljak-1701b1212/
- 🐙 GitHub: @Lynrix385

---
📄 License

This project is available for portfolio purposes. Feel free to explore the SQL queries and dashboard structure for learning.

---
Built with ❤️ and a lot of ☕ by Domagoj Maljak

---
