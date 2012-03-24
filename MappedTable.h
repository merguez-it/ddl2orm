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
#include <vector>
using namespace std;

typedef map<wstring,wstring> FieldTypes;	// Mapper les data fields et leur type C++, (sans mention de classe d'allocation)
typedef map<wstring,wstring> RoleMap;		// Mapper les cles etrangères ("to-one") avec les clés primaires associées
typedef vector<wstring> NullableMap;		// Mapper les fields nullables (les fk nullables peuvent y figurer, pas les rôles associés)
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
	RoleMap fkToPk;			// Mapping <fk,pk>*
	NullableMap nullables;	// Liste des fields nullables, mappés en pointeurs
}; 

#endif
