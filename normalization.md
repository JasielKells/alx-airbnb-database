# Database Normalization to Third Normal Form (3NF) - AirBnB Schema
## Current Schema Assessment

Original Entities:
1. USER
2. PROPERTY
3. BOOKING
4. PAYMENT
5. REVIEW
6. MESSAGE

## **Normalization Process
1. First Normal Form (1NF) Compliance
* All tables already satisfy 1NF:
- Each table has a primary key
- All attributes contain atomic values
- No repeating groups

2. Second Normal Form (2NF) Compliance
* All tables satisfy 2NF:
- All non-key attributes are fully functionally dependent on the entire primary key
- No partial dependencies exist

3. Third Normal Form (3NF) Compliance
* Identified potential issues:

**Issue 1: Derived Attribute in Booking
- total_price in Booking can be calculated from Property.pricepernight and date difference
- Violation: Transitive dependency (booking → property → pricepernight)

**Issue 2: Redundant User Role Handling
- role in User table mixes host/guest concepts
- Host-specific data (like properties owned) isn't separated

**Issue 3: Payment Method Data
- payment_method is an ENUM but might need more details for different methods

# Normalization Improvements
1. Remove Derived Attribute:
- Remove total_price from Booking
- Calculate it dynamically when needed

2. Separate Host Profile:
- Move host-specific attributes from User to Host_Profile
- User.role becomes simpler (just admin/regular)

3. Normalize Payment Methods


# 3NF-COMPLIANT ERD SCHEMA

1. USER
    user_id: Primary Key, UUID, Indexed
    first_name: VARCHAR, NOT NULL
    last_name: VARCHAR, NOT NULL
    email: VARCHAR, UNIQUE, NOT NULL
    password_hash: VARCHAR, NOT NULL
    phone_number: VARCHAR, NULL
    is_admin: BOOLEAN, DEFAULT FALSE, NOT NULL
    created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP


2. HOST PROFILE
    host_id: Primary Key, UUID, Indexed
    user_id: Foreign Key, references User(user_id), NOT NULL
    host_description: TEXT, NULL
    host_since: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
    is_superhost: BOOLEAN, DEFAULT FALSE, NOT NULL
    verification_status: ENUM (unverified, pending, verified), DEFAULT 'unverified', NOT NULL

3. PROPERTY
    property_id: Primary Key, UUID, Indexed
    host_id: Foreign Key, references Host_Profile(host_id), NOT NULL
    name: VARCHAR, NOT NULL
    description: TEXT, NOT NULL
    location: VARCHAR, NOT NULL
    pricepernight: DECIMAL(10,2), NOT NULL
    created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
    updated_at: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

4. BOOKING
    booking_id: Primary Key, UUID, Indexed
    property_id: Foreign Key, references Property(property_id), NOT NULL
    user_id: Foreign Key, references User(user_id), NOT NULL
    start_date: DATE, NOT NULL
    end_date: DATE, NOT NULL
    status: ENUM (pending, confirmed, canceled, completed), DEFAULT 'pending', NOT NULL
    created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

5. PAYMENT METHOD
    method_id: Primary Key, UUID, Indexed
    user_id: Foreign Key, references User(user_id), NOT NULL
    type: ENUM (credit_card, paypal, stripe), NOT NULL
    last_four: CHAR(4), NULL (for credit cards)
    expiry_date: DATE, NULL (for credit cards)
    created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

6. PAYMENT
    payment_id: Primary Key, UUID, Indexed
    booking_id: Foreign Key, references Booking(booking_id), NOT NULL
    method_id: Foreign Key, references Payment_Method(method_id), NOT NULL
    amount: DECIMAL(10,2), NOT NULL
    payment_date: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

7. Review
    review_id: Primary Key, UUID, Indexed
    property_id: Foreign Key, references Property(property_id)
    user_id: Foreign Key, references User(user_id)
    rating: INTEGER, CHECK: rating >= 1 AND rating <= 5, NOT NULL
    comment: TEXT, NOT NULL
    created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

8. Message
    message_id: Primary Key, UUID, Indexed
    sender_id: Foreign Key, references User(user_id)
    recipient_id: Foreign Key, references User(user_id)
    message_body: TEXT, NOT NULL
    sent_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
