/*
 *  ObjectModel.cpp
 *  ddl2cpp
 *
 *  Created by Mathias Franck on 13/03/12.
 *  Copyright 2012 Vidal. All rights reserved.
 *
 */
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
		cout << "parsing ddl2cpp: OK" << endl;
	} 
	else {
		cout << "parsing ddl2cpp: KO" << endl;
		return -1;
	}
	return 0;
}

void ObjectModel::populateToOneAndReversed(MappedTable& mt) {
	for (FieldIt fieldIt=mt.members.begin(); fieldIt!=mt.members.end(); fieldIt++) {
		if (mt.isToOneRole(fieldIt->first)) {
			// "to one" SQL loader
			wstring request=requestToOne;
			wstring targetClass=fieldIt->second.type;
			replaceAll(L"$classUpper",toUpper(mt.className),request);
			replaceAll(L"$targetRoleUpper",toUpper(fieldIt->first),request);
			replaceAll(L"$targetTable",tables[targetClass].tableName,request);
			replaceAll(L"$targetKey",tables[targetClass].primaryKey,request);
			wcout << mt.className << "." << fieldIt->first << "() => " << request << fieldIt->second.fkName << endl << flush;
			//Processes reversed "to one" SQL loader (i.e: implicit "one to many")
			wstring reverseRequest=requestOneToMany;
			replaceAll(L"$classUpper",toUpper(targetClass),reverseRequest);
			replaceAll(L"$targetRoleUpper",toUpper(mt.className),reverseRequest); // Injecter les noms des rôles inverses, car leur sémantique ne se déduit pas de la db.
			replaceAll(L"$targetTable",mt.tableName,reverseRequest);
			replaceAll(L"$sourceKey",fieldIt->second.fkName,reverseRequest);
			wcout << targetClass << "." << mt.tableName << "s"<< "() => " << reverseRequest << tables[targetClass].primaryKey << endl << endl << flush;
		}
	}
}

void ObjectModel::populateManyToMany(MappedTable& relation) {
	// Pre-cond: 
//	wstring request=requestManyToMany;
//	// #define select * from $targetTable inner join $linkTable on $targetTable.$targetKey=$linkTable.$linkTargetKey and $linkTable.$linkedSourceKey=;
//	wstring linkTable=relation.tableName;
//	wstring classA=
//	wstring classB=
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
			populateToOneAndReversed(mt);
		} 
	}
}

int ObjectModel::generateCppFiles() {
	int result=0;
	// <TEST>
//	tables[L"Product"].members[L"substances"].kind=MANY_TO_MANY;
//	tables[L"Product"].members[L"substances"].type=L"Molecule";
//	tables[L"Product"].members[L"substances"].request=L"select * from molecule where productId";
//	tables[L"Product"].members[L"packages"].kind=ONE_TO_MANY;
//	tables[L"Product"].members[L"packages"].type=L"Package";
//	tables[L"Product"].members[L"packages"].request=L"select etc...";

	// </TEST>
	//populateRelationships();
	for (MappedTables::iterator it=tables.begin(); it!=tables.end(); it++) {
		MappedTable& mt=it->second;
		if (!mt.isAssociation()) {
			string className=string(mt.className.begin(),mt.className.end());
			assert(!className.empty());
			string path=outputDir+PATH_SEPARATOR+className+".hxx";
			wofstream out(path.c_str());
			if (out.is_open())	{			
				mt.generateClassHeader();
				out <<	mt.classHeader;
				cout << path << " generated ( "<< mt.members.size() << " members mapped )" << endl;
			}
			if (out.fail()) {
				cout << "I/O error while generating " << path << endl;
				result=-1;
			}
		} 	
		else {
			wcout << mt.tableName << " skipped : this table maps a many-to-many association." << endl;
		}
	};
	return result;
}