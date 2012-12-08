/*
 *  main.cpp
 *  ddl2orm
 *
 *  Created by Mathias Franck on 13/03/12.
 *  Copyleft 2012 Merguez-IT. All rights reserved.
 *
 */

#include <iostream>
#include <assert.h>

#include "ObjectModel.h"
#include "OrmGenerator.h"

#define noErr 0
using namespace std;

int main (int argc, char * const argv[]) {
	
	//TODO: Usage...
	int err=noErr;
	string fileName = argv[1];
	string outputDir="./"; 
	if (argc >2) outputDir=argv[2]; 
	ObjectModel *model=new ObjectModel(fileName,outputDir);
	err=model->parseDDLtoObjectModel();
	if (noErr==err) {
		MappedTables bidir_assoces=model->pure_associations_tables();
		std::wcout << L"Total mapped tables : " << model->mapped_tables().size() << std::endl;
		std::wcout << L"Mapped pure associations: " << bidir_assoces.size() << std::endl;
		OrmGenerator gen(*model);
		err=gen.generateFiles();
	}
	delete model;
	return err;
}
