/*
 *  ObjectModel.h
 *  ddl2cpp
 *
 *  The model that instantiates a SQL (Coco) parser, 
 *  store the parsed tables descriptions, and generates corresponding cpp mapping for ODB.
 *
 *  Created by Mathias Franck on 13/03/12.
 *  Copyright 2012 Vidal. All rights reserved.
 *
 */
#ifndef OBJECT_MODEL_H
#define OBJECT_MODEL_H 

#include <stdlib.h>
#include <map>

#include "MappedTable.h"

using namespace std;
typedef map<wstring,MappedTable> MappedTables;
class Parser;

class ObjectModel  {
public:
	ObjectModel(const string& sqlFile, const string& anOutputDir);
	int parseDDLtoObjectModel();
	int generateCppFiles();
  const MappedTables& mapped_tables() const {return tables;}
  MappedTables pure_associations_tables() const ;
private:
	void populateToOneAndReversed(MappedTable& mt);
	void populateManyToMany(MappedTable& relation);
	void populateRelationships();
	std::pair<wstring,wstring> getLinkedClasses();
	friend class Parser;
	Parser *parser;
	string outputDir;
	MappedTables tables;
};

#endif