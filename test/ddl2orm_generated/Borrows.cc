/*
*  Borrows.cpp
*  
*  C++ mapping generated by ddl2orm (written by Mathias Franck).
*  Copyleft 2012 Merguez-it.
*
*/

#include "Borrows.h"
#include "Book.h"
#include "Person.h"

REGISTER_TABLE(Borrows) {
	field("date_of_borrow", &Borrows::date_of_borrow);
	has_one("borrowed_book_id", &Borrows::borrowed_book);
	has_one("borrower_id", &Borrows::borrower);
};
