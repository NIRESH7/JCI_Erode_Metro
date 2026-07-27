-- =============================================================================
-- JCI Member bulk import (generated from Excel)
-- Source: JCI_Member_Import_Template (1).xlsx
-- Members: 39 (includes extra member: Niresh Toranto)
--
-- Before running:
--   1. Run jci_production_live_setup.sql first (fresh schema).
--   2. Backup the database.
--
-- Usage:
--   mysql -u jcierodegreencity -p api_jcierodegreencity < member_bulk_import.sql
--   Or phpMyAdmin -> Import -> this file
-- =============================================================================

USE `api_jcierodegreencity`;

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
('https://drive.google.com/open?id=1qT3qHgUIDSbmlmsiH4NQ7th0T34yOJjw', 'S.Murugesan', NULL, 'ashwinhiphoto@gmail.com', '+919092068144', 'male', '11/09/1988', 'Ashwinphotography.MR , complex SPB Colony,Tajnagar', 'B+', NULL, 'Ashwinphotography,Tajnagar', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1TK7i_0TJ5EWhuT1KPWj4RYKUaRgYbXVv', 'Bhoobalakrishnan', NULL, 'gbhoobalakrishnan12@gmail.com', '+919842903235', 'male', '12/06/1981', '10/253,sai golden City,Sanarpalayam, Thuduppathi,perundurai', 'B+', NULL, 'Siva enterprises', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1LYDbQnS8nH-7Mx2EU9oSn4eV5PsNq66V', 'Hemanth S', NULL, 'hemanths.cct@gmail.com', '+916382651011', 'male', '07/02/2001', 'Erode', 'O+', NULL, 'Kuppai Scalers', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1hkoa-pP82hfViC96jPgrxVEyWZZgrWqr', 'Nithya J', NULL, 'kumarnithya987@gmail.com', '+918012279927', 'male', '12/10/1991', '61/6, MP House, suppurayan vasalu, Lakkapuram. 638002.', 'O+', NULL, 'Paper cone manufacturing', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1YHEGmK5npwc_oPQBkvlxZ1MZ6R9As76b', 'S. Sathish Kumar', NULL, 'santhoshsathish60@gmail.com', '+919976514268', 'male', '15/06/1990', '73/2, Ishwarya park, ondikkaran palayam, Villarasampatti, Erode -638107.', 'A1+', NULL, 'QC- Chemist, Sakthi Masala Pvt Ltd, Erode', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1gxsn1J_NWOL68nv2mrZYER3qRbHsnOjx', 'Gokul v', NULL, 'gokulbio310@gmail.com', '+917708526112', 'male', '30/07/1998', '81, main road, p.mettuppalayam, erode - 638315', 'B-', NULL, 'Sanitary inspector @ Erode corporation', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1I7lI391Wl92CFVcp-czxBiWzQZSvp4B0', 'Gokula Krishnan P', NULL, 'gokulrpkrishnan@gmail.com', '+919865048887', 'male', '22/10/1997', '161, Kiliankaatu Thottam,Chinniyampalayam,Jambai(po),Bhavani(TK),Erode-638312', 'B+', NULL, 'Sri Amman Steels Pvt Ltd, Construction materials Supply', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1llYRU74Pd0xg_c8j9JViymtZ7Y1sT77n', 'Sabarish', NULL, 'sabarish1006@gmail.com', '+918668012010', 'male', '30/07/1994', '28/1, Kalaimagal Street, Ashokapuram, Erode - 638004', 'O+', NULL, 'AT Digitals', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1HMtLQSqCdYj6NQOd3a_sFyO1kVLYNa3d', 'MAGESHWARI K P', NULL, 'mageshwarikp808@gmail.com', '+919487834808', 'male', '10/07/2004', '15, KOONAMPATTI PUDHUR , KOONAMPATTI VILLAGE, PALLAGOUNDAMPALAYAM (Po), UTHUKULI (Tk), TIRUPPUR -638056', 'B+', NULL, 'Student', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1VO2lbugV6dRkONOyTZSG0Pq56cXj9pCu', 'M. Mohana priya', NULL, 'mohanapriyamaanikam@gmail.com', '+916380157213', 'male', '13/10/2004', 'Allampalayam, sakthi nagar, Tiruppur-638103', 'B+', NULL, 'Student', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1hoEPdYu5F5tDdE0zD8M7u8MFY4qZZKCg', 'Rajesh', NULL, 'rajesharumugam3@gmail.com', '+918072829200', 'male', '03/12/1997', 'D.no.8 varuki 6th street', 'O+', NULL, 'Bhuvana Apparels', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=14FJ3QYZbA7LsMGn7t51ePSvhwkNVSHnm', 'DINESH K', NULL, 'kdineshgsterd@gmail.com', '+916382188795', 'male', '28/08/1999', '71C/1B, PERANTHAR KADU, C.N.PALAYAM, B.KOMARAPALAYAM.638183', 'A2B+', NULL, 'ACCOUNTANT', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=13V8v3KA-Kul-bUvhpPF7pdMJa-ifjZwo', 'Shiva shankar Kp', NULL, 'shivasan93@gmail.com', '+919108883555', 'male', '17/04/1993', '85/1, Kcp Chinnavar illam , Kcp chinnavar street , Perundurai road, Erode -638011', 'A1+', NULL, 'Playzo 33', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1qa5orPoaCtcd6_jxf8BfSz64j1S7zqQ_', 'Poongodi Udayakumar', NULL, 'poongodi123@gmail.com', '+918105697674', 'male', '16/12/1982', '230B7 peranthar kadu, Komarapalayam - 638183', 'A1+', NULL, '-', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1et2nE4FGYRUTcJRMxIevM2oS_NA72aJ5', 'Ramakrishnan', NULL, 's3fabricationsoct@gmail.com', '+919698693311', 'male', '01/10/1981', 'Kiliyampatty Mullamparappu Erode', 'O+', NULL, 'Samy SS Engineering', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1oL1lrA1Bop2pI0hTIXNhh_3D5WGr4Pqe', 'HARSHIT L', NULL, 'slhharshit6262@gmail.com', '+919442586262', 'male', '31/10/2007', '7/33,Semur , Poondurai Semur ,Aval Poondurai ,Erode-638104', 'O+', NULL, 'Sree Pondevi Transports - Modakkurichi', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=15xlBOQXfucJTOpl1rrG5-oAWpaXj809Y', 'Anitha S', NULL, 'anithaing@gmail.com', '+919789486068', 'male', '25/05/1990', '65,ASR Apartment', 'O+', NULL, 'Gee Ar Agency', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1aQWeVlIOufdgGl4LLU-N-_VLrL6gN-q2', 'BALAJI V K', NULL, 'chitralayaprinters@gmail.com', '+919843217669', 'male', '24/03/1997', 'ASOKAPURAM ,KASPAPETTAI(PO), AVALPOONDURAI (VIA), ERODE - 638115', 'O+', NULL, 'CHITRALAYA PRINTERS', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1DKlmWd4ZliCahgOou3KJF6r6qzNyyCuN', 'Mohanapriya T', NULL, 'tmpksrce@gmail.com', '+919578618691', 'male', '11/06/1989', 'W/O Dhakshinamoorthi V, 33 Kovilkadu, Nathakattupalayam, Pungampadi, Perundurai, Erode -638112.', 'O+', NULL, 'Associate Professor', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=11CjcY5GD8V0V2PUMAsDQ3NSbPfLv2_pM', 'Sachithanantham R', NULL, 'rajendirantraders2016@gmail.com', '+919865614472', 'male', '18/11/1991', 'Natha goundan Palayam', 'O+', NULL, 'Gunny Bag and plastic bags supplier', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1lhHY0QQp1AhUsXFz4rynXxf8E7dsMaZj', 'Tamizharasu M', NULL, 'mtamizharasu2020@gmail.com', '+918072732533', 'male', '31/12/2005', '9, Arikkarankattur road,
Vellottamparappu,
Erode - 638154', 'O+', NULL, 'R.N & CO., Contractors. I''m pursuing my B.E Civil engineering at PSG ITECH, COIMBATORE 0', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=144KFoSqC46y3P8hxMv-xW5y3TwzkpXMt', 'Kanagaraj', NULL, 'erodeshoppingvlogksdn@gmail.com', '+917448866982', 'male', '01/01/1985', '119,lakshminagar vendipalayam erode.2', 'O+', NULL, 'Government municipal corporation', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1FXlE6yypnQkzcdw4DR4YRF4oGxMddw4D', 'Sathishkumar B', NULL, 'erodetugofwarassociation@gmail.com', '+919994141143', 'male', '28/02/1984', 'Erode', 'A1+', NULL, 'Teacher', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1FDEIq_gFxVRnL50lXzyncUOhn-ogTnCy', 'Prasaath', NULL, 'prasaathkris@gmail.com', '+917010457347', 'male', '14/08/1999', '163,Mettupalayam,Elumathur,Erode-638104.', 'O+', NULL, 'NA', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=10heMaRn6r_cr03wbIcNIx8npueQnXuaF', 'Thangamanikandan S', NULL, 'manistkn@gmail.com', '+919750000216', 'male', '25/07/1987', '200, Nagaratchi Nagar,Railway Colony Post,solar, Erode - 2', 'B+', NULL, 'Aptline Technologies Private Limited- Security system and automation solution provider', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1QtC2w6nSAdkmAqUTASrpJ8ZNyiDDYBaf', 'Saranya Krishnamurthy', NULL, 'saranyaak1990@gmail.com', '+919659451351', 'male', '07/05/1990', 'No.5, Mekkan Street, Bhavani-638301', 'B+', NULL, 'Tecsity Edtech Private Limited', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1UKZ8O8ZsWzRNlF9HSl4rvyE6c2h43sZ5', 'Mushtoq ahamed', NULL, 'mushtoqahamed@gmail.com', '+919043783508', 'male', '13/04/1981', '99/100,sathy road, erode-638003', 'A+', NULL, 'Universal xerox', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1mxPovw6mjYwzpIVqQAOOA1Dt17tB9GtQ', 'Gokul', NULL, 'gokul8600@gmail.com', '+919750760000', 'male', '05/01/1995', '175 chidambaram colony , periyar nagar , erode', 'B+', NULL, 'Gokul Adds', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1qDROhs2N1eDwxNO7QHlhTUz42tq4jWn0', 'Thalapathi V', NULL, 'thalapathi5744@gmail.com', '+919942731020', 'male', '07/06/1979', '2/5/240 kattukottigal unjapalayam Boothapadi po Anthiyur Tk. Erode Dt 638311', 'A1+', NULL, 'Amman Builders', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=12U6w4EYwBc6nvbnPCB5c-dfBwPmfDlRY', 'Sumi Priya S', NULL, 'sumihoney2509@gmail.com', '+919087433533', 'male', '25/09/1985', 'SS NUTRITION CENTRE 
37, Chitra Towers, 
Near Thirunagar colony Axis Bank,
Erode 638003', 'A1+', NULL, 'SS Nutrition Centre - Nutrition and Nutritional Supplements', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1ORC3UbdQMgPke_7_XlNtZsTwbMejzXJC', 'Udayakumar B', NULL, 'udaybalakrishnan1987@gmail.com', '+919842539143', 'male', '08/04/1987', '123, Kamaraj Padippagam', 'A1+', NULL, 'Platinum Groups', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=13LZIKtCDFDLVmg4mCKPwMxTHBgVLhiMP', 'Dhinakar', NULL, 'dhinakarvet@gmail.com', '+919092706555', 'male', '19/10/2001', 'Modakkurichi,erode', 'A1+', NULL, 'Sevarkodi Earthmovers', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1_pjTlurZmycJMjbsFv4WhrlDvDTOR8v0', 'PRATHEEBHA P', NULL, 'pratheebhaprasanth@gmail.com', '+919597630273', 'male', '22/01/2003', '18 Sinthan Nagar 4 th Street krishnampalayam, Erode - 3.', 'O-', NULL, 'Avengers Baby Cartoon (ABC Entertainment)', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=19xuOPnEOfxkzwsB_0wtdbyM0C0Auwm-n', 'Poonguzhali. S', NULL, 'poonguzhalisivaps@gmail.com', '+919894247074', 'male', '25/04/1989', 'No 17 Rithuna Nagar,Rangamplayam', 'A2B+', NULL, 'DCAUTOMOTIVE', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1dLvbowtJ7lh9t_4uNeNVYUlfWD00Q8el', 'Suganya S', NULL, 'suganyasundharajan@gmail.com', '+919566588996', 'male', '20/10/1994', '46/ Jeeva nagar, Thirunagar colony, erode', 'O+', NULL, 'Cheliyan chit funds pvt Ltd', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1uLpACGlhUiXPbIAc2qIco-cmv02G2FGW', 'Sanjiv kumar. S', NULL, 'ceeyesinteriorserd@gmail.com', '+919976969311', 'male', '10/07/1994', 'M. Chinnasamy illam, iraniyan street, Rangampalayam, Erode', 'O+', NULL, 'Ceeyes interiors|constructions', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=1sq2OY1Pyi9VInWEXjLaMACLWoeFxer-u', 'Harikrishnan S', NULL, 'harikrishss.16@gmail.com', '+916382380381', 'male', '16/07/2001', 'Erode', 'O+', NULL, 'Building Doctor Erode - Construction chemicals', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('https://drive.google.com/open?id=11uZBHXb-3NrZV7TSUCPFi8WHeFhmHMC_', 'V VASUDEVAN', NULL, 'vasucool052@gmail.com', '+919688001144', 'male', '19/03/1994', '35A,Uduparai Vellaiyam Palayam,Solipalayam (po) Avalpoondurai,Erode', 'O+', NULL, 'PONSENTHUR TRADERS', NULL, NULL, 'member', 'no', NULL, 'Member', 'Erode'),
('/images/placeholder.jpg', 'Niresh Toranto', NULL, 'nireshtoranto@gmail.com', '+919345034653', 'male', '15/06/1995', 'Perundurai Road, Erode, Tamil Nadu', 'B+', 'yes', 'Nutz Technovation', 'Information Technology', 'Software Developer', 'member', 'no', 'unmarried', 'Member', 'JCI Erode Greencity');

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
