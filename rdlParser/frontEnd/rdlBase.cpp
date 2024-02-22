#include <iostream>
#include "rdlBase.h"

RDLBase::RDLBase(const char* nm, rdl_base_type tp)
{
  setName(nm);
  setType(tp);
}
void RDLBase::setName(const char* nm)
{
  name = nm ? strdup(nm) : 0;
}
const char* RDLBase::getName()
{
  return name;
}
void  RDLBase::setType(rdl_base_type type)
{
  baseType = type;
}
RDLBase::rdl_base_type RDLBase::getType()
{
  return baseType;
}

void RDLBase::setScope(RDLBase* scp)
{
  scope = scp;
}
RDLBase* RDLBase::getScope()
{
  return scope;
}
void RDLBase::addItem(RDLBase* itm)
{
  if (itm)
  {
    RDLBase* definedObj = 0;
    if (itm->getName())
    {
      definedObj = isAlreadyDefined(itm->getName());
      if (definedObj)
      {
        cout << "WARNING: " << itm->getName() << " was already defined inside " << definedObj->getName() << endl;
      }
      else
      {
        itemsArr.push_back(itm);
        if (itm->getType() != RDLBase::RDL_BASE_PROPERTY)
          definedNames[strdup(itm->getName())] = itm;
      }
    }
    else
      itemsArr.push_back(itm);
  }
}
RDLBase* RDLBase::isAlreadyDefined(const char* itmNm)
{
  RDLBase* retVal = 0;
  if (definedNames.find(itmNm) == definedNames.end())
  {
    if (getScope())
      retVal =getScope()->isAlreadyDefined(itmNm);
  }
  else
  {
      retVal = definedNames[itmNm];
  }

  return retVal;
}
void RDLBase::addToDefinedNames(const char* nm, RDLBase* itm)
{
  definedNames[strdup(nm)] = itm;
}
RDLBase* RDLBase::getItem(int it)
{
  return itemsArr[it];
}
int RDLBase::getNoItems()
{
  return itemsArr.size();
}
void RDLBase::decompile()
{
  for (int i = 0; i < itemsArr.size(); i++)
    getItem(i)->decompile();
}
