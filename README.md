# 🍔 FoodApp - Online Food Ordering System

**FoodApp** is a full-stack Java web application designed to streamline the food ordering process. It features role-based access for Customers, Admins, and Drivers, utilizing a persistent MySQL database and a secure MVC architecture.

## 🚀 Features

### 👤 Customer
* **Registration & Login:** Secure account creation with password hashing.
* **Menu Browsing:** View products filtered by category or search by keyword.
* **Shopping Cart:** Add items, update quantities, and manage cart session.
* **Checkout:** Simulated payment flow and address management.
* **Order Tracking:** Real-time status updates (Pending -> Preparing -> Out for Delivery -> Delivered).
* **Profile:** Update delivery address and change password securely.

### 🛠️ Administrator
* **Dashboard:** View all active orders and their status.
* **Product Management:** Add, Edit, and Delete menu items (includes Image Uploads).
* **Order Fulfillment:** Assign specific drivers to "Pending" orders.
* **Maintenance:** Delete old/completed orders.

### 🛵 Delivery Driver
* **Dashboard:** View specific orders assigned by the Admin.
* **Status Update:** Mark assigned orders as "Delivered".

---

## 🛠️ Technology Stack

* **Frontend:** JSP (JavaServer Pages), HTML5, CSS3 (Custom Design System), JavaScript (Validation).
* **Backend:** Java Servlets (MVC Pattern), DAO Pattern (Data Access Objects).
* **Database:** MySQL (Relational Schema with Foreign Keys).
* **Security:** jBCrypt (Password Hashing), Role-Based Access Control (RBAC).
* **Build Tool:** Maven.

---

## ⚙️ Setup Instructions

### 1. Database Setup
1.  Open **MySQL Workbench** (or your preferred SQL client).
2.  Open the file `database.sql` located in the root of this repository.
3.  Run the script to create the `foodapp_db` database and all necessary tables.

### 2. Application Setup
1.  Open the project in **IntelliJ IDEA** (or Eclipse).
2.  Navigate to `src/main/java/org/foodapp/foodapp/util/DBUtil.java`.
3.  Update the `USER` and `PASSWORD` variables with your local MySQL credentials.
4.  Run the application on **Apache Tomcat 10.1**.

### 3. User Accounts (Admin & Driver)
**Security Note:** Passwords are hashed using BCrypt. You must register users via the app first, then promote them via SQL.

**To create the Admin:**
1.  Register a new user named `admin` (password: `admin123`) via the Register page.
2.  Run this SQL: `UPDATE users SET role = 'ADMIN' WHERE username = 'admin';`

**To create a Driver:**
1.  Register a new user named `driver1` (password: `driver123`).
2.  Run this SQL: `UPDATE users SET role = 'DRIVER' WHERE username = 'driver1';`

---

## 🤖 AI Attribution

Artificial Intelligence tools were utilized to accelerate development, specifically focusing on the **Frontend (UI/UX)**.

* **UI/UX:** AI generated the CSS design system (variables, responsive layouts) and semantic HTML structure.
* **Refactoring:** AI assisted in refactoring legacy JSP logic into the MVC pattern and debugging SQL syntax.
* **Logic:** Core business logic, database architecture, and security implementations were verified and implemented manually.

---

## 📊 Diagrams

### Class Diagram

<img width="1508" height="788" alt="class_diagram" src="https://github.com/user-attachments/assets/cf7d4b77-8459-4fc1-9e08-50d5df4ebdd6" />

### ER Diagram
<img width="1496" height="885" alt="er_diagram" src="https://github.com/user-attachments/assets/2041084c-a0a6-436a-be01-9f639ce0a2cc" />
