/*
 *  MappedTable.cpp
 *  ddl2orm
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
	return (!members.empty()) && fkToPk.size()==members.size() && (2==members.size()); // équivaut à : pas d'autres champs que 2 clés ... Beurk ...
	//return primaryKey.empty(); // Si on mappe les classes d'assoces seulement comme des liens, quel accès aux infos de liens ?
}

// Returns the role's classes for *this*, assumed it represents a binary association
std::pair<wstring,wstring> MappedTable::getLinkedClasses() const {
	pair<wstring,wstring> result;
	if (isAssociation()) {
	} else throw "Access to roles requires an association !!";
  return result;
}

wstring MappedTable::memberDecl(const wstring&field ) const { 
  assert(members.count(field)!=0);
	wstring type=members.find(field)->second.type;
	wstring result=L"column<"+type+L"> " + field;
	if (isToOneRole(field)) result=L"reference<"+type+L"> " + field;
	else if (isToManyRole(field)) result=L"COLLECTION("+type+L","+field+L")";
	else if (isNullable(field)) { /* TO DO dans lorm: result=L"nullable_column<"+type+L">" */};
	return result;
}

void MappedTable::generateClassHeader() {
	if (!members.empty() &!isAssociation()) {
		classHeader+= interfacePrologue;			// .h header
		
		for (FieldIt it=members.begin(); it!=members.end(); it++) {
			if (isRole(it->first)) classHeader+=L"class "+it->second.type+L";\n"; // Forward declarations
		} //TODO: doubloner
		
		classHeader+= interfaceClassPrologue;	// Public fields
		if (!primaryKey.empty()) {
			classHeader+=L"\tcolumn<int> id;\n";
		}
		for (FieldIt it=members.begin();it!=members.end();it++) { // Members mapped with their cpp type
            if (primaryKey!=it->first) {
                classHeader += L"\t" + memberDecl(it->first) + L";\n"; 
            }
		}	
		classHeader += interfaceEpilogue;		// Hop, les accolades et les #endif !
		replaceAll(L"$className", className, classHeader);
	} else {
		wcout << className << L" skipped : no members could be mapped" << endl;
	}
};