/*
 *  ObjectModel.cpp
 *  ddl2orm
 *
 *  Created by Mathias Franck on 13/03/12.
 *  Copyleft 2012 Merguez-IT. All rights reserved.
 *
 */
#include <sstream>
#include <iostream>

#include "ObjectModel.h"
#include "Scanner.h"
#include "Parser.h"

ObjectModel::ObjectModel(const string& sqlFile, const string& anOutputDir): outputDir(anOutputDir) {
	wstring wsqlFile=wstring(sqlFile.begin(),sqlFile.end());
	Scanner *scanner=new Scanner(wsqlFile.c_str());
	parser = new Parser(scanner);
	parser->model=this;
}

int ObjectModel::parseDDLtoObjectModel() {
	parser->Parse();
	if (parser->errors->count == 0) {
		populateRelationships();
		wcout << L"[INFO] parsing ddl2orm: OK" << endl;
	} 
	else {
		wcout << L"[ERROR] parsing ddl2orm: KO" << endl;
		return -1;
	}
	return 0;
}

void ObjectModel::populateReversedToOne(MappedTable& mt) {
	for (FieldIt fieldIt=mt.members.begin(); fieldIt!=mt.members.end(); fieldIt++) {
		if (mt.isToOneRole(fieldIt->first)) {
			wstring targetClass=fieldIt->second.type;
			assert(!targetClass.empty());
			assert(tables.count(targetClass)==1);
			MappedTable& targetMappedTable = tables[targetClass];
      if (!targetMappedTable.isReferenceTable()){
        MemberDesc virtual_member;
        virtual_member.kind=ONE_TO_MANY;
        virtual_member.type=mt.className;
        virtual_member.reverseRoleName=fieldIt->first;
        wstring generatedName=targetMappedTable.add_to_many_role(mt.tableName, virtual_member); //TODO: Inject one to-many role name as it may be crappy
        if (generatedName!=mt.tableName+L"s" && generatedName!=mt.tableName) {
          wcout << L"[WARNING] One-to-many generated role: " << targetMappedTable.tableName <<  L"." << generatedName << " may have a non-significant ambiguous crappy name..." << endl;
        }
      }
		} 
	}
}

void ObjectModel::populateManyToMany(MappedTable& association) {
  for (MemberMap::iterator role_it1=association.members.begin();role_it1!=association.members.end();role_it1++ ) {
    MemberDesc role1 = role_it1->second;
    if (role1.kind == TO_ONE ) {
      role1.kind=MANY_TO_MANY;
      role1.linkClass=association.tableName;
      assert(tables.count(role1.type)==1);
      for (MemberMap::iterator role_it2=association.members.begin();role_it2!=association.members.end();role_it2++ ) {
        MemberDesc role2 = role_it2->second;
        if (role2.kind == TO_ONE &&
            role1.fkName!=role2.fkName &&
            !tables[role2.type].isReferenceTable()) {
          assert(tables.count(role2.type)==1);
          role1.reverseRoleName=role2.fkName;
          wstring radical = role1.roleName;
          wstring generatedName=tables[role2.type].add_to_many_role(radical,role1);
          if (generatedName!=radical+L"s" && generatedName!=radical) {
            wcout << "[WARNING] Many-to-many generated role " << role2.type << L"." << generatedName << " may have a non-significant ambiguous crappy name..." << endl;
          }
        }
      }
    }
  }
}

MappedTables ObjectModel::pure_binary_associations() const {
  MappedTables result;
	for (MappedTables::const_iterator it=tables.begin(); it!=tables.end(); it++) {
    if (it->second.isPureBinaryAssociation()) {
      result.insert(*it);
    }
  }
  return result;
}

MappedTables ObjectModel::association_classes() const {
    MappedTables result;
	for (MappedTables::const_iterator it=tables.begin(); it!=tables.end(); it++) {
        if (it->second.isAssociationClass()) {
            result.insert(*it);
        }
    }
    return result;
}

MappedTables ObjectModel::reference_tables() const {
    MappedTables result;
	for (MappedTables::const_iterator it=tables.begin(); it!=tables.end(); it++) {
        if (it->second.isReferenceTable()) {
            result.insert(*it);
        }
    }
    return result;
}
// Returns the set of classes which this MappedTable depends on.

void ObjectModel::populateRelationships() {
	for (MappedTables::iterator it=tables.begin(); it!=tables.end(); it++) {
		MappedTable& mt=it->second;
		if (mt.isAssociationClass() || mt.isPureBinaryAssociation()) {
			populateManyToMany(mt);
		}
    if (!mt.isPureBinaryAssociation() && !mt.isReferenceTable())
    {
			populateReversedToOne(mt);
		} 
	}
}
