--By Finlay Thomson (23953297)

PRAGMA foreign_keys = ON; --This isnt enforced by default

CREATE TABLE Store (
    storeId TEXT PRIMARY KEY NOT NULL,
    storeName TEXT,
    suburb TEXT,
    openingDate TEXT
);

CREATE TABLE Member (
    memberId INTEGER PRIMARY KEY NOT NULL,
    memberName TEXT,
    memberEmail TEXT UNIQUE,
    cardNumber TEXT UNIQUE CHECK (
        cardNumber IS NULL OR (
            length(cardNumber) = 10--BR5, card number must be 10 digits
            
            AND cardNumber NOT GLOB '*[^0-9]*'--BR5, card num must be only digits
            
            AND (
                10 * CAST(substr(cardNumber, 1, 1) AS INTEGER) +
                9 * CAST(substr(cardNumber, 2, 1) AS INTEGER) +
                8 * CAST(substr(cardNumber, 3, 1) AS INTEGER) +
                7 * CAST(substr(cardNumber, 4, 1) AS INTEGER) +
                6 * CAST(substr(cardNumber, 5, 1) AS INTEGER) +
                5 * CAST(substr(cardNumber, 6, 1) AS INTEGER) +
                4 * CAST(substr(cardNumber, 7, 1) AS INTEGER) +
                3 * CAST(substr(cardNumber, 8, 1) AS INTEGER) +
                2 * CAST(substr(cardNumber, 9, 1) AS INTEGER) +
                1 * CAST(substr(cardNumber, 10, 1) AS INTEGER)
            ) % 11 = 0 --BR5 checksum
        )
    ),
    joinDate TEXT
);

CREATE TABLE Product (
    productId TEXT PRIMARY KEY NOT NULL,
    productName TEXT,
    category TEXT,
    basePrice REAL NOT NULL CHECK (basePrice > 0), --BR1 enforcement
    status TEXT NOT NULL CHECK (status in ('ACTIVE', 'DISCONTINUED')) --BR2 enforcement
);

CREATE TABLE SizeOption (
    size TEXT PRIMARY KEY NOT NULL,
    sizeSurcharge REAL
);

CREATE TABLE SalesOrder (
    orderId INTEGER PRIMARY KEY NOT NULL,
    memberId INTEGER,
    storeId TEXT NOT NULL,
    orderDate TEXT,
    orderTime TEXT,
    FOREIGN KEY (memberId) REFERENCES Member (memberId) ON DELETE RESTRICT,
    FOREIGN KEY (storeId) REFERENCES Store (storeId) ON DELETE RESTRICT
);

CREATE TABLE OrderItem (
    orderId INTEGER NOT NULL,
    lineNo INTEGER NOT NULL,
    productId TEXT NOT NULL,
    size TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity BETWEEN 1 AND 10),--BR3 enforcement
    unitPrice REAL,
    lineTotal REAL,
    PRIMARY KEY (orderId, lineNo),
    FOREIGN KEY (orderId) REFERENCES SalesOrder (orderId) ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES Product (productId) ON DELETE RESTRICT,
    FOREIGN KEY (size) REFERENCES SizeOption (size) ON DELETE RESTRICT
);

CREATE TABLE Ingredient (
    ingredientId TEXT PRIMARY KEY NOT NULL,
    ingredientName TEXT,
    unit TEXT,
    unitCost REAL
);

CREATE TABLE Recipe (
    productId TEXT NOT NULL,
    ingredientId TEXT NOT NULL,
    amountRequired REAL CHECK (amountRequired > 0), --BR4 enforcement
    PRIMARY KEY (productId, ingredientId),
    FOREIGN KEY (productId) REFERENCES Product (productId) ON DELETE RESTRICT,
    FOREIGN KEY (ingredientId) REFERENCES Ingredient (ingredientId) ON DELETE RESTRICT
);
