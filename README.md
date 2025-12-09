# 🧪 Intelligent Medical Test Result Analyzer with Alerting System

## 📅 Project Details

| Field | Details |
|-------|---------|
| **Student Name** | GISA Miguel |
| **Student ID** | 27332 |
| **Project Title** | Intelligent Medical Test Result Analyzer with Alerting System |
| **Lecturer** | Eric Maniraguha |
| **Course Code & Name** | INSY 8311 – Database Development with PL/SQL |


---

## 🌐 Introduction

Modern healthcare relies heavily on accuracy, speed, and reliability in laboratory operations. Delayed or overlooked critical results can compromise patient safety. Manual processes are prone to errors, inefficiency, and lack of traceability.

This project presents a comprehensive, automated, and intelligent database system that analyzes medical test results, detects abnormalities, generates alerts, and maintains full auditability. Using PL/SQL triggers, procedures, packages, and business rules, the system ensures clinical data integrity and timely notifications for healthcare professionals.

---

## Problem Statement

Healthcare facilities often struggle with:
- Delayed detection of abnormal or critical results
- Manual test evaluation prone to human error
- Limited visibility for physicians
- Lack of centralized auditing or traceability
- No automated mechanisms for alerting or follow-up

This system solves the above challenges by providing automated, rule-based result analysis and alerting.

---

## Target Users

- Laboratory Technicians
- Physicians
- Hospital Administrators
- System Administrators

---

## Project Goals

✅ Automate detection of abnormal and critical test results  
✅ Notify physicians promptly when patient safety is at risk  
✅ Maintain secure and complete audit trails  
✅ Enforce rule-based workflows (e.g., holiday/weekend restrictions)  
✅ Provide clean, reliable data for BI dashboards

---

## 📊 Entity Relationship Diagram (ERD)

### Core Entities
1. **Patients**
2. **Physicians**
3. **Users**
4. **Orders**
5. **Test_Types**
6. **Lab_Results**
7. **Alerts**
8. **Alert_Notifications**
9. **Holidays**
10. **Audit_Log**
11. **System_Settings**

### Key Relationships
- Physicians place Orders for Patients
- Orders produce Lab_Results
- Lab_Results generate Alerts based on thresholds
- Alerts generate Notifications
- All transactions are logged in Audit_Log

<img width="1366" height="768" alt="ERD 2" src="https://github.com/user-attachments/assets/7e85b6e4-9d21-4d53-b6b6-dc7d145d76ce" />


---

## 🔧 Database Structure

### 🔢 Tables

| Table Name | Description | Primary Key |
|------------|-------------|-------------|
| `PATIENTS` | Patient demographic information | `patient_id` |
| `PHYSICIANS` | Physician details and contact info | `physician_id` |
| `USERS` | System users and credentials | `user_id` |
| `TEST_TYPES` | Laboratory test definitions and thresholds | `test_type_id` |
| `ORDERS` | Test orders placed by physicians | `order_id` |
| `LAB_RESULTS` | Actual test result values | `result_id` |
| `ALERTS` | Generated alert records | `alert_id` |
| `ALERT_NOTIFICATIONS` | Notification dispatch records | `notification_id` |
| `HOLIDAYS` | Public holiday calendar | `holiday_id` |
| `AUDIT_LOG` | System audit trail | `log_id` |
| `SYSTEM_SETTINGS` | Configuration parameters | `setting_id` |

### 💡 Constraints
- **Primary Keys** / **Foreign Keys**
- **NOT NULL**, **UNIQUE**, **CHECK** constraints
- Cascading relationships (ON DELETE CASCADE)
- Timestamp auditing columns (`created_at`, `updated_at`)

---

## 🛠️ SQL Components

## 📅 Timeline

### ✔️ Phase I: Problem Definition
The project identifies major challenges in hospital laboratory result management and proposes an automated system to ensure real-time detection of critical values.

---

### ✔️ Phase II: Business Process Modeling
A BPMN diagram was created to illustrate the workflow:

- Physician orders tests  
- Lab processes samples  
- System analyzes values  
- Alerts generated when necessary  
- Physicians receive notifications  

<img width="1536" height="1024" alt="BPMN" src="https://github.com/user-attachments/assets/0e91987b-9d10-4f01-9e00-083c819fcca7" />


---

### ✔️ Phase III: Logical Design
- ERD defines all system entities and their relationships  
- Normalization ensures reliability and reduces redundancy    

---

### ✔️ Phase IV: Database Creation
Database objects created using:

- Tablespaces  
- Users  
- Roles and privileges  
- Physical table structures  
<img width="1366" height="768" alt="CREATING PDB, CREATING USER  AND GRANTING USER ALL PRIVILEGES" src="https://github.com/user-attachments/assets/77f0339c-02d8-497f-b090-aa567d4f5cd6" />


---

### ✔️ Phase V: Data Insertion and Validation
Realistic sample data inserted to simulate:

- Test orders  
- Abnormal results  
- Critical cases triggering alerts  

Validation ensured correct:

- Foreign keys  
- Threshold logic  
- Business rules  
<img width="1366" height="768" alt="INSERT INTO ORDERS" src="https://github.com/user-attachments/assets/3609ef1b-3790-44e5-8c4c-f9d6796367ab" />

---

### ✔️ Phase VI: Procedures, Functions, Triggers, Packages
Developed PL/SQL components include:

- Alert creation logic  
- Interpretation function for results  
- Cursors for batch processing  
- Package for modularity 
- Triggers for restrictions and auditing  

---

### ✔️ Phase VII: Programming & Auditing
A robust auditing mechanism ensures:

- All sensitive DML actions are logged  
- DML is restricted during weekends or public holidays  
- Compliance with data governance standards  

---

### ✔️ Phase VIII: Final Documentation & Presentation
A comprehensive documentation & PPT was produced, containing:

- Objectives  
- ERD & BPMN diagrams  
- SQL structures  
- Screenshots  
- Final system design  

Delivered in:  
`/docs/`

---

## 📄 License
This project is submitted as part of the **Capstone Project** for:

**Database Development with PL/SQL – Academic Year 2025–2026**  
**Adventist University of Central Africa (AUCA)**  

> *"Excellence is not an act but a habit — repeated through integrity, discipline, and innovation."*
