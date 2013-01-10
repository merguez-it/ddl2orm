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
#include "Borrows.h"
#include "Tag.h"

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
	collection<Person> *everyone = who.find();
	for ( collection<Person>::iterator p=everyone->begin() ; p!=everyone->end() ; p++ )	{
		cout << p->name << " (with id " << p->id << ") owns " << p->books().size() << " book(s) :" << endl;
    for (int i=0; i < p->books().size() ; i++) {
      collection<Tag> tags=p->books()[i].tags();
      std::string stringTags="( ";
      std::string sep;
      for (int j=0;j<tags.size(); j++) {
        stringTags+= sep + tags[j].label.value();
        sep=", ";
      }
      cout << "\tOwned:  " << p->books()[i].title  << stringTags << " )" << endl;
    }
		cout << "and  borrowed " << p->borrows().size() << " book(s) :" << endl;
    for (int i=0; i < p->borrows().size() ; i++) {
      cout << "\tBorrowed : " << p->borrowed_books()[i].title << " on " << p->borrows()[i].date_of_borrow << endl;
    }
    cout << p->name << " liked " << p->liked_books().size() << " book(s) :" << endl;
    for (int i=0; i < p->liked_books().size() ; i++) {
      cout << "\tLiked:  " << p->liked_books()[i].title << endl;
    }
    cout << endl;
	}
	Lorm::disconnect();
}

