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
	int generateFiles();
protected:
	wstring forwardDeclarations(const MappedTable& mt) const;
	wstring memberDeclaration(const MappedTable& mt, const wstring&field) const ;  //member declaration depending on mapped kind : Simple value, Nullable, to-many, to-one.
	wstring classHeader(const MappedTable& mt) const;
	wstring classImplementation(const MappedTable& mt) const;
	wstring fieldImpl(const MappedTable& mt,const MemberDesc& field) const;
	wstring toOneImpl(const MappedTable& mt,const MemberDesc& field) const;

	const ObjectModel& model;
};

#endif