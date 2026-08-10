-- =============================================================================
-- JCI Erode Metro — member import from registration form Excel
-- Source: JCI Erode Metro Member Registration Form (Web &APP).xlsx
-- Members: 18 (17 from Excel + Niresh)
-- Profile pics: /images/1.* … /images/N.* (row order); Niresh uses placeholder
--
-- Before running: backup the live database.
-- Also upload images 1.*–N.* to the API static /images folder.
--
-- Usage:
--   mysql -u jcierodemetro -p api_jcierodemetro < add_members_erode_metro_registration.sql
--   Or phpMyAdmin -> Import -> this file
-- =============================================================================

USE `api_jcierodemetro`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS `MemberImportStaging`;

CREATE TEMPORARY TABLE `MemberImportStaging` (
  `profile_pic` varchar(255) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `membership_id` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `contact` varchar(255) NOT NULL,
  `gender` enum('male','female','others') NOT NULL DEFAULT 'male',
  `dob` varchar(15) DEFAULT NULL,
  `location` text DEFAULT NULL,
  `blood_group` enum('O+','O-','A+','A-','B+','B-','AB+','AB-','A1+','A2+','A1B+','A1B-','A2B+','HH') DEFAULT NULL,
  `willing_to_donate` enum('yes','no') DEFAULT NULL,
  `office_name` varchar(255) DEFAULT NULL,
  `sector` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `member_type` enum('member','boardmember') NOT NULL DEFAULT 'member',
  `board_member` enum('yes','no') NOT NULL DEFAULT 'no',
  `martial_status` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `jci_location` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `MemberImportStaging` (
  `profile_pic`, `user_name`, `membership_id`, `email`, `contact`,
  `gender`, `dob`, `location`, `blood_group`, `willing_to_donate`,
  `office_name`, `sector`, `job`, `member_type`, `board_member`,
  `martial_status`, `role`, `jci_location`
) VALUES
('/images/1.png', 'S.M. SYED SIRAJUDEEN', '1492662', 'sirajrubeen1984@gmail.com', '+919080082039', 'male', '24/04/1984', '11, SKC road erode', 'O+', NULL, 'RUBEEN BAGS', 'Bag manufacturers', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/2.jpeg', 'Jc HGF N. Karthick', '1320370', 'nkarthick.in@gmail.com', '+919698444411', 'male', '27/05/1990', 'PagePluz 
11/2, LS Building 2nd floor, 
Annamalai Layout, 
Erode - 638011', 'A+', 'yes', 'PagePluz', 'Influencer', 'Business', 'boardmember', 'yes', 'married', 'Past President', 'JCI Erode Metro'),
('/images/3.jpg', 'Jc R. Manikandan', '1337451', 'goodideamani.dm@gmail.com', '+916382658695', 'male', '23/11/1993', '28, Periyanna Street, Erode - 1', 'O-', 'yes', 'Good Idea Creators', 'Graphic Designer', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/4.JPG', 'S.Thangapandian', '1508256', 'goldenacc16@gmail.com', '+919976142003', 'male', '05/06/1990', '39/103,Chennipali,Mukasi Anumanpalli Po,Erode-638101', 'O+', NULL, 'Golden Insure & E sevai,And Mobiles', 'insurance Associate Partner (Life,Health,gentral)', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/5.jpg', 'M Kathirvel', '1480090', 'skpainting2022@gmail.com', '+919787818777', 'male', '03/06/1997', '6/145 C Mettupalayam, Perode(PO),Chithode, Erode', 'O+', 'yes', 'SK PAINTINGS', 'PAINTING CONTRACTOR', 'Business', 'member', 'no', 'married', 'Member', 'JCI Erode Metro'),
('/images/6.jpeg', 'R.Poornima', '1513691', 'rajapoornima2@gmail.com', '+919344052046', 'female', '20/02/2003', 'Erode surampatti', 'O+', NULL, 'avalnaturals', 'Cosmetics', 'Business', 'member', 'no', 'unmarried', 'Member', 'JCI Erode Metro'),
('/images/7.jpg', 'Jc R.L. Prabhu', '1491788', 'www.lakshmiambulance1996@gmail.com', '+918682943079', 'male', '31/12/1995', '16/5, Chinnamuthu 2nd St, Edayankattuvalasu, Erode - 11', 'O-', 'no', 'Sri Lakshmi Ambulance', 'Ambulance Services', 'Business', 'member', 'no', 'married', 'Member', 'JCI Erode Metro'),
('/images/8.jpg', 'G. Vijayaragavan', '1480085', 'vijaysmile.ragavan@gmail.com', '+919600886639', 'male', '05/08/1991', 'China sadayampalayam, Erode', 'O+', 'yes', 'Creative Vision', 'Cctv Sales and Service', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/9.jpg', 'JFM Nandhakumar TG', '1298016', 'fidusgroups@gmail.com', '+919087830505', 'male', '23/08/1985', '20, Velaa Residency, 2nd St,
Ondikaranpalayam, villarasampatti 
Erode', 'A+', 'yes', 'FIDUS INSURANCE & INVESTMENTS', 'Insurance', 'Business', 'member', 'no', 'married', 'Member', 'JCI Erode Metro'),
('/images/10.jpg', 'Jc R Sekar', '1494909', 'sksekarsk@gmail.com', '+917339424121', 'male', '09/05/1994', 'S/O C.Ramasamy,
123, Indhiragandhi street, Palayapalayam,
Collector Office (Po), Erode -638011.', 'B+', 'yes', 'Karpagam RealEstate', 'Property Buying,Selling, and Investments', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/11.png', 'JC S NAVEENKUMAR', '1513000', 'findmyloans2025@gmail.com', '+918015612309', 'male', '07/10/1994', 'D4 Nikil nivas Lakshmi garden phase 2 46pudur Erode 2', 'B+', NULL, 'FIND MY LOANS', 'LOAN CONSULTANTCY', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/12.jpg', 'Jc M.Nanthini', '1512998', 'nanthiniselviraj@gmail.com', '+917708076660', 'female', '08/01/1994', 'No28, Periyannan street, Erode', 'O+', 'yes', 'Erode Balloon Decors', 'Balloon Decor', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/13.jpg', 'Jc M.Sathesh Kumar', '1557009', 'manicktraders.erode@gmail.com', '+919952854104', 'male', '25/02/1993', '54 Main Road, Anaigoundenpudur, vellottamparappu Erode 638154', 'B+', 'yes', 'Manick Traders', 'FMCG Distributor', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/14.jpg', 'Shankar Marimuthu', '1474732', 'shankarelex43@gmail.com', '+918883712177', 'male', '15/04/1991', 'No 6, New Ram Nagar 1st , payment office backside, EBP Nagar, Erode', 'AB+', 'no', 'Future tech service system', 'Home appliances service', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/15.jpg', 'Jc. Karthi R', '1474731', 'karthidata67@gmail.com', '+918056467044', 'male', '06/05/1991', 'EBP Nagar,Erode -638004', 'B+', 'yes', 'Future Tech Service System', 'Home Appliances Service', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/16.jpg', 'Shanmugam P', '1507434', 'shanmugamp91@gmail.com', '+919688348987', 'male', '21/09/1991', '65/4, K.P.K NAGAR, ELLAPALAYAM, PERIYASEMUR,ERODE-638004', 'O+', 'yes', 'Mayon Home Made Cakes', 'Cakes', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/17.jpg', 'Jc HGF D. Navaneethakrishnan', '1337490', 'jcdnavaneethakrishnan@gmail.com', '+919965286428', 'male', '20/05/1987', 'Vedam Food Products 
34- ST 2, Manakattupudur, 
Naduppalayam, 
Vellottanparappu - Post
Pasur - via
Erode. -638154
Ph - 7845747878
         9965286428', 'O+', 'yes', 'Vedam Food Products', 'Food Products Manufacturing', 'Business', 'boardmember', 'yes', 'married', 'Board Member', 'JCI Erode Metro'),
('/images/placeholder.jpg', 'Niresh', NULL, 'nireshtoranto@gmail.com', '+919345034653', 'male', '15/06/1995', 'Perundurai Road, Erode, Tamil Nadu', 'B+', 'yes', 'Nutz Technovation', 'Information Technology', 'Software Developer', 'member', 'no', 'unmarried', 'Member', 'JCI Erode Metro');

INSERT INTO `Member` (
  `profile_pic`, `user_name`, `membership_id`, `email`, `contact`,
  `gender`, `dob`, `location`, `blood_group`, `willing_to_donate`,
  `office_name`, `job`, `sector`, `martial_status`, `role`, `jci_location`,
  `type`, `status`, `app_access`, `createdAt`, `updatedAt`
)
SELECT
  s.`profile_pic`, s.`user_name`, s.`membership_id`, s.`email`, s.`contact`,
  s.`gender`, s.`dob`, s.`location`, s.`blood_group`, s.`willing_to_donate`,
  s.`office_name`, s.`job`, s.`sector`, s.`martial_status`, s.`role`, s.`jci_location`,
  s.`member_type`, 'active', 'view', NOW(), NOW()
FROM `MemberImportStaging` s
WHERE NOT EXISTS (
  SELECT 1 FROM `Member` m
  WHERE m.`email` = s.`email` OR m.`contact` = s.`contact`
);

INSERT INTO `boardMembers` (`member_id`, `createdAt`, `updatedAt`)
SELECT m.`id`, NOW(), NOW()
FROM `Member` m
INNER JOIN `MemberImportStaging` s ON s.`email` = m.`email`
WHERE s.`board_member` = 'yes'
  AND NOT EXISTS (
    SELECT 1 FROM `boardMembers` b WHERE b.`member_id` = m.`id`
  );

DROP TEMPORARY TABLE IF EXISTS `MemberImportStaging`;

SET FOREIGN_KEY_CHECKS = 1;

COMMIT;

SELECT 'Members imported (total active)' AS check_type, COUNT(*) AS value
FROM `Member` WHERE `status` = 'active';
SELECT 'Board members linked' AS check_type, COUNT(*) AS value FROM `boardMembers`;
