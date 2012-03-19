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

class Parser;

class ObjectModel  {
public:
	ObjectModel(const string& sqlFile, const string& anOutputDir);
	int parseDDLtoPopulateModel();
	int generateCppFiles();
private:
	friend class Parser;
	Parser *parser;
	string outputDir;
	map<wstring,MappedTable> tables;
};

#endif