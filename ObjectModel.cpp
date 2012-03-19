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

int ObjectModel::parseDDLtoPopulateModel() {
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

int ObjectModel::generateCppFiles() {
	int result=0;
	for (map<wstring,MappedTable>::iterator it=tables.begin(); it!=tables.end(); it++) {
		MappedTable& mt=it->second;
		if (!mt.isAssociation()) {
			string className=string(mt.className.begin(),mt.className.end());
			string path=outputDir+PATH_SEPARATOR+className+".hxx";
			wofstream out(path.c_str());
			if (out.is_open())	{			
				mt.generateClassRepresentation();
				out <<	mt.classRepresentation;
				cout << path << " generated ( "<< mt.fieldMap.size() << " members mapped )" << endl;
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