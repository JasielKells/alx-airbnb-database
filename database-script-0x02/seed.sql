-- Clear existing data (optional - use with caution)
TRUNCATE TABLE message, review, payment, payment_method, booking, property, host_profile, "user" RESTART IDENTITY CASCADE;

-- Insert sample Users
INSERT INTO "user" (user_id, first_name, last_name, email, password_hash, phone_number, is_admin, created_at) VALUES
-- Admin user
('11111111-1111-1111-1111-111111111111', 'Admin', 'User', 'admin@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MQRqQzL5FmYdKZogN9.E.FBBN3d7DAC', '+1234567890', TRUE, '2023-01-01 10:00:00'),

-- Regular users
('22222222-2222-2222-2222-222222222222', 'John', 'Smith', 'john.smith@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MQRqQzL5FmYdKZogN9.E.FBBN3d7DAC', '+1555123456', FALSE, '2023-02-15 14:30:00'),
('33333333-3333-3333-3333-333333333333', 'Emily', 'Johnson', 'emily.j@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MQRqQzL5FmYdKZogN9.E.FBBN3d7DAC', '+1555987654', FALSE, '2023-03-10 09:15:00'),
('44444444-4444-4444-4444-444444444444', 'Michael', 'Brown', 'michael.b@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MQRqQzL5FmYdKZogN9.E.FBBN3d7DAC', '+1555876543', FALSE, '2023-04-05 16:45:00'),
('55555555-5555-5555-5555-555555555555', 'Sarah', 'Williams', 'sarah.w@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MQRqQzL5FmYdKZogN9.E.FBBN3d7DAC', NULL, FALSE, '2023-05-20 11:20:00');

-- Insert Host Profiles
INSERT INTO host_profile (host_id, user_id, host_description, host_since, is_superhost, verification_status) VALUES
-- John is a verified host
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 'Experienced host with multiple properties in downtown area. Love meeting new people!', '2023-02-20 00:00:00', TRUE, 'verified'),

-- Emily is a pending host
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '33333333-3333-3333-3333-333333333333', 'New host with a cozy beachfront cottage. Passionate about hospitality.', '2023-03-15 00:00:00', FALSE, 'pending'),

-- Michael is a superhost
('cccccccc-cccc-cccc-cccc-cccccccccccc', '44444444-4444-4444-4444-444444444444', 'Professional host with luxury properties. 5-star service guaranteed.', '2023-04-10 00:00:00', TRUE, 'verified');

-- Insert Properties
INSERT INTO property (property_id, host_id, name, description, location, price_per_night, created_at, updated_at) VALUES
-- John's properties
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Downtown Luxury Loft', 'Spacious loft with amazing city views. 2 bedrooms, modern kitchen, and rooftop access.', '123 Main St, New York, NY', 250.00, '2023-02-25 10:00:00', '2023-06-01 09:30:00'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Cozy Studio Apartment', 'Perfect for solo travelers. Centrally located with all amenities.', '456 Elm St, New York, NY', 120.00, '2023-03-05 14:00:00', '2023-05-15 16:45:00'),

-- Emily's property
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Beachfront Cottage', 'Charming cottage steps from the beach. Private patio and ocean views.', '789 Ocean Dr, Miami, FL', 180.00, '2023-03-20 09:00:00', '2023-04-10 11:20:00'),

-- Michael's properties
('gggggggg-gggg-gggg-gggg-gggggggggggg', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Luxury Penthouse', 'Ultra-modern penthouse with panoramic views. 3 bedrooms, infinity pool.', '101 Skyline Blvd, Los Angeles, CA', 500.00, '2023-04-15 12:00:00', '2023-05-20 14:30:00'),
('hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mountain Retreat', 'Secluded cabin with hot tub and mountain views. Perfect for nature lovers.', '202 Forest Ln, Aspen, CO', 220.00, '2023-05-01 08:00:00', '2023-05-25 10:15:00');

-- Insert Payment Methods
INSERT INTO payment_method (method_id, user_id, type, last_four, expiry_date, is_default, created_at) VALUES
-- John's payment methods
('iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii', '22222222-2222-2222-2222-222222222222', 'credit_card', '4242', '2025-12-01', TRUE, '2023-02-16 11:00:00'),
('jjjjjjjj-jjjj-jjjj-jjjj-jjjjjjjjjjjj', '22222222-2222-2222-2222-222222222222', 'paypal', NULL, NULL, FALSE, '2023-03-10 15:30:00'),

-- Emily's payment method
('kkkkkkkk-kkkk-kkkk-kkkk-kkkkkkkkkkkk', '33333333-3333-3333-3333-333333333333', 'credit_card', '5555', '2024-10-01', TRUE, '2023-03-12 09:45:00'),

-- Michael's payment methods
('llllllll-llll-llll-llll-llllllllllll', '44444444-4444-4444-4444-444444444444', 'credit_card', '3782', '2026-05-01', TRUE, '2023-04-06 14:20:00'),
('mmmmmmmm-mmmm-mmmm-mmmm-mmmmmmmmmmmm', '44444444-4444-4444-4444-444444444444', 'stripe', NULL, NULL, FALSE, '2023-05-15 10:10:00'),

-- Sarah's payment method
('nnnnnnnn-nnnn-nnnn-nnnn-nnnnnnnnnnnn', '55555555-5555-5555-5555-555555555555', 'credit_card', '1111', '2025-08-01', TRUE, '2023-05-21 16:00:00');

-- Insert Bookings
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, status, created_at) VALUES
-- Completed booking (Sarah stayed at John's loft)
('oooooooo-oooo-oooo-oooo-oooooooooooo', 'dddddddd-dddd-dddd-dddd-dddddddddddd', '55555555-5555-5555-5555-555555555555', '2023-06-10', '2023-06-15', 'completed', '2023-05-25 14:00:00'),

-- Upcoming booking (Sarah booked Emily's cottage)
('pppppppp-pppp-pppp-pppp-pppppppppppp', 'ffffffff-ffff-ffff-ffff-ffffffffffff', '55555555-5555-5555-5555-555555555555', '2023-07-20', '2023-07-25', 'confirmed', '2023-06-05 10:30:00'),

-- Canceled booking (Michael tried to book his own property - would fail the check constraint)
-- ('qqqqqqqq-qqqq-qqqq-qqqq-qqqqqqqqqqqq', 'gggggggg-gggg-gggg-gggg-gggggggggggg', '44444444-4444-4444-4444-444444444444', '2023-08-01', '2023-08-07', 'canceled', '2023-05-28 16:45:00'),

-- Current booking (John staying at Michael's mountain retreat)
('rrrrrrrr-rrrr-rrrr-rrrr-rrrrrrrrrrrr', 'hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', '22222222-2222-2222-2222-222222222222', '2023-06-01', '2023-06-08', 'confirmed', '2023-05-20 09:15:00');

-- Insert Payments
INSERT INTO payment (payment_id, booking_id, method_id, amount, payment_date, status) VALUES
-- Payment for Sarah's completed stay
('ssssssss-ssss-ssss-ssss-ssssssssssss', 'oooooooo-oooo-oooo-oooo-oooooooooooo', 'nnnnnnnn-nnnn-nnnn-nnnn-nnnnnnnnnnnn', 1250.00, '2023-05-25 14:05:00', 'completed'),

-- Payment for Sarah's upcoming stay (deposit)
('tttttttt-tttt-tttt-tttt-tttttttttttt', 'pppppppp-pppp-pppp-pppp-pppppppppppp', 'nnnnnnnn-nnnn-nnnn-nnnn-nnnnnnnnnnnn', 360.00, '2023-06-05 10:35:00', 'completed'),

-- Payment for John's current stay
('uuuuuuuu-uuuu-uuuu-uuuu-uuuuuuuuuuuu', 'rrrrrrrr-rrrr-rrrr-rrrr-rrrrrrrrrrrr', 'iiiiiiii-iiii-iiii-iiii-iiiiiiiiiiii', 1540.00, '2023-05-20 09:20:00', 'completed');

-- Insert Reviews
INSERT INTO review (review_id, property_id, user_id, rating, comment, created_at) VALUES
-- Sarah's review of John's loft
('vvvvvvvv-vvvv-vvvv-vvvv-vvvvvvvvvvvv', 'dddddddd-dddd-dddd-dddd-dddddddddddd', '55555555-5555-5555-5555-555555555555', 5, 'Amazing stay! The loft was even better than pictured. John was a fantastic host.', '2023-06-16 10:00:00'),

-- John's review of Michael's mountain retreat
('wwwwwwww-wwww-wwww-wwww-wwwwwwwwwwww', 'hhhhhhhh-hhhh-hhhh-hhhh-hhhhhhhhhhhh', '22222222-2222-2222-2222-222222222222', 4, 'Beautiful location and very peaceful. The hot tub was perfect after hiking.', '2023-06-09 14:30:00');

-- Insert Messages
INSERT INTO message (message_id, sender_id, recipient_id, message_body, is_read, sent_at) VALUES
-- Conversation between Sarah and John about the loft
('xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx', '55555555-5555-5555-5555-555555555555', '22222222-2222-2222-2222-222222222222', 'Hi John, I''m interested in your loft for June 10-15. Is it available?', TRUE, '2023-05-20 09:00:00'),
('yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy', '22222222-2222-2222-2222-222222222222', '55555555-5555-5555-5555-555555555555', 'Hi Sarah! Yes, those dates are open. Would you like to book it?', TRUE, '2023-05-20 11:30:00'),
('zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz', '55555555-5555-5555-5555-555555555555', '22222222-2222-2222-2222-222222222222', 'Yes please! I''ll make the booking now.', TRUE, '2023-05-20 12:15:00'),

-- Conversation between Sarah and Emily about the beach cottage
('11111111-1111-1111-1111-111111111112', '55555555-5555-5555-5555-555555555555', '33333333-3333-3333-3333-333333333333', 'Hello Emily, your cottage looks lovely! Is July 20-25 available?', FALSE, '2023-06-01 14:00:00'),
('11111111-1111-1111-1111-111111111113', '33333333-3333-3333-3333-333333333333', '55555555-5555-5555-5555-555555555555', 'Hi Sarah! Yes, those dates are open. Would you like to proceed?', TRUE, '2023-06-01 16:45:00');
