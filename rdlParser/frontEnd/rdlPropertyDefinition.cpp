#include <iostream>
#include "rdlPropertyDefinition.h"

RDLPropertyDefinition::RDLPropertyDefinition(const char* id)
                      : RDLBase(id, RDLBase::RDL_BASE_PROPERTY_DEFINITION)
{
  propTypeType = RDLPropertyDefinition::RDL_PROPERTY_TYPE_NONE;
  propDfltType = RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_NONE;
  propCompType = RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_NONE;
}
void RDLPropertyDefinition::setPropertyTypeType(RDLPropertyDefinition::rdl_property_type_type type)
{
  propTypeType = type;
}
RDLPropertyDefinition::rdl_property_type_type RDLPropertyDefinition::getPropertyTypeType()
{
  return propTypeType;
}
void RDLPropertyDefinition::setPropertyDefaultType(RDLPropertyDefinition::rdl_property_default_type type)
{
  propDfltType = type;
}
RDLPropertyDefinition::rdl_property_default_type RDLPropertyDefinition::getPropertyDefaultType()
{
  return propDfltType;
}
void RDLPropertyDefinition::setPropertyComponentType(RDLPropertyDefinition::rdl_property_component_type type)
{
  propCompType = type;
}
bool RDLPropertyDefinition::isPropertyComponentType(RDLPropertyDefinition::rdl_property_component_type mask)
{
  return (propCompType & mask);
}
void RDLPropertyDefinition::decompile()
{ 
  cout << "property ";
  if (getName())
    cout << getName();
  cout << "{" << endl; 
}
