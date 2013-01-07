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
INSERT INTO "book" VALUES ('Lord of the rings 3', 'J.R.R Tolkien', 3, 1);
INSERT INTO "book" VALUES ('Effective C++', 'Scott Meyer', 4, 4);
INSERT INTO "book" VALUES ('Design Patterns', 'Gamme et alt.', 5, 4);
INSERT INTO "book" VALUES ('Principle Of Compiler Design', 'Ullman et alt.', 6, 4);
INSERT INTO "book" VALUES ('Harry Potter and the chamber of secrets', 'J.K. Rowling', 7, 4);
INSERT INTO "book" VALUES ('Moby Dick', 'Hermann Melville', 8, 5);
COMMIT;

-- ----------------------------
--  Table structure for "borrows"
-- ----------------------------
DROP TABLE IF EXISTS "borrows";
CREATE TABLE "borrows" (
"borrowed_book_id" INTEGER NOT NULL,
"borrower_id" INTEGER NOT NULL,
"date_of_borrow" DATE NOT NULL,
FOREIGN KEY ("borrowed_book_id") REFERENCES "book" ("book_id"),
FOREIGN KEY ("borrower_id") REFERENCES "person" ("person_id")
);

-- ----------------------------
--  Records of "borrows"
-- ----------------------------
BEGIN;
INSERT INTO "borrows" VALUES (1, 1,'2012-05-06');
INSERT INTO "borrows" VALUES (1, 5,'1994-06-25');
INSERT INTO "borrows" VALUES (2, 4,'1967-12-17');
INSERT INTO "borrows" VALUES (2, 5,'2012-06-21');
INSERT INTO "borrows" VALUES (6, 3,'2005-07-06');
INSERT INTO "borrows" VALUES (6, 2,'2013-10-14');
INSERT INTO "borrows" VALUES (3, 4,'2010-08-20');
INSERT INTO "borrows" VALUES (4, 2,'1964-04-11');
INSERT INTO "borrows" VALUES (7, 1,'2004-11-11');
COMMIT;

-- ----------------------------
--  Table structure for "likes"
-- ----------------------------
DROP TABLE IF EXISTS "likes";
CREATE TABLE "likes" (
"liked_book_id" INTEGER NOT NULL,
"happy_reader_id" INTEGER NOT NULL,
FOREIGN KEY ("liked_book_id") REFERENCES "book" ("book_id"),
FOREIGN KEY ("happy_reader_id") REFERENCES "person" ("person_id")
);

-- ----------------------------
--  Records of "likes"
-- ----------------------------
BEGIN;
INSERT INTO "likes" VALUES(2,4);
INSERT INTO "likes" VALUES(2,5);
INSERT INTO "likes" VALUES(6,3);
INSERT INTO "likes" VALUES(6,2);
INSERT INTO "likes" VALUES(5,4);
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
