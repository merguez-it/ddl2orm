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
	if (!argv[1]) {
		std::cout << "An SQLite script file path should be given - quitting..." << endl;
		err=-1;
	} else {
		string fileName = argv[1];
		string outputDir="./";
		if (argc >2) outputDir=argv[2];
		ObjectModel *model=new ObjectModel(fileName,outputDir);
		err=model->parseDDLtoObjectModel();
		if (noErr==err) {
			MappedTables bidir_assoces=model->pure_binary_associations();
      MappedTables assoces_classes = model-> association_classes();
      MappedTables ref_tables = model->reference_tables();
			OrmGenerator gen(*model);
			err=gen.generateFiles();
      std::wcout << endl;
      std::wcout << L"------------------------------------------" << endl;
      std::wcout << L"|        ddl2orm Mapping summary         |" << endl;
      std::wcout << L"------------------------------------------" << endl;
      std::wcout << L"| Total mapped tables :               " << model->mapped_tables().size()  << "\t|" << std::endl;
      std::wcout << L"| Mapped as domain object :           " << model->mapped_tables().size() - bidir_assoces.size() - assoces_classes.size() - ref_tables.size() << "\t|" << std::endl;
      std::wcout << L"| Mapped as associations classes :    " << assoces_classes.size() << "\t|" << std::endl;
      std::wcout << L"| Mapped as pure binary associations: " << bidir_assoces.size() << "\t|" << std::endl;
      std::wcout << L"| Mapped as reference tables :        " << ref_tables.size() << "\t|" << std::endl;
      std::wcout << L"------------------------------------------" << endl;

		}
		delete model;
	}
	return err;
}