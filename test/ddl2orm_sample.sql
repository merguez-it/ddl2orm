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
INSERT INTO "book" VALUES ('Moby Dick', 'Herman Melville', 8, 5);
INSERT INTO "book" VALUES ('Java Programming Language', 'Arnold-Gosling-Holmes', 9, 5);

COMMIT;
-- ----------------------------
--  Table structure for "tag"
--  will be mapped as a reference table,
--  i.e: no navigation from those values to their referrers.
-- ----------------------------
DROP TABLE IF EXISTS "tag";
CREATE TABLE "tag" (
"label" text NOT NULL ,
"tag_id" integer NOT NULL PRIMARY KEY AUTOINCREMENT
);

-- ----------------------------
--  Records of "tag"
-- ----------------------------
BEGIN;
INSERT INTO "tag" VALUES ('Heroic fantasy', 1 );
INSERT INTO "tag" VALUES ('Dwarfs', 2 );
INSERT INTO "tag" VALUES ('Ancient languages',3 );
INSERT INTO "tag" VALUES ('C++', 4 );
INSERT INTO "tag" VALUES ('OO programming',5 );
INSERT INTO "tag" VALUES ('Computing theory', 6 );
INSERT INTO "tag" VALUES ('Evil whale', 7 );
INSERT INTO "tag" VALUES ('Obsession', 8 );
COMMIT;

-- ----------------------------
--  Table structure for "tagging"
--  will be mapped as a multiple role navigable from "book" instances to "tag" instances only.
-- ----------------------------

DROP TABLE IF EXISTS "tagging";
CREATE TABLE "tagging" (
  "tag_id" INTEGER NOT NULL,
  "tagged_book_id" INTEGER NOT NULL,
  FOREIGN KEY ("tagged_book_id") REFERENCES "book" ("book_id"),
  FOREIGN KEY ("tag_id") REFERENCES "tag" ("tag_id")
);

-- ----------------------------
--  Records of "tagging"
-- ----------------------------

BEGIN;
INSERT INTO "tagging" VALUES (1, 1 );
INSERT INTO "tagging" VALUES (1, 2 );
INSERT INTO "tagging" VALUES (1, 3 );
INSERT INTO "tagging" VALUES (2, 1 );
INSERT INTO "tagging" VALUES (2, 2 );
INSERT INTO "tagging" VALUES (2, 3 );
INSERT INTO "tagging" VALUES (3, 1 );
INSERT INTO "tagging" VALUES (3, 2 );
INSERT INTO "tagging" VALUES (3, 3 );
INSERT INTO "tagging" VALUES (3, 4 );
INSERT INTO "tagging" VALUES (4, 4 );
INSERT INTO "tagging" VALUES (5, 4 );
INSERT INTO "tagging" VALUES (5, 5 );
INSERT INTO "tagging" VALUES (5, 9 );
INSERT INTO "tagging" VALUES (6, 5 );
INSERT INTO "tagging" VALUES (6, 6 );
INSERT INTO "tagging" VALUES (7, 8 );
INSERT INTO "tagging" VALUES (7, 9 );
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
   "date_of_birth" DATE,
	 "person_id" integer PRIMARY KEY AUTOINCREMENT
);

-- ----------------------------
--  Records of "person"
-- ----------------------------
BEGIN;
INSERT INTO "person" VALUES ('Tony','1981-01-02',     1 );
INSERT INTO "person" VALUES ('Grégoire','1974-03-04', 2 );
INSERT INTO "person" VALUES ('Jean-Paul','1962-05-06',3 );
INSERT INTO "person" VALUES ('Yves', '1982-07-08',    4 );
INSERT INTO "person" VALUES ('Mathias','1967-26-06' , 5 );
COMMIT;

PRAGMA foreign_keys = true;
