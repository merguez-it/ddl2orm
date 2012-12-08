/*
 *  main_test.cpp
 *  ddl2orm
 *
 *  Created by Mathias Franck on 08/12/12.
 *  Copyleft 2012 Merguez-IT. All rights reserved.
 *
 */
#include <assert.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <iterator>
#include "Lorm.h"

#include "Book.h"
#include "Person.h"

#define BUILD_BOOK(book)\
Book book;\
book.title=#book;\
book=book.save();\

#define BUILD_PERSON(person)\
Person person;\
person.name=#person;\
person=person.save();\

using namespace std;

int main (int argc, char * const argv[]) {	

	Lorm::connect("sqlite://:memory:");
	// Preparing
	ifstream script_file("../../test/ddl2orm_sample.sql");
	std::stringstream buffer;
	buffer << script_file.rdbuf();
	Lorm::getInstance()->execute(buffer.str());
	// Go !
	Person who;
	collection<Person> everyone = who.find();
	for ( collection<Person>::iterator p=everyone.begin() ; p!=everyone.end() ; p++ )	{
		cout << p->name << " ( with id " << p->id << ") owns " << p->books().size() << " book(s)" << endl;
		cout << "and  borrowed " << p->borrowed_books().size() << " book(s)." << endl << endl;
	}
	Lorm::disconnect();
}

