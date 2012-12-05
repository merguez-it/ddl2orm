/*
 *  ObjectModel.cpp
 *  ddl2orm
 *
 *  Created by Mathias Franck on 13/03/12.
 *  Copyright 2012 Vidal. All rights reserved.
 *
 */
#include <sstream>
#include <iostream>

#include "ObjectModel.h"
#include "Scanner.h"
#include "Parser.h"

#define PATH_SEPARATOR "/"

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
		wcout << L"[INFO] parsing ddl2cpp: OK" << endl;
	} 
	else {
		wcout << L"[ERROR] parsing ddl2cpp: KO" << endl;
		return -1;
	}
	return 0;
}

// Given an table, populates the MappedTables matching the end of each "to-one" associations, with the "reversed"  member-specification  
// used to navigate the association from it's other end.
void ObjectModel::populateReversedToOne(MappedTable& mt) {
	for (FieldIt fieldIt=mt.members.begin(); fieldIt!=mt.members.end(); fieldIt++) {
		if (mt.isToOneRole(fieldIt->first)) {
			wstring targetClass=fieldIt->second.type;
			assert(!targetClass.empty());
			assert(tables.count(targetClass)==1);
			MappedTable& targetMappedTable = tables[targetClass];
			MemberDesc virtual_member;
			virtual_member.kind=ONE_TO_MANY;
			virtual_member.type=mt.className;
			wstring generatedName=targetMappedTable.add_to_many_role(mt.className, virtual_member);
			if (generatedName!=mt.className+L"s") { 
				wcout << L"[WARNING] One-to-many generated role: " << mt.className <<  L"." << generatedName << " may have a non-significant ambiguous crappy name..." << endl;
			}
		}
	}
}

// Returns the pair of MappedTable representing role-ends description, for a given MappedTable that represents a bi-directional association.
std::pair<MappedTable , MappedTable> ObjectModel::getLinkedClasses(const MappedTable& mt) const {
	assert(mt.isAssociation());
	pair<MemberDesc , MemberDesc > p = mt.getLinkedRoles();
	wstring class_role1=p.first.type;
	wstring class_role2=p.second.type;
	assert(tables.count(class_role1)==1);
	assert(tables.count(class_role2)==1);
	return pair<MappedTable , MappedTable >(tables.find(class_role1)->second,tables.find(class_role2)->second);
}

// Given an association table (i.e: "many-to-many" link table), populates MappedTables matching the ends of the association with member-specification  
// used to navigate that association from either of its class-ends.
// Pre-cond: All tables have been mapped to respective classes, some of them representing "many-to-many" relationships. 
// 					 "bidirectional_association" param is assumed to be one of them (i.e: table made only of 2 FKs) .
void ObjectModel::populateManyToMany(MappedTable& bidirectional_association) {
	assert(bidirectional_association.isAssociation());
	pair<MemberDesc,MemberDesc> roles = bidirectional_association.getLinkedRoles();
	MemberDesc role1 = roles.first;
	MemberDesc role2 = roles.second;
	assert(tables.count(role1.type)==1);
	assert(tables.count(role2.type)==1);
	role1.kind=MANY_TO_MANY;
	role2.kind=MANY_TO_MANY;
	wstring generatedName=tables[role2.type].add_to_many_role(role1.roleName,role1);
	if (generatedName!=wstring(roles.first.roleName+L"s")) { 
		wcout << "[WARNING] Many-to-many generated role " << role2.type << L"." << generatedName << " may have a non-significant ambiguous crappy name..." << endl;
	}
	generatedName=tables[role1.type].add_to_many_role(role2.roleName,role2);
	if (generatedName!=wstring(roles.second.roleName+L"s")) { 
		wcout << "[WARNING] Many-to-many generated role " << role1.type << L"." << generatedName << " may have a non-significant ambiguous crappy name..." << endl;
	}
}

MappedTables ObjectModel::pure_associations_tables() const {
  MappedTables result;
	for (MappedTables::const_iterator it=tables.begin(); it!=tables.end(); it++) {
    if (it->second.isAssociation()) {
      result.insert(*it);
    }
  }
  return result;
}

void ObjectModel::populateRelationships() {
	for (MappedTables::iterator it=tables.begin(); it!=tables.end(); it++) {
		MappedTable& mt=it->second;
		if (mt.isAssociation()) {
			populateManyToMany(mt);
		} else {
			populateReversedToOne(mt);
		} 
	}
}

int ObjectModel::generateCppFiles() {
	int result=0;
	for (MappedTables::iterator it=tables.begin(); it!=tables.end(); it++) {
		MappedTable& mt=it->second;
		string className=string(mt.className.begin(),mt.className.end());
		assert(!className.empty());
		if (!mt.isAssociation()) {
			string path=outputDir+PATH_SEPARATOR+className+".h";
			wofstream out(path.c_str());
			if (out.is_open())	{		
					mt.generateClassHeader();
					out <<	mt.classHeader;
					cout << className << ".h and .cpp generated ( "<< mt.members.size() << " members mapped )" << endl;
			}
			if (out.fail()) {
				cout << "I/O error while generating " << path << endl;
				result=-1;
			}
		}
	} 	
	return result;
}