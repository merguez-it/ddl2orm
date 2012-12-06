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
#include <sstream>
#include <fstream>
#include <iterator>
#include <wchar.h>
#include <set>
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
	else if (mt.isNullable(field)) { /* result=L"nullable_column<"+type+L"> "+ field; */}
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

wstring OrmGenerator::classHeader(const MappedTable& mt) const {
	wstring classHeader;
	if (!mt.members.empty()) {
		classHeader += interfacePrologue;			// .h header
		classHeader += forwardDeclarations(mt);
		classHeader += interfaceClassPrologue;	// Public fields
		if (!mt.primaryKey.empty()) {
			classHeader+=L"\tcolumn<int> id;\n";
		}
		set < MemberDesc, less_decl> ordered_decls;
		for (FieldIt it=mt.members.begin();it!=mt.members.end();it++) { // Members mapped with their cpp type
			if (mt.primaryKey!=it->first) {
				ordered_decls.insert(it->second); 
			}
		}
		for (set < MemberDesc >::const_iterator it=ordered_decls.begin();it!=ordered_decls.end();it++) {
			classHeader += L"\t" + memberDeclaration(mt,it->roleName) + L";\n";
		}
		classHeader += interfaceEpilogue;		// Hop, les accolades et les #endif !
		replaceAll(L"$className", mt.className, classHeader);
		replaceAll(L"$tableName", mt.tableName, classHeader);
	} else {
		wcout << L"[WARNING] " << mt.className << L" skipped : no members could be mapped" << endl;
	}
	return classHeader;
};


wstring OrmGenerator::fieldImpl(const MappedTable& mt,const MemberDesc& field) const {
	wstring result=fieldTemplate; //TODO:  refactor the functional way
	replaceAll(L"$className", mt.className, result);
	replaceAll(L"$roleName", field.roleName, result);
	replaceAll(L"$fieldName", field.roleName, result); //TODO: Case when name of member differs from name of field.
	return result;
}

wstring OrmGenerator::toOneImpl(const MappedTable& mt,const MemberDesc& field) const {
	wstring result=has_oneTemplate; //TODO:  refactor the functional way
	replaceAll(L"$className", mt.className, result);
	replaceAll(L"$roleName", field.roleName, result);
	replaceAll(L"$fkName", field.fkName, result);
	return result;
}

wstring OrmGenerator::classImplementation(const MappedTable& mt) const {
	wstring classBody=implementationPrologue;
	wstring registration=registerTemplate;
	set<wstring> registered_fields,computed_collections;
	for (FieldIt it = mt.members.begin(); it != mt.members.end(); it++) {
		MemberKind memberKind=it->second.kind;
		switch (memberKind) {
			case DATA:
			case NULLABLE_DATA:
				registered_fields.insert(fieldImpl(mt,it->second));
				break;
			case TO_ONE:
				registered_fields.insert(toOneImpl(mt,it->second));
				break;
			case ONE_TO_MANY:
				break;
			case MANY_TO_MANY:
				break;
			default:
				assert(false);
				break;
		}
	}
//	wstringstream sstream;
//	ostream_iterator<wstring> out_it(sstream);
//	copy(registered_fields.begin();it!=registered_fields.end(), out_it);
	wstring registered_fields_str;
	for (set<wstring>::iterator it=registered_fields.begin();it!=registered_fields.end();it++) {registered_fields_str+=*it;}
	replaceAll(L"$fieldsImpl",registered_fields_str, registration);
	classBody+=registration;
	replaceAll(L"$className", mt.className, classBody);
	replaceAll(L"$tableName", mt.tableName, classBody);
	replaceAll(L"$id", mt.primaryKey, classBody);
	//classBody += computed_collections;
	return classBody;
};



int OrmGenerator::generateFiles() {
	int result=0;
	for (MappedTables::const_iterator it=model.tables.begin(); it!=model.tables.end(); it++) {
		MappedTable mt=it->second;
		string className=string(mt.className.begin(),mt.className.end());
		assert(!className.empty());
		if (!mt.isPureBinaryAssociation()) { // Mapped using "many-to-many" roles in respective end-classes.
			if (!mt.isAssociationClass()) {
				string path_interface=model.outputDir+PATH_SEPARATOR+className+".h"; //TODO: DRY !
				string path_implementation=model.outputDir+PATH_SEPARATOR+className+".cpp";

				wofstream out_interface(path_interface.c_str()); //TODO: DRY !
				wofstream out_implementation(path_implementation.c_str());

				if (out_interface.is_open() && out_implementation.is_open())	{	
					out_interface <<	classHeader(mt); //CANADA: DRY !
					out_implementation << classImplementation(mt);
					cout << className << ".h and .cpp generated ( "<< mt.members.size() << " members mapped )" << endl;
				}
				if (out_interface.fail() || out_implementation.fail() ) {
					cout << "I/O error while generating " << className << endl;
					result=-1;
				}
			} else {
				cout << "[WARNING] : " << className << " not mapped as it has no simple PK" << endl;
			}
		}
	} 	
	return result;
}
