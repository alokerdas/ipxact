#ifndef RDL_PROPERTY_DEFINITION_H
#define RDL_PROPERTY_DEFINITION_H

#include "rdlBase.h"

class RDLPropertyDefinition : public RDLBase
{
  public:
  typedef enum {
    RDL_PROPERTY_DEFAULT_NONE,
    RDL_PROPERTY_DEFAULT_TRUE,
    RDL_PROPERTY_DEFAULT_FALSE,
    RDL_PROPERTY_DEFAULT_NUMBER,
    RDL_PROPERTY_DEFAULT_STRING
  } rdl_property_default_type;

  typedef enum {
    RDL_PROPERTY_COMPONENT_NONE = 0,
    RDL_PROPERTY_COMPONENT_REG = 1,
    RDL_PROPERTY_COMPONENT_FIELD = 2,
    RDL_PROPERTY_COMPONENT_SIGNAL = 4,
    RDL_PROPERTY_COMPONENT_ADDRMAP = 8,
    RDL_PROPERTY_COMPONENT_REGFILE = 16,
    RDL_PROPERTY_COMPONENT_ALL = 32
  } rdl_property_component_type;

  typedef enum {
    RDL_PROPERTY_TYPE_NONE,
    RDL_PROPERTY_TYPE_REF,
    RDL_PROPERTY_TYPE_REG,
    RDL_PROPERTY_TYPE_FIELD,
    RDL_PROPERTY_TYPE_ADDRMAP,
    RDL_PROPERTY_TYPE_REGFILE,
    RDL_PROPERTY_TYPE_STRING,
    RDL_PROPERTY_TYPE_NUMBER,
    RDL_PROPERTY_TYPE_BOOLEAN
  } rdl_property_type_type;

  private:
  rdl_property_default_type propDfltType;
  rdl_property_component_type propCompType;
  rdl_property_type_type propTypeType;

  public:
  RDLPropertyDefinition(const char* id);
  rdl_property_type_type getPropertyTypeType();
  void setPropertyTypeType(rdl_property_type_type type);
  rdl_property_default_type getPropertyDefaultType();
  void setPropertyDefaultType(rdl_property_default_type type);
  bool isPropertyComponentType(rdl_property_component_type mask);
  void setPropertyComponentType(rdl_property_component_type type);
  void decompile();


};

#endif
