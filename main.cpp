#include <iostream>
#include "ObjectModel.h"

#define noErr 0
using namespace std;

int main (int argc, char * const argv[]) {
	
	//TODO: Usage...
	int err=noErr;
	string fileName = argv[1];
	string outputDir="../../test"; 
	if (argc >2) outputDir=argv[2]; 
	ObjectModel *model=new ObjectModel(fileName,outputDir);
	err=model->parseDDLtoPopulateModel();
	if (noErr==err) {
		err=model->generateCppFiles();
	}
	delete model;
	return err;
}
