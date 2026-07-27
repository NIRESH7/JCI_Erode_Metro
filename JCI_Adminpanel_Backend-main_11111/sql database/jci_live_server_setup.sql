-- =============================================================================
-- JCI ? LIVE SERVER END-TO-END DATABASE SETUP
-- =============================================================================
-- Run this ONCE on a fresh MySQL 8.x server (as root or admin user).
--
-- What it does:
--   1. Creates database `jci` with all tables (mobile + admin + referral + fitness)
--   2. Seeds default admin account + sample data from production dump
--   3. Creates MySQL app user `jci_app` for the Node.js backend
--
-- HOW TO RUN (pick one):
--
--   A) MySQL Workbench
--      File -> Open SQL Script -> select this file -> Execute (lightning bolt)
--
--   B) Linux server CLI
--      mysql -u root -p < "jci_live_server_setup.sql"
--
--   C) phpMyAdmin
--      Import -> choose this file -> Go
--
-- BEFORE YOU RUN:
--   1. Change CHANGE_ME_STRONG_DB_PASSWORD below to a strong password
--   2. Use the SAME password in backend .env as HS_DB_PASSWORD
--
-- AFTER YOU RUN:
--   1. Set backend .env:
--        HS_DB_NAME=jci
--        HS_DB_HOST=127.0.0.1
--        HS_DB_USERNAME=jci_app
--        HS_DB_PASSWORD=<your password>
--   2. Start backend: npm start (or PM2)
--   3. Login to admin panel with:
--        Email:    admin@jci.local
--        Password: Admin@12345
--      (Change password after first login)
--
-- NOTE: This script DROPS database `jci` if it already exists.
-- =============================================================================

-- =============================================================================
-- PART 1: FULL SCHEMA + SEED DATA
-- (content merged from jci_complete_full_database.sql)
-- =============================================================================
-- JCI COMPLETE DATABASE (Mobile + Admin + Referral + Fitness)
-- HOW TO RUN: Press Ctrl+A to select ALL, then click Execute (lightning bolt)

DROP DATABASE IF EXISTS `jci`;
CREATE DATABASE `jci` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `jci`;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

CREATE TABLE `Admin` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email_id` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `user_type` enum('ROOT','USER') NOT NULL DEFAULT 'USER',
  `status` enum('active','inactive','terminated') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Admin`
--

INSERT INTO `Admin` (`id`, `email_id`, `phone`, `username`, `password`, `user_type`, `status`, `createdAt`, `updatedAt`) VALUES
(1, 'jcierodegreencity@gmail.com', '+919994388355', 'greencity', '$2b$10$wKnTIwfWyIYzhJaDS89rGevEPyAQg6RTG0BVfht965Sqy9S7X.UUq', 'ROOT', 'active', '2021-12-14 07:22:37', '2021-12-14 07:22:37');

-- --------------------------------------------------------

--
-- Table structure for table `Banners`
--

CREATE TABLE `Banners` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `banner_image` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Banners`
--

INSERT INTO `Banners` (`id`, `banner_image`, `createdAt`, `updatedAt`) VALUES
(3, 'https://jcierodegreencity.in/images/JCI1641554251764.jpeg', '2022-01-07 11:17:31', '2022-01-07 11:17:31'),
(10, 'https://jcierodegreencity.in/images/JCI1674918140659.jpg', '2023-01-28 15:02:21', '2023-01-28 15:02:21'),
(11, 'https://jcierodegreencity.in/images/JCI1676041385735.jpg', '2023-02-10 15:03:06', '2023-02-10 15:03:06'),
(13, 'https://jcierodegreencity.in/images/JCI1676984818249.jpg', '2023-02-21 13:06:58', '2023-02-21 13:06:58'),
(14, 'https://jcierodegreencity.in/images/JCI1676984925218.jpg', '2023-02-21 13:08:45', '2023-02-21 13:08:45'),
(15, 'https://jcierodegreencity.in/images/JCI1676985117396.jpg', '2023-02-21 13:11:58', '2023-02-21 13:11:58'),
(16, 'https://jcierodegreencity.in/images/JCI1676985310669.jpg', '2023-02-21 13:15:11', '2023-02-21 13:15:11'),
(17, 'https://jcierodegreencity.in/images/JCI1676985565780.jpg', '2023-02-21 13:19:26', '2023-02-21 13:19:26');

-- --------------------------------------------------------

--
-- Table structure for table `BloodReq`
--

CREATE TABLE `BloodReq` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `NameOfPatient` varchar(255) NOT NULL,
  `BloodGroup` varchar(255) NOT NULL,
  `NoOfUnits` varchar(255) NOT NULL,
  `Hospital_name` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `Contact` varchar(255) NOT NULL,
  `Attender` varchar(255) NOT NULL,
  `VerifiedBy` varchar(255) DEFAULT '',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `BloodReq`
--

INSERT INTO `BloodReq` (`id`, `NameOfPatient`, `BloodGroup`, `NoOfUnits`, `Hospital_name`, `location`, `Contact`, `Attender`, `VerifiedBy`, `createdAt`, `updatedAt`) VALUES
(1, 'Logesh R', 'A+', '3', 'sudha', 'Perundurai Road', '8668171024', 'Raja', 'kowsi', '2024-03-11 11:31:11', '2024-03-11 11:31:11'),
(2, 'Logesh R', 'A+', '3', 'erode medical', 'Perundurai Road', '8668171024', 'Raja', NULL, '2024-03-11 11:31:11', '2024-03-11 11:31:11'),
(3, 'Logesh R', 'A+', '3', 'gh', 'Perundurai Road', '8668171024', 'Raja', NULL, '2024-03-11 11:31:39', '2024-03-11 11:31:39'),
(4, 'Logesh R', 'A+', '3', 'sudha', 'Perundurai Road', '8668171024', 'Raja', NULL, '2024-03-11 11:35:35', '2024-03-11 11:35:35'),
(5, 'Logesh R', 'A+', '3', 'sudha', 'Perundurai Road', '8668171024', 'Raja', NULL, '2024-03-11 11:35:35', '2024-03-11 11:35:35'),
(6, 'kowsi', 'B+', '1', 'sudha', 'Perundurai Road, Erode', '1234567890', 'ABCD', NULL, '2024-03-11 11:38:13', '2024-03-11 11:38:13');

-- --------------------------------------------------------

--
-- Table structure for table `boardMembers`
--

CREATE TABLE `boardMembers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `BusinessType`
--

CREATE TABLE `BusinessType` (
  `id` int(11) NOT NULL,
  `Business_category` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `BusinessType`
--

INSERT INTO `BusinessType` (`id`, `Business_category`, `department`, `createdAt`, `updatedAt`) VALUES
(1, 'banking', 'manager', '2024-03-13 10:03:32', '2024-03-13 10:03:32'),
(2, 'college', 'student', '2024-03-13 10:03:51', '2024-03-13 10:03:51'),
(3, 'college', 'lecturer', '2024-03-13 10:04:04', '2024-03-13 10:04:04'),
(4, 'banking ', 'clerk', '2024-03-13 10:04:32', '2024-03-13 10:04:32'),
(5, 'banking', 'sales staff', '2024-03-13 10:04:43', '2024-03-13 10:04:43');

-- --------------------------------------------------------

--
-- Table structure for table `Designation`
--

CREATE TABLE `Designation` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `designation_name` varchar(255) NOT NULL,
  `designation_year` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Designation`
--

INSERT INTO `Designation` (`id`, `member_id`, `designation_name`, `designation_year`, `createdAt`, `updatedAt`) VALUES
(1, 92, 'Past President', '1992', '2022-03-21 16:35:28', '2022-03-21 16:35:28'),
(2, 93, '', '1994', '2022-03-21 16:35:45', '2022-03-21 16:35:45'),
(3, 92, 'President', '1993', '2022-03-21 16:40:08', '2022-03-21 16:40:08'),
(4, 22, 'Past President', '2011', '2022-03-21 16:40:54', '2022-03-21 16:40:54'),
(5, 23, '', '2016', '2022-03-21 16:41:11', '2022-03-21 16:41:11'),
(6, 24, '', '2017', '2022-03-21 16:41:24', '2022-03-21 16:41:24'),
(7, 34, '', '2000', '2022-03-21 16:41:37', '2022-03-21 16:41:37'),
(8, 1, 'President', '2022', '2022-03-21 16:42:16', '2022-03-21 16:42:16'),
(9, 31, 'Past President', '2019', '2022-03-21 16:42:33', '2022-03-21 16:42:33'),
(10, 27, '', '2020', '2022-03-21 16:42:43', '2022-03-21 16:42:43'),
(11, 2, 'Past President', '2021', '2022-03-21 16:47:54', '2022-03-21 16:47:54'),
(12, 94, 'Past President', '1995', '2022-03-21 16:56:03', '2022-03-21 16:56:03'),
(13, 95, 'Past President', '1996', '2022-03-21 17:03:02', '2022-03-21 17:03:02'),
(14, 97, 'Past President', '2003', '2022-03-22 08:47:52', '2022-03-22 08:47:52'),
(15, 96, '', '2001', '2022-03-22 08:48:52', '2022-03-22 08:48:52'),
(16, 98, 'Past President', '2004', '2022-03-22 08:59:12', '2022-03-22 08:59:12'),
(17, 99, 'Past President', '2005', '2022-03-22 09:04:26', '2022-03-22 09:04:26'),
(18, 100, 'Past President', '2006', '2022-03-22 09:14:16', '2022-03-22 09:14:16'),
(19, 101, 'Past President', '2007', '2022-03-22 09:20:33', '2022-03-22 09:20:33'),
(20, 102, 'Past President', '2008', '2022-03-22 09:30:43', '2022-03-22 09:30:43'),
(21, 103, 'Past President', '2009', '2022-03-22 09:40:55', '2022-03-22 09:40:55'),
(22, 104, 'Past President', '2015', '2022-03-22 10:04:09', '2022-03-22 10:04:09'),
(23, 105, 'Past President', '2018', '2022-03-22 10:11:47', '2022-03-22 10:11:47'),
(24, 106, 'Past President', '2012', '2022-03-22 10:13:48', '2022-03-22 10:13:48'),
(25, 1, 'Past President', '2023', '2023-02-21 13:23:16', '2023-02-21 13:23:16'),
(26, 1, 'Immediate Past President', '2023', '2023-02-21 13:30:27', '2023-02-21 13:30:27');

-- --------------------------------------------------------

--
-- Table structure for table `Events`
--

CREATE TABLE `Events` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_image` varchar(255) NOT NULL,
  `event_date` varchar(255) NOT NULL,
  `event_time` varchar(255) NOT NULL,
  `event_location` varchar(255) NOT NULL,
  `event_desc` text NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Events`
--

INSERT INTO `Events` (`id`, `event_name`, `event_image`, `event_date`, `event_time`, `event_location`, `event_desc`, `createdAt`, `updatedAt`) VALUES
(5, '1st Regular Meeting - PONGAL Celebration', 'https://jcierodegreencity.in/images/JCI1641554798722.jpeg', '07/01/2022', '06:30 PM', 'Sivagami Sengottiya Mahal, Erode', 'Pongal celebrations with Traditional Games ', '2022-01-07 11:26:41', '2022-01-07 11:26:41'),
(6, '6th REGULAR MEETING ', 'https://jcierodegreencity.in/images/JCI1648827410199.png', '26/03/2022', '08:00 PM', 'Rotary CD Hall, Palayapalayam', '6th Regular Meeting of 2022.\r\nChief Guest - Mr Palani (Vijay TV Kalakakkapovathu Yaaru fame)', '2022-03-21 07:28:45', '2022-04-01 15:36:54'),
(7, 'BUTTER MILK DISTRIBUTION - MARIAMMAN FESTIVAL', 'https://jcierodegreencity.in/images/JCI1648816052898.png', '02/04/2022', '01:00 PM', 'Opposite to Periaya Mariamman Kovil, Meenakshi Sundaranar Road', 'Buttermilk is to be served to the devotees of Mariamman.', '2022-04-01 12:27:39', '2022-04-01 12:27:39'),
(8, '7th Regular Meeting - B2B', 'https://jcierodegreencity.in/images/JCI1649385007403.jpg', '08/04/2022', '08:00 PM', 'Rotary CD Hall, Palayapalayam', '7th Regular meeting', '2022-04-08 02:30:12', '2022-04-08 02:30:12'),
(9, 'World Health Day - Dental Camp at CN College', 'https://jcierodegreencity.in/images/JCI1649414089093.jpg', '07/04/2022', '02:00 PM', 'Chikkaiah Naicker College', 'Dental Camp for the students of CN College', '2022-04-08 10:34:54', '2022-04-08 10:34:54'),
(10, 'FUTURE Phase 11', 'https://jcierodegreencity.in/images/JCI1649414189885.jpg', '08/04/2022', '09:30 AM', 'Vellalar Engineering College', 'FUTURE Training for the students of Vellalar Engineering College', '2022-04-08 10:36:32', '2022-04-08 10:36:32'),
(11, 'FUTURE Phase 12', 'https://jcierodegreencity.in/images/JCI1649414251834.jpg', '08/04/2022', '09:30 AM', 'Vellalar Engineering College', 'FUTURE Training for the students of Vellalar Engineering College', '2022-04-08 10:37:34', '2022-04-08 10:37:34'),
(12, 'FUTURE Phase 13', 'https://jcierodegreencity.in/images/JCI1649414341526.jpg', '08/04/2022', '09:30 AM', 'Vellalar Engineering College', 'FUTURE Training for the students of Vellalar Engineering College', '2022-04-08 10:39:04', '2022-04-08 10:39:04'),
(13, 'FUTURE Phase 14', 'https://jcierodegreencity.in/images/JCI1649414396543.jpg', '08/04/2022', '09:30 AM', 'Vellalar Engineering College', 'FUTURE Training for the students of Vellalar Engineering College', '2022-04-08 10:40:00', '2022-04-08 10:40:00'),
(14, 'FUTURE Phase 15', 'https://jcierodegreencity.in/images/JCI1649414455205.jpg', '08/04/2022', '09:30 AM', 'Vellalar Engineering College ', 'FUTURE Training for the students of Vellalar Engineering College', '2022-04-08 10:40:57', '2022-04-08 10:40:57'),
(15, 'Junior Jaycee Bulletin ARUMBU March Edition Release', 'https://jcierodegreencity.in/images/JCI1649840267896.jpg', '11/04/2022', '10:30 AM', 'Government High School Valayapalayam', 'March edition of Junior Jaycee Bulletin Arumbu was released. ', '2022-04-13 08:57:52', '2022-04-13 08:57:52'),
(16, 'Blood Donation Camp - Vellalar Engineering College', 'https://jcierodegreencity.in/images/JCI1649840574898.jpg', '12/04/2022', '10:00 AM', 'Vellalar Engineering College', 'Blood camp was conducted at Vellalar Engineering College. 161 units of blood was collected.', '2022-04-13 09:02:56', '2022-04-13 09:02:56'),
(17, 'Blood Donation Camp - Chikkaiah Naicker College', 'https://jcierodegreencity.in/images/JCI1649840663605.jpg', '13/04/2022', '10:00 AM', 'Chikkaiah Naicker College', 'Blood camp was organized at Chikkaiah Naicker College. 30 units of blood was collected.', '2022-04-13 09:04:25', '2022-04-13 09:04:25'),
(18, 'Salute the Silent Worker - Honoring Bus Drivers and Conductors', 'https://jcierodegreencity.in/images/JCI1649908819939.jpg', '14/04/2022', '05:00 PM', 'Bus Stand, Erode', 'Honoring Bus drivers and conductors who work on Public Holidays (Festivals)', '2022-04-14 04:00:34', '2022-04-14 04:00:34'),
(19, 'Salute the Silent Worker - Honoring Railway Staffs', 'https://jcierodegreencity.in/images/JCI1649908942292.jpg', '14/04/2022', '06:00 PM', 'Railway Station, Erode', 'Honoring Railway staffs who work on public holidays (festivals)', '2022-04-14 04:02:27', '2022-04-14 04:02:27'),
(20, 'JCI Action Framework', 'https://jcierodegreencity.in/images/JCI1649909181121.jpg', '17/04/2022', '05:00 PM', 'Central Lions Hall, Veerappampalayam', 'ID program on JCI Action Framework ', '2022-04-14 04:06:27', '2022-04-14 04:06:27'),
(21, 'Women\'s Readers Club', 'https://jcierodegreencity.in/images/JCI1650342024948.jpg', '20/04/2022', '10:00 AM', 'Digital Library Sampath Nagar', 'Inauguration of Readers Club', '2022-04-19 04:20:33', '2022-04-19 04:20:33'),
(22, 'Blood Donation - Sasurie Engineering College', 'https://jcierodegreencity.in/images/JCI1650387653575.jpg', '20/04/2022', '10:15 AM', 'Sasurie Engineering College Vijayamangalam', 'Blood Donation Camp at Sasurie Engineering College', '2022-04-19 17:01:08', '2022-04-19 17:01:08'),
(23, '8th Regular Meeting - Pattimandram', 'https://jcierodegreencity.in/images/JCI1650473978224.jpg', '22/04/2022', '08:00 PM', 'Rotary CD Hall, Palayapalayam', '8th Regular Meeting of 2022', '2022-04-20 16:59:40', '2022-04-20 16:59:40'),
(24, 'Cooking Competition for Kids', 'https://jcierodegreencity.in/images/JCI1650601278481.jpg', '22/04/2022', '06:30 PM', 'Rotary CD Hall, Palayapalayam', 'Cooking Without Fire - A cooking Competition for Kids', '2022-04-22 04:21:42', '2022-04-22 04:21:42'),
(25, 'National President Official Visit', 'https://jcierodegreencity.in/images/JCI1650722043433.jpg', '24/04/2022', '07:30 PM', 'Sivagami Sengottaiyan Mahal, Veerappampalayam', 'JCI India President JFS Anshu Saraf is on an official visit to meet the Jaycees of Erode', '2022-04-23 13:54:07', '2022-04-23 13:54:07'),
(26, 'FUTURE Phase 16 to 26', 'https://jcierodegreencity.in/images/JCI1650723320205.jpg', '25/04/2022', '01:00 PM', 'Erode Arts and Science College, Rangampalayam', '11 Phases of Future Training Sessions for the Students of Erode Arts and Science College', '2022-04-23 13:56:27', '2022-04-23 14:15:28'),
(27, 'Junior Jaycee Wing Installation - Surya Engineering College', 'https://jcierodegreencity.in/images/JCI1650945450647.jpg', '27/04/2022', '10:00 AM', 'Surya Engineering College, Mettukadai', 'Inauguration and Installation of 2nd Junior Jaycee Wing of 2022', '2022-04-26 03:57:43', '2022-04-26 03:57:43'),
(28, 'Thread Jewellery Making Session', 'https://jcierodegreencity.in/images/JCI1651152890915.jpg', '29/04/2022', '10:00 AM', 'VU Dental Care, Sampath Nagar', 'Skill Development Session on Thread Jewellery Making for our Lady Jcs', '2022-04-28 13:35:17', '2022-04-28 13:35:17'),
(29, 'Happy Parenting', 'https://jcierodegreencity.in/images/JCI1651153228247.jpg', '29/04/2022', '11:00 AM', 'VU Dental Care, Sampath Nagar', 'Happy Parenting ID Session to our members', '2022-04-28 13:41:15', '2022-04-28 13:41:15'),
(30, 'Junior Jaycee Bulletin ARUMBU April Edition Release', 'https://jcierodegreencity.in/images/JCI1651664980447.jpg', '05/05/2022', '11:00 AM', 'Government High School, Valayapalayam', 'April month edition of Junior Jaycee Bulletin Arumbu', '2022-05-04 11:49:42', '2022-05-04 11:49:42'),
(31, 'Trio Business Day 1 - B2B', 'https://jcierodegreencity.in/images/JCI1651853340705.jpg', '07/05/2022', '12:00 PM', 'Smartkids Pregnancy Caring Center', 'Trio Business  Day 1 - B2B', '2022-05-06 16:09:02', '2022-05-06 16:09:02'),
(32, 'Trio Business Day 1 - Virtual Business Expo', 'https://jcierodegreencity.in/images/JCI1651853855694.jpg', '07/05/2022', '01:00 PM', 'Zoom', 'Trio Business Day 1 - Virtual Business Expo', '2022-05-06 16:11:18', '2022-05-06 16:17:37'),
(33, 'Trio Business Day 1 - Role of Ethics in Business', 'https://jcierodegreencity.in/images/JCI1651853682682.jpg', '07/05/2022', '02:00 PM', 'Smartkids Pregnancy Caring Center', 'Trio Business Day 1 - Business Seminar on Ethics in Business', '2022-05-06 16:14:44', '2022-05-06 16:14:44'),
(34, 'Business Directory App Release', 'https://jcierodegreencity.in/images/JCI1651930543236.jpg', '07/05/2022', '06:00 PM', 'Tiptop Erode', 'JCI Erode Greencity Mobile app released by EA to JCI President JCI PPP Kaveen Kumar', '2022-05-07 13:35:46', '2022-05-07 13:35:46'),
(35, 'Region G Multi LO Business Training Seminar', 'https://jcierodegreencity.in/images/JCI1651930638063.jpg', '07/05/2022', '06:00 PM', 'Zoom', 'Multi LO Business ID', '2022-05-07 13:37:19', '2022-05-07 13:37:19'),
(36, 'Trio Business Day 2 - Startup Training with MSME', 'https://jcierodegreencity.in/images/JCI1651978713196.jpg', '08/05/2022', '09:00 AM', 'SSKV @ Associates', 'Trio Business Day 2 - Startup Training with MSME', '2022-05-08 02:58:36', '2022-05-08 02:58:36'),
(39, 'Trio Business Day 2 - Training on 5S', 'https://jcierodegreencity.in/images/JCI1651984737362.jpg', '08/05/2022', '12:00 PM', 'Toco India, Nasiyanur', 'Trio Business Day 2 - Training on 5S', '2022-05-08 04:38:59', '2022-05-08 04:38:59'),
(40, 'Trio Business Day 2 - Training on Quality Assurance', 'https://jcierodegreencity.in/images/JCI1651995686992.jpg', '08/05/2022', '03:00 PM', 'Toco India, Nasiyanur', 'Trio Business Day 2 - Training on Quality Assurance', '2022-05-08 07:41:30', '2022-05-08 07:41:30'),
(41, 'Trio Business Day 2 - Commodities Trading', 'https://jcierodegreencity.in/images/JCI1652003438097.jpg', '08/05/2022', '05:00 PM', 'Snackers', 'Trio Business Day 2 - Commodities Trading', '2022-05-08 09:50:39', '2022-05-08 09:50:39'),
(42, 'Trio Business Day 3 - Session on Digital Marketing', 'https://jcierodegreencity.in/images/JCI1652091186547.jpg', '09/05/2022', '09:00 AM', 'Kongu Engineering College', 'Trio Business Day 3 - Session on Digital Marketing', '2022-05-09 10:13:08', '2022-05-09 10:13:08'),
(43, 'Trio Business Day 3 - Session on Safe E-Commerce', 'https://jcierodegreencity.in/images/JCI1652091275910.jpg', '09/05/2022', '10:00 AM', 'Kongu Engineering College', 'Trio Business Day 3 - Session on Safe e-commerce', '2022-05-09 10:14:39', '2022-05-09 10:14:39'),
(44, 'Trio Business Day 3 - Session on Cash Less Society', 'https://jcierodegreencity.in/images/JCI1652091387327.jpg', '09/05/2022', '12:00 PM', 'Rotary CD Hall', 'Trio Business Day 3 - Session on Cash Less Society', '2022-05-09 10:16:29', '2022-05-09 10:16:29'),
(45, 'Trio Business Day 3 - Session on Cyber Security', 'https://jcierodegreencity.in/images/JCI1652091509879.jpg', '09/05/2022', '12:00 PM', 'Nutz Technovation', 'Trio Business Day 3 - Session on Cyber Security ', '2022-05-09 10:18:31', '2022-05-09 10:18:31'),
(46, 'Craft Making Session for Kids', 'https://jcierodegreencity.in/images/JCI1652365155751.jpg', '13/05/2022', '06:00 PM', 'Rotary CD Hall, Palayapalayam', 'Craft Making Session for Kids', '2022-05-12 14:19:18', '2022-05-12 14:19:18'),
(47, '9th Regular Meeting - We are Watching', 'https://jcierodegreencity.in/images/JCI1652365241648.jpg', '13/05/2022', '08:00 PM', 'Rotary CD Hall, Palayapalayam ', 'A Meeting on Ethical Hacking', '2022-05-12 14:20:43', '2022-05-12 14:20:43'),
(48, 'ID Session - Cyber Security', 'https://jcierodegreencity.in/images/JCI1652858394825.jpg', '18/05/2022', '02:00 PM', 'Vellalar Engineering College, Thindal', 'Training program on Cyber Security', '2022-05-18 07:19:57', '2022-05-18 07:19:57'),
(49, 'Aavin Industrial Visit', 'https://jcierodegreencity.in/images/JCI1653100892154.jpg', '21/05/2022', '10:30 AM', 'Aavin, Chithode', 'Industrial Visit for our members to Aavin Industrial Plant', '2022-05-21 02:41:34', '2022-05-21 02:41:34'),
(50, 'Training Day - Leading Is Our Duty', 'https://jcierodegreencity.in/images/JCI1653291232527.jpg', '23/05/2022', '03:00 PM', 'Vellalar Engineering College  Thindal ', 'National Training Day Program', '2022-05-23 07:33:55', '2022-05-23 07:33:55'),
(51, 'Prayas Day - Sanitary Napkin Distribution', 'https://jcierodegreencity.in/images/JCI1653743355761.jpg', '28/05/2022', '04:00 PM', 'PeriyaSemur', 'Donation of Sanitary Napkins to Women', '2022-05-28 13:09:17', '2022-05-28 13:09:17'),
(52, '10th Regular Meeting - Fun with Family', 'https://jcierodegreencity.in/images/JCI1653743573174.jpg', '29/05/2022', '10:00 AM', 'Coco Paradise, Kavundapadi', '10th Regular Meeting of 2022', '2022-05-28 13:12:56', '2022-05-28 13:12:56'),
(53, 'JCOM Orientation', 'https://jcierodegreencity.in/images/JCI1653749257068.jpg', '29/05/2022', '02:30 PM', 'Zoom', 'A session about JCOM', '2022-05-28 14:47:38', '2022-05-28 14:47:38'),
(54, 'Business to Business (B2B)', 'https://jcierodegreencity.in/images/JCI1653749376855.jpg', '29/05/2022', '03:30 PM', 'Zoom', 'Business to Business Meet among Women Enterpreneurs', '2022-05-28 14:49:38', '2022-05-28 14:49:38'),
(55, 'Woolen Thread Craft Session', 'https://jcierodegreencity.in/images/JCI1654918080118.jpg', '11/06/2022', '06:00 PM', 'Rotary CD Hall, Palayapalayam ', 'Woolen Thread Craft Making Session by Mrs Vinothini Arulmatheswaran', '2022-06-11 03:28:02', '2022-06-11 03:28:02'),
(56, '12th Regular Meeting - Lead A Healthy Life', 'https://jcierodegreencity.in/images/JCI1654918193530.jpg', '11/06/2022', '08:00 PM', 'Rotary CD Hall, Palayapalayam ', 'Lead a Healthy Life session by Dr Ranjit Nataesh', '2022-06-11 03:29:55', '2022-06-11 03:29:55'),
(57, 'Effective Public Speaking', 'https://jcierodegreencity.in/images/JCI1655266567839.jpg', '15/06/2022', '10:00 AM', 'Surya Engineering College ', '2 day EPS for Junior Jayceea at Surya Engineering College ', '2022-06-15 04:16:08', '2022-06-15 04:16:08'),
(58, 'Inauguration & Installation of JCI Erode Penniyam', 'https://jcierodegreencity.in/images/JCI1657594825559.jpg', '12/07/2022', '11:00 AM', 'Rotary CD Hall, Palayapalayam', 'Installation of JCI Erode Penniyam', '2022-07-12 03:00:26', '2022-07-12 03:00:26'),
(59, '13th Regular Meeting - 30th Charter Day', 'https://jcierodegreencity.in/images/JCI1657881416450.jpg', '15/07/2022', '08:00 PM', 'Civil Engineers Association Hall, Palayapalayam', '30th Charter Day', '2022-07-15 10:36:58', '2022-07-15 10:36:58'),
(60, '14th Regular Meeting - Assertiveness', 'https://jcierodegreencity.in/images/JCI1658456006551.jpg', '22/07/2022', '08:00 PM', 'Rotary CD Hall, Palayapalayam', '14th Regular Meeting', '2022-07-22 02:13:27', '2022-07-22 02:13:27'),
(61, 'Color Paper Decor', 'https://jcierodegreencity.in/images/JCI1658456106735.jpg', '22/07/2022', '06:00 PM', 'Rotary CD Hall, Palayapalayam ', 'Color Paper Decoration session for ladies and kids', '2022-07-22 02:15:10', '2022-07-22 02:15:10'),
(62, 'Business Expo Inauguration', 'https://jcierodegreencity.in/images/JCI1658456216299.jpg', '22/07/2022', '05:30 PM', 'Gurusamy Gounder Kalyana Mandapam, Sengodampalayam', '4 day Home and Lifestyle Expo', '2022-07-22 02:16:58', '2022-07-22 02:16:58'),
(63, 'Pongal Day special debate', 'https://jcigreencity.cf/images/JCI1672941514948.jpg', '06/01/2023', '02:00 PM', 'Nandha Engineering College', 'Pongal Day Special Debate was organized by JCI Erode Greencity and Vasanth TV.\r\nFilm actor and Director Mr. Ramesh Khanna\r\nto be held under his leadership.', '2023-01-05 17:48:28', '2023-01-05 17:58:35'),
(64, 'Pongal Celebration ', 'https://jcierodegreencity.in/images/JCI1675869870147.jpg', '13/01/2023', '06:30 PM', 'Hotel Marina, Perundurai road, Erode', 'We cordially invite all the members to participate in the Pongal festival and games with their families to celebrate the festival.', '2023-01-11 14:32:16', '2023-02-08 15:24:31'),
(65, '2nd Regular Meeting - A Comedy Party', 'https://jcierodegreencity.in/images/JCI1674481451661.jpg', '27/01/2023', '08:00 PM', 'Rotary CD Hall, Palayapalayam', 'If there is no feeling of happiness\nLife becomes an unbearable burden.\n\nThus, Our 2nd annual meeting has been organized to entertain us.\nProfessor I.Selvam is going to entertain us all with the theme of \"Comedy Party\".', '2023-01-23 13:44:12', '2023-01-23 13:44:12'),
(66, 'Republic day Celebration', 'https://jcierodegreencity.in/images/JCI1674650776290.jpg', '26/01/2023', '08:00 AM', 'Government Elementry school, Veerappampalayam', 'We cordially invite all for the republic day celebration and our Chief guest JFM M.KARTHIK Past President will celebrate with us.', '2023-01-25 12:46:17', '2023-01-25 12:46:17'),
(67, 'Free Medical Counseling camp', 'https://jcierodegreencity.in/images/JCI1674916296657.jpg', '29/01/2023', '09:00 AM', 'Bharathi Education Institute nursery and primary school, Nasiyanur, Erode', 'We request everyone to participate and get benefitted from it.', '2023-01-28 14:31:37', '2023-01-28 14:31:37'),
(68, 'Free Eye treatment camp', 'https://jcierodegreencity.in/images/JCI1675507395862.jpg', '05/02/2023', '08:30 AM', 'Bharathi Education Institute Nursery and Primary school, Nasiyanur, Erode ', 'We request everyone to participate and get benefitted.', '2023-02-04 10:43:16', '2023-02-04 10:43:16'),
(69, '3rd Regular meeting - Ukkamadhu Kaividal', 'https://jcierodegreencity.in/images/JCI1675693614954.jpg', '10/02/2023', '08:00 PM', 'Rotary CD Hall, Palayapalayam, Erode', 'Our Chief guest A.Paari IPS., Former Inspector - General of Police will join with us and make the session more effective . All are requested to attend the meeting with your family.', '2023-02-06 14:26:55', '2023-02-06 14:26:55'),
(70, 'Free Blood donation camp', 'https://jcierodegreencity.in/images/JCI1675870383130.jpg', '09/02/2023', '08:30 AM', 'Vellalar Engineering and Technology college, Thindal, Erode', 'All are requested to attend the blood donation camp', '2023-02-08 15:33:04', '2023-02-08 15:33:04'),
(71, 'BREAK THE FEAR', 'https://jcierodegreencity.in/images/JCI1675924339503.jpg', '10/02/2023', '10:00 AM', 'The Richmond Public School, Perundurai, Erode.', 'The counselling for the students who are going to write Board exams.', '2023-02-09 06:32:20', '2023-02-09 06:32:20'),
(72, '4th Regular Meeting - Vanga Sirikalaam ', 'https://jcierodegreencity.in/images/JCI1676867352432.jpg', '24/02/2023', '08:00 PM', 'Rotary CD Hall, Palayapalayam, Erode.', '4 th Regular Meeting of 2023.\nChief guest - Mrs. Sasikala(Vijay Tv Kalakapovadhu Yaaru Fame)', '2023-02-20 04:29:13', '2023-02-20 04:29:13'),
(73, '5th Regular Meeting - Women\'s day celebration', 'https://jcierodegreencity.in/images/JCI1678372052838.jpg', '10/03/2023', '08:00 PM', 'Rotary CD Hall, Palayapalayam.', 'We take immense pleasure in inviting you all for the upcoming meeting in accordance to the celebration of women\'s day titled *The High Tides- The emotinal equilibrium* by  Ms Gousia A S  who is an ICF Certified Executive and Life coach, Certified Master Trainer &NLP Practitioner. An innovative session which will help women and men understand each other\'s emotion and deal with it in a productive way. ', '2023-03-09 14:27:33', '2023-03-09 14:27:33'),
(74, '6th Regular Meeting - H A P P I N E S S', 'https://jcierodegreencity.in/images/JCI1679313523395.jpg', '24/03/2023', '08:00 PM', 'Rotary CD Hall, Palayapalayam, Erode', 'We Immense happiness and we cordially invite the members to join in the meeting.', '2023-03-20 11:58:44', '2023-03-20 11:58:44'),
(75, 'SHETHON ', 'https://jcierodegreencity.in/images/JCI1679585590470.jpg', '26/03/2023', '05:30 AM', 'Vellalar Engineering college, Thindal, Erode', 'Here is the Rise Up Now \'Run for PCOD Awareness\' organised by JCI India Zone XVII hosted by Jaycees of Erode.', '2023-03-23 15:33:10', '2023-03-23 15:33:10'),
(76, 'Neer moor Festival', 'https://jcierodegreencity.in/images/JCI1680610870273.jpg', '08/04/2023', '01:00 PM', 'Periyamaariyamman kovil, Meenakshi sundaranaar road, Erode.', 'We request everyone to join us with this festival.', '2023-04-04 12:21:11', '2023-04-04 12:21:11'),
(77, '7th Regular Meeting - KIDNEY Health for All', 'https://jcierodegreencity.in/images/JCI1681301061604.jpg', '14/04/2023', '08:00 PM', 'Rotary CD Hall, Palayapalayam, Erode', 'We take immense pleasure in inviting you and your family members.', '2023-04-12 12:04:22', '2023-04-12 12:04:22'),
(78, '9th Regular Meeting - Andhi maalai Attrangarai Oram nilavudan', 'https://jcierodegreencity.in/images/JCI1683817795007.jpg', '12/05/2023', '08:00 PM', 'Rotary CD Hall, Palayapalayam, Erode', 'Chief Guest JFM Dr Raja D ', '2023-05-11 15:09:56', '2023-05-11 15:09:56'),
(79, '10th Regular Meeting - Valarungal Valara Vidungal', 'https://jcierodegreencity.in/images/JCI1685035411267.jpg', '26/05/2023', '08:00 PM', 'Rotary CD Hall, Palayapalayam, Erode', 'Chief Guest VidhyaDevi Jayaprakash', '2023-05-25 17:23:32', '2023-05-25 17:23:32');

-- --------------------------------------------------------

--
-- Table structure for table `eventsImage`
--

CREATE TABLE `eventsImage` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `event_id` bigint(20) UNSIGNED NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_image` varchar(255) NOT NULL,
  `status` enum('active','inactive','terminated') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `eventsImage`
--

INSERT INTO `eventsImage` (`id`, `event_id`, `event_name`, `event_image`, `status`, `createdAt`, `updatedAt`) VALUES
(1, 6, '6th REGULAR MEETING ', 'https://jcierodegreencity.in/images/JCI1648827508907.png', 'active', '2022-04-01 15:38:30', '2022-04-01 15:38:30'),
(2, 6, '6th REGULAR MEETING ', 'https://jcierodegreencity.in/images/JCI1648827533937.png', 'active', '2022-04-01 15:38:55', '2022-04-01 15:38:55'),
(3, 5, '1st Regular Meeting - PONGAL Celebration', 'https://jcierodegreencity.in/images/JCI1648827696024.png', 'active', '2022-04-01 15:41:38', '2022-04-01 15:41:38'),
(4, 5, '1st Regular Meeting - PONGAL Celebration', 'https://jcierodegreencity.in/images/JCI1648827759980.png', 'active', '2022-04-01 15:42:42', '2022-04-01 15:42:42'),
(5, 5, '1st Regular Meeting - PONGAL Celebration', 'https://jcierodegreencity.in/images/JCI1648827811180.png', 'active', '2022-04-01 15:43:33', '2022-04-01 15:43:33'),
(6, 5, '1st Regular Meeting - PONGAL Celebration', 'https://jcierodegreencity.in/images/JCI1648827850192.png', 'active', '2022-04-01 15:44:12', '2022-04-01 15:44:12'),
(7, 7, 'BUTTER MILK DISTRIBUTION - MARIAMMAN FESTIVAL', 'https://jcierodegreencity.in/images/JCI1649414527450.jpg', 'active', '2022-04-08 10:42:10', '2022-04-08 10:42:10'),
(8, 7, 'BUTTER MILK DISTRIBUTION - MARIAMMAN FESTIVAL', 'https://jcierodegreencity.in/images/JCI1649414640181.jpg', 'active', '2022-04-08 10:44:02', '2022-04-08 10:44:02'),
(9, 7, 'BUTTER MILK DISTRIBUTION - MARIAMMAN FESTIVAL', 'https://jcierodegreencity.in/images/JCI1649414802852.jpg', 'active', '2022-04-08 10:46:45', '2022-04-08 10:46:45'),
(10, 9, 'World Health Day - Dental Camp at CN College', 'https://jcierodegreencity.in/images/JCI1649414924124.jpg', 'active', '2022-04-08 10:48:46', '2022-04-08 10:48:46'),
(11, 9, 'World Health Day - Dental Camp at CN College', 'https://jcierodegreencity.in/images/JCI1649414966712.jpg', 'active', '2022-04-08 10:49:28', '2022-04-08 10:49:28'),
(12, 10, 'FUTURE Phase 11', 'https://jcierodegreencity.in/images/JCI1649415077757.jpg', 'active', '2022-04-08 10:51:19', '2022-04-08 10:51:19'),
(13, 10, 'FUTURE Phase 11', 'https://jcierodegreencity.in/images/JCI1649415117122.jpg', 'active', '2022-04-08 10:51:58', '2022-04-08 10:51:58'),
(14, 10, 'FUTURE Phase 11', 'https://jcierodegreencity.in/images/JCI1649415181098.jpg', 'active', '2022-04-08 10:53:03', '2022-04-08 10:53:03'),
(15, 11, 'FUTURE Phase 12', 'https://jcierodegreencity.in/images/JCI1649415258478.jpg', 'active', '2022-04-08 10:54:20', '2022-04-08 10:54:20'),
(16, 11, 'FUTURE Phase 12', 'https://jcierodegreencity.in/images/JCI1649415315027.jpg', 'active', '2022-04-08 10:55:16', '2022-04-08 10:55:16'),
(17, 11, 'FUTURE Phase 12', 'https://jcierodegreencity.in/images/JCI1649415361420.jpg', 'active', '2022-04-08 10:56:02', '2022-04-08 10:56:02'),
(18, 12, 'FUTURE Phase 13', 'https://jcierodegreencity.in/images/JCI1649415413360.jpg', 'active', '2022-04-08 10:56:54', '2022-04-08 10:56:54'),
(19, 12, 'FUTURE Phase 13', 'https://jcierodegreencity.in/images/JCI1649415474135.jpg', 'active', '2022-04-08 10:57:56', '2022-04-08 10:57:56'),
(20, 12, 'FUTURE Phase 13', 'https://jcierodegreencity.in/images/JCI1649415545938.jpg', 'active', '2022-04-08 10:59:07', '2022-04-08 10:59:07'),
(21, 13, 'FUTURE Phase 14', 'https://jcierodegreencity.in/images/JCI1649415699312.jpg', 'active', '2022-04-08 11:01:40', '2022-04-08 11:01:40'),
(22, 13, 'FUTURE Phase 14', 'https://jcierodegreencity.in/images/JCI1649415741324.jpg', 'active', '2022-04-08 11:02:23', '2022-04-08 11:02:23'),
(23, 13, 'FUTURE Phase 14', 'https://jcierodegreencity.in/images/JCI1649415767874.jpg', 'active', '2022-04-08 11:02:49', '2022-04-08 11:02:49'),
(24, 14, 'FUTURE Phase 15', 'https://jcierodegreencity.in/images/JCI1649415804984.jpg', 'active', '2022-04-08 11:03:26', '2022-04-08 11:03:26'),
(25, 14, 'FUTURE Phase 15', 'https://jcierodegreencity.in/images/JCI1649416099751.jpg', 'active', '2022-04-08 11:08:21', '2022-04-08 11:08:21'),
(26, 8, '7th Regular Meeting - B2B', 'https://jcierodegreencity.in/images/JCI1649840037658.jpg', 'active', '2022-04-13 08:54:00', '2022-04-13 08:54:00'),
(27, 8, '7th Regular Meeting - B2B', 'https://jcierodegreencity.in/images/JCI1649840075699.jpg', 'active', '2022-04-13 08:54:37', '2022-04-13 08:54:37'),
(28, 8, '7th Regular Meeting - B2B', 'https://jcierodegreencity.in/images/JCI1649840115973.jpg', 'active', '2022-04-13 08:55:20', '2022-04-13 08:55:20'),
(29, 15, 'Junior Jaycee Bulletin ARUMBU March Edition Release', 'https://jcierodegreencity.in/images/JCI1649840376495.jpg', 'active', '2022-04-13 08:59:38', '2022-04-13 08:59:38'),
(30, 15, 'Junior Jaycee Bulletin ARUMBU March Edition Release', 'https://jcierodegreencity.in/images/JCI1649840465493.jpg', 'active', '2022-04-13 09:01:06', '2022-04-13 09:01:06'),
(31, 16, 'Blood Donation Camp - Vellalar Engineering College', 'https://jcierodegreencity.in/images/JCI1649840782096.jpg', 'active', '2022-04-13 09:06:24', '2022-04-13 09:06:24'),
(32, 16, 'Blood Donation Camp - Vellalar Engineering College', 'https://jcierodegreencity.in/images/JCI1649840838753.jpg', 'active', '2022-04-13 09:07:21', '2022-04-13 09:07:21'),
(33, 16, 'Blood Donation Camp - Vellalar Engineering College', 'https://jcierodegreencity.in/images/JCI1649840886857.jpg', 'active', '2022-04-13 09:08:08', '2022-04-13 09:08:08'),
(34, 17, 'Blood Donation Camp - Chikkaiah Naicker College', 'https://jcierodegreencity.in/images/JCI1649840925396.jpg', 'active', '2022-04-13 09:08:47', '2022-04-13 09:08:47'),
(35, 17, 'Blood Donation Camp - Chikkaiah Naicker College', 'https://jcierodegreencity.in/images/JCI1649909011459.jpg', 'active', '2022-04-14 04:03:36', '2022-04-14 04:03:36'),
(36, 20, 'JCI Action Framework', 'https://jcierodegreencity.in/images/JCI1650341800140.jpg', 'active', '2022-04-19 04:16:57', '2022-04-19 04:16:57'),
(37, 20, 'JCI Action Framework', 'https://jcierodegreencity.in/images/JCI1650341860383.jpg', 'active', '2022-04-19 04:17:47', '2022-04-19 04:17:47'),
(38, 20, 'JCI Action Framework', 'https://jcierodegreencity.in/images/JCI1650341937357.jpg', 'active', '2022-04-19 04:19:03', '2022-04-19 04:19:03'),
(39, 22, 'Blood Donation - Sasurie Engineering College', 'https://jcierodegreencity.in/images/JCI1650473031023.jpg', 'active', '2022-04-20 16:44:12', '2022-04-20 16:44:12'),
(40, 22, 'Blood Donation - Sasurie Engineering College', 'https://jcierodegreencity.in/images/JCI1650473119438.jpg', 'active', '2022-04-20 16:45:40', '2022-04-20 16:45:40'),
(41, 22, 'Blood Donation - Sasurie Engineering College', 'https://jcierodegreencity.in/images/JCI1650473284764.jpg', 'active', '2022-04-20 16:48:20', '2022-04-20 16:48:20'),
(42, 24, 'Cooking Competition for Kids', 'https://jcierodegreencity.in/images/JCI1650721015537.jpg', 'active', '2022-04-23 13:37:07', '2022-04-23 13:37:07'),
(43, 24, 'Cooking Competition for Kids', 'https://jcierodegreencity.in/images/JCI1650721106685.jpg', 'active', '2022-04-23 13:38:33', '2022-04-23 13:38:33'),
(44, 24, 'Cooking Competition for Kids', 'https://jcierodegreencity.in/images/JCI1650721188769.jpg', 'active', '2022-04-23 13:39:52', '2022-04-23 13:39:52'),
(45, 24, 'Cooking Competition for Kids', 'https://jcierodegreencity.in/images/JCI1650721186870.jpg', 'active', '2022-04-23 13:39:55', '2022-04-23 13:39:55'),
(46, 24, 'Cooking Competition for Kids', 'https://jcierodegreencity.in/images/JCI1650721200353.jpg', 'active', '2022-04-23 13:40:07', '2022-04-23 13:40:07'),
(47, 23, '8th Regular Meeting - Pattimandram', 'https://jcierodegreencity.in/images/JCI1650721620030.jpg', 'active', '2022-04-23 13:47:07', '2022-04-23 13:47:07'),
(48, 23, '8th Regular Meeting - Pattimandram', 'https://jcierodegreencity.in/images/JCI1650721696440.jpg', 'active', '2022-04-23 13:48:20', '2022-04-23 13:48:20'),
(49, 23, '8th Regular Meeting - Pattimandram', 'https://jcierodegreencity.in/images/JCI1650721715079.jpg', 'active', '2022-04-23 13:48:37', '2022-04-23 13:48:37'),
(50, 23, '8th Regular Meeting - Pattimandram', 'https://jcierodegreencity.in/images/JCI1650721746981.jpg', 'active', '2022-04-23 13:49:09', '2022-04-23 13:49:09'),
(51, 23, '8th Regular Meeting - Pattimandram', 'https://jcierodegreencity.in/images/JCI1650721862962.jpg', 'active', '2022-04-23 13:51:09', '2022-04-23 13:51:09'),
(52, 26, 'FUTURE Phase 16 to 26', 'https://jcierodegreencity.in/images/JCI1650945503020.jpg', 'active', '2022-04-26 03:58:26', '2022-04-26 03:58:26'),
(53, 26, 'FUTURE Phase 16 to 26', 'https://jcierodegreencity.in/images/JCI1650945533165.jpg', 'active', '2022-04-26 03:58:57', '2022-04-26 03:58:57'),
(54, 26, 'FUTURE Phase 16 to 26', 'https://jcierodegreencity.in/images/JCI1650945581427.jpg', 'active', '2022-04-26 03:59:45', '2022-04-26 03:59:45'),
(55, 26, 'FUTURE Phase 16 to 26', 'https://jcierodegreencity.in/images/JCI1650945650409.jpg', 'active', '2022-04-26 04:00:53', '2022-04-26 04:00:53'),
(56, 26, 'FUTURE Phase 16 to 26', 'https://jcierodegreencity.in/images/JCI1650945727346.jpg', 'active', '2022-04-26 04:02:10', '2022-04-26 04:02:10'),
(57, 25, 'National President Official Visit', 'https://jcierodegreencity.in/images/JCI1650945777453.jpg', 'active', '2022-04-26 04:03:01', '2022-04-26 04:03:01'),
(58, 25, 'National President Official Visit', 'https://jcierodegreencity.in/images/JCI1650945823307.jpg', 'active', '2022-04-26 04:03:47', '2022-04-26 04:03:47'),
(59, 25, 'National President Official Visit', 'https://jcierodegreencity.in/images/JCI1650945889425.jpg', 'active', '2022-04-26 04:04:52', '2022-04-26 04:04:52'),
(60, 27, 'Junior Jaycee Wing Installation - Surya Engineering College', 'https://jcierodegreencity.in/images/JCI1651152950943.jpg', 'active', '2022-04-28 13:36:01', '2022-04-28 13:36:01'),
(61, 27, 'Junior Jaycee Wing Installation - Surya Engineering College', 'https://jcierodegreencity.in/images/JCI1651152972914.jpg', 'active', '2022-04-28 13:36:24', '2022-04-28 13:36:24'),
(62, 27, 'Junior Jaycee Wing Installation - Surya Engineering College', 'https://jcierodegreencity.in/images/JCI1651153046102.jpg', 'active', '2022-04-28 13:37:35', '2022-04-28 13:37:35'),
(63, 27, 'Junior Jaycee Wing Installation - Surya Engineering College', 'https://jcierodegreencity.in/images/JCI1651153069716.jpg', 'active', '2022-04-28 13:38:02', '2022-04-28 13:38:02'),
(64, 27, 'Junior Jaycee Wing Installation - Surya Engineering College', 'https://jcierodegreencity.in/images/JCI1651153104811.jpg', 'active', '2022-04-28 13:38:31', '2022-04-28 13:38:31'),
(65, 28, 'Thread Jewellery Making Session', 'https://jcierodegreencity.in/images/JCI1651665039436.jpg', 'active', '2022-05-04 11:50:41', '2022-05-04 11:50:41'),
(66, 28, 'Thread Jewellery Making Session', 'https://jcierodegreencity.in/images/JCI1651665065603.jpg', 'active', '2022-05-04 11:51:07', '2022-05-04 11:51:07'),
(67, 28, 'Thread Jewellery Making Session', 'https://jcierodegreencity.in/images/JCI1651665093024.jpg', 'active', '2022-05-04 11:51:34', '2022-05-04 11:51:34'),
(68, 29, 'Happy Parenting', 'https://jcierodegreencity.in/images/JCI1651665118318.jpg', 'active', '2022-05-04 11:51:59', '2022-05-04 11:51:59'),
(69, 29, 'Happy Parenting', 'https://jcierodegreencity.in/images/JCI1651665146271.jpg', 'active', '2022-05-04 11:52:28', '2022-05-04 11:52:28'),
(70, 28, 'Thread Jewellery Making Session', 'https://jcierodegreencity.in/images/JCI1651665209592.jpg', 'active', '2022-05-04 11:53:31', '2022-05-04 11:53:31'),
(71, 31, 'Trio Business Day 1 - B2B', 'https://jcierodegreencity.in/images/JCI1651945034970.jpg', 'active', '2022-05-07 17:37:15', '2022-05-07 17:37:15'),
(72, 31, 'Trio Business Day 1 - B2B', 'https://jcierodegreencity.in/images/JCI1651945061548.jpg', 'active', '2022-05-07 17:37:43', '2022-05-07 17:37:43'),
(73, 31, 'Trio Business Day 1 - B2B', 'https://jcierodegreencity.in/images/JCI1651945087476.jpg', 'active', '2022-05-07 17:38:08', '2022-05-07 17:38:08'),
(74, 31, 'Trio Business Day 1 - B2B', 'https://jcierodegreencity.in/images/JCI1651945122080.jpg', 'active', '2022-05-07 17:38:43', '2022-05-07 17:38:43'),
(75, 31, 'Trio Business Day 1 - B2B', 'https://jcierodegreencity.in/images/JCI1651945158321.jpg', 'active', '2022-05-07 17:39:19', '2022-05-07 17:39:19'),
(76, 31, 'Trio Business Day 1 - B2B', 'https://jcierodegreencity.in/images/JCI1651945221375.jpg', 'active', '2022-05-07 17:40:22', '2022-05-07 17:40:22'),
(77, 32, 'Trio Business Day 1 - Virtual Business Expo', 'https://jcierodegreencity.in/images/JCI1651945288923.jpg', 'active', '2022-05-07 17:41:31', '2022-05-07 17:41:31'),
(78, 32, 'Trio Business Day 1 - Virtual Business Expo', 'https://jcierodegreencity.in/images/JCI1651945315619.jpg', 'active', '2022-05-07 17:41:57', '2022-05-07 17:41:57'),
(79, 32, 'Trio Business Day 1 - Virtual Business Expo', 'https://jcierodegreencity.in/images/JCI1651945360057.jpg', 'active', '2022-05-07 17:42:41', '2022-05-07 17:42:41'),
(80, 33, 'Trio Business Day 1 - Role of Ethics in Business', 'https://jcierodegreencity.in/images/JCI1651945387043.jpg', 'active', '2022-05-07 17:43:08', '2022-05-07 17:43:08'),
(81, 33, 'Trio Business Day 1 - Role of Ethics in Business', 'https://jcierodegreencity.in/images/JCI1651945412574.jpg', 'active', '2022-05-07 17:43:33', '2022-05-07 17:43:33'),
(82, 33, 'Trio Business Day 1 - Role of Ethics in Business', 'https://jcierodegreencity.in/images/JCI1651945439911.jpg', 'active', '2022-05-07 17:44:01', '2022-05-07 17:44:01'),
(83, 34, 'Business Directory App Release', 'https://jcierodegreencity.in/images/JCI1651945487925.jpg', 'active', '2022-05-07 17:44:49', '2022-05-07 17:44:49'),
(84, 34, 'Business Directory App Release', 'https://jcierodegreencity.in/images/JCI1651945513705.jpg', 'active', '2022-05-07 17:45:15', '2022-05-07 17:45:15'),
(85, 35, 'Region G Multi LO Business Training Seminar', 'https://jcierodegreencity.in/images/JCI1651945545583.jpg', 'active', '2022-05-07 17:45:47', '2022-05-07 17:45:47'),
(86, 35, 'Region G Multi LO Business Training Seminar', 'https://jcierodegreencity.in/images/JCI1651945565428.jpg', 'active', '2022-05-07 17:46:06', '2022-05-07 17:46:06'),
(87, 36, 'Trio Business Day 2 - Startup Training with MSME', 'https://jcierodegreencity.in/images/JCI1652032665723.jpg', 'active', '2022-05-08 17:57:47', '2022-05-08 17:57:47'),
(88, 36, 'Trio Business Day 2 - Startup Training with MSME', 'https://jcierodegreencity.in/images/JCI1652032704536.jpg', 'active', '2022-05-08 17:58:26', '2022-05-08 17:58:26'),
(89, 36, 'Trio Business Day 2 - Startup Training with MSME', 'https://jcierodegreencity.in/images/JCI1652032737253.jpg', 'active', '2022-05-08 17:58:59', '2022-05-08 17:58:59'),
(90, 39, 'Trio Business Day 2 - Training on 5S', 'https://jcierodegreencity.in/images/JCI1652032769579.jpg', 'active', '2022-05-08 17:59:31', '2022-05-08 17:59:31'),
(91, 39, 'Trio Business Day 2 - Training on 5S', 'https://jcierodegreencity.in/images/JCI1652032811623.jpg', 'active', '2022-05-08 18:00:13', '2022-05-08 18:00:13'),
(92, 40, 'Trio Business Day 2 - Training on Quality Assurance', 'https://jcierodegreencity.in/images/JCI1652032845796.jpg', 'active', '2022-05-08 18:00:48', '2022-05-08 18:00:48'),
(93, 40, 'Trio Business Day 2 - Training on Quality Assurance', 'https://jcierodegreencity.in/images/JCI1652032886943.jpg', 'active', '2022-05-08 18:01:28', '2022-05-08 18:01:28'),
(94, 41, 'Trio Business Day 2 - Commodities Trading', 'https://jcierodegreencity.in/images/JCI1652032934361.jpg', 'active', '2022-05-08 18:02:15', '2022-05-08 18:02:15'),
(95, 41, 'Trio Business Day 2 - Commodities Trading', 'https://jcierodegreencity.in/images/JCI1652032967021.jpg', 'active', '2022-05-08 18:02:48', '2022-05-08 18:02:48'),
(96, 42, 'Trio Business Day 3 - Session on Digital Marketing', 'https://jcierodegreencity.in/images/JCI1652671479656.jpg', 'active', '2022-05-16 03:24:40', '2022-05-16 03:24:40'),
(97, 42, 'Trio Business Day 3 - Session on Digital Marketing', 'https://jcierodegreencity.in/images/JCI1652671559500.jpg', 'active', '2022-05-16 03:26:00', '2022-05-16 03:26:00'),
(98, 43, 'Trio Business Day 3 - Session on Safe E-Commerce', 'https://jcierodegreencity.in/images/JCI1652671600180.jpg', 'active', '2022-05-16 03:26:41', '2022-05-16 03:26:41'),
(99, 43, 'Trio Business Day 3 - Session on Safe E-Commerce', 'https://jcierodegreencity.in/images/JCI1652671634192.jpg', 'active', '2022-05-16 03:27:15', '2022-05-16 03:27:15'),
(100, 43, 'Trio Business Day 3 - Session on Safe E-Commerce', 'https://jcierodegreencity.in/images/JCI1652671673498.jpg', 'active', '2022-05-16 03:27:54', '2022-05-16 03:27:54'),
(101, 44, 'Trio Business Day 3 - Session on Cash Less Society', 'https://jcierodegreencity.in/images/JCI1652671717406.jpg', 'active', '2022-05-16 03:28:38', '2022-05-16 03:28:38'),
(102, 44, 'Trio Business Day 3 - Session on Cash Less Society', 'https://jcierodegreencity.in/images/JCI1652671759067.jpg', 'active', '2022-05-16 03:29:20', '2022-05-16 03:29:20'),
(103, 45, 'Trio Business Day 3 - Session on Cyber Security', 'https://jcierodegreencity.in/images/JCI1652671815169.jpg', 'active', '2022-05-16 03:30:16', '2022-05-16 03:30:16'),
(104, 45, 'Trio Business Day 3 - Session on Cyber Security', 'https://jcierodegreencity.in/images/JCI1652671864316.jpg', 'active', '2022-05-16 03:31:06', '2022-05-16 03:31:06'),
(105, 45, 'Trio Business Day 3 - Session on Cyber Security', 'https://jcierodegreencity.in/images/JCI1652671978289.jpg', 'active', '2022-05-16 03:32:59', '2022-05-16 03:32:59'),
(106, 48, 'ID Session - Cyber Security', 'https://jcierodegreencity.in/images/JCI1653100941052.jpg', 'active', '2022-05-21 02:42:22', '2022-05-21 02:42:22'),
(107, 48, 'ID Session - Cyber Security', 'https://jcierodegreencity.in/images/JCI1653100982451.jpg', 'active', '2022-05-21 02:43:03', '2022-05-21 02:43:03'),
(108, 48, 'ID Session - Cyber Security', 'https://jcierodegreencity.in/images/JCI1653101019161.jpg', 'active', '2022-05-21 02:43:40', '2022-05-21 02:43:40'),
(109, 48, 'ID Session - Cyber Security', 'https://jcierodegreencity.in/images/JCI1653101067156.jpg', 'active', '2022-05-21 02:44:28', '2022-05-21 02:44:28'),
(110, 49, 'Aavin Industrial Visit', 'https://jcierodegreencity.in/images/JCI1653291564050.jpg', 'active', '2022-05-23 07:39:26', '2022-05-23 07:39:26'),
(111, 49, 'Aavin Industrial Visit', 'https://jcierodegreencity.in/images/JCI1653291577823.jpg', 'active', '2022-05-23 07:39:39', '2022-05-23 07:39:39'),
(112, 49, 'Aavin Industrial Visit', 'https://jcierodegreencity.in/images/JCI1653291708163.jpg', 'active', '2022-05-23 07:41:49', '2022-05-23 07:41:49'),
(113, 49, 'Aavin Industrial Visit', 'https://jcierodegreencity.in/images/JCI1653291731568.jpg', 'active', '2022-05-23 07:42:13', '2022-05-23 07:42:13'),
(114, 49, 'Aavin Industrial Visit', 'https://jcierodegreencity.in/images/JCI1653291771057.jpg', 'active', '2022-05-23 07:42:53', '2022-05-23 07:42:53'),
(115, 50, 'Training Day - Leading Is Our Duty', 'https://jcierodegreencity.in/images/JCI1653389385843.jpg', 'active', '2022-05-24 10:49:48', '2022-05-24 10:49:48'),
(116, 50, 'Training Day - Leading Is Our Duty', 'https://jcierodegreencity.in/images/JCI1653389502495.jpg', 'active', '2022-05-24 10:51:44', '2022-05-24 10:51:44'),
(117, 51, 'Prayas Day - Sanitary Napkin Distribution', 'https://jcierodegreencity.in/images/JCI1653749408750.jpg', 'active', '2022-05-28 14:50:10', '2022-05-28 14:50:10'),
(118, 51, 'Prayas Day - Sanitary Napkin Distribution', 'https://jcierodegreencity.in/images/JCI1653749439783.jpg', 'active', '2022-05-28 14:50:41', '2022-05-28 14:50:41'),
(119, 51, 'Prayas Day - Sanitary Napkin Distribution', 'https://jcierodegreencity.in/images/JCI1653749464924.jpg', 'active', '2022-05-28 14:51:06', '2022-05-28 14:51:06'),
(120, 51, 'Prayas Day - Sanitary Napkin Distribution', 'https://jcierodegreencity.in/images/JCI1653749491954.jpg', 'active', '2022-05-28 14:51:34', '2022-05-28 14:51:34'),
(121, 63, 'Pongal Day special debate', 'https://jcierodegreencity.in/images/JCI1672941245361.jpg', 'active', '2023-01-05 17:54:06', '2023-01-05 17:54:06'),
(122, 64, 'Pongal Celebration ', 'https://jcierodegreencity.in/images/JCI1674459322966.png', 'active', '2023-01-23 07:35:23', '2023-01-23 08:51:21'),
(123, 66, 'Republic day Celebration', 'https://jcierodegreencity.in/images/JCI1674916496135.jpg', 'active', '2023-01-28 14:34:57', '2023-01-28 14:34:57'),
(124, 65, '2nd Regular Meeting - A Comedy Party', 'https://jcierodegreencity.in/images/JCI1674916918359.jpg', 'active', '2023-01-28 14:41:59', '2023-01-28 14:41:59'),
(125, 65, '2nd Regular Meeting - A Comedy Party', 'https://jcierodegreencity.in/images/JCI1674917004145.jpg', 'active', '2023-01-28 14:43:24', '2023-01-28 14:43:24'),
(126, 67, 'Free Medical Counseling camp', 'https://jcierodegreencity.in/images/JCI1674981467708.jpg', 'active', '2023-01-29 08:37:48', '2023-01-29 08:37:48'),
(127, 67, 'Free Medical Counseling camp', 'https://jcierodegreencity.in/images/JCI1674981536935.jpg', 'active', '2023-01-29 08:38:57', '2023-01-29 08:38:57'),
(128, 67, 'Free Medical Counseling camp', 'https://jcierodegreencity.in/images/JCI1674981604993.jpg', 'active', '2023-01-29 08:40:06', '2023-01-29 08:40:06'),
(129, 67, 'Free Medical Counseling camp', 'https://jcierodegreencity.in/images/JCI1674981630215.jpg', 'active', '2023-01-29 08:40:31', '2023-01-29 08:40:31'),
(130, 64, 'Pongal Celebration ', 'https://jcierodegreencity.in/images/JCI1675870141150.jpg', 'active', '2023-02-08 15:29:01', '2023-02-08 15:29:01'),
(131, 64, 'Pongal Celebration ', 'https://jcierodegreencity.in/images/JCI1675870228560.jpg', 'active', '2023-02-08 15:30:29', '2023-02-08 15:30:29'),
(132, 70, 'Free Blood donation camp', 'https://jcierodegreencity.in/images/JCI1675949784848.jpg', 'active', '2023-02-09 13:36:25', '2023-02-09 13:36:25'),
(133, 70, 'Free Blood donation camp', 'https://jcierodegreencity.in/images/JCI1675949890920.jpg', 'active', '2023-02-09 13:38:11', '2023-02-09 13:38:11');

-- --------------------------------------------------------

--
-- Table structure for table `Family`
--

CREATE TABLE `Family` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `dob` varchar(255) NOT NULL,
  `anniversary` varchar(20) DEFAULT NULL,
  `blood_group` enum('O+','O-','A+','A-','B+','B-','AB+','AB-','A1+','A2+','A1B+','A1B-','A2B+','HH') NOT NULL,
  `relationship` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Family`
--

INSERT INTO `Family` (`id`, `member_id`, `name`, `dob`, `anniversary`, `blood_group`, `relationship`, `createdAt`, `updatedAt`) VALUES
(1, 1, 'S.Rajendran', '24/11/1962', NULL, 'AB+', 'Father', '2021-12-15 15:17:15', '2021-12-15 15:17:15'),
(3, 1, 'R.Abinaya', '08/08/1989', '2013-06-19', 'O+', 'Wife', '2021-12-15 15:26:11', '2021-12-15 15:26:11'),
(4, 1, 'R. Senthamil selvi', '10/08/1965', NULL, 'O+', 'Mother', '2021-12-15 15:26:53', '2021-12-15 15:26:53'),
(5, 1, 'K.Sashvath Aarav ', '21/02/2015', NULL, 'O+', 'Childeren', '2021-12-15 15:28:07', '2021-12-15 15:28:07'),
(6, 2, 'Kuppusamy', '17/07/1958', NULL, 'A1+', 'Father', '2021-12-16 15:21:16', '2021-12-16 15:21:16'),
(7, 3, 'M Bhuvananeshwari', '07/12/1990', '2021-08-27', 'B-', 'Wife', '2021-12-16 15:26:23', '2021-12-16 15:26:23'),
(8, 3, 'A.Muruganandham', '09/11/1952', NULL, 'B+', 'Father', '2021-12-16 15:28:02', '2021-12-16 15:28:02'),
(9, 3, 'M. Nadanambikai', '26/07/1963', NULL, 'B+', 'Mother', '2021-12-16 15:28:42', '2021-12-16 15:28:42'),
(10, 4, 'C.Sindhu', '01/01/1993', '2018-06-03', 'B+', 'Wife', '2021-12-16 15:36:11', '2021-12-16 15:36:11'),
(11, 4, 'R.Paariventhan', '14/05/2019', NULL, 'B+', 'Childeren', '2021-12-16 15:37:27', '2021-12-16 15:37:27'),
(12, 5, 'M.Malarvizhi', '02/01/1994', '2018-03-14', 'B+', 'Wife', '2021-12-16 15:42:06', '2021-12-16 15:42:06'),
(13, 5, 'M.M.Dhuvariga', '01/01/2019', NULL, 'O+', 'Childeren', '2021-12-16 15:42:53', '2021-12-16 15:42:53'),
(14, 5, 'K.Kalaiyarasan', '20/12/1960', NULL, 'B+', 'Father', '2021-12-16 15:43:56', '2021-12-16 15:43:56'),
(15, 5, 'K.Kalaiselvi', '15/09/1967', NULL, 'O+', 'Mother', '2021-12-16 15:45:04', '2021-12-16 15:45:04'),
(16, 6, 'L.Savithiri', '14/01/1973', NULL, 'A1+', 'Mother', '2021-12-16 15:53:03', '2021-12-16 15:53:03'),
(17, 7, 'T Logapriya', '10/08/1993', '2020-03-06', 'O+', 'Wife', '2021-12-16 16:03:02', '2021-12-16 16:03:02'),
(18, 7, 'K.Arumugam', '04/04/1951', NULL, 'O+', 'Father', '2021-12-16 16:04:04', '2021-12-16 16:04:04'),
(19, 7, 'A.Thamilselvi', '05/06/1962', NULL, 'O+', 'Mother', '2021-12-16 16:04:54', '2021-12-16 16:04:54'),
(20, 8, 'V. Sushmitha', '24/03/1995', '2018-09-11', 'A2+', 'Wife', '2021-12-16 16:14:10', '2021-12-16 16:14:10'),
(21, 8, ' V.S.Kumaaraswamy', '14/01/1964', NULL, 'A1+', 'Father', '2021-12-16 16:19:06', '2021-12-16 16:19:06'),
(22, 8, 'Shanthi K', '10/05/1969', NULL, 'B+', 'Mother', '2021-12-16 16:20:05', '2021-12-16 16:20:05'),
(23, 10, 'Ajitha Rubani', '10/04/1994', '2020-10-30', 'O+', 'Wife', '2021-12-16 16:35:23', '2021-12-16 16:35:23'),
(24, 10, 'S.Sengottaian', '19/08/1959', NULL, 'O+', 'Father', '2021-12-16 16:36:45', '2021-12-16 16:36:45'),
(25, 10, 'S.Tamilarasi', '20/06/1966', NULL, 'O+', 'Mother', '2021-12-16 16:38:03', '2021-12-16 16:38:03'),
(26, 11, 'Sindhuja', '06/07/1999', '2021-08-20', 'O+', 'Wife', '2021-12-16 17:11:56', '2021-12-16 17:11:56'),
(27, 12, 'C.G.Vechitra', '09/07/1991', '2016-09-16', 'O+', 'Wife', '2021-12-16 17:19:36', '2021-12-16 17:19:36'),
(28, 12, 'N.Ranganathan', '01/10/1962', NULL, 'O+', 'Father', '2021-12-16 17:21:20', '2021-12-16 17:21:20'),
(29, 12, 'R.Shanthi', '17/09/1970', NULL, 'B+', 'Mother', '2021-12-16 17:22:23', '2021-12-16 17:22:23'),
(30, 12, 'K.Sakshi Sree', '15/03/2019', NULL, 'O+', 'Childeren', '2021-12-16 17:23:35', '2021-12-16 17:23:35'),
(31, 13, 'N.Pavithra', '31/10/1994', '2017-02-16', 'O+', 'Wife', '2021-12-16 17:31:54', '2021-12-16 17:31:54'),
(32, 13, 'A.Jayakumar', '12/04/1952', NULL, 'B+', 'Father', '2021-12-16 17:33:31', '2021-12-16 17:33:31'),
(33, 13, 'J.Vijayaa', '01/06/1972', NULL, 'B+', 'Mother', '2021-12-16 17:35:13', '2021-12-16 17:35:13'),
(34, 13, 'Mellisai', '20/04/2018', NULL, 'B+', 'Childeren', '2021-12-16 17:35:43', '2021-12-16 17:35:43'),
(35, 14, 'R.Chandrasekaran', '10/05/1972', NULL, 'A+', 'Father', '2021-12-16 17:47:28', '2021-12-16 17:47:28'),
(36, 14, 'C.Preetha', '01/01/1984', NULL, 'O+', 'Mother', '2021-12-16 17:51:11', '2021-12-16 17:51:11'),
(37, 15, 'M.Kavi priya', '28/11/1990', '2013-09-09', 'B+', 'Wife', '2021-12-16 18:01:26', '2021-12-16 18:01:26'),
(39, 15, 'R.Kalaiselvi ', '17/05/1984', NULL, 'O+', 'Mother', '2021-12-16 18:03:09', '2021-12-16 18:03:09'),
(40, 15, 'K.R. Prahalyaa', '04/07/2014', NULL, 'B+', 'Childeren', '2021-12-16 18:04:18', '2021-12-16 18:04:18'),
(41, 16, 'M.D.Easwaran`', '01/03/1970', NULL, 'A1+', 'Father', '2021-12-16 18:09:12', '2021-12-16 18:09:12'),
(42, 16, 'E.Chandra', '16/06/1979', NULL, 'O+', 'Mother', '2021-12-16 18:09:55', '2021-12-16 18:09:55'),
(43, 17, 'Madhura', '08/08/1994', '2017-06-28', 'O+', 'Wife', '2021-12-16 18:17:49', '2021-12-16 18:17:49'),
(44, 17, 'Thirunavukkarasu', '08/10/1965', NULL, 'O+', 'Father', '2021-12-16 18:18:47', '2021-12-16 18:18:47'),
(45, 17, 'Yavanarani', '17/09/1969', NULL, 'A2+', 'Mother', '2021-12-16 18:19:35', '2021-12-16 18:19:35'),
(46, 17, 'Thihan T', '30/09/2020', NULL, 'A2+', 'Childeren', '2021-12-16 18:20:05', '2021-12-16 18:20:05'),
(47, 18, 'R.Vijayalakshmi', '14/10/1990', '2019-12-08', 'A+', 'Wife', '2021-12-16 18:26:36', '2021-12-16 18:26:36'),
(48, 18, 'S.Harshitha', '14/09/2020', NULL, 'A+', 'Childeren', '2021-12-16 18:27:50', '2021-12-16 18:27:50'),
(49, 19, 'G.GOKILA', '16/05/1993', '2013-12-06', 'O+', 'Wife', '2021-12-16 18:34:05', '2021-12-16 18:34:05'),
(50, 19, 'Varshika', '09/09/2014', NULL, 'O-', 'Childeren', '2021-12-16 18:34:52', '2021-12-16 18:34:52'),
(51, 9, 'K.Gokila', '25/03/1991', '2015-10-26', 'B+', 'Wife', '2021-12-16 18:46:11', '2021-12-16 18:46:11'),
(53, 22, 'N.Smrithi', '12/11/2007', NULL, 'B+', 'Childeren', '2021-12-17 14:36:19', '2021-12-17 14:36:19'),
(54, 22, 'Anitha ', '11/03/1981', '2006-08-22', 'B+', 'Wife', '2021-12-17 14:38:32', '2021-12-17 14:38:32'),
(55, 23, 'Adhira .Y', '28/01/2009', NULL, 'B+', 'Childeren', '2021-12-17 14:47:09', '2021-12-17 14:47:09'),
(56, 23, 'Ananya', '08/11/2012', NULL, 'B+', 'Childeren', '2021-12-17 14:48:39', '2021-12-17 14:48:39'),
(57, 24, 'Ramya', '28/07/1981', '2005-10-24', 'O+', 'Wife', '2021-12-17 15:43:50', '2021-12-17 15:43:50'),
(58, 24, 'SK.Akshaay', '10/11/2006', NULL, 'O+', 'Childeren', '2021-12-17 15:45:39', '2021-12-17 15:45:39'),
(59, 26, 'Shanmugasundaram.K', '19/03/1973', '2000-06-11', 'O+', 'Wife', '2021-12-17 16:02:38', '2021-12-17 16:02:38'),
(60, 26, 'Rithika.K.S', '20/06/2001', NULL, 'O+', 'Childeren', '2021-12-17 16:04:47', '2021-12-17 16:04:47'),
(61, 26, 'Kaviya Ragavan', '17/10/2011', NULL, 'O+', 'Childeren', '2021-12-17 16:05:52', '2021-12-17 16:05:52'),
(62, 27, 'Dr R Sruthi', '13/06/1987', '2013-09-08', 'O+', 'Wife', '2021-12-17 16:11:38', '2021-12-17 16:11:38'),
(63, 27, 'A S Samritaa Tashvi', '27/06/2014', NULL, 'O-', 'Childeren', '2021-12-17 16:14:03', '2021-12-17 16:14:03'),
(64, 27, 'A Lishan Advith', '06/01/2020', NULL, 'O+', 'Childeren', '2021-12-17 16:16:11', '2021-12-17 16:16:11'),
(65, 31, 'S.Nirmala devi', '14/02/1985', '2012-03-11', 'O+', 'Wife', '2021-12-17 17:25:35', '2021-12-17 17:25:35'),
(66, 31, 'E.Sri Nemalan', '16/01/2013', NULL, 'A+', 'Childeren', '2021-12-17 17:26:25', '2021-12-17 17:26:25'),
(67, 31, 'E.Hari nandhan', '22/10/2017', NULL, 'O+', 'Childeren', '2021-12-17 17:27:19', '2021-12-17 17:27:19'),
(68, 32, 'Yuvaraja', '17/03/1982', '2008-03-09', 'A1+', 'Wife', '2021-12-17 17:42:48', '2021-12-17 17:42:48'),
(69, 32, 'Adhira .Y', '28/01/2009', NULL, 'B+', 'Childeren', '2021-12-17 17:45:09', '2021-12-17 17:45:09'),
(70, 32, 'Ananya', '08/11/2012', NULL, 'B+', 'Childeren', '2021-12-17 17:46:07', '2021-12-17 17:46:07'),
(71, 35, 'S.Sujitha', '06/02/1990', '2016-06-12', 'B+', 'Wife', '2021-12-17 18:06:03', '2021-12-17 18:06:03'),
(72, 35, 'S.Kaviksha ', '01/08/2018', NULL, 'O+', 'Childeren', '2021-12-17 18:07:00', '2021-12-17 18:07:00'),
(73, 35, 'S.Janani ', '23/08/2019', NULL, 'A+', 'Childeren', '2021-12-17 18:08:03', '2021-12-17 18:08:03'),
(74, 38, 'Daksha', '04/11/1993', '2005-02-04', 'O+', 'Wife', '2021-12-17 18:31:01', '2021-12-17 18:31:01'),
(75, 38, 'Prem Kumar', '21/01/2006', NULL, 'B-', 'Childeren', '2021-12-17 18:31:52', '2021-12-17 18:31:52'),
(76, 38, 'Sanskruti', '04/12/2007', NULL, 'B-', 'Childeren', '2021-12-17 18:33:02', '2021-12-17 18:33:02'),
(77, 39, 'Dr.N.K.Dhanapackiam', '10/06/1977', '2004-06-09', 'O+', 'Wife', '2021-12-17 18:42:46', '2021-12-17 18:42:46'),
(78, 39, 'S.D.Kuralini', '15/01/2006', NULL, 'A1+', 'Childeren', '2021-12-17 18:45:04', '2021-12-17 18:45:04'),
(79, 39, 'S.D.Thamizhini', '12/07/2009', NULL, 'O+', 'Childeren', '2021-12-17 18:48:22', '2021-12-17 18:48:22'),
(80, 40, 'K.K.Sureshkumar', '14/12/1975', '2004-06-09', 'A1+', 'Wife', '2021-12-17 18:53:34', '2021-12-17 18:53:34'),
(81, 40, 'S.D.Kuralini', '15/01/2006', NULL, 'A1+', 'Childeren', '2021-12-17 18:54:27', '2021-12-17 18:54:27'),
(82, 40, 'S.D.Thamizhini', '12/07/2009', NULL, 'O+', 'Childeren', '2021-12-17 18:55:17', '2021-12-17 18:55:17'),
(83, 73, 'J.Lavanya', '02/07/1996', '2019-02-09', 'O+', 'Wife', '2022-01-06 12:16:25', '2022-01-06 12:16:25'),
(84, 73, 'J.Lavanya', '02/07/1993', '2019-09-02', 'O+', 'Wife', '2022-01-06 12:44:11', '2022-01-06 12:44:11'),
(85, 73, 'J.Nidharshanaa', '09/07/2020', NULL, 'B+', 'Childeren', '2022-01-06 12:48:51', '2022-01-06 12:48:51'),
(86, 70, 'chenthoorun', '03/01/1993', '2020-10-30', 'O+', 'Wife', '2022-01-06 12:54:02', '2022-01-06 12:54:02'),
(87, 69, 'Jc K.Madhuppranesh', '17/03/1992', '2018-09-11', 'HH', 'Wife', '2022-01-06 12:58:28', '2022-01-06 12:58:28'),
(88, 69, 'M.Sithvi', '17/12/2020', NULL, 'HH', 'Childeren', '2022-01-06 13:02:32', '2022-01-06 13:02:32'),
(94, 64, 'Jc Mohanraj', '15/04/1981', '2008-07-14', 'HH', 'Wife', '2022-01-07 07:31:38', '2022-01-07 07:31:38'),
(95, 64, 'AM.Sanjaykrishnan', '02/04/2009', NULL, 'HH', 'Childeren', '2022-01-07 07:33:15', '2022-01-07 07:33:15'),
(96, 64, 'AM.Naren', '28/08/2012', NULL, 'HH', 'Childeren', '2022-01-07 07:35:09', '2022-01-07 07:35:09'),
(97, 63, 'Jc S Ramesh', '07/08/1989', '2018-06-03', 'O+', 'Wife', '2022-01-07 07:39:14', '2022-01-07 07:39:14'),
(98, 63, ' R. Paariventhan', '14/05/2019', NULL, 'B+', 'Childeren', '2022-01-07 07:40:52', '2022-01-07 07:40:52'),
(101, 59, 'Swathi', '22/07/1986', '2012-02-22', 'O+', 'Wife', '2022-01-07 08:00:56', '2022-01-07 08:00:56'),
(102, 59, 'Sakshum', '23/01/2015', NULL, 'O+', 'Childeren', '2022-01-07 08:03:17', '2022-01-07 08:03:17'),
(103, 80, 'S.Ramyadevi', '21/05/1987', '2011-09-01', 'O+', 'Wife', '2022-01-17 07:31:16', '2022-01-17 07:31:16'),
(104, 80, 'S.Lakshana', '08/08/2012', NULL, 'A1+', 'Childeren', '2022-01-17 07:45:00', '2022-01-17 07:45:00'),
(105, 79, 'Y.Mohana', '14/06/1986', '2008-02-24', 'HH', 'Wife', '2022-01-17 07:48:04', '2022-01-17 07:48:04'),
(106, 78, 'Jc.Sen.Suresh Kumar.N', '07/03/1981', '2005-10-24', 'O+', 'Wife', '2022-01-17 07:50:52', '2022-01-17 07:50:52'),
(107, 78, 'SK.Akshaay', '10/11/2006', NULL, 'O+', 'Childeren', '2022-01-17 07:59:46', '2022-01-17 07:59:46'),
(108, 76, 'S.Keerthana', '20/06/1992', '2015-07-12', 'O+', 'Wife', '2022-01-17 08:13:59', '2022-01-17 08:13:59'),
(109, 76, 'Inban Ankuram', '26/04/2016', NULL, 'O+', 'Childeren', '2022-01-17 08:14:45', '2022-01-17 08:14:45'),
(110, 76, 'Dhuruvan Ankuram', '12/04/2018', NULL, 'HH', 'Childeren', '2022-01-17 08:15:48', '2022-01-17 08:15:48'),
(111, 57, 'E. Yaashini', '29/11/1990', '2017-10-29', 'O+', 'Wife', '2022-01-17 08:49:43', '2022-01-17 08:49:43'),
(112, 57, 'Yuktesh ', '29/05/2019', NULL, 'O+', 'Childeren', '2022-01-17 08:51:56', '2022-01-17 08:51:56'),
(113, 56, 'Jc K.K. Manoj Prabakar', '09/05/1991', '2018-03-14', 'B+', 'Wife', '2022-01-17 08:54:16', '2022-01-17 08:54:16'),
(114, 56, 'M.M. Dhuvariga', '01/01/2019', NULL, 'O+', 'Childeren', '2022-01-17 08:55:31', '2022-01-17 08:55:31'),
(115, 54, 'M.Tamilselvi', '17/01/1982', '2008-07-14', 'A1+', 'Wife', '2022-01-17 09:25:43', '2022-01-17 09:25:43'),
(116, 54, 'A.M.Sanjai Krishnan', '02/04/2009', NULL, 'B+', 'Childeren', '2022-01-17 09:44:09', '2022-01-17 09:44:09'),
(117, 54, 'A.M.Naren', '25/08/2012', NULL, 'A+', 'Childeren', '2022-01-17 09:45:53', '2022-01-17 09:45:53'),
(118, 53, 'Dhanalakshmi S.', '06/06/1988', '2008-08-28', 'O+', 'Wife', '2022-01-17 09:48:09', '2022-01-17 09:48:09'),
(119, 52, 'C.V.Chinnamal', '30/08/1994', '2017-11-09', 'O+', 'Wife', '2022-01-17 09:51:21', '2022-01-17 09:51:21'),
(120, 52, 'V.Sanjana', '30/09/2018', NULL, 'O+', 'Childeren', '2022-01-17 09:54:31', '2022-01-17 09:54:31'),
(121, 51, 'E.P.Arulvel', '07/11/1976', '2002-05-20', 'B+', 'Wife', '2022-01-17 09:59:29', '2022-01-17 09:59:29'),
(122, 51, 'A.V.Nishanth', '11/09/2003', NULL, 'B+', 'Childeren', '2022-01-17 10:00:43', '2022-01-17 10:00:43'),
(123, 51, 'A.V.Mahizh', '05/08/2015', NULL, 'B+', 'Childeren', '2022-01-17 10:01:57', '2022-01-17 10:01:57'),
(124, 50, 'V.G.Venkatesan', '24/05/1971', '1999-11-10', 'B+', 'Wife', '2022-01-17 10:10:26', '2022-01-17 10:10:26'),
(125, 50, 'V. Sanjith Ragul', '20/08/2000', NULL, 'B+', 'Childeren', '2022-01-17 10:11:58', '2022-01-17 10:11:58'),
(126, 49, 'E.Karthikeyan', '01/12/1981', '2007-10-25', 'B+', 'Wife', '2022-01-17 10:24:21', '2022-01-17 10:24:21'),
(127, 49, 'k.k.anannya', '18/06/2010', NULL, 'A+', 'Childeren', '2022-01-17 10:25:56', '2022-01-17 10:25:56'),
(128, 49, 'K.k.athirai', '12/04/0017', NULL, 'B+', '', '2022-01-17 10:27:22', '2022-01-17 10:27:22'),
(129, 46, 'Jc C.Vanithamani ', '23/07/1980', '2002-05-20', 'B+', 'Wife', '2022-01-17 10:32:25', '2022-01-17 10:32:25'),
(130, 46, 'A.V.Nishanth', '11/09/2003', NULL, 'B+', 'Childeren', '2022-01-17 10:36:01', '2022-01-17 10:36:01'),
(131, 46, 'A.V.Mahizh', '05/08/2015', NULL, 'B+', 'Childeren', '2022-01-17 10:36:53', '2022-01-17 10:36:53'),
(132, 45, 'Jc P.R.Kalaiyarasi', '28/01/1983', '2007-10-25', 'HH', 'Wife', '2022-01-17 11:01:07', '2022-01-17 11:01:07'),
(133, 45, 'k.k.anannya', '18/06/2010', NULL, 'A+', 'Childeren', '2022-01-17 11:02:01', '2022-01-17 11:02:01'),
(134, 45, 'K.k.athirai', '12/04/2017', NULL, 'B+', '', '2022-01-17 11:02:46', '2022-01-17 11:02:46'),
(135, 44, 'Uthaya Sankar', '08/07/1980', '2001-06-03', 'O+', 'Wife', '2022-01-17 11:19:15', '2022-01-17 11:19:15'),
(136, 44, 'U.Harish', '03/06/2003', NULL, 'A1+', 'Childeren', '2022-01-17 11:41:08', '2022-01-17 11:41:08'),
(137, 43, 'JFP R.Kowsik', '22/08/1987', '2013-06-19', 'B+', 'Wife', '2022-01-17 11:44:26', '2022-01-17 11:44:26'),
(138, 43, 'K.Sashvath Aarav', '21/02/2015', NULL, 'O+', 'Childeren', '2022-01-17 11:46:03', '2022-01-17 11:46:03'),
(139, 42, 'T.Jeyanthi', '02/06/1992', '2017-11-29', 'A1+', 'Wife', '2022-01-17 11:48:14', '2022-01-17 11:48:14'),
(140, 42, 'S.J.Shivaani', '13/12/2018', NULL, 'HH', 'Childeren', '2022-01-17 12:15:56', '2022-01-17 12:15:56'),
(141, 41, 'v.Ramesh Venkachalam', '27/11/1978', '2010-11-19', 'O+', 'Wife', '2022-01-17 12:52:09', '2022-01-17 12:52:09'),
(142, 41, 'R.Aradhana', '07/03/2012', NULL, 'O+', 'Childeren', '2022-01-17 12:53:05', '2022-01-17 12:53:05'),
(143, 40, ' Jc. K.K.Sureshkumar', '14/12/1975', '2004-06-09', 'A1+', 'Wife', '2022-01-17 12:55:11', '2022-01-17 12:55:11'),
(144, 40, 'S.D.Kuralini', '15/01/2006', NULL, 'A1+', 'Childeren', '2022-01-17 12:56:00', '2022-01-17 12:56:00'),
(145, 40, 'S.D.Thamizhini', '12/07/2009', NULL, 'O+', 'Childeren', '2022-01-17 12:57:54', '2022-01-17 12:57:54'),
(146, 39, 'Jc. HGF.Dr.N.K.Dhanapackiam', '10/06/1977', '2004-06-09', 'O+', 'Wife', '2022-01-17 13:03:42', '2022-01-17 13:03:42'),
(147, 39, 'S.D.Kuralini', '15/01/2006', NULL, 'A1+', 'Childeren', '2022-01-17 13:04:35', '2022-01-17 13:04:35'),
(148, 39, 'S.D.Thamizhini', '12/07/2009', NULL, 'O+', 'Childeren', '2022-01-17 13:05:47', '2022-01-17 13:05:47'),
(149, 38, 'Daksha', '04/11/1993', '2005-02-04', 'O+', 'Wife', '2022-01-18 06:21:00', '2022-01-18 06:21:00'),
(150, 38, 'Prem Kumar', '21/01/2006', NULL, 'B-', '', '2022-01-18 06:22:47', '2022-01-18 06:22:47'),
(151, 38, 'Sanskruti', '04/12/2007', NULL, 'B-', 'Childeren', '2022-01-18 06:24:21', '2022-01-18 06:24:21'),
(152, 36, 'JFP D.Aniruthan', '03/10/1985', '2013-09-08', 'O+', 'Wife', '2022-01-18 06:37:48', '2022-01-18 06:37:48'),
(153, 36, 'AS.Samritaa Tashvi', '27/06/2014', NULL, 'O-', 'Childeren', '2022-01-18 06:46:07', '2022-01-18 06:46:07'),
(154, 36, 'A.Lishaaan Advith', '06/01/2020', NULL, 'O+', 'Childeren', '2022-01-18 06:48:01', '2022-01-18 06:48:01'),
(155, 35, 'S.Sujitha', '06/02/1990', '2016-06-12', 'B+', 'Wife', '2022-01-18 06:51:51', '2022-01-18 06:51:51'),
(156, 35, 'S.Kaviksha ', '01/08/2018', NULL, 'O+', 'Childeren', '2022-01-18 06:53:26', '2022-01-18 06:53:26'),
(157, 35, 'S.Janani ', '23/08/2019', NULL, 'A+', 'Childeren', '2022-01-18 06:55:31', '2022-01-18 06:55:31'),
(158, 34, 'JC S. Brinda Rao', '20/06/1970', '1987-06-28', 'B+', 'Wife', '2022-01-18 07:07:03', '2022-01-18 07:07:03'),
(159, 34, 'JC K.A.  Gautham', '19/10/1989', NULL, 'HH', 'Childeren', '2022-01-18 07:09:36', '2022-01-18 07:09:36'),
(160, 32, 'JFP Yuvaraja', '17/03/1982', '2008-03-09', 'A1+', 'Wife', '2022-01-18 07:56:57', '2022-01-18 07:56:57'),
(161, 32, 'Ananya', '08/11/2012', NULL, 'B+', '', '2022-01-18 08:55:11', '2022-01-18 08:55:11'),
(162, 31, 'S.Nirmala devi', '14/02/1985', '2012-03-11', 'O+', 'Wife', '2022-01-18 09:08:58', '2022-01-18 09:08:58'),
(163, 31, 'E.Sri Nemalan', '16/01/2013', NULL, 'A+', 'Childeren', '2022-01-18 09:13:59', '2022-01-18 09:13:59'),
(164, 31, 'E.Hari nandhan', '22/10/2017', NULL, 'O+', 'Childeren', '2022-01-18 09:15:47', '2022-01-18 09:15:47'),
(165, 28, 'S.Usha', '28/03/1980', '2004-08-20', 'HH', 'Wife', '2022-01-18 09:25:45', '2022-01-18 09:25:45'),
(166, 28, 'L.Shre Krishna', '30/12/2005', NULL, 'HH', 'Childeren', '2022-01-18 09:32:25', '2022-01-18 09:32:25'),
(167, 27, 'Jc DR R Sruthi', '13/06/1987', '2013-09-08', 'O+', 'Wife', '2022-01-18 09:38:04', '2022-01-18 09:38:04'),
(168, 27, 'A S Samritaa Tashvi', '27/06/2014', NULL, 'O-', 'Childeren', '2022-01-18 10:37:33', '2022-01-18 10:37:33'),
(169, 27, 'A Lishan Advith', '06/01/2020', NULL, 'O+', '', '2022-01-18 10:38:33', '2022-01-18 10:38:33'),
(170, 60, 'S Brinda', '11/11/1982', '2010-01-27', 'B+', 'Wife', '2022-03-21 13:31:57', '2022-03-21 13:31:57'),
(171, 60, 'S Neha', '28/10/2011', NULL, 'B+', 'Childeren', '2022-03-21 13:33:28', '2022-03-21 13:33:28'),
(172, 60, 'S Sashvanth', '03/06/2017', NULL, 'B+', 'Childeren', '2022-03-21 13:35:01', '2022-03-21 13:35:01'),
(173, 61, 'Vaishmitha', '05/09/1996', '2021-02-24', 'AB+', 'Wife', '2022-03-21 13:42:38', '2022-03-21 13:42:38'),
(174, 25, 'Jc S Nadhipriya', '17/06/1989', '2010-08-30', 'B+', 'Wife', '2022-03-21 14:02:56', '2022-03-21 14:02:56'),
(176, 67, 'Jc E Karthikeyan', '30/11/1984', '2010-08-30', 'A1+', 'Wife', '2022-03-21 14:12:24', '2022-03-21 14:12:24'),
(177, 53, 'C Ashwin', '17/07/2009', NULL, 'O+', 'Childeren', '2022-03-21 14:23:37', '2022-03-21 14:23:37'),
(178, 53, 'C Yohith', '03/10/2011', NULL, 'O+', 'Childeren', '2022-03-21 14:24:21', '2022-03-21 14:24:21'),
(179, 68, 'Jc S Chandramohan', '03/10/1983', '2008-08-28', 'O+', 'Wife', '2022-03-21 14:26:19', '2022-03-21 14:26:19'),
(180, 68, 'C Ashwin', '17/07/2009', NULL, 'O+', 'Childeren', '2022-03-21 14:27:00', '2022-03-21 14:27:00'),
(181, 68, 'C Yohith', '03/10/2011', NULL, 'O+', 'Childeren', '2022-03-21 14:27:47', '2022-03-21 14:27:47'),
(182, 72, 'Kavitha', '14/10/1986', '2010-09-12', 'B+', 'Wife', '2022-03-21 14:43:19', '2022-03-21 14:43:19'),
(183, 72, 'Jclt Namirtha', '31/08/2011', NULL, 'B+', 'Childeren', '2022-03-21 14:43:56', '2022-03-21 14:43:56'),
(184, 72, 'Jclt Ilamughil', '14/02/2016', NULL, 'B+', 'Childeren', '2022-03-21 14:45:06', '2022-03-21 14:45:06'),
(185, 85, 'R Valarmathi', '26/01/1991', '2014-06-30', 'B+', 'Wife', '2022-03-21 15:04:38', '2022-03-21 15:04:38'),
(186, 85, 'J Nakshathraa', '19/09/2015', NULL, 'B+', 'Childeren', '2022-03-21 15:05:36', '2022-03-21 15:05:36'),
(187, 85, 'V J Vidul', '01/12/2021', NULL, 'B+', 'Childeren', '2022-03-21 15:06:12', '2022-03-21 15:06:12'),
(188, 86, 'JFP C Jotheeswaramoorthy', '27/08/1977', '2002-01-28', 'B+', 'Wife', '2022-03-21 15:16:32', '2022-03-21 15:16:32'),
(189, 86, 'Jclt J Pavishna', '29/10/2002', NULL, 'B+', 'Childeren', '2022-03-21 15:17:26', '2022-03-21 15:17:26'),
(190, 86, 'Jclt J Harshana', '07/03/2009', NULL, 'B+', 'Childeren', '2022-03-21 15:18:05', '2022-03-21 15:18:05'),
(191, 89, 'Sathiyamoorthy', '07/03/1979', '2004-05-16', 'A+', 'Wife', '2022-03-21 15:51:42', '2022-03-21 15:51:42'),
(192, 89, 'Jclt Ashwin', '15/02/2005', NULL, 'A+', 'Childeren', '2022-03-21 15:53:00', '2022-03-21 15:53:00'),
(193, 89, 'Jclt Mirrthula', '25/07/2013', NULL, 'O+', 'Childeren', '2022-03-21 15:53:42', '2022-03-21 15:53:42'),
(194, 90, 'Mythily', '14/06/1994', '2016-11-06', 'B+', 'Wife', '2022-03-21 16:00:26', '2022-03-21 16:00:26'),
(195, 90, 'Jclt Vivaan Aadith', '10/10/2017', NULL, 'O-', 'Childeren', '2022-03-21 16:01:23', '2022-03-21 16:01:23'),
(196, 90, 'Jclt Govardhini', '06/08/2020', NULL, 'O-', 'Childeren', '2022-03-21 16:01:56', '2022-03-21 16:01:56'),
(197, 91, 'Jc K R Ramesh', '06/01/1988', '2013-09-09', 'O+', 'Wife', '2022-03-21 16:11:51', '2022-03-21 16:11:51'),
(198, 91, 'Jclt K R Prahalyaa', '04/07/2014', NULL, 'B+', 'Childeren', '2022-03-21 16:12:51', '2022-03-21 16:12:51'),
(199, 92, 'R Sujatha', '13/10/1970', '1991-08-28', 'O+', 'Wife', '2022-03-21 16:24:18', '2022-03-21 16:24:18'),
(200, 92, 'Jc R Shwetha', '11/10/1992', NULL, 'B+', 'Childeren', '2022-03-21 16:25:20', '2022-03-21 16:25:20'),
(201, 92, 'Jclt R Harshitha', '25/05/2000', NULL, 'B+', 'Childeren', '2022-03-21 16:26:42', '2022-03-21 16:26:42'),
(202, 93, 'Jc G Keerthini', '03/01/1988', NULL, 'O+', 'Childeren', '2022-03-21 16:34:44', '2022-03-21 16:34:44'),
(203, 94, 'Jclt C Vikkashini', '11/09/1990', NULL, 'O+', 'Childeren', '2022-03-21 16:55:38', '2022-03-21 16:55:38'),
(204, 95, 'K Shanthi', '10/05/1969', '1990-03-08', 'B+', 'Wife', '2022-03-21 17:02:01', '2022-03-21 17:02:01'),
(205, 95, 'Jc K Madhuppranesh', '17/03/1992', NULL, 'A1+', 'Childeren', '2022-03-21 17:02:46', '2022-03-21 17:02:46'),
(206, 96, 'M Deepa', '04/10/1979', '2001-06-24', 'O+', 'Wife', '2022-03-22 08:23:25', '2022-03-22 08:23:25'),
(207, 96, 'M Dhanush', '25/06/2002', NULL, 'B+', 'Childeren', '2022-03-22 08:24:13', '2022-03-22 08:24:13'),
(208, 96, 'M Monissha', '11/09/2007', NULL, 'B+', 'Childeren', '2022-03-22 08:24:50', '2022-03-22 08:24:50'),
(209, 94, 'C Mynavathi', '29/08/1963', '1980-01-28', 'B+', 'Wife', '2022-03-22 08:26:41', '2022-03-22 08:26:41'),
(210, 97, 'Jc Roopa Tito', '21/06/1981', '2004-09-07', 'B+', 'Wife', '2022-03-22 08:42:42', '2022-03-22 08:42:42'),
(211, 97, 'Jclt Cebe', '28/12/2006', NULL, 'O+', 'Childeren', '2022-03-22 08:43:43', '2022-03-22 08:43:43'),
(212, 93, 'G Vasanthi', '28/12/1963', '1987-02-09', 'O+', 'Wife', '2022-03-22 08:45:49', '2022-03-22 08:45:49'),
(213, 93, 'Jclt Harshini', '15/02/2000', NULL, 'O+', 'Childeren', '2022-03-22 08:47:20', '2022-03-22 08:47:20'),
(214, 98, 'K Vijayalakshmi', '20/06/1982', '2001-03-11', 'O+', 'Wife', '2022-03-22 08:57:14', '2022-03-22 08:57:14'),
(215, 98, 'Jclt K Varsha', '04/08/2002', NULL, 'O+', 'Childeren', '2022-03-22 08:57:53', '2022-03-22 08:57:53'),
(216, 98, 'Jclt K Joshna', '05/12/2005', NULL, 'O+', 'Childeren', '2022-03-22 08:58:25', '2022-03-22 08:58:25'),
(217, 99, 'S Ambiga', '14/07/1976', '1994-08-24', 'B-', 'Wife', '2022-03-22 09:02:16', '2022-03-22 09:02:16'),
(218, 99, 'Jclt S Preetham', '23/10/1995', NULL, 'B+', 'Childeren', '2022-03-22 09:03:18', '2022-03-22 09:03:18'),
(219, 99, 'Jclt Harinishre', '21/10/1999', NULL, 'B+', 'Childeren', '2022-03-22 09:04:04', '2022-03-22 09:04:04'),
(220, 100, 'Kanchana Thangavelu', '03/01/1976', '1995-03-13', 'O+', 'Wife', '2022-03-22 09:12:07', '2022-03-22 09:12:07'),
(221, 100, 'Jclt T Harikrishna', '10/12/1995', NULL, 'A1+', 'Childeren', '2022-03-22 09:12:54', '2022-03-22 09:12:54'),
(222, 100, 'Jclt Shruthi Vaishali', '27/12/2001', NULL, 'A1+', 'Childeren', '2022-03-22 09:13:36', '2022-03-22 09:13:36'),
(223, 101, 'P Kokila', '26/09/1978', '2000-11-06', 'O+', 'Wife', '2022-03-22 09:18:32', '2022-03-22 09:18:32'),
(225, 101, 'Jclt S P Raghuram', '02/02/2002', NULL, 'O+', 'Childeren', '2022-03-22 09:20:00', '2022-03-22 09:20:00'),
(226, 102, 'P Janaranjani', '27/06/1983', '2006-08-27', 'O+', 'Wife', '2022-03-22 09:24:10', '2022-03-22 09:24:10'),
(227, 102, 'Jclt V Pavya', '03/12/2007', NULL, 'O+', 'Childeren', '2022-03-22 09:30:00', '2022-03-22 09:30:00'),
(228, 103, 'K Savitha', '15/06/1978', '2001-06-03', 'A1+', 'Wife', '2022-03-22 09:39:11', '2022-03-22 09:39:11'),
(229, 103, 'Jclt K Shree Vikashini', '22/04/2002', NULL, 'B+', 'Childeren', '2022-03-22 09:40:01', '2022-03-22 09:40:01'),
(230, 103, 'Jclt S K Sabarish', '18/05/2005', NULL, 'B+', 'Childeren', '2022-03-22 09:40:40', '2022-03-22 09:40:40'),
(231, 104, 'Jc Chandrakala', '19/06/1978', '2002-01-28', 'B+', 'Wife', '2022-03-22 10:02:39', '2022-03-22 10:02:39'),
(232, 104, 'Jclt J Pavishna', '29/10/2002', NULL, 'B+', 'Childeren', '2022-03-22 10:03:24', '2022-03-22 10:03:24'),
(233, 104, 'Jclt J Harshana', '07/03/2009', NULL, 'B+', 'Childeren', '2022-03-22 10:03:53', '2022-03-22 10:03:53'),
(234, 37, 'Jc HGF R K Rameshkumar', '03/10/1978', '2003-12-04', 'B+', 'Wife', '2022-03-22 10:06:39', '2022-03-22 10:06:39'),
(235, 37, 'Jclt R K Namritaa', '25/10/2005', NULL, 'B+', 'Childeren', '2022-03-22 10:08:01', '2022-03-22 10:08:01'),
(236, 105, 'Jc R K Jayanthi', '22/12/1981', '2003-12-04', 'O+', 'Wife', '2022-03-22 10:10:55', '2022-03-22 10:10:55'),
(238, 81, 'Jc M Gomathi', '22/07/1989', NULL, 'B+', 'Spouse', '2022-03-23 08:23:27', '2022-03-23 08:23:27'),
(239, 81, 'Jclt Raanaa', '04/05/2019', NULL, 'B+', 'Childeren', '2022-03-23 08:24:45', '2022-03-23 08:24:45'),
(240, 113, 'Jc R Kesavan', '23/01/1989', NULL, 'O+', 'Spouse', '2022-03-23 09:01:56', '2022-03-23 09:01:56'),
(241, 113, 'Jclt Sakshi', '15/03/2019', NULL, 'O+', 'Childeren', '2022-03-23 09:02:53', '2022-03-23 09:02:53'),
(242, 114, 'JFM A M Siddharthan', '28/09/1987', NULL, 'B+', 'Spouse', '2022-03-23 09:17:09', '2022-03-23 09:17:09'),
(243, 115, 'S Samsun Nafiya', '20/03/1996', NULL, 'B+', 'Spouse', '2022-03-23 09:21:10', '2022-03-23 09:21:10'),
(245, 115, 'Jclt M S Rufaidha Salmaa', '28/04/2020', NULL, 'B+', 'Childeren', '2022-03-23 09:34:58', '2022-03-23 09:34:58'),
(246, 116, 'Jc M Shanmugasundaram', '08/04/1986', NULL, 'B+', 'Spouse', '2022-03-23 09:37:46', '2022-03-23 09:37:46'),
(247, 116, 'Jclt Raanaa', '04/05/2019', NULL, 'B+', 'Childeren', '2022-03-23 09:40:56', '2022-03-23 09:40:56'),
(248, 117, 'Shiva', '27/02/1989', NULL, 'B+', 'Spouse', '2022-03-23 09:46:07', '2022-03-23 09:46:07'),
(250, 117, 'Jclt Nithish', '31/10/2008', NULL, 'B+', 'Childeren', '2022-03-23 09:46:54', '2022-03-23 09:46:54'),
(253, 122, 'Jc Swetha', '11/10/1992', NULL, 'A+', 'Spouse', '2022-03-23 10:09:01', '2022-03-23 10:09:01'),
(254, 122, 'Jclt S Satvika', '04/06/2018', NULL, 'O+', 'Childeren', '2022-03-23 10:09:42', '2022-03-23 10:09:42'),
(255, 123, 'Jc Siddarth Varshan', '17/01/1990', NULL, 'O+', 'Spouse', '2022-03-23 10:14:22', '2022-03-23 10:14:22'),
(256, 123, 'Jclt S Satvika', '04/06/2018', NULL, 'O+', 'Childeren', '2022-03-23 10:14:55', '2022-03-23 10:14:55'),
(257, 126, 'G Sivasangari', '24/09/1996', NULL, 'O+', 'Spouse', '2022-03-23 10:26:21', '2022-03-23 10:26:21'),
(258, 126, 'Jclt A S Yazhisai', '10/07/2019', NULL, 'O+', 'Childeren', '2022-03-23 10:27:10', '2022-03-23 10:27:10'),
(259, 127, 'Sindhu', '04/06/1994', NULL, 'O+', 'Spouse', '2022-03-23 10:34:08', '2022-03-23 10:34:08'),
(260, 128, 'R Rajasekar', '16/11/1977', NULL, 'B+', 'Spouse', '2022-03-23 11:00:13', '2022-03-23 11:00:13'),
(261, 128, 'Jclt R Gokul Prasath', '13/11/2002', NULL, 'B+', 'Childeren', '2022-03-23 11:01:00', '2022-03-23 11:01:00'),
(262, 128, 'Jclt R Monish', '18/12/2008', NULL, 'B+', 'Childeren', '2022-03-23 11:01:29', '2022-03-23 11:01:29'),
(263, 130, 'R Nandhini Devi', '28/08/1990', NULL, 'O+', 'Spouse', '2022-03-23 11:07:50', '2022-03-23 11:07:50'),
(264, 130, 'Jclt R N Mahimitha', '08/08/2013', NULL, 'B+', 'Childeren', '2022-03-23 11:08:39', '2022-03-23 11:08:39'),
(265, 131, 'Divya', '27/08/1990', NULL, 'O+', 'Spouse', '2022-03-23 11:13:07', '2022-03-23 11:13:07'),
(266, 131, 'Jclt Iyal', '22/08/2018', NULL, 'O+', 'Childeren', '2022-03-23 11:13:51', '2022-03-23 11:13:51'),
(267, 132, 'Jc S Gomathi', '08/07/1993', NULL, 'O+', 'Spouse', '2022-03-23 11:18:14', '2022-03-23 11:18:14'),
(268, 118, 'T Balasubramaniam', '23/05/1970', '1998-07-06', 'O+', 'Spouse', '2022-04-01 12:40:30', '2022-04-01 12:40:30'),
(269, 118, 'Jclt S Dharani', '11/05/1999', NULL, 'O+', 'Childeren', '2022-04-01 12:41:23', '2022-04-01 12:41:23'),
(270, 118, 'Jclt T.S.B Karthikeyan', '15/01/2002', NULL, 'O+', 'Childeren', '2022-04-01 12:42:23', '2022-04-01 12:42:23'),
(271, 133, 'S Mageswari', '16/09/1982', '2001-03-07', 'O+', 'Spouse', '2022-04-01 12:51:57', '2022-04-01 12:51:57'),
(272, 133, 'Jclt S Rithika', '29/03/2002', NULL, 'O+', 'Childeren', '2022-04-01 12:56:34', '2022-04-01 12:56:34'),
(273, 133, 'Jclt S Sanjay', '12/06/2004', NULL, 'B+', 'Childeren', '2022-04-01 12:57:14', '2022-04-01 12:57:14'),
(274, 134, 'Jc T THILAKAVEL', '04/06/1992', '2017-06-28', 'A+', 'Spouse', '2022-04-01 13:18:15', '2022-04-01 13:18:15'),
(275, 134, 'Jclt T Thihan', '30/09/2020', NULL, 'O+', 'Childeren', '2022-04-01 13:18:56', '2022-04-01 13:18:56'),
(276, 135, 'Jc K Ponraj', '07/09/1992', '2021-11-11', 'B+', 'Spouse', '2022-04-01 13:28:01', '2022-04-01 13:28:01'),
(277, 136, 'Jc Dr M L Shanmathi', '18/12/1996', '2021-11-11', 'A1+', 'Spouse', '2022-04-01 13:32:29', '2022-04-01 13:32:29'),
(278, 137, 'Nandhini', '14/05/1987', '2012-11-18', 'AB+', 'Spouse', '2022-04-01 13:50:08', '2022-04-01 13:50:08'),
(279, 137, 'Jclt Mahathe Prakash', '29/10/2013', NULL, 'O+', 'Childeren', '2022-04-01 13:50:55', '2022-04-01 13:50:55'),
(280, 137, 'Jclt Adhithe Prakash', '11/10/2017', NULL, 'O+', 'Childeren', '2022-04-01 13:51:32', '2022-04-01 13:51:32'),
(281, 141, 'Jc Priyadharshni Nagaraj', '12/07/1985', '2007-02-22', 'O+', 'Spouse', '2022-04-01 14:18:26', '2022-04-01 14:18:26'),
(282, 141, 'Jclt Jignesh Nagaraj', '02/12/2008', NULL, 'O+', 'Childeren', '2022-04-01 14:19:02', '2022-04-01 14:19:02'),
(283, 142, 'Jc K Nagaraj', '08/05/1978', '2007-02-22', 'A1+', 'Spouse', '2022-04-01 14:22:05', '2022-04-01 14:22:05'),
(284, 142, 'Jclt Jignesh Nagaraj', '02/12/2008', NULL, 'O+', 'Childeren', '2022-04-01 14:22:58', '2022-04-01 14:22:58'),
(285, 143, 'Jc Mangai Kumar', '02/03/1988', '2014-11-12', 'AB+', 'Spouse', '2022-04-01 14:39:05', '2022-04-01 14:39:05'),
(286, 143, 'Jclt Riswanth', '17/10/2015', NULL, 'B+', 'Childeren', '2022-04-01 14:39:50', '2022-04-01 14:39:50'),
(287, 143, 'Jclt Ridhulan', '08/02/2021', NULL, 'O+', 'Childeren', '2022-04-01 14:41:05', '2022-04-01 14:41:05'),
(288, 144, 'Jc Kumar Palanisamy', '28/06/1986', '2014-11-12', 'O+', 'Spouse', '2022-04-01 14:43:08', '2022-04-01 14:43:08'),
(289, 144, 'Jclt Riswanth', '17/10/2015', NULL, 'A+', 'Childeren', '2022-04-01 14:43:51', '2022-04-01 14:43:51'),
(290, 144, 'Jclt Ridhulan', '08/02/2021', NULL, 'O+', 'Childeren', '2022-04-01 14:44:30', '2022-04-01 14:44:30'),
(291, 145, 'R Prema', '04/12/1994', '2013-05-30', 'O+', 'Spouse', '2022-04-01 14:54:32', '2022-04-01 14:54:32'),
(292, 145, 'Jclt Sinekitha R', '25/05/2014', NULL, 'O+', 'Childeren', '2022-04-01 14:55:08', '2022-04-01 14:55:08'),
(293, 145, 'Jclt R Kaviya', '14/01/2021', NULL, 'O+', 'Childeren', '2022-04-01 14:55:40', '2022-04-01 14:55:40'),
(294, 147, 'S Sharimila Devi', '06/01/1987', '2015-11-18', 'AB+', 'Spouse', '2022-04-01 15:11:26', '2022-04-01 15:11:26'),
(295, 147, 'Jclt Eyal Lakshmi', '21/11/2016', NULL, 'O+', 'Childeren', '2022-04-01 15:12:12', '2022-04-01 15:12:12'),
(296, 147, 'Jclt S Aadhirai', '12/01/2018', NULL, 'O+', 'Childeren', '2022-04-01 15:12:44', '2022-04-01 15:12:44'),
(297, 159, 'I Hasina', '11/12/1979', '2000-08-20', 'O+', 'Spouse', '2022-04-08 11:22:53', '2022-04-08 11:22:53'),
(298, 159, 'Jclt I Shahezia Gulnoor', '08/07/2001', NULL, 'O+', 'Childeren', '2022-04-08 11:24:20', '2022-04-08 11:24:20'),
(299, 159, 'Jclt Fazia Akshem', '24/01/2005', NULL, 'O+', 'Childeren', '2022-04-08 11:25:18', '2022-04-08 11:25:18'),
(300, 152, 'S Abirami', '08/09/1991', '2014-11-10', 'O+', 'Spouse', '2022-04-08 11:29:26', '2022-04-08 11:29:26'),
(301, 152, 'Jclt S Haaradhya', '06/10/2015', NULL, 'O+', 'Childeren', '2022-04-08 11:30:08', '2022-04-08 11:30:08'),
(302, 152, 'Jclt S Gurumithran', '22/09/2018', NULL, 'O+', 'Childeren', '2022-04-08 11:30:51', '2022-04-08 11:30:51'),
(303, 105, 'Jclt R K Namritaa', '25/10/2006', NULL, 'O+', 'Childeren', '2022-04-13 08:48:58', '2022-04-13 08:48:58'),
(304, 160, 'M Shanthi Priya', '27/12/1982', '2008-08-27', 'O+', 'Spouse', '2022-04-19 04:34:22', '2022-04-19 04:34:22'),
(305, 160, 'Jclt M Mukundhan Katheriyar', '08/12/2009', NULL, 'O+', 'Childeren', '2022-04-19 04:35:35', '2022-04-19 04:35:35'),
(306, 160, 'Jclt Devhashree Mariyappan', '27/04/2015', NULL, 'B+', 'Childeren', '2022-04-19 04:36:27', '2022-04-19 04:36:27'),
(307, 161, 'Jc L Priya', '08/02/1983', '2010-11-19', 'O+', 'Spouse', '2022-04-28 13:30:48', '2022-04-28 13:30:48'),
(308, 161, 'Jclt R Aaraadhana', '07/03/2012', NULL, 'O+', 'Childeren', '2022-04-28 13:31:29', '2022-04-28 13:31:29'),
(309, 162, 'S.G.Thilagavathi', '01/07/1984', '2008-03-09', 'O+', 'Spouse', '2022-05-24 10:56:36', '2022-05-24 10:56:36'),
(310, 162, 'Just D T Karnika', '12/12/2008', NULL, 'O+', 'Childeren', '2022-05-24 10:57:30', '2022-05-24 10:57:30'),
(311, 162, 'Jclt D T Nakshathra', '29/05/2015', NULL, 'O+', 'Childeren', '2022-05-24 10:58:26', '2022-05-24 10:58:26'),
(312, 126, 'A.S.MAGIZHISAI', '19/05/2022', NULL, 'O+', 'Childeren', '2023-04-24 08:18:46', '2023-04-24 08:18:46'),
(313, 1, 'nivetha', '13/06/2023', '2023-06-16', 'O+', 'Spouse', '2023-06-09 04:44:18', '2023-06-09 04:44:18'),
(314, 1, 'nisha', '05/06/2023', '2023-06-18', 'A1+', 'Spouse', '2023-06-09 04:45:49', '2023-06-09 04:45:49'),
(315, 1, 'Shanmuga Weaving', '04/06/2023', '2023-06-14', 'B+', 'Spouse', '2023-06-09 05:31:10', '2023-06-09 05:31:10'),
(316, 1, 'fhtfht', '24/06/2023', '2023-06-23', 'O+', 'Spouse', '2023-06-21 06:17:27', '2023-06-21 06:17:27'),
(317, 4, 'ramesh', '07/06/2023', '2023-06-22', 'O+', 'Spouse', '2023-06-21 06:20:27', '2023-06-21 06:20:27');

-- --------------------------------------------------------

--
-- Table structure for table `folderName`
--

CREATE TABLE `folderName` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `folderName` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `folderName`
--

INSERT INTO `folderName` (`id`, `folderName`, `title`, `description`, `status`, `createdAt`, `updatedAt`) VALUES
(1, 'grads22', 'graduation', '2022 b.e graduation', 'active', '2024-03-12 10:06:48', '2024-03-12 10:06:48'),
(2, 'grads22', 'graduation', '2022 b.e graduation', 'active', '2024-03-13 11:50:30', '2024-03-13 11:50:30');

-- --------------------------------------------------------

--
-- Table structure for table `GreenChannel`
--

CREATE TABLE `GreenChannel` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `pdf_url` text NOT NULL,
  `pdf_name` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `GreenChannel`
--

INSERT INTO `GreenChannel` (`id`, `pdf_url`, `pdf_name`, `createdAt`, `updatedAt`) VALUES
(1, 'https://jcierodegreencity.in/images/original/Green Channel.jpeg', 'Green Channel - 1st Edition', '2022-01-07 11:23:07', '2022-01-07 11:23:07');

-- --------------------------------------------------------

--
-- Table structure for table `Member`
--

CREATE TABLE `Member` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `gender` enum('male','female','others') DEFAULT 'male',
  `dob` varchar(15) DEFAULT NULL,
  `location` text DEFAULT NULL,
  `blood_group` enum('O+','O-','A+','A-','B+','B-','AB+','AB-','A1+','A2+','A1B+','A1B-','A2B+','HH') DEFAULT NULL,
  `willing_to_donate` enum('yes','no') DEFAULT NULL,
  `office_name` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `sector` varchar(255) DEFAULT NULL,
  `martial_status` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `type` enum('member','boardmember') DEFAULT 'member',
  `status` enum('active','inactive') DEFAULT 'active',
  `app_access` enum('view','full') NOT NULL DEFAULT 'view',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Member`
--

INSERT INTO `Member` (`id`, `profile_pic`, `user_name`, `email`, `contact`, `gender`, `dob`, `location`, `blood_group`, `willing_to_donate`, `office_name`, `job`, `sector`, `martial_status`, `role`, `type`, `status`, `createdAt`, `updatedAt`) VALUES
(1, '/images/placeholder.jpg', 'kowsi', 'test@gmail.com', '+919080855615', 'female', '16/04/2001', 'test', 'B+', 'yes', NULL, 'banking', 'manager', NULL, 'board member', 'boardmember', 'active', '2024-03-06 06:13:10', '2024-03-06 06:13:10'),
(3, '/images/placeholder.jpg', 'abi', 'test@gmail.com', '+919080855614', 'female', '08/09/2001', 'test', 'A+', 'yes', NULL, 'banking', 'loan staff', NULL, 'member', 'member', 'active', '2024-03-06 06:13:10', '2024-03-06 06:13:10'),
(4, '/images/placeholder.jpg', 'bhuvana', 'test@gmail.com', '+919080855613', 'female', '11/03/2001', 'test', 'A-', 'yes', NULL, 'banking', 'sales staff', NULL, 'member', 'member', 'active', '2024-03-06 06:13:10', '2024-03-06 06:13:10'),
(5, '/images/placeholder.jpg', 'parkavi', 'test@gmail.com', '+919080855612', 'female', '26/06/2001', 'test', 'O+', 'yes', NULL, 'college', 'lecturer', NULL, 'member', 'member', 'active', '2024-03-06 06:13:10', '2024-03-06 06:13:10'),
(6, '/images/placeholder.jpg', 'nikitha', 'test@gmail.com', '+919080855611', 'female', '26/11/2001', 'test', 'AB+', 'yes', NULL, 'college', 'student', NULL, 'board member', 'boardmember', 'active', '2024-03-06 06:13:10', '2024-03-06 06:13:10');

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `notification_type` enum('member','boardmember') NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `title`, `description`, `notification_type`, `createdAt`, `updatedAt`) VALUES
(1, 'diwali', 'diwali function', 'member', '2024-03-11 08:38:27', '2024-03-11 08:38:27'),
(2, 'diwali', 'diwali function', 'boardmember', '2024-03-11 08:45:35', '2024-03-11 08:45:35'),
(3, 'diwali', 'diwali function', 'member', '2024-03-11 08:45:50', '2024-03-11 08:45:50');

-- --------------------------------------------------------

--
-- Table structure for table `roleOfHonour`
--

CREATE TABLE `roleOfHonour` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `role_of_honour_year` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Sponser`
--

CREATE TABLE `Sponser` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sponser_name` varchar(255) NOT NULL,
  `sponser_image` varchar(255) DEFAULT NULL,
  `sponser_contact` varchar(255) NOT NULL,
  `sponser_email` varchar(255) NOT NULL,
  `sponser_description` varchar(255) NOT NULL,
  `sponser_location` varchar(255) NOT NULL,
  `sponser_website` varchar(255) NOT NULL,
  `sponser_expiryTime` varchar(255) NOT NULL,
  `role` enum('sponser','main_sponser') DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `Sponser`
--

INSERT INTO `Sponser` (`id`, `sponser_name`, `sponser_image`, `sponser_contact`, `sponser_email`, `sponser_description`, `sponser_location`, `sponser_website`, `sponser_expiryTime`, `role`, `status`, `createdAt`, `updatedAt`) VALUES
(1, 'kowsi', 'https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw', '9080855615', 'gowherjanj786@gmail.com', 'fhwhasfhlkajflk', 'erode', 'www.hagjqhk.in', '2024-03-30', 'sponser', 'active', '2024-03-05 07:44:21', '2024-03-05 07:44:21'),
(2, 'abi', 'https://play-lh.googleusercontent.com/1-hPxafOxdYpYZEOKzNIkSP43HXCNftVJVttoo4ucl7rsMASXW3Xr6GlXURCubE1tA=w3840-h2160-rw', '56789900003', 'abi@gmail.com', 'agdqjgaQFHLQK', 'trichy', 'sfgjakqKLgl;kr', '2024-03-22', 'sponser', 'active', '2024-03-05 07:45:23', '2024-03-05 07:45:23');

-- --------------------------------------------------------

--
-- Table structure for table `userRoles`
--

CREATE TABLE `userRoles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_name` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userRoles`
--

INSERT INTO `userRoles` (`id`, `role_name`, `createdAt`, `updatedAt`) VALUES
(1, 'Director', '2021-12-15 15:05:39', '2021-12-15 15:05:39'),
(2, 'President', '2021-12-15 15:05:56', '2021-12-15 15:05:56'),
(3, 'Vice President - Resource, Business and Internationalisim ', '2021-12-15 15:32:37', '2021-12-15 15:32:37'),
(4, 'Secretary', '2021-12-15 15:32:58', '2021-12-15 15:32:58'),
(5, 'Member', '2021-12-15 15:33:15', '2021-12-15 15:33:15'),
(7, 'Vice President - Management', '2021-12-15 15:34:05', '2021-12-15 15:34:05'),
(8, 'Vice President - Community', '2021-12-15 15:34:23', '2021-12-15 15:34:23'),
(9, 'Vice President - Individual Development', '2021-12-15 15:34:47', '2021-12-15 15:34:47'),
(10, 'Treasurer', '2021-12-15 15:35:03', '2021-12-15 15:35:03'),
(11, 'Joint Secretary', '2021-12-15 15:35:23', '2021-12-15 15:35:23'),
(12, 'Immediate Past President', '2021-12-16 15:13:02', '2021-12-16 15:13:02'),
(13, 'Past President', '2022-01-27 13:20:46', '2022-01-27 13:20:46'),
(15, 'Demo', '2022-03-23 05:37:18', '2022-03-23 05:37:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Admin`
--
ALTER TABLE `Admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Banners`
--
ALTER TABLE `Banners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `BloodReq`
--
ALTER TABLE `BloodReq`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `boardMembers`
--
ALTER TABLE `boardMembers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `BusinessType`
--
ALTER TABLE `BusinessType`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Designation`
--
ALTER TABLE `Designation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `Events`
--
ALTER TABLE `Events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `eventsImage`
--
ALTER TABLE `eventsImage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Family`
--
ALTER TABLE `Family`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `folderName`
--
ALTER TABLE `folderName`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `GreenChannel`
--
ALTER TABLE `GreenChannel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Member`
--
ALTER TABLE `Member`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roleOfHonour`
--
ALTER TABLE `roleOfHonour`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `Sponser`
--
ALTER TABLE `Sponser`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `userRoles`
--
ALTER TABLE `userRoles`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Admin`
--
ALTER TABLE `Admin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Banners`
--
ALTER TABLE `Banners`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `BloodReq`
--
ALTER TABLE `BloodReq`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `boardMembers`
--
ALTER TABLE `boardMembers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `BusinessType`
--
ALTER TABLE `BusinessType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Designation`
--
ALTER TABLE `Designation`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `Events`
--
ALTER TABLE `Events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `eventsImage`
--
ALTER TABLE `eventsImage`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=134;

--
-- AUTO_INCREMENT for table `Family`
--
ALTER TABLE `Family`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=318;

--
-- AUTO_INCREMENT for table `folderName`
--
ALTER TABLE `folderName`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `GreenChannel`
--
ALTER TABLE `GreenChannel`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Member`
--
ALTER TABLE `Member`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `roleOfHonour`
--
ALTER TABLE `roleOfHonour`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Sponser`
--
ALTER TABLE `Sponser`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `userRoles`
--
ALTER TABLE `userRoles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `boardMembers`
--
ALTER TABLE `boardMembers`
  ADD CONSTRAINT `boardMembers_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `Designation`
--
ALTER TABLE `Designation`
  ADD CONSTRAINT `Designation_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `roleOfHonour`
--
ALTER TABLE `roleOfHonour`
  ADD CONSTRAINT `roleOfHonour_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`) ON UPDATE CASCADE;

CREATE TABLE `MemberAuth` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint UNSIGNED NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `login_email` varchar(255) DEFAULT NULL,
  `login_phone` varchar(50) DEFAULT NULL,
  `is_setup_complete` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_id` (`member_id`),
  UNIQUE KEY `google_id` (`google_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `PasswordResetToken` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint UNSIGNED NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `type` enum('email_link','identity_verify') NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `MemberSession` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint UNSIGNED NOT NULL,
  `fcm_token` varchar(512) DEFAULT NULL,
  `device_info` varchar(255) DEFAULT NULL,
  `last_active` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fcm_token` (`fcm_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Referral` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `referrer_member_id` bigint UNSIGNED NOT NULL,
  `linked_member_id` bigint UNSIGNED DEFAULT NULL,
  `referral_type` enum('self','jci_member','non_jci_member') NOT NULL,
  `referred_name` varchar(255) NOT NULL,
  `referred_phone` varchar(50) NOT NULL,
  `remark` text DEFAULT NULL,
  `referred_member_id` bigint UNSIGNED DEFAULT NULL,
  `status` enum('pending','accepted','rejected') NOT NULL DEFAULT 'pending',
  `connection_type` enum('non_closed_connect','completed') DEFAULT NULL,
  `connect_amount` decimal(12,2) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `FitnessStory` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `member_id` bigint UNSIGNED NOT NULL,
  `image_path` varchar(512) NOT NULL,
  `expires_at` datetime NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_fitness_expires` (`expires_at`),
  KEY `idx_fitness_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

SELECT 'SUCCESS: JCI complete database installed.' AS Status;
-- =============================================================================
-- PART 2: PRODUCTION MYSQL APP USER (for Node.js backend)
-- =============================================================================
-- Change password before running on live server!

CREATE USER IF NOT EXISTS 'jci_app'@'localhost' IDENTIFIED BY 'CHANGE_ME_STRONG_DB_PASSWORD';
CREATE USER IF NOT EXISTS 'jci_app'@'127.0.0.1' IDENTIFIED BY 'CHANGE_ME_STRONG_DB_PASSWORD';
-- If backend runs on a different host than MySQL, also grant from that host:
-- CREATE USER IF NOT EXISTS 'jci_app'@'10.0.0.5' IDENTIFIED BY 'CHANGE_ME_STRONG_DB_PASSWORD';

GRANT ALL PRIVILEGES ON jci.* TO 'jci_app'@'localhost';
GRANT ALL PRIVILEGES ON jci.* TO 'jci_app'@'127.0.0.1';
FLUSH PRIVILEGES;

-- =============================================================================
-- PART 3: PRODUCTION ADMIN ACCOUNT (known password for first login)
-- =============================================================================
-- Default seed admin (greencity) password is unknown ? use this account instead.
-- Password: Admin@12345  (bcrypt hash below)

INSERT INTO `Admin` (`id`, `email_id`, `phone`, `username`, `password`, `user_type`, `status`, `createdAt`, `updatedAt`)
VALUES (
  2,
  'admin@jci.local',
  '+910000000000',
  'admin',
  '$2b$10$rAfJx7OAI087t96Lj7pVVuT3eSkBgqbV7iVGczHMB4YHXlND/4kaC',
  'ROOT',
  'active',
  NOW(),
  NOW()
)
ON DUPLICATE KEY UPDATE
  `email_id` = VALUES(`email_id`),
  `password` = VALUES(`password`),
  `status` = 'active';

-- =============================================================================
-- PART 4: VERIFY INSTALLATION
-- =============================================================================

SELECT 'Database' AS check_type, DATABASE() AS value;
SELECT 'Tables' AS check_type, COUNT(*) AS value FROM information_schema.tables WHERE table_schema = 'jci';
SELECT 'Admin users' AS check_type, COUNT(*) AS value FROM `Admin`;
SELECT 'Members' AS check_type, COUNT(*) AS value FROM `Member`;
SELECT 'Referral module' AS check_type, IF(COUNT(*) > 0, 'OK', 'MISSING') AS value FROM information_schema.tables WHERE table_schema = 'jci' AND table_name = 'Referral';
SELECT 'Fitness module' AS check_type, IF(COUNT(*) > 0, 'OK', 'MISSING') AS value FROM information_schema.tables WHERE table_schema = 'jci' AND table_name = 'FitnessStory';
SELECT 'Member auth' AS check_type, IF(COUNT(*) > 0, 'OK', 'MISSING') AS value FROM information_schema.tables WHERE table_schema = 'jci' AND table_name = 'MemberAuth';

SELECT 'SUCCESS: JCI live server database is ready. Update backend .env and restart Node.js.' AS Final_Status;

