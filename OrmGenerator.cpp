/*
 *  OrmGenerator.cpp
 *  ddl2cpp
 *
 *  Created by Mathias Franck on 05/12/12.
 *  Copyleft 2012 Merguez-IT. All rights reserved.
 *
 */
#include <assert.h>
#include <iostream>
#include <fstream>
#include <wchar.h>

#include "MappingUtils.h"
#include "OrmGenerator.h"
#include "cppClassTemplate.inc.h"

using namespace std;

#define PATH_SEPARATOR "/"

wstring OrmGenerator::memberDeclaration(const MappedTable& mt, const wstring& field ) const { 
	assert(mt.members.count(field)!=0);
	wstring type=mt.members.find(field)->second.type;
	wstring result=L"column<"+type+L"> " + field;
	if (mt.isToOneRole(field)) result=L"reference<"+type+L"> " + field;
	else if (mt.isToManyRole(field)) result=L"COLLECTION("+type+L","+field+L")";
	else if (mt.isNullable(field)) { /* TO DO dans lorm: result=L"nullable_column<"+type+L">" */}
	return result;
}

wstring OrmGenerator::forwardDeclarations(const MappedTable& mt) const {
	wstring result;
	vector<wstring> already_declared;
	already_declared.push_back(L"class " + mt.className + L";\n"); // Do not forward-declare *this* mapped class
	for (FieldIt it = mt.members.begin(); it != mt.members.end(); it++) {
		if (mt.isRole(it->first)) {					
			wstring forward_declaration = L"class " + it->second.type + L";\n";
			if (find(already_declared.begin(), already_declared.end(), forward_declaration) == already_declared.end()) {
				already_declared.push_back(forward_declaration);
				result += forward_declaration;
			}
		}
	} 
	return result;
}

wstring OrmGenerator::generateClassHeader(const MappedTable& mt) {
	wstring classHeader;
	if (!mt.members.empty()) {
		classHeader += interfacePrologue;			// .h header
		classHeader += forwardDeclarations(mt);
		classHeader += interfaceClassPrologue;	// Public fields
		if (!mt.primaryKey.empty()) {
			classHeader+=L"\tcolumn<int> id;\n";
		}
		for (FieldIt it=mt.members.begin();it!=mt.members.end();it++) { // Members mapped with their cpp type
			if (mt.primaryKey!=it->first) {
				classHeader += L"\t" + memberDeclaration(mt,it->first) + L";\n"; 
			}
		}	
		classHeader += interfaceEpilogue;		// Hop, les accolades et les #endif !
		replaceAll(L"$className", mt.className, classHeader);
		replaceAll(L"$tableName", mt.tableName, classHeader);
	} else {
		wcout << L"[WARNING] " << mt.className << L" skipped : no members could be mapped" << endl;
	}
	return classHeader;
};

int OrmGenerator::generateCppFiles() {
	int result=0;
	for (MappedTables::const_iterator it=model.tables.begin(); it!=model.tables.end(); it++) {
		MappedTable mt=it->second;
		string className=string(mt.className.begin(),mt.className.end());
		assert(!className.empty());
		if (!mt.isAssociation()) {
			string path=model.outputDir+PATH_SEPARATOR+className+".h";
			wofstream out(path.c_str());
			if (out.is_open())	{		
				out <<	generateClassHeader(mt);
				cout << className << ".h and .cpp generated ( "<< mt.members.size() << " members mapped )" << endl;
			}
			if (out.fail()) {
				cout << "I/O error while generating " << path << endl;
				result=-1;
			}
		}
	} 	
	return result;
}
