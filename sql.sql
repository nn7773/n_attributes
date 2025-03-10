CREATE TABLE IF NOT EXISTS player_attributes (
    identifier VARCHAR(50) NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age VARCHAR(10) NOT NULL,
    height VARCHAR(10) NOT NULL,
    description TEXT NOT NULL
);
