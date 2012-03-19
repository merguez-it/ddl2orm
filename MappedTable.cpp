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

using namespace std;

// Returns true if the given "name" represents a "role" name  (= field "to-one" that figures a linked object) 
bool MappedTable::isRole(const wstring& name) { 	
	return fkToPk.find(name)!=fkToPk.end();
}

//Returns true if the mapped table represents an association rather than a class
bool MappedTable::isAssociation() { 
	return (!fieldMap.empty()) && (fkToPk.size()*2==fieldMap.size());
}

void MappedTable::generateClassRepresentation() {
	if (!fieldMap.empty() &!isAssociation()) {
		wstring prologue=cppPrologue; //Pour ne pas modifier le template cppPrologue static, sinon, l'analyse multi-table plantera.
		replaceAll(L"$className", className, prologue); // substituer le nom de la classe à son "tag".
		replaceAll(L"$tableName", tableName, prologue); // le nom de la table pour le pragma db table("tableName")
		classRepresentation+= prologue;		// En-tête
		classRepresentation+= cppAccessors;	// Accesseurs
		for (fieldIt it=fieldMap.begin();it!=fieldMap.end();it++) {  
			classRepresentation+= L"\t\tconst " + it->second + L"& "+ it->first + L"()" ;
			if (isRole(it->first))
				classRepresentation+= L" const {" + it->first + L"_.load(); return " +  it->first + L"_; }\n";
			else
				classRepresentation+= L" const { return " +  it->first + L"_; }\n";
		}
		wstring fields=cppFields;
		replaceAll(L"$className", className, fields); //le constructeur privé
		classRepresentation+= fields;		
		for (fieldIt it=fieldMap.begin();it!=fieldMap.end();it++) { // Les données-membres mappées avec leur type
			if (isRole(it->first))  { 
				if (it->first!=fkToPk[it->first]) { //pragma ssi odb ne peut déduire le lien du nom de rôle (convention "<role>Id")
					wstring insertedPragma=pragmaRole;
					replaceAll(L"$roleColumn", it->first, insertedPragma);
					classRepresentation+= insertedPragma;
				}
			}
			if (it->first==primaryKey) classRepresentation += pragmaID; //clé primaire maquée d'un pragma
			classRepresentation += L"\t\t" + it->second + L" "+ it->first + L"_;\n"; 
		}	
		classRepresentation += cppEpilogue;		// Hop, les accolades et les #endif !
	} else {
		wcout << className << L" skipped : no members could be mapped" << endl;
	}
};