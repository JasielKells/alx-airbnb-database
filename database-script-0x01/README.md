# Database Schema Summary
## Overview
This database schema is designed for a property booking platform (similar to Airbnb) with a 3NF-compliant relational structure. The schema supports user accounts, property listings, bookings, payments, reviews, and messaging functionality.

## Key Tables
### Core Entities
1. User: Stores user account information with authentication details
2. Host Profile: Contains host-specific information linked to user accounts
3. Property: Lists all rental properties with descriptions and pricing

### Transactional Entities
1. Booking: Manages property reservations with date ranges and status tracking
2. Payment Method: Stores user payment options (credit cards, PayPal, etc.)
3. Payment: Records financial transactions for bookings

### Interaction Entities
1. Review: Captures user reviews and ratings for properties
2. Message: Handles communication between users

## Schema Features
### Data Integrity
1. UUID primary keys for all tables
2. Proper foreign key relationships with cascading deletes where appropriate
3. CHECK constraints for data validation (ratings, dates, payment amounts)
4. UNIQUE constraints to prevent duplicates

### Performance Optimizations
1. Indexes on all foreign keys
2. Specialized indexes for common query patterns (dates, statuses, search fields)
3. Composite indexes for efficient message threading

### Security Considerations
1. Password hashing (stored in users table)
2. Payment method data normalization (only storing last 4 digits of cards)
3. Verification status tracking for hosts

### Usage Notes
1. Requires UUID support in your database system
2. Uses TIMESTAMP WITH TIME ZONE for proper timezone handling
3. Includes sample indexes - adjust based on your actual query patterns
4. ENUM types are implemented as VARCHAR with CHECK constraints for portability
