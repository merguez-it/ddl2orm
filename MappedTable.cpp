/*
 *  MappedTable.cpp
 *  ddl2cpp
 *
 *  Created by Mathias Franck on 13/03/12.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */
#include <iostream>
#include "MappingUtils.h"
#include "MappedTable.h"
#include "cppClassTemplate.inc.h"
#include <assert.h>
using namespace std;


// Returns true if the given field is of a nullable simple type 
bool MappedTable::isNullable(const wstring& fieldName) const {
  assert(members.count(fieldName)!=0);
	return NULLABLE_DATA==members.find(fieldName)->second.kind;
}

// Returns true if the given fielName is a FK 
bool MappedTable::isForeignKey(const wstring& fieldName) const {
	return fkToPk.count(fieldName)!=0;
}

// Returns true if the given "roleName" represents a linked object. 
bool MappedTable::isToOneRole(const wstring& roleName) const {
	return (members.count(roleName)!=0) && (TO_ONE==members.find(roleName)->second.kind);
}

// Returns true if the given "roleName" represents a to-many role name
bool MappedTable::isToManyRole(const wstring& roleName) const {
	return members.count(roleName)!=0 && 
	(MANY_TO_MANY==members.find(roleName)->second.kind || ONE_TO_MANY==members.find(roleName)->second.kind);
}

bool MappedTable::isRole(const wstring& roleName) const {
	return isToManyRole(roleName) || isToOneRole(roleName);
}

// Returns true if the mapped table represents an association (i.e: table with 2 links and no simple data fields) rather than a class.
// n-ary associations (n>2) and associations-classes not yet recognized (=> They are mapped as "real" objects)
bool MappedTable::isAssociation() const { 
	return (!members.empty()) && (fkToPk.size()*2==members.size() && 4==members.size()); // équivaut à : pas d'autres champs que 2 clés ... Beurk ...
	//return primaryKey.empty(); // Si on mappe les classes d'assoces seulement comme des liens, quel accès aux infos de liens ?
}

// Returns the role's classes for *this*, assumed it represents a binary association
std::pair<wstring,wstring> MappedTable::getLinkedClasses() const {
	pair<wstring,wstring> result;
	if (isAssociation()) {
	} else throw "Access to roles requires an association !!";
  return result;
}

wstring MappedTable::storageClass(const wstring&field ) const { 
  assert(members.count(field)!=0);
	wstring type=members.find(field)->second.type;
	wstring result=type;
	if (isToOneRole(field)) result=L"TO_ONE("+type+L")";
	else if (isToManyRole(field)) result=L"TO_MANY("+type+L")";
	else if (isNullable(field)) result=L"NULLABLE("+type+L")";
	return result;
}

void MappedTable::generateClassHeader() {
	if (!members.empty() &!isAssociation()) {
		classHeader+= hxxPrologue;			// Hxx header
		for (FieldIt it=members.begin(); it!=members.end(); it++) {
			if (isRole(it->first)) classHeader+=L"class "+it->second.type+L";\n";
		}
		classHeader+= hxxClassProplogue;	// Public finders
		if (!primaryKey.empty()) {
			classHeader+=findByIdDecl;
		}
		if (members.find(L"name")!=members.end()) { // Voir si toujours pertinent, notamment pour products...
			classHeader+=findByNameDecl;
		}
		for (FieldIt it=members.begin();it!=members.end();it++) {  // Public accessors
			classHeader+= L"\tconst " + storageClass(it->first) + L"& "+ it->first + L"();\n" ;
		}
		classHeader+= hxxFields;		
		for (FieldIt it=members.begin();it!=members.end();it++) { // Members mapped with their cpp type
			classHeader += L"\t" + storageClass(it->first) + L" "+ it->first + L"_;\n"; 
		}	
		classHeader += hxxEpilogue;		// Hop, les accolades et les #endif !
		replaceAll(L"$className", className, classHeader);
	} else {
		wcout << className << L" skipped : no members could be mapped" << endl;
	}
};