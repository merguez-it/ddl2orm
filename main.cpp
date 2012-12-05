#include <iostream>
#include "ObjectModel.h"

#include <assert.h>

#define noErr 0
using namespace std;

int main (int argc, char * const argv[]) {
	
	//TODO: Usage...
	int err=noErr;
	string fileName = argv[1];
	string outputDir="../../test/ddl2cpp_generated"; 
	if (argc >2) outputDir=argv[2]; 
	ObjectModel *model=new ObjectModel(fileName,outputDir);
	err=model->parseDDLtoObjectModel();
	if (noErr==err) {
//		assert(model->mapped_tables().size()==152);
		MappedTables bidir_assoces=model->pure_associations_tables();
		//      assert(bidir_assoces.size()==47);
		std::wcout << L"Total mapped tables : " << model->mapped_tables().size() << std::endl;
		std::wcout << L"Mapped pure associations: " << bidir_assoces.size() << std::endl;
		err=model->generateCppFiles();
	}
	delete model;
	return err;
}
