# 📊 Customer Churn and Retention Analysis in a Multinational Retail Bank

## 💻 Project Overview
This project analyzes customer demographic and account activity data to identify patterns associated with customer churn in a multinational retail banking environment. Using SQL for data preparation and Power BI for visualization, the analysis develops a churn-focused dataset and segmentation framework to support customer retention strategies.

## 💼Business Challenge
The organization is experiencing increased customer churn due to several key factors:
•	Growing competition from fintech and neobanks
•	Declining customer engagement in certain regions
•	Limited behavioral-based customer segmentation
•	Absence of proactive churn monitoring and retention models

## 🧠 Project Objectives
The primary objectives of this analysis are to:
•	Identify common characteristics among churned customers
•	Compare churn behavior across the UK, Germany, and France
•	Segment customers based on churn risk and engagement levels
•	Develop analytical views that support churn monitoring
•	Visualize key churn metrics for executive-level decision making
•	Support targeted retention and customer engagement strategies

## 📁 Dataset Description
The dataset contains customer demographic and account-level attributes used to analyze behavioral patterns and identify churn risk indicators.
Key Dataset Fields
Column	Description
CustomerId	Unique customer identifier
LastName	Customer surname
CreditScore	Creditworthiness indicator
Country	Customer location (UK, Germany, France)
Gender	Customer gender
Age	Customer age
Tenure	Number of years with the bank
Balance	Customer account balance (£)
Products	Number of bank products owned
CreditCard	Credit card ownership indicator
ActiveMember	Customer activity status
Exited	Customer churn indicator
These variables enable demographic analysis, behavioral segmentation, and churn risk identification.

## 🛠️ Technology Stack
Microsoft SQL Server
•	Data storage and querying
•	Data cleaning and validation
•	Feature engineering
•	Creation of analytical views and segmentation tables
Microsoft Power BI
•	Data modeling and DAX calculations
•	Interactive dashboards
•	Visualization of churn metrics and customer segments

## 🔁Analytical Process
The project follows a structured analytical workflow:
1.	Database setup and dataset importation 
2.	Data quality checks and exploratory data analysis
3.	Feature engineering and churn-related variable creation
4.	Creation of analytical views and segmentation logic
5.	Development of Power BI dashboards for churn analysis
6.	Insight generation for stakeholder decision-making

## Dashboard Preview 
![Veritas Bank Dashboard Overview](https://github.com/thecadMunik/customer_churn_and_retention/blob/main/





## 📌Key Metrics
- Total customers analyzed: 10,000
- Overall churn rate across the dataset: 13.85%
- Total balance analyzed: £271.54M
- Balance lost from churned customers: £22.59M
- Active customers: 51.5% 
- Customer distribution by country: UK (50.1%) | Germany (25.1%) | France (24.8%)
- Credit card ownership across the customer base: 71.6%
- All churned customers are non–credit card holders
- Germany and France churn rates: 18.06% and 17.52% vs 9.93% in the UK (of country total)
- Inactive customers account for the majority of churn, with 3,460 inactive churn cases vs 1,390 retained
- Very low balance customers show the highest churn rate at 18.54%
- High Risk and Elevated Risk segments record churn rates of 15.50% and 15.33%
- Young adults show the highest churn among age groups at 14.89%

## 🧾Key Insights
- Churn is structurally higher in Germany and France, driven by higher concentrations of elevated and high-risk customers compared to the UK.
- Churn is primarily driven by customer behavior, particularly inactivity, low engagement, and low balances, rather than demographic factors such as age or gender.
- Credit card ownership strongly correlates with retention, suggesting product depth plays a protective role in customer relationships.
- Younger and middle-aged customers dominate the risk pool, creating long-term revenue exposure if churn is not controlled early.
- The churn risk segmentation framework effectively differentiates customer churn likelihood and provides a foundation for targeted retention strategies.

## 📈Business Recommendations
Based on the findings from the analysis, the following strategies are recommended:
- Study operational and engagement strategies in the UK market and apply similar approaches to improve customer retention in Germany and France.
- Prioritize re-engagement campaigns for inactive customers, as disengagement is one of the strongest predictors of churn.
- Increase product usage among low-balance customers through bundled product offers and incentives that deepen financial relationships.
- Implement early intervention programs targeting high-risk and elevated-risk customer segments before churn occurs.
- Strengthen loyalty and engagement initiatives for younger and middle-aged customers, who represent a large share of the future revenue base.
- Shift from reactive churn management to proactive churn prevention, using regular monitoring of customer engagement and activity levels.

