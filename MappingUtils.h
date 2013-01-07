/*
 *  MappingUtils.h
 *  ddl2cpp
 *
 *  Created by Mathias Franck on 14/03/12.
 *  Copyleft 2012 Merguez-IT. All rights reserved.
 *
 */
#ifndef MAPPING_UTILS_H
#define MAPPING_UTILS_H

#include <stdlib.h>
#include <string>
#include <vector>
#include <map>

using namespace std;

#define for_each(collection) 

inline void replaceAll(const wstring& pattern, const wstring& word, wstring& target) {
	size_t pos=0;
	do {
		pos=target.find(pattern,pos);
		if (pos!=wstring::npos) {
			target.replace(pos,pattern.size(),word);
			pos=pos+word.size();
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

inline wstring toUpper(wstring s) {
	wstring r = s;
	transform(r.begin(), r.end(), r.begin(), ::toupper);
	return r;
}

// returns keyName without any useless crappy suffix (if present): id or _id, case insensitive.
inline wstring stripSuffix(wstring keyName) { 
	int length = keyName.length();
	wstring result=keyName;
	if (toUpper(keyName).find(toUpper(L"_ID")) == length-3) {
		result= keyName.substr(0,length-3);
	} else if (toUpper(keyName).find(toUpper(L"ID")) == length-2) {
		result= keyName.substr(0,length-2);
	}
	return result;
}

struct case_insensistive_compare : std::binary_function<wstring, wstring, bool> {
  bool operator()(const wstring &lhs, const wstring &rhs) const {
    wstring l=lhs;
    wstring r=rhs;
    std::transform(l.begin(), l.end(), l.begin(), ::toupper);
    std::transform(r.begin(), r.end(), r.begin(), ::toupper);
    return (l < r);
  }
};

#endif
