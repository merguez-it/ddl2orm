/*
 *  MappedTable.h
 *  ddl2orm
 *
 * A MappedTable maps either à Class or an Association (tables "object1_object2") 
 * - It owns any required descriptive information about the mapped table (fields, roles, bidirectional associations, keys)
 * - Thus, it allows full generation of C++ representation for the mapped class.
 *
 * Created by Mathias Franck on 13/03/12.
 * Copyright 2012 Vidal. All rights reserved.
 *
 */
#ifndef MAPPED_TABLE_H
#define MAPPED_TABLE_H

#include <stdlib.h>
#include <string>
#include <map>
#include <vector>
using namespace std;


enum  MemberKind {
	DATA, NULLABLE_DATA, TO_ONE, MANY_TO_MANY, ONE_TO_MANY
};

// Describes a member to map 
struct MemberDesc {
	MemberKind kind; 
	wstring type;	//  Class (to-one, to-manies) or simple type
	// Following fields are only used to map role-members
	wstring fkName;  // Foreign key name, when *this* descriptor models a "to-one" role
	wstring request; // SQL request used to access the to-one or to-many roles (SOCI only).
};

typedef map<wstring,wstring> FkToPkMap;		// Maps FKs with related PKs
typedef map<wstring,MemberDesc> MemberMap;	// Maps data fields and related C++ type/class
typedef MemberMap::iterator FieldIt;

class MappedTable  {
public:
	bool isAssociation() const ; 	//Returns true if the mapped table represents an association (i.e: table FKs and no data inside) rather than a class.

	void generateClassHeader(); // Generate hxx skeleton for *this* table
	void generateClassImplementation() {}; //Generate cxx body for *this* class
	void generateSociConverter() {}; // Generate hxx (instantiated template) function body for data transfer from db
protected:
	friend class Parser;
	friend class ObjectModel;
	bool isNullable(const wstring& fieldName) const ; 
	bool isForeignKey(const wstring& fieldName) const ;  //TODO: VIRER
	bool isToOneRole(const wstring& roleName) const ; 
	bool isToManyRole(const wstring& roleName) const ; 
	bool isRole(const wstring& roleName) const ; 
	vector<wstring> getAllRoles() const ; 
	wstring memberDecl(const wstring&field) const ;  //member declaration depending on mapped kind : Simple value, Nullable, to-many, to-one.
  std::pair<wstring,wstring> getLinkedClasses() const ; 
	wstring className;
	wstring tableName;
	wstring classHeader;
	wstring primaryKey;
	MemberMap members;			// Mapping <field or member, description>*
	FkToPkMap fkToPk;				// Mapping <fk,pk>* for to-one associations
}; 

#endif
