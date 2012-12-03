/*
 *  ObjectModel.h
 *  ddl2orm
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
#include <wchar.h>
#include "MappedTable.h"

using namespace std;

struct case_insensistive_compare : std::binary_function<wstring, wstring, bool> {
    bool operator()(const wstring &lhs, const wstring &rhs) const {
        wstring l=lhs;
        wstring r=rhs;
        std::transform(l.begin(), l.end(), l.begin(), ::toupper);
        std::transform(r.begin(), r.end(), r.begin(), ::toupper);
        return (l < r);
    }
};

typedef map<wstring,MappedTable,case_insensistive_compare> MappedTables;
class Parser;

class ObjectModel  {
public:
	ObjectModel(const string& sqlFile, const string& anOutputDir);
	int parseDDLtoObjectModel();
	int generateCppFiles();
  const MappedTables& mapped_tables() const {return tables;}
  MappedTables pure_associations_tables() const ;
private:
	void populateReversedToOne(MappedTable& mt);
	void populateManyToMany(MappedTable& relation);
	void populateRelationships();
	std::pair<wstring,wstring> getLinkedClasses();
	friend class Parser;
	Parser *parser;
	string outputDir;
	MappedTables tables;
};

#endif