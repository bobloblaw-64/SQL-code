PRAGMA foreign_keys = ON;

CREATE TABLE Store (
    storeId TEXT PRIMARY KEY NOT NULL,
    storeName TEXT,
    suburb TEXT,
    openingDate TEXT
);

CREATE TABLE Member (
    memberId INTEGER PRIMARY KEY NOT NULL,
    memberName TEXT,
    memberEmail TEXT,
    cardNumber TEXT,
    joinDate TEXT
);

CREATE TABLE Product (
    productId TEXT PRIMARY KEY NOT NULL,
    productName TEXT,
    category TEXT,
    basePrice REAL CHECK (basePrice > 0),
    status TEXT CHECK (status in ('ACTIVE', 'DISCONTINUED'))
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
    quantity INTEGER NOT NULL CHECK (quantity BETWEEN 0 AND 10),
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
    amountRequired REAL CHECK (amountRequired > 0),
    PRIMARY KEY (productId, ingredientId),
    FOREIGN KEY (productId) REFERENCES Product (productId) ON DELETE CASCADE,
    FOREIGN KEY (ingredientId) REFERENCES Ingredient (ingredientId) ON DELETE RESTRICT
);