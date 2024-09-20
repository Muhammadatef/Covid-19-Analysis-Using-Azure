# Azure Data Factory COVID-19 Analysis

## Overview
This project builds a robust data ingestion pipeline using **Azure Data Factory (ADF)** and various Azure services to analyze COVID-19 hospital admissions across countries. The solution is designed for scalability and production-readiness, incorporating services like **Azure Data Lake Storage Gen2**, **Azure SQL Database**, **Azure Blob Storage**, **HDInsight**, **Databricks**, **Azure Data Studio**, and **Power BI**. We also implemented **CI/CD pipelines** via **Azure DevOps**, automating the release process of ADF pipelines to Dev, Test, and Production environments while integrating **Azure DevOps Repos** with ADF and **Git**.

## Architecture

![System Architecture](system_architecture_image_url)  
![CI/CD Architecture](cicd_architecture_image_url)

- **Data Sources**: 
  - CSV files in **Azure Blob Storage**.
  - HTTP-based data sources for COVID-19 statistics.

- **Data Storage**: 
  - **Azure Data Lake Storage Gen2 (ADLS2)** stores both raw and processed data.

- **Data Processing**: 
  - **Azure Data Factory (ADF)** orchestrates the entire data pipeline using activities such as:
    - Pipelines
    - **Select**, **Join**, and **Pivot** transformations
    - **Data Flows**
    - **Datasets** and **Linked Services**
    - **Triggers** for automated execution
  - Data transformations handled via:
    - **ADF Mapping Data Flows** for ETL processes.
    - **HDInsight** for big data processing.
    - **Azure Databricks** for advanced data transformations and analytics.

- **Data Warehouse**: 
  - Transformed data is loaded into **Azure SQL Database** for long-term storage and reporting.

- **Data Exploration**: 
  - **Azure Data Studio** is used for querying and exploring the data in the data warehouse.
  - **Azure Storage Explorer** to interact with **Azure Blob Storage** and **ADLS Gen2**.

- **Visualization**: 
  - The processed data is visualized using **Power BI**, with interactive dashboards showcasing insights on COVID-19 hospital admissions and trends.

## Features

- **Data Ingestion**: ADF pipelines ingest COVID-19 data from multiple sources (Azure Blob Storage and HTTP-based).
  
- **Data Transformation**: The data is transformed using a range of ADF activities, including **Select**, **Pivot**, and **Join**, combined with **HDInsight** for big data processing and **Databricks** for complex transformations.

- **Data Storage & Archiving**: 
  - Raw and transformed data are stored in **ADLS Gen2**.
  - Processed and structured data is stored in **Azure SQL Database**.

- **Visualization**: 
  - Interactive **Power BI** dashboards visualize trends in hospital admissions, geography, and demographics.

- **CI/CD Pipelines**: 
  - Fully automated pipelines for development, testing, and production are set up using **Azure DevOps**. ADF is integrated with **Git** via **Azure Repos** for version control and seamless deployment across environments.

## Prerequisites

- Active **Azure subscription** with access to the following services:
  - **Azure Data Factory**
  - **Azure Data Lake Storage Gen2**
  - **Azure Blob Storage**
  - **Azure HDInsight**
  - **Azure Databricks**
  - **Azure SQL Database**
  - **Power BI**
  - **Azure Data Studio**
  - **Azure DevOps** for CI/CD pipelines
- Familiarity with ADF components such as pipelines, data flows, and activities.
- COVID-19 datasets or APIs available for ingestion.

## Serving Layer

To view the dashboards, follow this link:  
 ``` https://project.novypro.com/tZnrYJ
 
 
## Getting Started

1. Clone this repository.
2. Set up an **Azure Data Factory** instance in your Azure subscription.
3. Create necessary **Linked Services**, **Datasets**, and **Pipelines** in ADF according to your data sources and transformations.
4. Execute the pipelines to ingest, transform, and load the COVID-19 data.
5. Explore data in **Azure SQL Database** using **Azure Data Studio**.
6. Visualize the processed data with **Power BI**.

## CI/CD Pipelines

- We have implemented automated CI/CD pipelines for **Dev**, **Test**, and **Prod** environments using **Azure DevOps**. This setup includes:
  - Integration of **Azure Data Factory** with **Git** (via **Azure Repos**).
  - Automated deployment of ADF pipelines across environments.
  - **Build** and **Release** pipelines for managing deployments to higher environments.

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or enhancement.
3. Commit your changes with a descriptive message.
4. Submit a pull request for review.

## Acknowledgements

- Special thanks to the contributors of Azure Data Factory, HDInsight, Databricks, and other Azure services used in this project.
- Credits to the providers of COVID-19 datasets for enabling this analysis.

## Contact

For inquiries or feedback, feel free to reach out:

**Mohamed Atef Fahmy**  
Email: [muhamedfahmy7474@gmail.com](mailto:muhamedfahmy7474@gmail.com)

