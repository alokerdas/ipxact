#ifndef RDL_INSTANCE_H
#define RDL_INSTANCE_H

#include "rdlBase.h"
#include "rdlNumber.h"

using namespace std;
class RDLComponent;

class RDLInstance : public RDLBase
{
  public:
  typedef enum
  {
    RDL_INSTANCE_NONE,
    RDL_INSTANCE_INTERNAL,
    RDL_INSTANCE_EXTERNAL
  } rdl_instance_type;

  private:
  rdl_instance_type instanceType;
  char* aliasName;
  RDLBase* component;
  RDLNumber* indexLeft;
  RDLNumber* indexRight;

  public:

  RDLInstance(rdl_instance_type compType = RDL_INSTANCE_NONE, const char* nm = 0);
  void setInstanceType(rdl_instance_type type);
  rdl_instance_type getInstanceType();
  void setComponent(RDLBase* comp);
  RDLBase* getComponent();

  void setIndexLeft(RDLNumber* lNum);
  void setIndexRight(RDLNumber* rNum);
  RDLNumber* getIndexLeft();
  RDLNumber* getIndexRight();
  string getInstanceString();
  void decompile();
};

#endif
