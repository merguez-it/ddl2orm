/*
 *  MappedTable.cpp
 *  ddl2orm
 *
 *  Created by Mathias Franck on 13/03/12.
 *  Copy 2012 __MyCompanyName__. All rights reserved.
 *
 */
#include <iostream>
#include <sstream>
#include <assert.h>

#include "MappingUtils.h"
#include "MappedTable.h"

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
bool MappedTable::isPureBinaryAssociation() const { 
	return (!members.empty()) && fkToPk.size()==members.size() && (2==members.size()); // équivaut à : pas d'autres champs que 2 clés ... bof ...
}



// Returns the pair of member descriptors representing role-ends of a MappedTable
// that is assumed to model a bi-directional association.
std::pair<MemberDesc , MemberDesc> MappedTable::getLinkedRoles() const {
	assert(isPureBinaryAssociation()) ;
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