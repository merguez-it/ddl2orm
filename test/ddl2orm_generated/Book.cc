/*
*  Book.cpp
*  
*  C++ mapping generated by ddl2orm (written by Mathias Franck).
*  Copyleft 2012 Merguez-it.
*
*/

#include "Book.h"
#include "Borrows.h"
#include "Person.h"

REGISTER_TABLE(Book) {
	identity("book_id",&Book::id);
	field("author", &Book::author);
	field("title", &Book::title);
	has_one("ownerId", &Book::owner);
};

has_and_belongs_to_many(Book,Person,happy_readers,"likes","liked_book_id","happy_reader_id");
has_many(Book,Borrows,borrows,borrowed_book);
