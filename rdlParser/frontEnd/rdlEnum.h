#ifndef RDL_ENUM_H
#define RDL_ENUM_H

#include <string>
#include <map>
#include "rdlBase.h"
#include "rdlNumber.h"

using namespace std;

class RDLEnum : public RDLBase
{
  private:
  map<string, RDLNumber*> enumEntries;

  public:

  RDLEnum(const char* nm = 0);
  RDLNumber* getEntryValue(const char* id);
  void setEntryValue(const char* id, RDLNumber* num);
  void decompile();
};

#endif
