-- Bảng cấu hình cấp độ người dùng
CREATE TABLE level_config (
    level INT PRIMARY KEY,
    experience_required INT NOT NULL
);

-- Dữ liệu mẫu cho bảng level_config
INSERT INTO level_config (level, experience_required) VALUES
(1, 0),
(2, 100),
(3, 300),
(4, 600),
(5, 1000);
(6, 1500);
(7, 2100);
(8, 2800);
(9, 3600);
(10, 4500);
(11, 5500);
(12, 6600);
(13, 7800);
(14, 9100);
(15, 10500);
(16, 12000);
(17, 13600);
(18, 15300);
(19, 17100);
(20, 19000);
(21, 21000);
(22, 23100);
(23, 25300);
(24, 27600);
(25, 30000);
(26, 32500);
(27, 35100);
(28, 37800);
(29, 40600);
(30, 43500);
(31, 46500);
(32, 49600);
(33, 52800);
(34, 56100);
(35, 59500);
(36, 63000);
(37, 66600);
(38, 70300);
(39, 74100);
(40, 78000);
(41, 82000);
(42, 86100);
(43, 90300);
(44, 94600);
(45, 99000);
(46, 103500);
(47, 108100);
(48, 112800);
(49, 117600);
(50, 122500);

-- Bảng người dùng
CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    earned_balance DECIMAL(10, 2) DEFAULT 100.00,
    top_up_balance DECIMAL(10, 2) DEFAULT 0.00,
    role ENUM('PLAYER', 'MODERATOR', 'ADMIN') DEFAULT 'PLAYER',
    experience INT DEFAULT 0, -- Kinh nghiệm của người dùng
    level INT DEFAULT 1, -- Cấp độ hiện tại của người dùng
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Bảng cấu hình cấp độ cá Koi
CREATE TABLE koi_level_config (
    id SERIAL PRIMARY KEY,
    breed VARCHAR(255) NOT NULL, -- Giống cá Koi
    level INT NOT NULL, -- Cấp độ của cá
    experience_required INT NOT NULL, -- Kinh nghiệm cần thiết để lên cấp
    UNIQUE (breed, level) -- Đảm bảo mỗi giống và cấp độ là duy nhất
);

-- Dữ liệu mẫu cho bảng koi_level_config
INSERT INTO koi_level_config (breed, level, experience_required) VALUES
('Kohaku', 1, 0),
('Kohaku', 2, 100),
('Kohaku', 3, 300),
('Sanke', 1, 0),
('Sanke', 2, 150),
('Sanke', 3, 450);

-- Bảng cá Koi
CREATE TABLE koi (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    size DECIMAL(5, 2),
    weight DECIMAL(5, 2),
    gender ENUM('MALE', 'FEMALE'),
    breed VARCHAR(255), -- Giống cá Koi
    origin VARCHAR(255),
    price DECIMAL(10, 2),
    mutation BOOLEAN DEFAULT FALSE,
    owner_id INT,
    last_fed TIMESTAMP,
    is_hungry BOOLEAN DEFAULT TRUE,
    is_mature BOOLEAN DEFAULT FALSE,
    experience INT DEFAULT 0, -- Kinh nghiệm hiện tại của cá
    current_level INT DEFAULT 1, -- Cấp độ hiện tại của cá
    next_level_experience INT DEFAULT 100, -- Kinh nghiệm cần để lên cấp tiếp theo
    value_mature INT DEFAULT 100000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (owner_id) REFERENCES "user"(id)
);

-- Bảng vật phẩm
CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type ENUM('FOOD', 'MEDICINE', 'OTHER', 'SEED') DEFAULT 'FOOD',
    price DECIMAL(10, 2),
    effect VARCHAR(255),
    experience_gain INT DEFAULT 0, -- Lượng kinh nghiệm mà thức ăn cung cấp
    source ENUM('STORE', 'FARM') DEFAULT 'STORE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Dữ liệu mẫu cho bảng item
INSERT INTO item (name, type, price, effect, experience_gain) VALUES
('Thức ăn cơ bản', 'FOOD', 10.00, 'Tăng 10 kinh nghiệm', 10),
('Thức ăn cao cấp', 'FOOD', 30.00, 'Tăng 30 kinh nghiệm', 30);

-- Bảng cho ăn
CREATE TABLE feeding (
    id SERIAL PRIMARY KEY,
    koi_id INT,
    item_id INT,
    feeding_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    experience_gained INT DEFAULT 0, -- Lượng kinh nghiệm mà cá nhận được
    source ENUM('STORE', 'FARM') DEFAULT 'STORE',
    FOREIGN KEY (koi_id) REFERENCES koi(id),
    FOREIGN KEY (item_id) REFERENCES item(id)
);

-- Bảng tiến hóa cá Koi
CREATE TABLE koi_evolution (
    id SERIAL PRIMARY KEY,
    breed VARCHAR(255) NOT NULL, -- Giống cá Koi
    evolution_stage VARCHAR(255) NOT NULL, -- Giai đoạn tiến hóa
    required_level INT NOT NULL, -- Cấp độ yêu cầu
    experience_required INT NOT NULL, -- Kinh nghiệm yêu cầu
    UNIQUE (breed, evolution_stage) -- Đảm bảo mỗi giống và giai đoạn là duy nhất
);

-- Dữ liệu mẫu cho bảng koi_evolution
INSERT INTO koi_evolution (breed, evolution_stage, required_level, experience_required) VALUES
('Kohaku', 'Trưởng thành', 3, 300),
('Kohaku', 'Tiến hóa đặc biệt', 5, 1000),
('Sanke', 'Trưởng thành', 4, 600);

-- Bảng ao
CREATE TABLE pond (
    id SERIAL PRIMARY KEY,
    size DECIMAL(10, 2),
    quality VARCHAR(255),
    owner_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (owner_id) REFERENCES "user"(id)
);

-- Bảng túi đồ
CREATE TABLE bag (
    id SERIAL PRIMARY KEY,
    user_id INT,
    item_id INT,
    quantity INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES "user"(id),
    FOREIGN KEY (item_id) REFERENCES item(id)
);

-- Bảng sinh sản
CREATE TABLE breeding (
    id SERIAL PRIMARY KEY,
    parent1_id INT,
    parent2_id INT,
    breeding_type ENUM('MANUAL', 'AUTOMATIC') DEFAULT 'MANUAL',
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    result_koi_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (parent1_id) REFERENCES koi(id),
    FOREIGN KEY (parent2_id) REFERENCES koi(id),
    FOREIGN KEY (result_koi_id) REFERENCES koi(id)
);

-- Bảng trang trại
CREATE TABLE farm (
    id SERIAL PRIMARY KEY,
    user_id INT,
    item_id INT,
    planting_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    harvest_time TIMESTAMP,
    status ENUM('PLANTED', 'HARVESTED') DEFAULT 'PLANTED',
    FOREIGN KEY (user_id) REFERENCES "user"(id),
    FOREIGN KEY (item_id) REFERENCES item(id)
);

-- Bảng giao dịch
CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    user_id INT,
    koi_id INT,
    item_id INT,
    amount INT,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    type ENUM('BUY', 'SELL') DEFAULT 'BUY',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES "user"(id),
    FOREIGN KEY (koi_id) REFERENCES koi(id),
    FOREIGN KEY (item_id) REFERENCES item(id)
);