/* ======================================================================
   EVENT MANAGEMENT SYSTEM DATABASE
   
   This SQL script creates and populates a complete database for an
   event management system, including users, venues, events, bookings,
   and all related entities.
====================================================================== */

-- Create and use the database
create DATABASE project2;

use project2;

/* ======================================================================
   TABLE CREATION SECTION
   Creating all the base tables for the system
====================================================================== */

-- 1. Users (Strong Entity)
CREATE TABLE Users (
  UserID INT PRIMARY KEY ,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) UNIQUE NOT NULL,
  Password VARCHAR(100) NOT NULL,
  Role VARCHAR(20) NOT NULL CHECK (Role IN ('Admin', 'Organizer', 'Customer')),
  Phone VARCHAR(15),
  Image VARCHAR(255)
);

-- 2. Customers (Weak Entity, linked to Users)
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY ,
  UserID INT UNIQUE NOT NULL,
  RegistrationDate DATE NOT NULL,
  DietaryPreference VARCHAR(100),
  SpecialNeeds VARCHAR(255),
  Address VARCHAR(255),
  FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 3. Venues (Composite Attribute: Address)
CREATE TABLE Venues (
  VenueID INT PRIMARY KEY ,
  VenueName VARCHAR(100) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  City VARCHAR(50) NOT NULL,
  State VARCHAR(50) NOT NULL,
  ContactPhone VARCHAR(15) NOT NULL,
  Capacity INT NOT NULL,
  ManagerName VARCHAR(100),
  Gender VARCHAR(20) CHECK (Gender IN ('Male', 'Female', 'Other'))
);

-- 4. Events (Strong Entity, linked to Users and Venues)
CREATE TABLE Events (
  EventID INT PRIMARY KEY ,
  EventName VARCHAR(100) NOT NULL,
  Description TEXT,
  StartDateTime DATETIME NOT NULL,
  EndDateTime DATETIME NOT NULL,
  VenueID INT NOT NULL,
  OrganizerID INT NOT NULL,
  Status VARCHAR(20) CHECK (Status IN ('Planned', 'Confirmed', 'Cancelled')) DEFAULT 'Planned',
  FOREIGN KEY (VenueID) REFERENCES Venues(VenueID),
  FOREIGN KEY (OrganizerID) REFERENCES Users(UserID)
);

-- 5. Bookings (Weak Entity, linked to Users, Events, and PaymentModes)
CREATE TABLE Bookings (
  BookingID INT PRIMARY KEY ,
  EventID INT NOT NULL,
  UserID INT NOT NULL,
  BookingDate DATE NOT NULL,
  Status VARCHAR(20) CHECK (Status IN ('Pending', 'Confirmed')) DEFAULT 'Pending',
  ConfirmationCode VARCHAR(50) UNIQUE,
  ModeID INT NOT NULL,
  TotalAmount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (EventID) REFERENCES Events(EventID),
  FOREIGN KEY (UserID) REFERENCES Users(UserID),
  FOREIGN KEY (ModeID) REFERENCES PaymentModes(ModeID)
);

-- 6. FoodItems (Strong Entity)
CREATE TABLE FoodItems (
  FoodID INT PRIMARY KEY ,
  FoodName VARCHAR(100) NOT NULL,
  Type VARCHAR(20) CHECK (Type IN ('Vegetarian', 'Non-Vegetarian', 'Vegan')),
  DietaryInfo VARCHAR(255),
  CostPerPerson DECIMAL(10,2) NOT NULL,
  CuisineType VARCHAR(50)
);

-- 7. Event_Food (Many-to-Many Relation between Events and FoodItems)
CREATE TABLE Event_Food (
  EventID INT,
  FoodID INT,
  Quantity INT NOT NULL CHECK (Quantity > 0),
  PRIMARY KEY (EventID, FoodID),
  FOREIGN KEY (EventID) REFERENCES Events(EventID),
  FOREIGN KEY (FoodID) REFERENCES FoodItems(FoodID)
);

-- 8. Decorations (Strong Entity)
CREATE TABLE Decorations (
  DecorationID INT PRIMARY KEY ,
  DecorationName VARCHAR(100) NOT NULL,
  Type VARCHAR(50) NOT NULL,
  Cost DECIMAL(10,2) NOT NULL,
  Supplier VARCHAR(100),
  QuantityAvailable INT CHECK (QuantityAvailable >= 0)
);

-- 9. Event_Decorations (Many-to-Many Relation between Events and Decorations)
CREATE TABLE Event_Decorations (
  EventID INT,
  DecorationID INT,
  QuantityUsed INT CHECK (QuantityUsed > 0),
  PRIMARY KEY (EventID, DecorationID),
  FOREIGN KEY (EventID) REFERENCES Events(EventID),
  FOREIGN KEY (DecorationID) REFERENCES Decorations(DecorationID)
);

-- 10. Tickets (Weak Entity, linked to Customers and Events)
CREATE TABLE Tickets (
  TicketID INT PRIMARY KEY ,
  EventID INT NOT NULL,
  CustomerID INT NOT NULL,
  TicketType VARCHAR(20) CHECK (TicketType IN ('VIP', 'General')),
  Price DECIMAL(10,2) CHECK (Price > 0),
  PurchaseDate DATE NOT NULL,
  SeatNumber VARCHAR(10),
  FOREIGN KEY (EventID) REFERENCES Events(EventID),
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 11. Sponsors (Strong Entity)
CREATE TABLE Sponsors (
  SponsorID INT PRIMARY KEY,
  SponsorName VARCHAR(100) NOT NULL,
  Industry VARCHAR(50) NOT NULL,
  ContactEmail VARCHAR(100) NOT NULL,
  ContactPhone VARCHAR(15) NOT NULL,
  ContributionRange VARCHAR(50),
  Website VARCHAR(255)
);

-- 12. Event_Sponsors (Many-to-Many Relation between Events and Sponsors)
CREATE TABLE Event_Sponsors (
  EventID INT,
  SponsorID INT,
  ContributionAmount DECIMAL(10,2) NOT NULL,
  AgreementDate DATE NOT NULL,
  PRIMARY KEY (EventID, SponsorID),
  FOREIGN KEY (EventID) REFERENCES Events(EventID),
  FOREIGN KEY (SponsorID) REFERENCES Sponsors(SponsorID)
);

-- 13. PaymentModes (Strong Entity)
CREATE TABLE PaymentModes (
  ModeID INT PRIMARY KEY ,
  ModeType VARCHAR(20) CHECK (ModeType IN ('Credit Card', 'Cash', 'Online')) NOT NULL,
  Description VARCHAR(255),
  ModeCode VARCHAR(10) UNIQUE NOT NULL,
  IsActive BOOLEAN DEFAULT TRUE
);

-- 14. Staff (Weak Entity, linked to Users)
CREATE TABLE Staff (
  StaffID INT PRIMARY KEY ,
  UserID INT UNIQUE NOT NULL,
  Position VARCHAR(50) NOT NULL,
  HireDate DATE NOT NULL,
  Salary DECIMAL(10,2) CHECK (Salary > 0),
  PhoneNumber VARCHAR(15),
  Department VARCHAR(50),
  FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 15. Event_Staff (Many-to-Many Relation between Events and Staff)
CREATE TABLE Event_Staff (
  EventID INT,
  StaffID INT,
  Role VARCHAR(50) NOT NULL,
  HoursAssigned INT CHECK (HoursAssigned > 0),
  PRIMARY KEY (EventID, StaffID),
  FOREIGN KEY (EventID) REFERENCES Events(EventID),
  FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

/* ======================================================================
   ALTER TABLE OPERATIONS
   Modifying existing tables to add or change columns
====================================================================== */

-- 1. Add a new column "DateOfBirth" to the "Users" table
ALTER TABLE Users ADD DateOfBirth DATE;

-- 2. Modify the "Phone" column in the "Users" table to increase the length to 20 characters
ALTER TABLE Users MODIFY COLUMN Phone VARCHAR(20);

-- 3. Rename the "Phone" column to "PhoneNumber" in the "Users" table
ALTER TABLE Users CHANGE COLUMN Phone PhoneNumber VARCHAR(20);

-- 4. Drop the "Image" column from the "Users" table
ALTER TABLE Users DROP COLUMN Image;

-- 5. Update the "PhoneNumber" value for a specific user in the "Users" table
UPDATE Users SET PhoneNumber = '123-456-7890' WHERE UserID = 1;

-- 6. Update the "Status" field in the "Events" table to 'Confirmed' for an event with ID 5
UPDATE Events SET Status = 'Confirmed' WHERE EventID = 5;

-- 7. Rename the "VenueName" column in the "Venues" table to "VenueTitle"
ALTER TABLE Venues CHANGE COLUMN VenueName VenueTitle VARCHAR(100);

/* ======================================================================
   DATA INSERTION SECTION
   Populating tables with sample data
====================================================================== */

-- Users data insertion
INSERT INTO Users (UserID, FirstName, LastName, Email, Password, Role, PhoneNumber, DateOfBirth)
VALUES
(1, 'Rahul', 'Sharma', 'rahul.sharma@example.com', 'password123', 'Admin', '9876543210', '1990-05-21'),
(2, 'Priya', 'Patel', 'priya.patel@example.com', 'password123', 'Organizer', '9123456789', '1985-08-15'),
(3, 'Amit', 'Kumar', 'amit.kumar@example.com', 'password123', 'Customer', '9812345678', '1992-03-10'),
(4, 'Neha', 'Verma', 'neha.verma@example.com', 'password123', 'Customer', '9345678910', '1993-07-22'),
(5, 'Vikram', 'Singh', 'vikram.singh@example.com', 'password123', 'Admin', '9101234567', '1987-11-02'),
(6, 'Rina', 'Gupta', 'rina.gupta@example.com', 'password123', 'Organizer', '9387123456', '1990-01-18'),
(7, 'Arun', 'Nair', 'arun.nair@example.com', 'password123', 'Customer', '9602345678', '1994-12-11'),
(8, 'Sneha', 'Desai', 'sneha.desai@example.com', 'password123', 'Organizer', '9753124567', '1988-09-25'),
(9, 'Ravi', 'Reddy', 'ravi.reddy@example.com', 'password123', 'Customer', '9156789012', '1991-10-17'),
(10, 'Simran', 'Kaur', 'simran.kaur@example.com', 'password123', 'Customer', '9934567890', '1995-02-05');

-- Customers data insertion
INSERT INTO Customers (CustomerID, UserID, RegistrationDate, DietaryPreference, SpecialNeeds, Address)
VALUES
(1, 3, '2023-05-12', 'Vegetarian', 'None', '123, 2nd Street, Delhi, India'),
(2, 4, '2023-06-15', 'Non-Vegetarian', 'Wheelchair Accessible', '456, 4th Avenue, Mumbai, India'),
(3, 7, '2023-07-20', 'Vegan', 'None', '789, 8th Lane, Bangalore, India'),
(4, 8, '2023-05-10', 'Vegetarian', 'None', '101, 5th Road, Pune, India'),
(5, 9, '2023-08-05', 'Non-Vegetarian', 'None', '102, 3rd Street, Hyderabad, India'),
(6, 10, '2023-04-25', 'Vegan', 'Hearing Impaired', '203, 6th Lane, Chennai, India'),
(7, 2, '2023-05-22', 'Vegetarian', 'None', '456, 7th Road, Ahmedabad, India'),
(8, 5, '2023-06-11', 'Non-Vegetarian', 'None', '789, 9th Street, Kolkata, India'),
(9, 6, '2023-09-30', 'Vegetarian', 'None', '123, 10th Avenue, Jaipur, India'),
(10, 1, '2023-07-15', 'Non-Vegetarian', 'None', '456, 2nd Lane, Delhi, India');

-- Venues data insertion
INSERT INTO Venues (VenueID, VenueTitle, Address, City, State, ContactPhone, Capacity, ManagerName, Gender)
VALUES
(1, 'Marina Arena', '123 Marina Street, Chennai', 'Chennai', 'Tamil Nadu', '9841234567', 500, 'Ajay Kumar', 'Male'),
(2, 'Oberoi Banquet Hall', '456 Oberoi Road, Mumbai', 'Mumbai', 'Maharashtra', '9876543210', 300, 'Priya Desai', 'Female'),
(3, 'Golden Palace', '789 Gold Street, Bangalore', 'Bangalore', 'Karnataka', '9908765432', 700, 'Ravi Reddy', 'Male'),
(4, 'Sunset Conference Hall', '101 Sunset Road, Delhi', 'Delhi', 'Delhi', '9812345678', 400, 'Anjali Sharma', 'Female'),
(5, 'Royal Gardens', '102 Royal Lane, Hyderabad', 'Hyderabad', 'Telangana', '9922334455', 600, 'Suresh Babu', 'Male'),
(6, 'Imperial Grounds', '103 Imperial Avenue, Pune', 'Pune', 'Maharashtra', '9881122334', 350, 'Rajesh Patil', 'Male'),
(7, 'City Conference Center', '104 City Road, Kolkata', 'Kolkata', 'West Bengal', '9334455667', 450, 'Neha Ghosh', 'Female'),
(8, 'Grand Ballroom', '105 Grand Street, Jaipur', 'Jaipur', 'Rajasthan', '9377123456', 500, 'Gaurav Singh', 'Male'),
(9, 'Green Meadows', '106 Green Park, Ahmedabad', 'Ahmedabad', 'Gujarat', '9608776543', 650, 'Rekha Mehta', 'Female'),
(10, 'Silver Sands', '107 Beach Road, Goa', 'Goa', 'Goa', '9687543210', 800, 'Deepak Soni', 'Male');

-- Events data insertion
INSERT INTO Events (EventID, EventName, Description, StartDateTime, EndDateTime, VenueID, OrganizerID, Status)
VALUES
(1, 'Wedding Celebration', 'A grand wedding event with family and friends.', '2023-12-12 18:00:00', '2023-12-12 23:00:00', 1, 2, 'Confirmed'),
(2, 'Music Concert', 'Live performance by popular artists.', '2023-11-25 19:00:00', '2023-11-25 22:00:00', 2, 3, 'Confirmed'),
(3, 'Tech Conference', 'An event for tech enthusiasts and professionals.', '2023-10-05 09:00:00', '2023-10-05 18:00:00', 3, 4, 'Planned'),
(4, 'Business Seminar', 'Seminar on modern business practices.', '2023-09-18 10:00:00', '2023-09-18 16:00:00', 4, 5, 'Planned'),
(5, 'Food Festival', 'A celebration of diverse cuisines.', '2023-08-20 12:00:00', '2023-08-20 20:00:00', 5, 6, 'Confirmed'),
(6, 'Art Exhibition', 'Showcasing artworks from local artists.', '2023-07-22 10:00:00', '2023-07-22 18:00:00', 6, 7, 'Confirmed'),
(7, 'Dance Night', 'A night of dance performances and entertainment.', '2023-06-15 21:00:00', '2023-06-16 01:00:00', 7, 8, 'Planned'),
(8, 'Corporate Retreat', 'A retreat for corporate professionals.', '2023-05-10 08:00:00', '2023-05-10 17:00:00', 8, 9, 'Confirmed'),
(9, 'Wedding Anniversary', 'Celebration of a couple''s wedding anniversary.', '2023-04-30 18:00:00', '2023-04-30 23:00:00', 9, 10, 'Confirmed'),
(10, 'Charity Gala', 'A fundraising gala for social causes.', '2023-03-20 19:00:00', '2023-03-20 23:00:00', 10, 1, 'Planned');

-- PaymentModes data insertion (inserting before Bookings due to foreign key dependency)
INSERT INTO PaymentModes (ModeID, ModeType, Description, ModeCode, IsActive)
VALUES
(1, 'Credit Card', 'Payment through credit card', 'CC123', TRUE),
(2, 'Cash', 'Payment through cash at the event', 'CASH01', TRUE),
(3, 'Online', 'Payment through online payment gateways', 'ONLINE99', TRUE);

-- Bookings data insertion
INSERT INTO Bookings (BookingID, EventID, UserID, BookingDate, Status, ConfirmationCode, ModeID, TotalAmount)
VALUES
(1, 1, 3, '2023-11-01', 'Confirmed', 'CONF123', 1, 5000.00),
(2, 2, 4, '2023-10-15', 'Pending', 'CONF124', 2, 1500.00),
(3, 3, 7, '2023-09-05', 'Confirmed', 'CONF125', 3, 3500.00),
(4, 4, 5, '2023-08-20', 'Confirmed', 'CONF126', 1, 2000.00),
(5, 5, 9, '2023-07-15', 'Confirmed', 'CONF127', 2, 7000.00),
(6, 6, 10, '2023-06-25', 'Pending', 'CONF128', 3, 4500.00),
(7, 7, 2, '2023-06-01', 'Confirmed', 'CONF129', 1, 2500.00),
(8, 8, 8, '2023-05-05', 'Pending', 'CONF130', 2, 6000.00),
(9, 9, 6, '2023-04-28', 'Confirmed', 'CONF131', 1, 5500.00),
(10, 10, 1, '2023-03-12', 'Confirmed', 'CONF132', 3, 10000.00);

-- FoodItems data insertion
INSERT INTO FoodItems (FoodID, FoodName, Type, DietaryInfo, CostPerPerson, CuisineType)
VALUES
(1, 'Paneer Tikka', 'Vegetarian', 'Contains dairy', 200.00, 'Indian'),
(2, 'Chicken Biryani', 'Non-Vegetarian', 'Contains chicken', 300.00, 'Indian'),
(3, 'Vegan Burger', 'Vegan', 'Plant-based ingredients', 250.00, 'American'),
(4, 'Butter Chicken', 'Non-Vegetarian', 'Contains chicken, dairy', 350.00, 'Indian'),
(5, 'Dosa', 'Vegetarian', 'Contains gluten', 150.00, 'Indian'),
(6, 'Chole Bhature', 'Vegetarian', 'Contains gluten', 180.00, 'Indian'),
(7, 'Mutton Kebab', 'Non-Vegetarian', 'Contains mutton', 400.00, 'Indian'),
(8, 'Vegan Wrap', 'Vegan', 'Plant-based ingredients', 220.00, 'Mediterranean'),
(9, 'Samosa', 'Vegetarian', 'Contains gluten', 50.00, 'Indian'),
(10, 'Fish Curry', 'Non-Vegetarian', 'Contains fish', 350.00, 'Indian');

-- Event_Food data insertion
INSERT INTO Event_Food (EventID, FoodID, Quantity)
VALUES
(1, 1, 150),
(1, 2, 100),
(2, 3, 200),
(2, 4, 150),
(3, 5, 250),
(4, 6, 200),
(5, 7, 100),
(6, 8, 300),
(7, 9, 500),
(8, 10, 200);

-- Decorations data insertion
INSERT INTO Decorations (DecorationID, DecorationName, Type, Cost, Supplier, QuantityAvailable)
VALUES
(1, 'Flower Garland', 'Floral', 500.00, 'Floral Creations', 50),
(2, 'LED Lights', 'Lighting', 300.00, 'LightWorld', 100),
(3, 'Table Centerpiece', 'Table Decor', 150.00, 'Home Decors', 200),
(4, 'Balloons', 'Party', 100.00, 'Balloon Kings', 500),
(5, 'Stage Backdrop', 'Stage', 1000.00, 'Event Masters', 20),
(6, 'Candle Holders', 'Lighting', 200.00, 'Elegant Events', 150),
(7, 'Curtains', 'Stage', 400.00, 'Curtain World', 40),
(8, 'Ribbons', 'Floral', 50.00, 'Floral Creations', 1000),
(9, 'Table Cloths', 'Table Decor', 300.00, 'Event Decorators', 300),
(10, 'Chandeliers', 'Lighting', 1500.00, 'Lux Lighting', 10);

-- Event_Decorations data insertion
INSERT INTO Event_Decorations (EventID, DecorationID, QuantityUsed)
VALUES
(1, 1, 50),
(1, 2, 20),
(2, 3, 100),
(2, 4, 200),
(3, 5, 15),
(4, 6, 50),
(5, 7, 30),
(6, 8, 200),
(7, 9, 100),
(8, 10, 10);

-- Tickets data insertion
INSERT INTO Tickets (TicketID, EventID, CustomerID, TicketType, Price, PurchaseDate, SeatNumber)
VALUES
(1, 1, 3, 'VIP', 1500.00, '2023-11-01', 'A1'),
(2, 2, 4, 'General', 500.00, '2023-10-10', 'B2'),
(3, 3, 7, 'VIP', 2000.00, '2023-09-10', 'C3'),
(4, 4, 5, 'General', 800.00, '2023-08-20', 'D4'),
(5, 5, 9, 'VIP', 2500.00, '2023-07-01', 'E5'),
(6, 6, 10, 'General', 1200.00, '2023-06-25', 'F6'),
(7, 7, 2, 'VIP', 2000.00, '2023-06-01', 'G7'),
(8, 8, 8, 'General', 1500.00, '2023-05-10', 'H8'),
(9, 9, 6, 'VIP', 2500.00, '2023-04-20', 'I9'),
(10, 10, 1, 'General', 1800.00, '2023-03-12', 'J10');

-- Sponsors data insertion
INSERT INTO Sponsors (SponsorID, SponsorName, Industry, ContactEmail, ContactPhone, ContributionRange, Website)
VALUES
(1, 'Tata Motors', 'Automobile', 'contact@tata.com', '9876543210', '1M-5M', 'www.tatamotors.com'),
(2, 'Reliance Industries', 'Conglomerate', 'contact@reliance.com', '9123456789', '5M-10M', 'www.reliance.com'),
(3, 'HDFC Bank', 'Banking', 'contact@hdfc.com', '9812345678', '500K-1M', 'www.hdfcbank.com'),
(4, 'Amazon India', 'E-Commerce', 'contact@amazon.in', '9708765432', '10M-20M', 'www.amazon.in'),
(5, 'Flipkart', 'E-Commerce', 'contact@flipkart.com', '9602345678', '500K-1M', 'www.flipkart.com'),
(6, 'Wipro', 'Information Technology', 'contact@wipro.com', '9734123456', '1M-5M', 'www.wipro.com'),
(7, 'Bajaj Auto', 'Automobile', 'contact@bajajauto.com', '9543216789', '1M-5M', 'www.bajajauto.com'),
(8, 'Maruti Suzuki', 'Automobile', 'contact@maruti.com', '9687324567', '10M-20M', 'www.marutisuzuki.com'),
(9, 'ICICI Bank', 'Banking', 'contact@icici.com', '9908776543', '500K-1M', 'www.icicibank.com'),
(10, 'Infosys', 'Information Technology', 'contact@infosys.com', '9234567890', '5M-10M', 'www.infosys.com');

-- Event_Sponsors data insertion
INSERT INTO Event_Sponsors (EventID, SponsorID, ContributionAmount, AgreementDate)
VALUES
(1, 1, 500000.00, '2023-11-01'),
(1, 2, 1000000.00, '2023-11-01'),
(2, 3, 250000.00, '2023-10-15'),
(2, 4, 1500000.00, '2023-10-10'),
(3, 5, 300000.00, '2023-09-05'),
(4, 6, 200000.00, '2023-08-20'),
(5, 7, 400000.00, '2023-07-15'),
(6, 8, 600000.00, '2023-06-25'),
(7, 9, 100000.00, '2023-06-01'),
(8, 10, 700000.00, '2023-05-10');

-- Staff data insertion
INSERT INTO Staff (StaffID, UserID, Position, HireDate, Salary, PhoneNumber, Department)
VALUES
(1, 2, 'Event Manager', '2021-08-01', 50000.00, '9876543210', 'Event Planning'),
(2, 3, 'Security Personnel', '2022-02-15', 25000.00, '9123456789', 'Security'),
(3, 4, 'Catering Staff', '2020-12-10', 20000.00, '9812345678', 'Catering'),
(4, 5, 'Technician', '2021-11-20', 30000.00, '9101234567', 'Technical Support'),
(5, 6, 'Customer Service', '2022-05-15', 22000.00, '9377123456', 'Customer Support'),
(6, 7, 'Security Personnel', '2023-03-30', 24000.00, '9602345678', 'Security'),
(7, 8, 'Event Coordinator', '2022-06-22', 35000.00, '9753124567', 'Event Coordination'),
(8, 9, 'Cleaner', '2021-09-18', 15000.00, '9156789012', 'Cleaning'),
(9, 10, 'Photographer', '2023-04-10', 45000.00, '9934567890', 'Photography'),
(10, 1, 'Event Planner', '2023-01-01', 55000.00, '9101234567', 'Event Planning');

-- Event_Staff data insertion
INSERT INTO Event_Staff (EventID, StaffID, Role, HoursAssigned)
VALUES
(1, 1, 'Event Manager', 8),
(1, 2, 'Security Personnel', 8),
(2, 3, 'Catering Staff', 8),
(3, 4, 'Technician', 8),
(4, 5, 'Customer Service', 6),
(5, 6, 'Security Personnel', 7),
(6, 7, 'Event Coordinator', 8),
(7, 8, 'Cleaner', 6),
(8, 9, 'Photographer', 8),
(9, 10, 'Event Planner', 8);

/* ======================================================================
   DATA QUERYING SECTION
   Basic queries to retrieve data from tables
====================================================================== */

-- 1. Display all data from the Users table
SELECT * FROM Users;

-- 2. Display all data from the Customers table
SELECT * FROM Customers;

-- 3. Display all data from the Venues table
SELECT * FROM Venues;

-- 4. Display all data from the Events table
SELECT * FROM Events;

-- 5. Display all data from the Bookings table
SELECT * FROM Bookings;

-- 6. Display all data from the FoodItems table
SELECT * FROM FoodItems;

-- 7. Display all data from the Event_Food table
SELECT * FROM Event_Food;

-- 8. Display all data from the Decorations table
SELECT * FROM Decorations;

-- 9. Display all data from the Event_Decorations table
SELECT * FROM Event_Decorations;

-- 10. Display all data from the Tickets table
SELECT * FROM Tickets;

-- 11. Display all data from the Sponsors table
SELECT * FROM Sponsors;

-- 12. Display all data from the Event_Sponsors table
SELECT * FROM Event_Sponsors;

-- 13. Display all data from the PaymentModes table
SELECT * FROM PaymentModes;

-- 14. Display all data from the Staff table
SELECT * FROM Staff;

-- 15. Display all data from the Event_Staff table
SELECT * FROM Event_Staff;

/* ======================================================================
   NORMALIZATION SECTION
   Creating normalized tables and migrating data
====================================================================== */

-- Create AddressDetails table for better normalization
CREATE TABLE AddressDetails (
  AddressID INT AUTO_INCREMENT PRIMARY KEY,
  Address VARCHAR(255) NOT NULL,
  City VARCHAR(50) NOT NULL,
  State VARCHAR(50) NOT NULL
);

-- Extract distinct address data from Venues
INSERT INTO AddressDetails (Address, City, State)
SELECT DISTINCT Address, City, State FROM Venues;

-- Add AddressID to Venues
ALTER TABLE Venues ADD COLUMN AddressID INT;

-- Allow safe updates
SET SQL_SAFE_UPDATES = 0;

-- Update Venues with AddressID using JOIN instead of nested query
UPDATE Venues v
JOIN AddressDetails a ON v.Address = a.Address AND v.City = a.City AND v.State = a.State
SET v.AddressID = a.AddressID;

-- Add foreign key after ensuring all records are updated
ALTER TABLE Venues ADD CONSTRAINT fk_venue_address FOREIGN KEY (AddressID) REFERENCES AddressDetails(AddressID);

-- Remove redundant columns only after confirming all data is properly linked
ALTER TABLE Venues DROP COLUMN Address;
ALTER TABLE Venues DROP COLUMN City;
ALTER TABLE Venues DROP COLUMN State;

-- Create VenueManagers table - better normalized structure
CREATE TABLE VenueManagers (
  ManagerID INT AUTO_INCREMENT PRIMARY KEY,
  ManagerName VARCHAR(100) NOT NULL,
  Gender VARCHAR(20) CHECK (Gender IN ('Male', 'Female', 'Other')),
  ContactPhone VARCHAR(15) NOT NULL
);

-- Extract distinct manager data
INSERT INTO VenueManagers (ManagerName, Gender, ContactPhone)
SELECT DISTINCT ManagerName, Gender, ContactPhone FROM Venues;

-- Add ManagerID to Venues
ALTER TABLE Venues ADD COLUMN ManagerID INT;

-- Update Venues with ManagerID using JOIN
UPDATE Venues v
JOIN VenueManagers m ON v.ManagerName = m.ManagerName AND v.Gender = m.Gender AND v.ContactPhone = m.ContactPhone
SET v.ManagerID = m.ManagerID;

-- Add foreign key and remove redundant columns
ALTER TABLE Venues ADD CONSTRAINT fk_venue_manager FOREIGN KEY (ManagerID) REFERENCES VenueManagers(ManagerID);
ALTER TABLE Venues DROP COLUMN ManagerName;
ALTER TABLE Venues DROP COLUMN Gender;
ALTER TABLE Venues DROP COLUMN ContactPhone;

-- Create properly normalized EventTypes table
CREATE TABLE EventTypes (
  EventTypeID INT AUTO_INCREMENT PRIMARY KEY,
  TypeName VARCHAR(50) NOT NULL UNIQUE,
  Description VARCHAR(255)
);

-- Insert meaningful event types
INSERT INTO EventTypes (TypeName, Description) VALUES
('Wedding', 'Wedding ceremonies and receptions'),
('Concert', 'Music performances and concerts'),
('Conference', 'Business and academic conferences'),
('Seminar', 'Educational and professional seminars'),
('Festival', 'Cultural and food festivals'),
('Exhibition', 'Art, product, and cultural exhibitions'),
('Retreat', 'Corporate and wellness retreats'),
('Gala', 'Formal social gatherings including charity events'),
('Other', 'Miscellaneous event types');

-- Add EventTypeID to Events
ALTER TABLE Events ADD COLUMN EventTypeID INT;

-- Use CASE expression with JOIN for better readability and performance
UPDATE Events e
SET e.EventTypeID = (
  SELECT et.EventTypeID
  FROM EventTypes et
  WHERE
    CASE
      WHEN e.EventName LIKE '%Wedding%' THEN 'Wedding'
      WHEN e.EventName LIKE '%Concert%' THEN 'Concert'
      WHEN e.EventName LIKE '%Conference%' THEN 'Conference'
      WHEN e.EventName LIKE '%Seminar%' THEN 'Seminar'
      WHEN e.EventName LIKE '%Festival%' THEN 'Festival'
      WHEN e.EventName LIKE '%Exhibition%' THEN 'Exhibition'
      WHEN e.EventName LIKE '%Retreat%' THEN 'Retreat'
      WHEN e.EventName LIKE '%Gala%' THEN 'Gala'
      ELSE 'Other'
    END = et.TypeName
);

-- Add foreign key constraint
ALTER TABLE Events ADD CONSTRAINT fk_event_type FOREIGN KEY (EventTypeID) REFERENCES EventTypes(EventTypeID);

-- Create Departments table with proper documentation
CREATE TABLE Departments (
  DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
  DepartmentName VARCHAR(50) NOT NULL UNIQUE,
  Description VARCHAR(255)
);

-- Extract department data and add descriptions
INSERT INTO Departments (DepartmentName)
SELECT DISTINCT Department FROM Staff;

-- Add sample descriptions (would be better with actual descriptions)
UPDATE Departments
SET Description = CONCAT(DepartmentName, ' department handles related functions');

-- Add DepartmentID to Staff
ALTER TABLE Staff ADD COLUMN DepartmentID INT;

-- Update Staff with DepartmentID using JOIN
UPDATE Staff s
JOIN Departments d ON s.Department = d.DepartmentName
SET s.DepartmentID = d.DepartmentID;

-- Add foreign key and remove redundant column after verifying data integrity
ALTER TABLE Staff ADD CONSTRAINT fk_staff_department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID);
ALTER TABLE Staff DROP COLUMN Department;

-- Create normalized FoodCategories table
CREATE TABLE FoodCategories (
  CategoryID INT AUTO_INCREMENT PRIMARY KEY,
  Type VARCHAR(20) CHECK (Type IN ('Vegetarian', 'Non-Vegetarian', 'Vegan')),
  CuisineType VARCHAR(50) NOT NULL,
  UNIQUE KEY unique_food_category (Type, CuisineType)
);

-- Extract food category data
INSERT INTO FoodCategories (Type, CuisineType)
SELECT DISTINCT Type, CuisineType FROM FoodItems;

-- Add CategoryID to FoodItems
ALTER TABLE FoodItems ADD COLUMN CategoryID INT;

-- Update FoodItems with CategoryID using JOIN
UPDATE FoodItems f
JOIN FoodCategories fc ON f.Type = fc.Type AND f.CuisineType = fc.CuisineType
SET f.CategoryID = fc.CategoryID;

-- Add foreign key and remove redundant columns after verifying
ALTER TABLE FoodItems ADD CONSTRAINT fk_food_category FOREIGN KEY (CategoryID) REFERENCES FoodCategories(CategoryID);
ALTER TABLE FoodItems DROP COLUMN Type;
ALTER TABLE FoodItems DROP COLUMN CuisineType;

-- Create normalized DecorationTypes table
CREATE TABLE DecorationTypes (
  TypeID INT AUTO_INCREMENT PRIMARY KEY,
  Type VARCHAR(50) NOT NULL UNIQUE,
  Description VARCHAR(255)
);

-- Extract decoration type data
INSERT INTO DecorationTypes (Type)
SELECT DISTINCT Type FROM Decorations;

-- Add TypeID to Decorations
ALTER TABLE Decorations ADD COLUMN TypeID INT;

-- Update Decorations with TypeID using JOIN
UPDATE Decorations d
JOIN DecorationTypes dt ON d.Type = dt.Type
SET d.TypeID = dt.TypeID;

-- Add foreign key and remove redundant column
ALTER TABLE Decorations ADD CONSTRAINT fk_decoration_type FOREIGN KEY (TypeID) REFERENCES DecorationTypes(TypeID);
ALTER TABLE Decorations DROP COLUMN Type;

-- Create normalized SponsorIndustries table
CREATE TABLE SponsorIndustries (
  IndustryID INT AUTO_INCREMENT PRIMARY KEY,
  Industry VARCHAR(50) NOT NULL UNIQUE,
  Description VARCHAR(255)
);

-- Extract industry data
INSERT INTO SponsorIndustries (Industry)
SELECT DISTINCT Industry FROM Sponsors;

-- Add IndustryID to Sponsors
ALTER TABLE Sponsors ADD COLUMN IndustryID INT;

-- Update Sponsors with IndustryID using JOIN
UPDATE Sponsors s
JOIN SponsorIndustries si ON s.Industry = si.Industry
SET s.IndustryID = si.IndustryID;

-- Add foreign key and remove redundant column
ALTER TABLE Sponsors ADD CONSTRAINT fk_sponsor_industry FOREIGN KEY (IndustryID) REFERENCES SponsorIndustries(IndustryID);
ALTER TABLE Sponsors DROP COLUMN Industry;

-- Reset safe updates mode
SET SQL_SAFE_UPDATES = 1;

-- Create a CustomerPreferences table to normalize the preferences
CREATE TABLE CustomerPreferences (
  PreferenceID INT AUTO_INCREMENT PRIMARY KEY,
  PreferenceType VARCHAR(50) NOT NULL UNIQUE,
  Description VARCHAR(255)
);

-- Extract distinct preference types
INSERT INTO CustomerPreferences (PreferenceType)
SELECT DISTINCT DietaryPreference FROM Customers
WHERE DietaryPreference IS NOT NULL;

-- Add PreferenceID to Customers
ALTER TABLE Customers ADD COLUMN PreferenceID INT;

-- Update with JOIN
SET SQL_SAFE_UPDATES = 0;
UPDATE Customers c
LEFT JOIN CustomerPreferences cp ON c.DietaryPreference = cp.PreferenceType
SET c.PreferenceID = cp.PreferenceID;
SET SQL_SAFE_UPDATES = 1;

-- Add foreign key (allowing NULL for customers with no preferences)
ALTER TABLE Customers ADD CONSTRAINT fk_customer_preference
FOREIGN KEY (PreferenceID) REFERENCES CustomerPreferences(PreferenceID);

/* ======================================================================
   COMPLEX QUERIES SECTION
   Advanced queries for data analysis and reporting
====================================================================== */

-- 1. List all events with their venue details and organizer names
SELECT e.EventID, e.EventName, v.VenueTitle, v.Capacity,
       ad.Address, ad.City, ad.State,
       u.FirstName AS OrganizerFirstName, u.LastName AS OrganizerLastName
FROM Events e
JOIN Venues v ON e.VenueID = v.VenueID
JOIN AddressDetails ad ON v.AddressID = ad.AddressID
JOIN Users u ON e.OrganizerID = u.UserID
ORDER BY e.StartDateTime;

-- 2. Show all customers with their dietary preferences and ticket purchases
SELECT c.CustomerID, u.FirstName, u.LastName, cp.PreferenceType AS DietaryPreference,
       t.TicketID, t.TicketType, t.Price, e.EventName
FROM Customers c
JOIN Users u ON c.UserID = u.UserID
LEFT JOIN CustomerPreferences cp ON c.PreferenceID = cp.PreferenceID
LEFT JOIN Tickets t ON c.CustomerID = t.CustomerID
LEFT JOIN Events e ON t.EventID = e.EventID;

-- 3. Get the menu items for each event
SELECT e.EventID, e.EventName, f.FoodName, fc.Type, fc.CuisineType,
       ef.Quantity, f.CostPerPerson, (ef.Quantity * f.CostPerPerson) AS TotalFoodCost
FROM Events e
JOIN Event_Food ef ON e.EventID = ef.EventID
JOIN FoodItems f ON ef.FoodID = f.FoodID
JOIN FoodCategories fc ON f.CategoryID = fc.CategoryID
ORDER BY e.EventID, fc.Type;

-- 4. Find all staff assigned to events in a specific city
SELECT es.EventID, e.EventName, ad.City,
       s.StaffID, u.FirstName, u.LastName, s.Position, d.DepartmentName,
       es.Role, es.HoursAssigned
FROM Event_Staff es
JOIN Events e ON es.EventID = e.EventID
JOIN Venues v ON e.VenueID = v.VenueID
JOIN AddressDetails ad ON v.AddressID = ad.AddressID
JOIN Staff s ON es.StaffID = s.StaffID
JOIN Users u ON s.UserID = u.UserID
JOIN Departments d ON s.DepartmentID = d.DepartmentID
WHERE ad.City = 'Mumbai'
ORDER BY e.EventID;

-- 5. Show all decorations used for each event with their types
SELECT e.EventID, e.EventName, d.DecorationName, dt.Type,
       ed.QuantityUsed, d.Cost, (ed.QuantityUsed * d.Cost) AS TotalDecorationCost
FROM Events e
JOIN Event_Decorations ed ON e.EventID = ed.EventID
JOIN Decorations d ON ed.DecorationID = d.DecorationID
JOIN DecorationTypes dt ON d.TypeID = dt.TypeID
ORDER BY e.EventID, dt.Type;

-- 6. List all sponsors with their contribution amounts for each event
SELECT e.EventID, e.EventName, s.SponsorName, si.Industry,
       es.ContributionAmount, es.AgreementDate
FROM Events e
JOIN Event_Sponsors es ON e.EventID = es.EventID
JOIN Sponsors s ON es.SponsorID = s.SponsorID
JOIN SponsorIndustries si ON s.IndustryID = si.IndustryID
ORDER BY e.EventID, es.ContributionAmount DESC;

-- 7. Show all bookings with payment method and event details
SELECT b.BookingID, b.EventID, e.EventName, e.StartDateTime,
       u.FirstName, u.LastName, b.BookingDate, b.Status,
       pm.ModeType AS PaymentMethod, b.TotalAmount, b.ConfirmationCode
FROM Bookings b
JOIN Events e ON b.EventID = e.EventID
JOIN Users u ON b.UserID = u.UserID
JOIN PaymentModes pm ON b.ModeID = pm.ModeID
ORDER BY b.BookingDate DESC;

-- 8. Find events with vegan food options
SELECT DISTINCT e.EventID, e.EventName, e.StartDateTime
FROM Events e
JOIN Event_Food ef ON e.EventID = ef.EventID
JOIN FoodItems f ON ef.FoodID = f.FoodID
JOIN FoodCategories fc ON f.CategoryID = fc.CategoryID
WHERE fc.Type = 'Vegan'
ORDER BY e.StartDateTime;

-- 9. Show managers of venues where confirmed events are scheduled
SELECT v.VenueID, v.VenueTitle, vm.ManagerName, vm.ContactPhone,
       e.EventID, e.EventName, e.StartDateTime
FROM Venues v
JOIN VenueManagers vm ON v.ManagerID = vm.ManagerID
JOIN Events e ON v.VenueID = e.VenueID
WHERE e.Status = 'Confirmed'
ORDER BY e.StartDateTime;

-- 10. List customers who have purchased VIP tickets along with their bookings
SELECT c.CustomerID, u.FirstName, u.LastName, t.TicketID, t.TicketType,
       e.EventName, t.Price, t.PurchaseDate, t.SeatNumber, b.BookingID
FROM Customers c
JOIN Users u ON c.UserID = u.UserID
JOIN Tickets t ON c.CustomerID = t.CustomerID
JOIN Events e ON t.EventID = e.EventID
LEFT JOIN Bookings b ON e.EventID = b.EventID AND c.UserID = b.UserID
WHERE t.TicketType = 'VIP'
ORDER BY t.PurchaseDate;

-- 11. Show events with multiple food types (both veg and non-veg)
SELECT e.EventID, e.EventName, COUNT(DISTINCT fc.Type) AS FoodTypeCount
FROM Events e
JOIN Event_Food ef ON e.EventID = ef.EventID
JOIN FoodItems f ON ef.FoodID = f.FoodID
JOIN FoodCategories fc ON f.CategoryID = fc.CategoryID
GROUP BY e.EventID, e.EventName
HAVING COUNT(DISTINCT fc.Type) > 1
ORDER BY FoodTypeCount DESC;

-- 12. Find staff members who work across multiple departments
SELECT s.StaffID, u.FirstName, u.LastName, GROUP_CONCAT(DISTINCT d.DepartmentName) AS Departments,
       COUNT(DISTINCT es.EventID) AS EventsAssigned
FROM Staff s
JOIN Users u ON s.UserID = u.UserID
JOIN Event_Staff es ON s.StaffID = es.StaffID
JOIN Departments d ON s.DepartmentID = d.DepartmentID
GROUP BY s.StaffID, u.FirstName, u.LastName
HAVING COUNT(DISTINCT es.EventID) > 1
ORDER BY EventsAssigned DESC;

-- 13. Show event attendance by ticket type
SELECT e.EventID, e.EventName, t.TicketType,
       COUNT(t.TicketID) AS TicketCount,
       SUM(t.Price) AS TotalRevenue
FROM Events e
JOIN Tickets t ON e.EventID = t.EventID
GROUP BY e.EventID, e.EventName, t.TicketType
ORDER BY e.EventID, TotalRevenue DESC;

-- 14. List event-related suppliers (food, decorations) with contact details
SELECT e.EventID, e.EventName,
       'Decoration' AS SupplierType, d.Supplier AS SupplierName, d.DecorationName AS ItemName
FROM Events e
JOIN Event_Decorations ed ON e.EventID = ed.EventID
JOIN Decorations d ON ed.DecorationID = d.DecorationID
WHERE d.Supplier IS NOT NULL
UNION
SELECT e.EventID, e.EventName,
       'Food' AS SupplierType, f.FoodName AS ItemName, fc.CuisineType AS Category
FROM Events e
JOIN Event_Food ef ON e.EventID = ef.EventID
JOIN FoodItems f ON ef.FoodID = f.FoodID
JOIN FoodCategories fc ON f.CategoryID = fc.CategoryID
ORDER BY EventID, SupplierType;

-- 15. Find customers who have special needs and their event participation
SELECT c.CustomerID, u.FirstName, u.LastName, c.SpecialNeeds,
       COUNT(t.TicketID) AS EventsAttended,
       GROUP_CONCAT(DISTINCT e.EventName) AS EventsParticipated
FROM Customers c
JOIN Users u ON c.UserID = u.UserID
LEFT JOIN Tickets t ON c.CustomerID = t.CustomerID
LEFT JOIN Events e ON t.EventID = e.EventID
WHERE c.SpecialNeeds IS NOT NULL AND c.SpecialNeeds != 'None'
GROUP BY c.CustomerID, u.FirstName, u.LastName, c.SpecialNeeds
ORDER BY EventsAttended DESC;
