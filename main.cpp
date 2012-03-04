#include <iostream>
#include "Parser.h"
#include "Scanner.h"

using namespace std;

string outputDir; // Vilaine globale utilisée par le parser, pour ranger ses sorties

int main (int argc, char * const argv[]) {
	
	//TODO: Usage...
	
	wchar_t *fileName = coco_string_create(argv[1]);
	outputDir="../../test"; 
	if (argc >2) outputDir=argv[2]; 
    Scanner *scanner = new Scanner(fileName);
	Parser  *parser = new Parser(scanner); 
	parser->Parse();
	if (parser->errors->count == 0) {
		cout << "parsing ddl2cpp: OK" << endl;
	} else {
		cout << "parsing ddl2cpp: KO" << endl;
		return -1;
	}
	return 0;
}
