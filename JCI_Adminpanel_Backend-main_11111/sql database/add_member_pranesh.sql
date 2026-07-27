-- Add member: Pranesh (can login in mobile app)
-- Email:    pranesh@gmail.com
-- Phone:    934567813
-- Password: 123456  (change after first login)

USE jci;

INSERT INTO `Member` (
  `profile_pic`,
  `user_name`,
  `email`,
  `contact`,
  `gender`,
  `role`,
  `type`,
  `status`,
  `createdAt`,
  `updatedAt`
) VALUES (
  '/images/placeholder.jpg',
  'Pranesh',
  'pranesh@gmail.com',
  '+91934567813',
  'male',
  'member',
  'member',
  'active',
  NOW(),
  NOW()
);

INSERT INTO `MemberAuth` (
  `member_id`,
  `password_hash`,
  `login_email`,
  `login_phone`,
  `is_setup_complete`,
  `createdAt`,
  `updatedAt`
) VALUES (
  LAST_INSERT_ID(),
  '$2b$10$0vspdq7tWYxZHEX/cUuo4OaljarwQSAY1PT7g7B7aKil7ndo5p8em',
  'pranesh@gmail.com',
  '+91934567813',
  1,
  NOW(),
  NOW()
);

SELECT m.id, m.user_name, m.email, m.contact, ma.is_setup_complete
FROM `Member` m
JOIN `MemberAuth` ma ON ma.member_id = m.id
WHERE m.email = 'pranesh@gmail.com';
