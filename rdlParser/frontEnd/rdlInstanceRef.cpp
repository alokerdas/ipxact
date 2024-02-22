#include <iostream>
#include "rdlInstanceRef.h"
#include "rdlNumber.h"

RDLInstanceRef::RDLInstanceRef()
               : RDLBase(0, RDLBase::RDL_BASE_INSTANCE_REFERENCE)
{
}
void RDLInstanceRef::addInstanceReference(RDLBase* inst, RDLNumber* idx)
{
  instanceIndexArr[inst] = idx;
}
void RDLInstanceRef::decompile()
{
  for (map<RDLBase*, RDLNumber*>::iterator itr = instanceIndexArr.begin();
       itr != instanceIndexArr.end(); itr++)
  {
    cout << (*itr).first->getName();
    if ((*itr).second)
    {
      cout << "[";
      (*itr).second->decompile();
      cout << "]";
    }
  }
  if (getNoItems() > 0)
  {
    cout << "->";
    getItem(0)->decompile();
  }
  if (getNoItems() > 1)
  {
    cout << " = ";
    getItem(1)->decompile();
  }
}
