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

## 💪 Problem Statement

Healthcare facilities often struggle with:
- 🚨 Delayed detection of abnormal or critical results
- 📝 Manual test evaluation prone to human error
- 👁️ Limited visibility for physicians
- 📊 Lack of centralized auditing or traceability
- 🔔 No automated mechanisms for alerting or follow-up

This system solves the above challenges by providing automated, rule-based result analysis and alerting.

---

## 🛍️ Target Users

- 🥼 Laboratory Technicians
- 👨‍⚕️ Physicians
- 👔 Hospital Administrators
- 🔧 System Administrators

---

## 🚀 Project Goals

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

> 📁 *ERD included in `/design/ER_diagram.png`*

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

### 🔹 Procedures

```sql
PROCEDURE generate_alerts 
-- Auto-generate alerts when critical thresholds are reached

PROCEDURE register_test_order 
-- Register test orders and lab results
