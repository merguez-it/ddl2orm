#ifndef __ORM_GENERATOR__
#define __ORM_GENERATOR__
/*
 *  OrmGenerator.h
 *  ddl2cpp
 *
 *  Created by Mathias Franck on 05/12/12.
 *  Copyleft 2012 Merguez-IT. All rights reserved.
 *
 */
#include <wchar.h>

#include "ObjectModel.h"
#include "MappedTable.h"

class OrmGenerator  {
public:
	OrmGenerator(const ObjectModel& aModel) : model(aModel) {};
	int generateCppFiles();
protected:
	wstring forwardDeclarations(const MappedTable& mt) const;
	wstring memberDeclaration(const MappedTable& mt, const wstring&field) const ;  //member declaration depending on mapped kind : Simple value, Nullable, to-many, to-one.
	wstring generateClassHeader(const MappedTable& mt);

	const ObjectModel& model;
};

#endif