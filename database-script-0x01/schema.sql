-- Enable UUID extension if using PostgreSQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- USER table
CREATE TABLE "user" (
    user_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20), NULL,
    is_admin BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for User table
CREATE INDEX idx_user_email ON "user" (email);
CREATE INDEX idx_user_phone ON "user" (phone_number) WHERE phone_number IS NOT NULL;

-- HOST PROFILE table
CREATE TABLE host_profile (
    host_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
    host_description TEXT,
    host_since TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_superhost BOOLEAN DEFAULT FALSE NOT NULL,
    verification_status VARCHAR(20) 
        DEFAULT 'unverified' 
        NOT NULL 
        CHECK (verification_status IN ('unverified', 'pending', 'verified'))
);

-- Indexes for Host Profile
CREATE INDEX idx_host_user ON host_profile (user_id);
CREATE INDEX idx_host_superhost ON host_profile (is_superhost) WHERE is_superhost = TRUE;

-- PROPERTY table
CREATE TABLE property (
    property_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    host_id UUID NOT NULL REFERENCES host_profile(host_id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL CHECK (price_per_night > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Property
CREATE INDEX idx_property_host ON property (host_id);
CREATE INDEX idx_property_location ON property (location);
CREATE INDEX idx_property_price ON property (price_per_night);

-- BOOKING table
CREATE TABLE booking (
    booking_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    property_id UUID NOT NULL REFERENCES property(property_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK (end_date > start_date),
    status VARCHAR(20) 
        DEFAULT 'pending' 
        NOT NULL 
        CHECK (status IN ('pending', 'confirmed', 'canceled', 'completed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for Booking
CREATE INDEX idx_booking_property ON booking (property_id);
CREATE INDEX idx_booking_user ON booking (user_id);
CREATE INDEX idx_booking_dates ON booking (start_date, end_date);
CREATE INDEX idx_booking_status ON booking (status);

-- PAYMENT METHOD table
CREATE TABLE payment_method (
    method_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL CHECK (type IN ('credit_card', 'paypal', 'stripe')),
    last_four CHAR(4),
    expiry_date DATE,
    is_default BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_card_details CHECK (
        (type = 'credit_card' AND last_four IS NOT NULL AND expiry_date IS NOT NULL) OR
        (type != 'credit_card' AND last_four IS NULL AND expiry_date IS NULL)
    )
);

-- Indexes for Payment Method
CREATE INDEX idx_payment_method_user ON payment_method (user_id);
CREATE INDEX idx_payment_method_default ON payment_method (user_id, is_default) WHERE is_default = TRUE;

-- PAYMENT table
CREATE TABLE payment (
    payment_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    booking_id UUID NOT NULL REFERENCES booking(booking_id) ON DELETE CASCADE,
    method_id UUID NOT NULL REFERENCES payment_method(method_id) ON DELETE RESTRICT,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'completed' NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded'))
);

-- Indexes for Payment
CREATE INDEX idx_payment_booking ON payment (booking_id);
CREATE INDEX idx_payment_method ON payment (method_id);
CREATE INDEX idx_payment_date ON payment (payment_date);

-- REVIEW table
CREATE TABLE review (
    review_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    property_id UUID NOT NULL REFERENCES property(property_id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (property_id, user_id)  -- Prevent multiple reviews for same property by same user
);

-- Indexes for Review
CREATE INDEX idx_review_property ON review (property_id);
CREATE INDEX idx_review_user ON review (user_id);
CREATE INDEX idx_review_rating ON review (rating);

-- MESSAGE table
CREATE TABLE message (
    message_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    sender_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
    recipient_id UUID NOT NULL REFERENCES "user"(user_id) ON DELETE CASCADE,
    message_body TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CHECK (sender_id != recipient_id)  -- Prevent sending messages to oneself
);

-- Indexes for Message
CREATE INDEX idx_message_sender ON message (sender_id);
CREATE INDEX idx_message_recipient ON message (recipient_id);
CREATE INDEX idx_message_sent ON message (sent_at);
CREATE INDEX idx_message_conversation ON message (
    LEAST(sender_id, recipient_id), 
    GREATEST(sender_id, recipient_id), 
    sent_at
);
