/*
*  Tag.cpp
*  
*  C++ mapping generated by ddl2orm (written by Mathias Franck).
*  Copyleft 2012 Merguez-it.
*
*/


#include "Tag.h"

REGISTER_TABLE(Tag) {
	identity("tag_id",&Tag::id);
	field("label", &Tag::label);
};

