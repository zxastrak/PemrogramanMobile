-- File Script Database MySQL untuk Aplikasi Resino Katalog Produk
-- Nama Database: db_tugas5

CREATE DATABASE IF NOT EXISTS `db_tugas5` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `db_tugas5`;

-- Table structure for table `products`
CREATE TABLE IF NOT EXISTS `products` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(100) NOT NULL,
  `subtitle` VARCHAR(150) NOT NULL,
  `price` INT NOT NULL,
  `icon` VARCHAR(50) NOT NULL,
  `description` TEXT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table `products`
INSERT INTO `products` (`id`, `title`, `subtitle`, `price`, `icon`, `description`) VALUES
(1, 'Sabun Mandi Antiseptik', 'Perlindungan kuman & kulit tetap lembut', 4500, 'clean_hands', 'Sabun mandi cair antiseptik yang efektif membersihkan kulit dari kuman dan bakteri sekaligus menjaga kelembapan alami kulit sepanjang hari.'),
(2, 'Shampo Anti Ketombe', 'Rambut segar & bebas ketombe seharian', 22000, 'sanitizer', 'Shampo khusus dengan formula menthol dan ZPTO yang efektif menghilangkan ketombe, mengurangi rasa gatal, serta memberikan sensasi dingin menyegarkan di kulit kepala.'),
(3, 'Detergen Pakaian Konsentrat', 'Bersih maksimal & wangi tahan lama', 18500, 'local_laundry_service', 'Detergen bubuk konsentrat dengan teknologi anti-noda membandel dan aroma kesegaran bunga yang tahan lama hingga 14 hari.');

-- Table structure for table `orders`
CREATE TABLE IF NOT EXISTS `orders` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `total_amount` INT NOT NULL,
  `status` VARCHAR(50) DEFAULT 'ACC / LUNAS',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
