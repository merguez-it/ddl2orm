/*
 *  MappedTable.h
 *  ddl2cpp
 *
 * A MappedTable maps either à Class or an Association (tables "object1_object2") 
 * - It owns any required descriptive information about the mapped table (fields, roles, keys)
 * - It generates textual representation of mapped classes.
 *   Associations are generated "as a whole" by the ObjectModel in a second pass,
 *   substituing "to-many" tags in class representations.
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

using namespace std;

typedef map<wstring,wstring> FieldTypes;
typedef map<wstring,wstring> RoleMap; //mapper les cles etrangères avec les clés primaires, si elles different
typedef FieldTypes::iterator fieldIt;


class MappedTable  {
public:
	bool isAssociation();
	void generateClassRepresentation(); //Generate cpp skeleton for *this* class
protected:
	friend class Parser;
	friend class ObjectModel;
	bool isRole(const wstring& name);
	wstring className;
	wstring tableName;
	wstring classRepresentation;
	wstring primaryKey;
	FieldTypes fieldMap;	// Mapping <champ, type>*
	RoleMap fkToPk;			// Mapping des rôles (clés étrangères)  vers les clés primaires concernées.
	// Ex:avec une table "personne": < personne_id,nom,prenom,mere_id >, on a:
	// fkToPk["mere_id"] égal à "personne_id", qui génèrera:
	//   #pragma db column("mere_id")
	//   lazy_auto_ptr<Personne> mere; 
}; 

#endif
