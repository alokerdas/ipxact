#ifndef RDL_COMPONENT_H
#define RDL_COMPONENT_H

#include <vector>
#include "rdlBase.h"

using namespace std;
class RDLEnum;
class RDLInstance;
class RDLProperty;

class RDLComponent : public RDLBase
{
  public:
  typedef enum
  {
    RDL_COMPONENT_NONE,
    RDL_COMPONENT_REG,
    RDL_COMPONENT_FIELD,
    RDL_COMPONENT_SIGNAL,
    RDL_COMPONENT_ADDRMAP,
    RDL_COMPONENT_REGFILE
  } rdl_component_type;

  private:
  rdl_component_type componentType;

  public:

  RDLComponent(rdl_component_type compType = RDL_COMPONENT_NONE, const char* nam = 0);
  void setComponentType(rdl_component_type type);
  rdl_component_type getComponentType();
  string getComponentString();
  void decompile();
};

#endif
