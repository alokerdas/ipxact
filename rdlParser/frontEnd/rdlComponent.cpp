#include <iostream>
#include "rdlComponent.h"
#include "rdlInstance.h"

RDLComponent::RDLComponent(RDLComponent::rdl_component_type compType, const char* nm)
             : RDLBase(nm, RDLBase::RDL_BASE_COMPONENT)
{
  componentType = compType;
}
void RDLComponent::setComponentType(rdl_component_type compType)
{
  componentType = compType;
}
RDLComponent::rdl_component_type RDLComponent::getComponentType()
{
  return componentType;
}
string RDLComponent::getComponentString()
{
  string compTp;
  switch (getComponentType())
  {
    case RDL_COMPONENT_REG:
      compTp = "reg";
      break;
    case RDL_COMPONENT_FIELD:
      compTp = "field";
      break;
    case RDL_COMPONENT_SIGNAL:
      compTp = "signal";
      break;
    case RDL_COMPONENT_ADDRMAP:
      compTp = "addrmap";
      break;
    case RDL_COMPONENT_REGFILE:
      compTp = "regfile";
      break;
    default:
      break;
  }
  return compTp;
}
void RDLComponent::decompile()
{
  int unNamedComp = 0;
  cout << getComponentString() << " " << getName();
  cout << " {" << endl;
  RDLBase::decompile();
  cout << "};" << endl;
}
