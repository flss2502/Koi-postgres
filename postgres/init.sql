
CREATE TABLE level_config (
    level INT PRIMARY KEY,
    experience_required INT NOT NULL
);

INSERT INTO level_config (level, experience_required) VALUES
(1, 0),
(2, 100),
(3, 300),
(4, 600),
(5, 1000);


CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    earned_balance DECIMAL(10, 2) DEFAULT 100.00,
    top_up_balance DECIMAL(10, 2) DEFAULT 0.00,
    role ENUM('PLAYER', 'MODERATOR', 'ADMIN') DEFAULT 'PLAYER',
    experience INT DEFAULT 0, -- Thêm trường kinh nghiệm
    level INT DEFAULT 1, -- Thêm trường cấp độ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Tạo bảng koi
CREATE TABLE koi (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    size DECIMAL(5, 2),
    weight DECIMAL(5, 2),
    gender ENUM('MALE', 'FEMALE'),
    breed VARCHAR(255),
    origin VARCHAR(255),
    price DECIMAL(10, 2),
    mutation BOOLEAN DEFAULT FALSE,
    owner_id INT,
    last_fed TIMESTAMP,
    is_hungry BOOLEAN DEFAULT TRUE,
    is_mature BOOLEAN DEFAULT FALSE,
    experience INT DEFAULT 0,
    value_mature INT DEFAULT 100000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (owner_id) REFERENCES "user"(id)
);

-- Tạo bảng pond
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

-- Tạo bảng item
CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type ENUM('FOOD', 'MEDICINE', 'OTHER', 'SEED') DEFAULT 'FOOD',
    price DECIMAL(10, 2),
    effect VARCHAR(255),
    source ENUM('STORE', 'FARM') DEFAULT 'STORE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Tạo bảng bag
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

-- Tạo bảng breeding
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

-- Tạo bảng feeding
CREATE TABLE feeding (
    id SERIAL PRIMARY KEY,
    koi_id INT,
    item_id INT,
    feeding_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source ENUM('STORE', 'FARM') DEFAULT 'STORE',
    FOREIGN KEY (koi_id) REFERENCES koi(id),
    FOREIGN KEY (item_id) REFERENCES item(id)
);

-- Tạo bảng farm
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

-- Tạo bảng transaction
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