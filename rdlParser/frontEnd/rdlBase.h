#ifndef RDL_BASE_H
#define RDL_BASE_H

#include <vector>
#include <map>
#include <string.h>

using namespace std;
class RDLNumber;

struct ltstr
{
  bool operator()(const char* s1, const char* s2) const
  {
    return strcmp(s1, s2) < 0;
  }
};


class RDLBase
{
  public:
  typedef enum {
    RDL_BASE_NONE,
    RDL_BASE_COMPONENT,
    RDL_BASE_INSTANCE,
    RDL_BASE_PROPERTY,
    RDL_BASE_ENUM,
    RDL_BASE_INSTANCE_REFERENCE,
    RDL_BASE_PROPERTY_DEFINITION
  } rdl_base_type;

  private:
  const char* name;
  rdl_base_type baseType;
  RDLBase* scope;
  map<const char*, RDLBase*, ltstr> definedNames;
  vector<RDLBase*> itemsArr;

  public:

  RDLBase(const char* nm = 0, rdl_base_type tp = RDL_BASE_NONE);
  void setName(const char* nm);
  const char* getName();
  void setType(rdl_base_type type);
  rdl_base_type getType();
  void setScope(RDLBase* scp);
  RDLBase* getScope();
  void addItem(RDLBase* itm);
  RDLBase* isAlreadyDefined(const char* itmNm);
  void addToDefinedNames(const char* nm, RDLBase* itm);
  RDLBase* getItem(int it);
  int getNoItems();
  virtual void decompile();
};

#endif
