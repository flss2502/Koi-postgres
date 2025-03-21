CREATE DATABASE user_db;

USE user_db;

CREATE TYPE user_role AS ENUM ('PLAYER', 'MODERATOR', 'ADMIN');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    earned_balance DECIMAL(10, 2) DEFAULT 100.00,
    top_up_balance DECIMAL(10, 2) DEFAULT 0.00,
    role user_role DEFAULT 'PLAYER',
    experience INT DEFAULT 0,
    level INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Trigger function to update 'updated_at'
CREATE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the trigger to users table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Level config table
CREATE TABLE level_config (
    level INT PRIMARY KEY,
    experience_required INT NOT NULL
);

-- Insert level data
INSERT INTO level_config (level, experience_required) VALUES
(1, 0), (2, 100), (3, 300), (4, 600), (5, 1000);



CREATE DATABASE koi_db;

USE koi_db;

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
    owner_id INT, -- Tham chiếu đến ID người dùng trong User Service
    last_fed TIMESTAMP,
    is_hungry BOOLEAN DEFAULT TRUE,
    is_mature BOOLEAN DEFAULT FALSE,
    experience INT DEFAULT 0,
    current_level INT DEFAULT 1,
    next_level_experience INT DEFAULT 100,
    value_mature INT DEFAULT 100000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE koi_level_config (
    id SERIAL PRIMARY KEY,
    breed VARCHAR(255) NOT NULL,
    level INT NOT NULL,
    experience_required INT NOT NULL,
    UNIQUE (breed, level)
);

CREATE TABLE koi_evolution (
    id SERIAL PRIMARY KEY,
    breed VARCHAR(255) NOT NULL,
    evolution_stage VARCHAR(255) NOT NULL,
    required_level INT NOT NULL,
    experience_required INT NOT NULL,
    UNIQUE (breed, evolution_stage)
);


CREATE DATABASE item_db;

USE item_db;

CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type ENUM('FOOD', 'MEDICINE', 'OTHER', 'SEED') DEFAULT 'FOOD',
    price DECIMAL(10, 2),
    effect VARCHAR(255),
    experience_gain INT DEFAULT 0,
    source ENUM('STORE', 'FARM') DEFAULT 'STORE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE bag (
    id SERIAL PRIMARY KEY,
    user_id INT, -- Tham chiếu đến ID người dùng trong User Service
    item_id INT,
    quantity INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);


CREATE DATABASE transaction_db;

USE transaction_db;

CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    user_id INT, -- Tham chiếu đến ID người dùng trong User Service
    koi_id INT, -- Tham chiếu đến ID cá Koi trong Koi Service
    item_id INT, -- Tham chiếu đến ID vật phẩm trong Item Service
    amount INT,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    type ENUM('BUY', 'SELL') DEFAULT 'BUY',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);




CREATE DATABASE pond_db;

USE pond_db;

CREATE TABLE pond (
    id SERIAL PRIMARY KEY,
    size DECIMAL(10, 2),
    quality VARCHAR(255),
    owner_id INT, -- Tham chiếu đến ID người dùng trong User Service
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);



CREATE DATABASE farm_db;

USE farm_db;

CREATE TABLE farm (
    id SERIAL PRIMARY KEY,
    user_id INT, -- Tham chiếu đến ID người dùng trong User Service
    item_id INT, -- Tham chiếu đến ID vật phẩm trong Item Service
    planting_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    harvest_time TIMESTAMP,
    status ENUM('PLANTED', 'HARVESTED') DEFAULT 'PLANTED'
);



CREATE DATABASE breeding_db;

USE breeding_db;

CREATE TABLE breeding (
    id SERIAL PRIMARY KEY,
    parent1_id INT, -- Tham chiếu đến ID cá Koi trong Koi Service
    parent2_id INT, -- Tham chiếu đến ID cá Koi trong Koi Service
    breeding_type ENUM('MANUAL', 'AUTOMATIC') DEFAULT 'MANUAL',
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    result_koi_id INT, -- Tham chiếu đến ID cá Koi trong Koi Service
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);