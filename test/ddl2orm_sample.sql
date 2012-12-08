PRAGMA foreign_keys = false;

-- ----------------------------
--  Table structure for "book"
-- ----------------------------
DROP TABLE IF EXISTS "book";
CREATE TABLE "book" (
	 "title" text,
	 "author" text,
	 "book_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	 "ownerId" integer NOT NULL,
	FOREIGN KEY ("ownerId") REFERENCES "person" ("person_id")
);

-- ----------------------------
--  Records of "book"
-- ----------------------------
BEGIN;
INSERT INTO "book" VALUES ('Lord of the rings 1', 'J.R.R Tolkien', 1, 2);
INSERT INTO "book" VALUES ('Lord of the rings 2', 'J.R.R Tolkien', 2, 3);
INSERT INTO "book" VALUES ('Effective C++', 'Scott Meyer', 4, 4);
INSERT INTO "book" VALUES ('Design Patterns', 'Gamme et alt.', 5, 4);
INSERT INTO "book" VALUES ('Principle Of Compiler Design', 'Ullman et alt.', 6, 4);
INSERT INTO "book" VALUES ('Harry Potter and the chamber of secrets', 'J.K. Rowling', 7, 1);
INSERT INTO "book" VALUES ('Moby Dick', 'Hermann Melville', 8, 5);
COMMIT;

-- ----------------------------
--  Table structure for "borrows"
-- ----------------------------
DROP TABLE IF EXISTS "borrows";
CREATE TABLE "borrows" (
"borrowed_book_id" INTEGER NOT NULL,
"borrower_id" INTEGER NOT NULL,
FOREIGN KEY ("borrowed_book_id") REFERENCES "book" ("book_id"),
FOREIGN KEY ("borrower_id") REFERENCES "person" ("person_id")
);

-- ----------------------------
--  Records of "borrows"
-- ----------------------------
BEGIN;
INSERT INTO "borrows" VALUES (1, 1);
INSERT INTO "borrows" VALUES (1, 5);
INSERT INTO "borrows" VALUES (2, 4);
INSERT INTO "borrows" VALUES (2, 5);
INSERT INTO "borrows" VALUES (6, 3);
INSERT INTO "borrows" VALUES (6, 2);
INSERT INTO "borrows" VALUES (6, 4);
INSERT INTO "borrows" VALUES (4, 2);
INSERT INTO "borrows" VALUES (7, 1);
COMMIT;

-- ----------------------------
--  Table structure for "person"
-- ----------------------------
DROP TABLE IF EXISTS "person";
CREATE TABLE "person" (
	 "name" text,
	 "person_id" integer PRIMARY KEY AUTOINCREMENT
);

-- ----------------------------
--  Records of "person"
-- ----------------------------
BEGIN;
INSERT INTO "person" VALUES ('Tony', 1);
INSERT INTO "person" VALUES ('Grégoire', 2);
INSERT INTO "person" VALUES ('Jean-Paul', 3);
INSERT INTO "person" VALUES ('Yves', 4);
INSERT INTO "person" VALUES ('Mathias', 5);
COMMIT;

PRAGMA foreign_keys = true;
