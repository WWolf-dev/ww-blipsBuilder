CREATE TABLE IF NOT EXISTS `blips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blip_name` varchar(255) NOT NULL,
  `blip_sprite` int(11) NOT NULL,
  `blip_size` float NOT NULL,
  `blip_color` int(11) NOT NULL,
  `blip_alpha` int(11) NOT NULL,
  `blip_coords` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;