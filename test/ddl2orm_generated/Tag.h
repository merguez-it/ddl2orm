/*
*  Tag.h
*  
*  C++ mapping generated by ddl2orm (written by Mathias Franck).
*  Copyleft 2012 Merguez-it.
*
*/

#ifndef Tag_H
#define Tag_H

#include "lorm.h"


class Tag : public table<Tag> { 
public: 
  TABLE_INIT(Tag,tag)
	column<int> id;
	column<std::string> label;
};

#endif