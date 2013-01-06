/*
*  Person.h
*  
*  C++ mapping generated by ddl2orm (written by Mathias Franck).
*  Copyleft 2012 Merguez-it.
*
*/

#ifndef Person_H
#define Person_H

#include "lorm.h"

class Book;
class Borrows;

class Person : public table<Person> { 
public: 
  TABLE_INIT(Person,person)
	column<int> id;
	column<std::string> name;
	COLLECTION(Book,books);
	COLLECTION(Borrows,borrows);
	COLLECTION(Book,liked_books);
};

#endif