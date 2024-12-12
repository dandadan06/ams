-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 09, 2024 at 06:25 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ams`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `attendance_time` time NOT NULL,
  `remarks` varchar(255) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `student_id`, `attendance_time`, `remarks`, `date`) VALUES
(11, 26, '21:39:03', 'Present', '2024-12-09'),
(12, 26, '21:39:41', 'Present', '2024-12-09'),
(13, 26, '21:55:03', 'Present', '2024-12-09'),
(14, 26, '23:20:25', 'Present', '0000-00-00'),
(15, 26, '23:24:43', 'Present', '2024-12-09'),
(16, 28, '23:24:56', 'Present', '2024-12-09'),
(17, 26, '23:27:03', 'Present', '2024-12-09'),
(18, 28, '23:27:19', 'Present', '2024-12-09'),
(19, 28, '23:30:05', 'Present', '2024-12-09'),
(20, 26, '23:31:36', 'Present', '2024-12-09');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_records`
--

CREATE TABLE `attendance_records` (
  `record_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance_records`
--

INSERT INTO `attendance_records` (`record_id`, `student_id`, `remarks`, `time`) VALUES
(1, 26, 'Present', '2024-12-09 13:59:09'),
(2, 8, 'Present', '2024-12-09 13:59:45'),
(3, 26, 'Present', '2024-12-09 15:32:43'),
(4, 26, 'Present', '2024-12-09 15:33:12'),
(5, 26, 'Present', '2024-12-09 15:33:52'),
(6, 28, 'Present', '2024-12-09 15:34:18'),
(7, 28, 'Present', '2024-12-09 15:51:30'),
(8, 28, 'Present', '2024-12-09 15:55:20'),
(9, 28, 'Present', '2024-12-09 16:05:36'),
(10, 28, 'Present', '2024-12-09 16:20:31'),
(11, 28, 'Present', '2024-12-09 16:35:28'),
(12, 28, 'Present', '2024-12-09 16:38:44'),
(13, 28, 'Present', '2024-12-09 16:40:44'),
(14, 29, 'Present', '2024-12-09 16:44:20'),
(15, 28, 'Present', '2024-12-09 16:46:03'),
(16, 28, 'Present', '2024-12-09 16:58:44'),
(17, 28, 'Present', '2024-12-09 16:59:09'),
(18, 28, 'Present', '2024-12-09 17:07:14'),
(19, 28, 'Present', '2024-12-09 17:23:40');

-- --------------------------------------------------------

--
-- Table structure for table `quizzes`
--

CREATE TABLE `quizzes` (
  `quiz_id` int(11) NOT NULL,
  `class_code` varchar(10) NOT NULL,
  `quiz_title` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quiz_options`
--

CREATE TABLE `quiz_options` (
  `option_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `option_text` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quiz_questions`
--

CREATE TABLE `quiz_questions` (
  `question_id` int(11) NOT NULL,
  `quiz_id` int(11) NOT NULL,
  `question_text` text NOT NULL,
  `correct_answer` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `section`
--

CREATE TABLE `section` (
  `section` varchar(50) NOT NULL,
  `year` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `section`
--

INSERT INTO `section` (`section`, `year`) VALUES
('NS', 1);

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`id`, `username`, `email`, `password`) VALUES
(2, 'gelay', 'gelay@gmail.com', 'gelay'),
(3, 'nigga', 'nigga@gmail.com', 'nigga1520'),
(4, 'miggy', 'miggy@gmail.com', 'migu'),
(5, 'morty', 'morty@gmail.com', 'morty');

-- --------------------------------------------------------

--
-- Table structure for table `student_info`
--

CREATE TABLE `student_info` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `student_id` varchar(50) NOT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `parent` varchar(50) NOT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_info`
--

INSERT INTO `student_info` (`id`, `first_name`, `last_name`, `student_id`, `gender`, `parent`, `profile_pic`, `section_id`) VALUES
(8, 'Miggy', 'Blas', '22-88990', 'Male', 'Reynnie', 'static/uploads/466595117_441439332327347_2904423254398471489_n.jpg', 47),
(22, 'Patrick Miguel', 'Blas', '22-11663', 'Male', 'Reynnie', 'static/uploads/profile-pic.png', 49),
(23, 'Ron', 'Alejo', '22-11758', 'Male', 'MIggy Blas', 'static/uploads/nicole.jpg', 50),
(24, 'Armando', 'Alejo', '22-11667', 'Female', 'Nicolas', 'static/uploads/hotdog.png', 48),
(26, 'Mharian', 'Rivera', '22-1234', 'Female', 'Miggy', 'static/uploads/roboto.jpg', 47),
(28, 'Nicole', 'Mahilum', '22-123', 'Female', 'Miggy', 'static/uploads/nicole.jpg', 57),
(29, 'Morty', 'Nigga', '22-22', 'Male', 'Miggy', 'static/uploads/chat icon.webp', 58);

-- --------------------------------------------------------

--
-- Table structure for table `teacher`
--

CREATE TABLE `teacher` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teacher`
--

INSERT INTO `teacher` (`id`, `username`, `email`, `password`) VALUES
(7, 'nini', 'nini@gmail.com', 'nini'),
(8, 'mharian', 'mharian@gmail.com', 'mharian'),
(9, 'nicole mahilum', 'nicole@gmail.com', 'astignimiggy'),
(10, 'miggy', 'miggy@gmail.com', 'miggy'),
(11, 'lorenzo', 'lorenz@gmail.com', 'gay');

-- --------------------------------------------------------

--
-- Table structure for table `t_classes`
--

CREATE TABLE `t_classes` (
  `teacher_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `class_name` varchar(255) NOT NULL,
  `class_code` varchar(10) NOT NULL,
  `teacher_username` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `year` varchar(50) NOT NULL,
  `attendance_time` time DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `t_classes`
--

INSERT INTO `t_classes` (`teacher_id`, `id`, `class_name`, `class_code`, `teacher_username`, `created_at`, `year`, `attendance_time`, `start_time`, `end_time`) VALUES
(0, 34, 'BPO', '', '', '2024-11-27 15:45:04', '2', NULL, '00:00:00', '00:00:00'),
(0, 44, 'NS', '', '', '2024-11-30 14:58:57', '4', NULL, '00:00:00', '00:00:00'),
(10, 47, 'BPO', '', '', '2024-11-30 17:50:24', '3', NULL, '00:00:00', '00:00:00'),
(7, 48, 'NS', '', '', '2024-11-30 18:41:39', '2', NULL, '00:00:00', '00:00:00'),
(7, 49, 'WMAD', '', '', '2024-11-30 20:13:22', '3', NULL, '00:00:00', '00:00:00'),
(11, 50, 'WMAD', '', '', '2024-12-02 04:32:45', '3', NULL, '00:00:00', '00:00:00'),
(8, 51, 'ns', '', '', '2024-12-02 05:36:16', '1', NULL, '00:00:00', '00:00:00'),
(11, 52, 'BPO', '', '', '2024-12-04 08:23:19', '4', NULL, '00:00:00', '00:00:00'),
(10, 57, 'WMAD', '', '', '2024-12-09 14:43:24', '2', NULL, '22:44:00', '23:00:00'),
(10, 58, 'st.matthew', '', '', '2024-12-09 16:43:26', '10', NULL, '00:00:00', '00:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `attendance_records`
--
ALTER TABLE `attendance_records`
  ADD PRIMARY KEY (`record_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD PRIMARY KEY (`quiz_id`),
  ADD KEY `class_code` (`class_code`);

--
-- Indexes for table `quiz_options`
--
ALTER TABLE `quiz_options`
  ADD PRIMARY KEY (`option_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `quiz_id` (`quiz_id`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `student_info`
--
ALTER TABLE `student_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`),
  ADD KEY `section_id` (`section_id`);

--
-- Indexes for table `teacher`
--
ALTER TABLE `teacher`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `t_classes`
--
ALTER TABLE `t_classes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `class_code` (`class_code`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `attendance_records`
--
ALTER TABLE `attendance_records`
  MODIFY `record_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `quizzes`
--
ALTER TABLE `quizzes`
  MODIFY `quiz_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `quiz_options`
--
ALTER TABLE `quiz_options`
  MODIFY `option_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student`
--
ALTER TABLE `student`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `student_info`
--
ALTER TABLE `student_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `teacher`
--
ALTER TABLE `teacher`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `t_classes`
--
ALTER TABLE `t_classes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_info` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attendance_records`
--
ALTER TABLE `attendance_records`
  ADD CONSTRAINT `attendance_records_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_info` (`id`);

--
-- Constraints for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD CONSTRAINT `quizzes_ibfk_1` FOREIGN KEY (`class_code`) REFERENCES `t_classes` (`class_code`) ON DELETE CASCADE;

--
-- Constraints for table `quiz_options`
--
ALTER TABLE `quiz_options`
  ADD CONSTRAINT `quiz_options_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`question_id`) ON DELETE CASCADE;

--
-- Constraints for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD CONSTRAINT `quiz_questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`quiz_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_info`
--
ALTER TABLE `student_info`
  ADD CONSTRAINT `student_info_ibfk_1` FOREIGN KEY (`section_id`) REFERENCES `t_classes` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
