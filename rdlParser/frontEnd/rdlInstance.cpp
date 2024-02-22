#include <iostream>
#include "rdlInstance.h"

RDLInstance::RDLInstance(RDLInstance::rdl_instance_type instType, const char* nm)
            :RDLBase(nm, RDLBase::RDL_BASE_INSTANCE)
{
  instanceType = instType;
}
void RDLInstance::setInstanceType(rdl_instance_type type)
{
  instanceType = type;
}
RDLInstance::rdl_instance_type RDLInstance::getInstanceType()
{
  return instanceType;
}

void RDLInstance::setComponent(RDLBase* comp)
{
  component = comp;
}
RDLBase* RDLInstance::getComponent()
{
  return component;
}
void RDLInstance::setIndexLeft(RDLNumber* lNum)
{
  indexLeft = lNum;
}
void RDLInstance::setIndexRight(RDLNumber* rNum)
{
  indexRight = rNum;
}
RDLNumber* RDLInstance::getIndexLeft()
{
  return indexLeft;
}
RDLNumber* RDLInstance::getIndexRight()
{
  return indexRight;
}
string RDLInstance::getInstanceString()
{
  string instTp;
  switch (getInstanceType())
  {
    case RDL_INSTANCE_INTERNAL:
      instTp = "internal";
      break;
    case RDL_INSTANCE_EXTERNAL:
      instTp = "external";
      break;
    default:
      instTp = "";
      break;
  }
  return instTp;
}
void RDLInstance::decompile()
{
  cout << getInstanceString() << " ";
  if (getComponent()->getName())
    cout << getComponent()->getName() << " ";

  cout << getName();
  if (getIndexLeft())
  {
    cout << "[";
    getIndexLeft()->decompile();
    if (getIndexRight())
    {
      cout << ":";
      getIndexRight()->decompile();
    }
    cout << "]";
  }
  cout << ";" << endl;
}
