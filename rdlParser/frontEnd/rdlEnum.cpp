#include <iostream>
#include "rdlEnum.h"

RDLEnum::RDLEnum(const char* nm)
        : RDLBase(nm, RDLBase::RDL_BASE_ENUM)
{
}
RDLNumber* RDLEnum::getEntryValue(const char* id)
{
  return enumEntries[id];
}
void RDLEnum::setEntryValue(const char* id, RDLNumber* num)
{
  enumEntries[id] = num;
}
void RDLEnum::decompile()
{
  cout << "enum ";
  if (getName())
    cout << getName();
  cout << " {" << endl;

  for (map<string, RDLNumber*>::iterator itr = enumEntries.begin();
       itr != enumEntries.end(); itr++)
  {
    cout << (*itr).first << " = ";
    (*itr).second->decompile();
    cout << ";" << endl;
  }
  cout << "};" << endl;
}
