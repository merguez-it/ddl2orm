/*
 *  MappingUtils.h
 *  ddl2cpp
 *
 *  Created by Mathias Franck on 14/03/12.
 *  Copyright 2012 Vidal. All rights reserved.
 *
 */
#ifndef MAPPING_UTILS_H
#define MAPPING_UTILS_H

#include <stdlib.h>
#include <string>
#include <map>

using namespace std;

inline void replaceAll(const wstring& pattern, const wstring& word, wstring& target) {
	size_t pos=0;
	do {
		pos=target.find(pattern);
		if (pos!=wstring::npos) {
			target.replace(pos,pattern.size(),word);
		}
	} while (pos!=wstring::npos);
}

inline wstring camelize(const wstring& target) {
	wstring result=target;
	result.replace(0,1,1,towupper(target[0]));
	return result;
}

inline wstring trimQuotes(const wstring& target) { //vire la quote de debut et de fin si besoin
	wstring result;
	int deb=0;
	int keep=target.size();
	if (target.size()>2) {
		if (target[target.size()-1]==L'"') keep--;
		if (target[0]==L'"') { deb++; keep--;}
	}
	return result.assign(target,deb,keep);
}

#endif
