🧪 Intelligent Medical Test Result Analyzer with Alerting System
📅 Project Details

Student Name: Miguel

Project Title: Intelligent Medical Test Result Analyzer with Alerting System

Lecturer: Eric Maniraguha

Course Code & Name: INSY 8311 – Database Development with PL/SQL

Academic Year: 2024–2025

🌐 Introduction

Modern healthcare relies heavily on accuracy, speed, and reliability in laboratory operations. Delayed or overlooked critical results can compromise patient safety. Manual processes are prone to errors, inefficiency, and lack of traceability.

This project presents a comprehensive, automated, and intelligent database system that analyzes medical test results, detects abnormalities, generates alerts, and maintains full auditability. Using PL/SQL triggers, procedures, packages, and business rules, the system ensures clinical data integrity and timely notifications for healthcare professionals.

💪 Problem Statement

Healthcare facilities often struggle with:

Delayed detection of abnormal or critical results

Manual test evaluation prone to human error

Limited visibility for physicians

Lack of centralized auditing or traceability

No automated mechanisms for alerting or follow-up

This system solves the above challenges by providing automated, rule-based result analysis and alerting.

🛍️ Target Users

Laboratory Technicians

Physicians

Hospital Administrators

System Administrators

🚀 Project Goals

Automate detection of abnormal and critical test results

Notify physicians promptly when patient safety is at risk

Maintain secure and complete audit trails

Enforce rule-based workflows (e.g., holiday/weekend restrictions)

Provide clean, reliable data for BI dashboards

📊 Entity Relationship Diagram (ERD)

Core Entities

Patients

Physicians

Users

Orders

Test_Types

Lab_Results

Alerts

Alert_Notifications

Holidays

Audit_Log

System_Settings

Key Relationships

Physicians place Orders for Patients

Orders produce Lab_Results

Lab_Results generate Alerts based on thresholds

Alerts generate Notifications

All transactions are logged in Audit_Log

(ERD included in /design/ER_diagram.png)

🔧 Database Structure
🔢 Tables

PATIENTS

PHYSICIANS

USERS

TEST_TYPES

ORDERS

LAB_RESULTS

ALERTS

ALERT_NOTIFICATIONS

HOLIDAYS

AUDIT_LOG

SYSTEM_SETTINGS

💡 Constraints

Primary Keys / Foreign Keys

NOT NULL, UNIQUE, CHECK

Cascading relationships

Timestamp auditing columns

🛠️ SQL Components
🔹 Procedures

Auto-generate alerts when critical thresholds are reached

Register test orders and lab results

🔹 Functions

Interpret test results (Normal / High / Critical)

Fetch patient alert history

🔹 Cursors

Retrieve results for a given patient or order

Loop through notifications for dispatch

🔹 Packages

SYSTEM_ALERT_PKG

Encapsulates analysis logic

Manages alert creation, notifications, rule checks

🔹 Triggers

Auto-insert alerts after new lab results

Prevent DML operations on weekends or public holidays

Insert audit records on sensitive actions

📊 Sample Data

Some examples of included data:

Patients: Uwase Carine, Mugabo Henry

Physicians: Dr. Mugenzi David, Dr. Uwamahoro Sarah

Lab Tests: Glucose, Creatinine, Hemoglobin, WBC Count

Holidays: Christmas, Genocide Memorial Day

💼 Tools Used

Oracle Database 21c

PL/SQL (Triggers, Procedures, Packages)

SQL Developer

BPMN Modeling Tools (draw.io)

GitHub for version control

📅 Timeline
✔️ Phase I: Problem Definition

The project identifies major challenges in hospital laboratory result management and proposes an automated system to ensure real-time detection of critical values.

✔️ Phase II: Business Process Modeling

A BPMN diagram was created to illustrate the workflow:

Physician orders tests

Lab processes samples

System analyzes values

Alerts generated when necessary

Physicians receive notifications

(BPMN diagram included in /business_process)

✔️ Phase III: Logical Design

The ERD defines all system entities and their relationships.
Normalization ensures reliability and reduces redundancy.
Data dictionary provided in design/data_dictionary.md.

✔️ Phase IV: Database Creation

Database objects created using:

Tablespaces

Users

Roles and privileges

Physical table structures

Scripts located in database/scripts/.

✔️ Phase V: Data Insertion and Validation

Realistic sample data was inserted to simulate:

Test orders

Abnormal results

Critical cases triggering alerts

Validation verified foreign keys, thresholds, and rule accuracy.

✔️ Phase VI: Procedures, Functions, Triggers, Packages

Developed PL/SQL components include:

Alert creation logic

Interpretation function for results

Cursors for batch processing

Package for modularity

Triggers for restrictions and auditing

✔️ Phase VII: Programming & Auditing

A robust auditing mechanism ensures:

All sensitive DML actions are logged

DML is restricted during weekends or holidays

Compliance with data governance standards

✔️ Phase VIII: Final Documentation & Presentation

A comprehensive PowerPoint summarizing:

Objectives

ERD / BPMN

SQL structures

Screenshots

Final system design

Delivered in /docs/.

📄 License

This project is submitted as part of the Capstone Project for
Database Development with PL/SQL – Academic Year 2024-2025,
Adventist University of Central Africa (AUCA).

“Excellence is not an act but a habit — repeated through integrity, discipline, and innovation.”
