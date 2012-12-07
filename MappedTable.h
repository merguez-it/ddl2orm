/*
 *  MappedTable.h
 *  ddl2orm
 *
 * A MappedTable maps either à Class or an Association (tables "object1_object2") 
 * - It owns any required descriptive information about the mapped table (fields, roles, bidirectional associations, keys)
 * - Thus, it allows full generation of C++ representation for the mapped class.
 *
 * Created by Mathias Franck on 13/03/12.
 *  Copyleft 2012 Merguez-IT. All rights reserved.
 *
 */
#ifndef MAPPED_TABLE_H
#define MAPPED_TABLE_H
#include <assert.h>
#include <stdlib.h>
#include <string>
#include <map>
#include <vector>
using namespace std;


enum  MemberKind {
	DATA, NULLABLE_DATA, TO_ONE, ONE_TO_MANY, MANY_TO_MANY, MANY_TO_MANY_WITH_INFO
};

// Describes a member to map.
struct MemberDesc {
	wstring roleName; 				// Names the role using conventions ( == key of "MemberMAp", see below)
	MemberKind kind; 					// Kind of member
	wstring type;							// Class (to-one, to-manies) or simple type (int,string...)
	
														// Following fields are used to map role-members
	wstring fkName;  					// - Foreign key name to a foreign object, when the described member is of kind TO_ONE.
														// - If the described member is a ONE_TO_MANY role, fkName is the key used to refer this TO_ONE object 
														//   from the "many" side of the relationship
														// - If the described member is of kind MANY_TO_MANY, fkName is the foreign key 
	                 					//   stored in the link table, that is used to fetch the elements at the other side of the relationship.

	wstring linkTable;				// Link table used to hold a relationship, when this descriptor models 

	wstring reverseRoleName; 	// - If the described member is a TO_ONE role, reverseRoleName is the ONE_TO_MANY role name 
														//   used at the other side of the relationship to refer *this* object.
														// - If the described member is a ONE_TO_MANY role, reverseRoleName is the TO_ONE role name 
														//   used at the other side of the relationship to refer *this* object.
														// - otherwise, it is undefined.
	
};

class less_decl {
public:
	bool operator()(const MemberDesc &l , const MemberDesc &r) const {
		return ( l.kind == r.kind ? (l.type == r.type ? l.roleName < r.roleName : l.type < r.type) : l.kind < r.kind );
	};
};

typedef map<wstring,wstring> FkToPkMap;		// Maps FKs with related PKs
typedef map<wstring,MemberDesc> MemberMap;	// Maps data fields and related C++ type/class
typedef MemberMap::const_iterator FieldIt;


class MappedTable  {
public:
	
	// Returns true if the mapped table represents a pure binary association,
	// that won't be mapped as a an object, but as a navigation accessor.
	// i.e: It contains 2 FKs and no data.
	// n-ary associations (n>2) are not yet recognized;

	bool isPureBinaryAssociation() const ; 
	
	// Returns true if the mapped table represents an association class
	// i.e: contains data and no single PK.
	// Skipped from generation for the moment.
	bool isAssociationClass() const {return !isPureBinaryAssociation() && primaryKey.empty();} 	
	
protected:
	
	friend class Parser;
	friend class ObjectModel;
	friend class OrmGenerator;
	
	bool isNullable(const wstring& fieldName) const ; 
	bool isForeignKey(const wstring& fieldName) const ; 
	bool isToOneRole(const wstring& roleName) const ; 
	bool isToManyRole(const wstring& roleName) const ; 
	bool isRole(const wstring& roleName) const ; 
	vector<wstring> getAllRoles() const ; 
	wstring add_to_many_role(const wstring& roleName, MemberDesc &role); 
	std::pair<MemberDesc , MemberDesc> getLinkedRoles() const;
	wstring className;
	wstring tableName;
	wstring primaryKey;
	MemberMap members;			// Mapping <field or member, description>*
	FkToPkMap fkToPk;				// Mapping <fk,pk>* for to-one associations
}; 

#endif
