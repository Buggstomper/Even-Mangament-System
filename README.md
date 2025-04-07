
# 🎉 Event Management System


A comprehensive![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?style=for-the-badge&logo=mysql&logoColor=white) database implementation for planning and managing events. This system provides a full-fledged backend solution for organizations handling everything from event logistics to financials.

---

## 📋 Overview

This database system supports all core operations involved in event planning and execution. From user and venue management to catering, staff coordination, and financial tracking, it offers a normalized relational schema designed for reliability and scalability.

---

## ✨ Key Features

- 👥 **Multi-role User Management**  
  Seamless role-based access for **Admins**, **Organizers**, and **Customers**, ensuring secure operations and efficient task delegation.

- 📆 **Complete Event Lifecycle Management**  
  End-to-end event handling — plan, schedule, manage, and review events with ease.

- 🏛️ **Venue Management**  
  Keep detailed records of **venue capacity**, **location**, and **availability**, plus manager assignments.

- 🍽️ **Catering & Food Preferences**  
  Manage diverse menus, dietary options (e.g., **Vegan**, **Gluten-Free**), suppliers, and cost structures.

- 🎀 **Decoration & Inventory Tracking**  
  Track decoration items, quantities, suppliers, and related costs for stunning event setups.

- 🎟️ **Ticketing System**  
  Support for **VIP** and **General Admission** tickets with pricing, seat allocation, and event-specific ticketing.

- 💼 **Sponsorship Management**  
  Record and monitor sponsor contributions, agreements, and evaluate **return on investment (ROI)**.

- 👨‍💼 **Staff Coordination**  
  Assign staff with defined **roles**, **departments**, and **work hours** for effective resource utilization.

- 💰 **Financial Tracking**  
  Monitor **payments**, **revenues**, and **bookings** — empowering event-level financial reporting and transparency.

- 🧩 **Robust Database Design**  
  Built on **3rd Normal Form (3NF)** principles for consistency, minimal redundancy, and optimal performance.

---

## 🗄️ Database Schema

The schema consists of 15+ well-structured tables representing all key entities and relationships:

### Core Entities
- `Users`: User credentials, roles, and permissions  
- `Events`: Event information including schedule and organizer  
- `Venues`: Venue details, capacity, and location  
- `Customers`: Customer profiles and special accommodations  

### Resource Management
- `FoodItems`: Food options with dietary tags  
- `Decorations`: Inventory of decoration items and suppliers  
- `Staff`: Personnel with departmental roles  
- `Sponsors`: Sponsor profiles and contributions  

### Relationship Tables
- `Bookings`: Customer bookings with payment information  
- `Tickets`: Ticket types, prices, and seating  
- `Event_Food`: Food assigned per event  
- `Event_Decorations`: Decorations used per event  
- `Event_Sponsors`: Sponsor-event relationships  
- `Event_Staff`: Staff assignment records  

### Supporting Tables
- `AddressDetails`: Centralized address storage  
- `VenueManagers`: Contacts responsible for venues  
- `EventTypes`: Categorization of events  
- `Departments`: Staff departmental mapping  
- `FoodCategories`: Dietary classifications  
- `CustomerPreferences`: Preferences linked to customers  

---

## 🛠️ Installation

```bash
# Clone the repository
git clone https://github.com/DishankVyas/event-management-system.git

# Navigate to the directory
cd event-management-system

# Import the database using MySQL
mysql -u root -p < EventManagementSystem.sql
```

---

## 🔍 Usage Examples

A few helpful queries for business and event insights:

```sql
-- List events with venue and organizer details
SELECT e.EventID, e.EventName, v.VenueTitle, v.Capacity,
       ad.Address, ad.City, ad.State,
       u.FirstName AS OrganizerFirstName, u.LastName AS OrganizerLastName
FROM Events e
JOIN Venues v ON e.VenueID = v.VenueID
JOIN AddressDetails ad ON v.AddressID = ad.AddressID
JOIN Users u ON e.OrganizerID = u.UserID
ORDER BY e.StartDateTime;

-- Find events offering vegan food options
SELECT DISTINCT e.EventID, e.EventName, e.StartDateTime
FROM Events e
JOIN Event_Food ef ON e.EventID = ef.EventID
JOIN FoodItems f ON ef.FoodID = f.FoodID
JOIN FoodCategories fc ON f.CategoryID = fc.CategoryID
WHERE fc.Type = 'Vegan'
ORDER BY e.StartDateTime;
```

---

## 📊 Business Intelligence

Leverage insightful reports and analytics:

- 📈 **Revenue Analysis**: Evaluate event profitability and ticket sales  
- 👥 **Customer Insights**: Track customer preferences and needs  
- 🏢 **Supplier Management**: Monitor supplier relationships and delivery records  
- 🧑‍💼 **Staff Productivity**: Analyze resource allocation across events  
- 🤝 **Sponsorship ROI**: Quantify sponsor impact and value

---

## ⚙️ Database Optimization

Best practices applied for performance and consistency:

- ✅ **3NF Normalization** for integrity and efficiency  
- 🧮 **Indexing** on key columns for faster query execution  
- 🔗 **Foreign Key Constraints** to maintain referential integrity  
- 📏 **Efficient Data Types** chosen for space and speed  
- ⚠️ **CHECK Constraints** to validate business rules

---

## 🧪 Testing

After setup, run the following to verify functionality:

```sql
USE project2;
SHOW TABLES;
SELECT COUNT(*) FROM Events;
SELECT COUNT(*) FROM Venues;
```

Sample data should be available, and all schema objects should be created successfully.

---

## 🔮 Future Enhancements

Planned features to enrich the system:

- 📣 Event promotion & marketing modules  
- 📱 Mobile app integration and API endpoints  
- 🌟 Customer ratings and post-event feedback  
- 📊 Interactive analytics dashboards  
- 📦 Consumable inventory management  

---

## 👥 Team Members

Developed by a passionate team:

- **Krishna Shetty**  
- **Shaman Shetty**  
- **Dishank Vyas**

Together, we’ve laid a powerful foundation for scalable and intelligent event management systems.

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository  
2. Create a feature branch  
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes  
   ```bash
   git commit -m 'Add your feature'
   ```
4. Push to GitHub  
   ```bash
   git push origin feature/your-feature-name
   ```
5. Open a Pull Request 🙌

