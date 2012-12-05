/*
 *  MappedTable.cpp
 *  ddl2orm
 *
 *  Created by Mathias Franck on 13/03/12.
 *  Copyright 2012 __MyCompanyName__. All rights reserved.
 *
 */
#include <iostream>
#include <sstream>
#include <assert.h>

#include "MappingUtils.h"
#include "MappedTable.h"
#include "cppClassTemplate.inc.h"

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
	assert(members.count(roleName)!=0);
	return TO_ONE==members.find(roleName)->second.kind;
}

// Returns true if the given "roleName" represents a to-many role name
bool MappedTable::isToManyRole(const wstring& roleName) const {
	assert(members.count(roleName)!=0);
	return MANY_TO_MANY==members.find(roleName)->second.kind || ONE_TO_MANY==members.find(roleName)->second.kind;
}

bool MappedTable::isRole(const wstring& roleName) const {
	assert(members.count(roleName)!=0);
	return isToManyRole(roleName) || isToOneRole(roleName);
}

// Returns true if the mapped table represents an association (i.e: table with 2 links and no simple data fields) rather than a class.
// n-ary associations (n>2) and associations-classes not yet recognized (=> They are mapped as "real" objects)
bool MappedTable::isAssociation() const { 
	return (!members.empty()) && fkToPk.size()==members.size() && (2==members.size()); // équivaut à : pas d'autres champs que 2 clés ... bof ...
}

wstring MappedTable::memberDecl(const wstring& field ) const { 
  assert(members.count(field)!=0);
	wstring type=members.find(field)->second.type;
	wstring result=L"column<"+type+L"> " + field;
	if (isToOneRole(field)) result=L"reference<"+type+L"> " + field;
	else if (isToManyRole(field)) result=L"COLLECTION("+type+L","+field+L")";
	else if (isNullable(field)) { /* TO DO dans lorm: result=L"nullable_column<"+type+L">" */}
	return result;
}

wstring MappedTable::generateForwardDeclarations() const {
	wstring result;
	vector<wstring> already_declared;
	already_declared.push_back(L"class " + className + L";\n"); // Do not forward-declare *this* mapped class
	for (FieldIt it = members.begin(); it != members.end(); it++) {
		if (isRole(it->first)) {					
			wstring forward_declaration = L"class " + it->second.type + L";\n";
			if (find(already_declared.begin(), already_declared.end(), forward_declaration) == already_declared.end()) {
				already_declared.push_back(forward_declaration);
				result += forward_declaration;
			}
		}
	} 
	return result;
}

void MappedTable::generateClassHeader() {
	if (!members.empty()) {
		classHeader += interfacePrologue;			// .h header
		classHeader += generateForwardDeclarations();
		classHeader += interfaceClassPrologue;	// Public fields
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
		replaceAll(L"$tableName", tableName, classHeader);
	} else {
		wcout << L"[WARNING] " << className << L" skipped : no members could be mapped" << endl;
	}
};

// Returns the pair of member descriptors representing role-ends of a MappedTable
// that is assumed to model a bi-directional association.
std::pair<MemberDesc , MemberDesc> MappedTable::getLinkedRoles() const {
	assert(isAssociation()) ;
	MemberDesc role1=members.begin()->second;
	MemberDesc role2=(++members.begin())->second;
	return pair<MemberDesc , MemberDesc >(role1,role2);
}

// Adds a member (=role) to this mapped table, ensuring it has a unique name,
// based on the given roleName pluralized (vite,TODO: mgz-utils !).
// Returns the name of the role actually inserted into the mapped table.
wstring MappedTable::add_to_many_role(const wstring& roleName, MemberDesc &role) {
	wstring result=roleName + L"s"; // TODO: Traiter les injections de nom des rôles "to-many" - ou au moins pluralize
	int i=0;
	while (members.count(result)!=0) { 
		std::wstringstream str;
		str << roleName << L"s_"<< ++i;
		result = str.str();
	}
	role.roleName=result;
	members[result]=role;
	return result;
}