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

// Utility that produces a string aggregating all classes which mt depends on, 
// surrounded by a given prefix and suffix. (used for includes and forward class decls.)
wstring formatRoleClasses(const wstring &prefix, const MappedTable& mt, const wstring &suffix ) {
	set<wstring> dependencies;
  wstring result;
  dependencies= mt.getClassDependencies();
	for (set<wstring>::iterator it = dependencies.begin(); it != dependencies.end(); it++) {
			wstring forward_declaration = prefix + *it + suffix;
      result += forward_declaration;
	} 
	return result;
}

wstring OrmGenerator::forwardDeclarations(const MappedTable& mt) const {
	return formatRoleClasses(L"class ",mt,L";\n");
}

wstring OrmGenerator::implementationIncludes(const MappedTable& mt) const {
	return formatRoleClasses(L"#include \"",mt,L".h\"\n");
}

wstring OrmGenerator::classHeader(const MappedTable& mt) const {
	wstring classHeader;
	if (!mt.members.empty()) {
		classHeader += interfacePrologue;			// .h header
		classHeader += forwardDeclarations(mt);
		classHeader += interfaceClassPrologue;	// Public fields
		//if (!mt.primaryKey.empty()) {
			classHeader+=L"\tcolumn<int> id;\n";
		//}
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

wstring OrmGenerator::oneToManyImpl(const MappedTable& mt,const MemberDesc& field) const {
	//	has_many(Person,Book,personal_library,owner);
	wstring result;
	MappedTable toManyClass=model.tables.find(field.type)->second;
  MemberDesc reverseRole=mt.members.find(field.roleName)->second;
  result=has_manyTemplate;
  replaceAll(L"$sourceClassName", mt.className, result);
  replaceAll(L"$roleName", field.roleName, result);
  replaceAll(L"$targetClassName", toManyClass.className, result);
  replaceAll(L"$reverseRoleName",field.reverseRoleName,result);		
	return result;
}

wstring OrmGenerator::manyToManyImpl(const MappedTable& mt,const MemberDesc& member) const {
	//has_and_belongs_to_many($className,$targetClassName,$roleName,\"$linkTable\",\"$sourceFK\",\"$targetFK\");\n";
  //has_and_belongs_to_many(Person,Book,borrowed_books,"borrows","borrower_id","borrowed_book_id");
  assert(member.kind==MANY_TO_MANY);
  assert(model.tables.count(member.linkClass)==1);
	wstring result=hmbtTemplate;
	replaceAll(L"$sourceClassName", mt.className, result);
	replaceAll(L"$targetClassName" , member.type , result);
	replaceAll(L"$roleName" , member.roleName , result);
	replaceAll(L"$linkTable" ,member.linkClass,result);
	replaceAll(L"$sourceFK" , member.reverseRoleName , result);
	replaceAll(L"$targetFK" , member.fkName , result);
	return result;
}

wstring OrmGenerator::classImplementation(const MappedTable& mt) const {
	wstring classBody=implementationPrologue;
	classBody+=implementationIncludes(mt) + + L"\n" ;
	wstring registration=registerTemplate;
  
	set<wstring> registered_fields,computed_collections;
  wstring registered_fields_str;
	for (FieldIt it = mt.members.begin(); it != mt.members.end(); it++) {
		MemberKind memberKind=it->second.kind;
		switch (memberKind) {
			case DATA:
			case NULLABLE_DATA:
				if (mt.primaryKey!=it->first) {
					registered_fields.insert(fieldImpl(mt,it->second)); 
				} else {
          registered_fields_str+=identityTemplate;
        }
				break;
			case TO_ONE:
				registered_fields.insert(toOneImpl(mt,it->second));
				break;
			case ONE_TO_MANY:
				computed_collections.insert(oneToManyImpl(mt,it->second));
				break;
			case MANY_TO_MANY:
				computed_collections.insert(manyToManyImpl(mt,it->second));
				break;
			default: assert(false);
		}
	}
	for (set<wstring>::iterator it=registered_fields.begin();it!=registered_fields.end();it++) {registered_fields_str+=*it;}
	replaceAll(L"$fieldsImpl",registered_fields_str, registration);
	classBody+=registration;
	replaceAll(L"$className", mt.className, classBody);
	replaceAll(L"$tableName", mt.tableName, classBody);
	replaceAll(L"$id", mt.primaryKey, classBody);
	wstring computed_collections_str;
	for (set<wstring>::iterator it=computed_collections.begin();it!=computed_collections.end();it++) {computed_collections_str+=*it;}
	classBody += computed_collections_str;
	return classBody;
};

int OrmGenerator::generateFiles() {
	int result=0;
	for (MappedTables::const_iterator it=model.tables.begin(); it!=model.tables.end(); it++) {
		MappedTable mt=it->second;
		string className=string(mt.className.begin(),mt.className.end());
		assert(!className.empty());
		if (!mt.isPureBinaryAssociation()) { // binary-associations are mapped using "many-to-many" roles in respective end-classes.
      string path_interface=model.outputDir+PATH_SEPARATOR+className+".h";
      string path_implementation=model.outputDir+PATH_SEPARATOR+className+".cc";
      wofstream out_interface(path_interface.c_str()); //TODO: DRY !
      wofstream out_implementation(path_implementation.c_str());
      if (out_interface.is_open() && out_implementation.is_open())	{
        out_interface <<	classHeader(mt); //CANADA: DRY !
        out_implementation << classImplementation(mt);
        cout << className << ".h and .cc generated ( "<< mt.members.size() << " members mapped )" << endl;
      }
      if (out_interface.fail() || out_implementation.fail() ) {
        cout << "I/O error while generating " << className << endl;
        result=-1;
      }
		}
	} 	
	return result;
}
