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
#include <set>
#include <vector>
using namespace std;


// Enumerates the kind of elements that could be mapped from a reversed DB table.
enum  MemberKind {
	DATA, NULLABLE_DATA, TO_ONE, ONE_TO_MANY, MANY_TO_MANY, MANY_TO_MANY_WITH_INFO
};

// Describes a member belonging to a mapping class.
struct MemberDesc {
	
	// Name of the attribute or role, using conventions ( == key of "MemberMap", see below)
	wstring roleName; 
	
	// Kind of this member
	MemberKind kind;
	
	//Simple type or mapping class for this role
	wstring type;							

	// Following fields are used to map role-members
	// - Foreign key name to a foreign object, when the described member is of kind TO_ONE.
	// - If the described member is a ONE_TO_MANY role, fkName is the key used to refer this TO_ONE object 
	//   from the "many" side of the relationship
	// - If the described member is of kind MANY_TO_MANY, fkName is the foreign key 
	//   stored in the link table, that is used to fetch the elements at the other side of the relationship.
	wstring fkName;
	
	// Class that maps a link table used to hold a relationship in the DB,
	// when this descriptor models a MANY_TO_MANY role.
	wstring linkClass;	
	
	// - If the described member is a TO_ONE role, reverseRoleName is the ONE_TO_MANY role name 
	//   used at the other side of the relationship to refer *this* object.
	// - If the described member is a ONE_TO_MANY role, reverseRoleName is the TO_ONE role name 
	//   used at the other side of the relationship to refer *this* object.
	// - otherwise, it is undefined.
	wstring reverseRoleName;
};

// Define a pretty order for presenting member declarations.
class less_decl {
public:
	bool operator()(const MemberDesc &l , const MemberDesc &r) const {
		return ( l.kind == r.kind ? (l.type == r.type ? l.roleName < r.roleName : l.type < r.type) : l.kind < r.kind );
	};
};

// Used to map FKs with related PKs. //TODO: Set also for many-to-manies
typedef map<wstring,wstring> FkToPkMap;		typedef map<wstring,MemberDesc> MemberMap;	// Maps members and roles to their description (type, 
typedef MemberMap::const_iterator FieldIt;


// Mapped table represents the map^ping between a class that will then be generated, and an SQL table reversed engineered.
// It describes attributes, one-to-one, one-to-many and many-to-many relationships, navigable
// from objects of the modeled class.
class MappedTable  {
public:
	// The name of the class. Defaults to the "camelized" name of the table.
	wstring className;
	
	// The name of the mapped table, as spelled in the reversed DDL script.
	wstring tableName;
	
	// The single PK of tuples in the mapped table, as spelled in the reversed DDL script.
	// TODO: Implement composite PKs
	wstring primaryKey;
	
	// A map to members descriptions for attributes of this mapping class.
	// Map keys are the generated names of the reversed or computed members. 
	MemberMap members;			// Mapping <field or member, description>*
	FkToPkMap fkToPk;				// Mapping <fk,pk>* for to-one associations

	
	// Returns true if the given field is of a nullable simple type 
	// Field is assumed to belong to *this* class, otherwise, an assert is issued.
	bool isNullable(const wstring& fieldName) const ; 
	
	// Returns true if the given field name is a FK, false otherwise
	bool isForeignKey(const wstring& fieldName) const ;
	
	// Returns true if the given "roleName" represents a to-one linked object (a.k.a. single role). 
	// Role is assumed to belong to *this* class, otherwise, an assert is issued.
	bool isToOneRole(const wstring& roleName) const ; 
	
	// Returns true if the given "roleName" represents a to-many role
	// Role is assumed to belong to *this* class, otherwise, an assert is issued.
	bool isToManyRole(const wstring& roleName) const ;
	
	bool isRole(const wstring& roleName) const ; 
	
	// Returns true if the mapped table represents a pure binary association,
	// that is not to be mapped as a an object, but rather as navigation accessors 
	// from both sides of the relationship.
	// A "pure binary association" is a table that contains 2 FKs and no data.
	// n-ary associations (n>2) not yet recognized.
	bool isPureBinaryAssociation() const ; 
	
	// Returns true if the mapped table represents an association class
	// i.e: contains data and no single PK.
	// Skipped from generation in the current version. TODO: Implement association-classes
	bool isAssociationClass() const {return !isPureBinaryAssociation() && primaryKey.empty() && fkToPk.size()==2;}
  
  // Returns the set of classes which this MappedTable depends on.
  set<wstring> getClassDependencies() const;

	
protected:
	
	friend class Parser;
	friend class ObjectModel;
	friend class OrmGenerator;	
	
	// Adds a member (=role) to this mapped table, ensuring it has a unique name,
	// based on the given roleName pluralized (vite,TODO: mgz-utils !).
	// Returns the name of the role actually inserted into the mapped table.
	wstring add_to_many_role(const wstring& roleName, MemberDesc &role); 
	
	// Returns the pair of member descriptors representing role-ends of a MappedTable
	// that is assumed to model a bi-directional association.
	// Asserts if *this* is not a pure binarassociation
	std::pair<MemberDesc , MemberDesc> getLinkedRoles() const;
	
}; 

#endif
