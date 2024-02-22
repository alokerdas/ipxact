#include <iostream>
#include "rdlProperty.h"

RDLProperty::RDLProperty(rdl_property_type propType, const char* nm)
            : RDLBase(nm, RDLBase::RDL_BASE_PROPERTY)
{
  propertyType = propType;
  userProperty = 0;
}
void RDLProperty::setPropertyType(RDLProperty::rdl_property_type type)
{
  propertyType = type;
}
RDLProperty::rdl_property_type RDLProperty::getPropertyType()
{
  return propertyType;
}
void RDLProperty::setPropertyModifierType(RDLProperty::rdl_property_modifier_type modType)
{
  propertyModifierType = modType;
}
RDLProperty::rdl_property_modifier_type RDLProperty::getPropertyModifierType()
{
  return propertyModifierType;
}
void RDLProperty::setPropertyDefinition(RDLPropertyDefinition* propDefn)
{
  userProperty = propDefn;
}
RDLPropertyDefinition* RDLProperty::getPropertyDefinition()
{
  return userProperty;
}
RDLNumber* RDLProperty::getValue()
{
  return numberValue;
}
void RDLProperty::setValue(RDLNumber* num)
{
  numberValue = num;
}
void RDLProperty::setPropertyValue(const char* nm)
{
  setName(nm);
}
const char* RDLProperty::getPropertyValue()
{
  return getName();
}
void RDLProperty::setAsDefault()
{
  isDefaultValue = 1;
}
unsigned char RDLProperty::isDefault()
{
  return isDefaultValue;
}
string RDLProperty::getPropertyModifierString()
{
  string propMod;
  switch (getPropertyModifierType())
  {
    case RDL_PROPERTY_MODIFIER_LEVEL:
      propMod = "level";
      break;
    case RDL_PROPERTY_MODIFIER_POSEDGE:
      propMod = "posedge";
      break;
    case RDL_PROPERTY_MODIFIER_NEGEDGE:
      propMod = "negedge";
      break;
    case RDL_PROPERTY_MODIFIER_BOTHEDGE:
      propMod = "bothedge";
      break;
    case RDL_PROPERTY_MODIFIER_NONSTICKY:
      propMod = "nonsticky";
      break;
    default:
      break;
  }
  return propMod;
}
string RDLProperty::getPropertyString()
{
  string propTp;
  switch (getPropertyType())
  {
    case RDLProperty::RDL_PROPERTY_NAME:
      propTp = "name";
      break;
    case RDLProperty::RDL_PROPERTY_DESC:
      propTp = "desc";
      break;
    case RDLProperty::RDL_PROPERTY_ARBITER:
      propTp = "arbiter";
      break;
    case RDLProperty::RDL_PROPERTY_RSET:
      propTp = "rset";
      break;
    case RDLProperty::RDL_PROPERTY_RCLR:
      propTp = "rclr";
      break;
    case RDLProperty::RDL_PROPERTY_WOCLR:
      propTp = "woclr";
      break;
    case RDLProperty::RDL_PROPERTY_WOSET:
      propTp = "woset";
      break;
    case RDLProperty::RDL_PROPERTY_WE:
      propTp = "we";
      break;
    case RDLProperty::RDL_PROPERTY_WEL:
      propTp = "wel";
      break;
    case RDLProperty::RDL_PROPERTY_SWWE:
      propTp = "swwe";
      break;
    case RDLProperty::RDL_PROPERTY_SWWEL:
      propTp = "swwel";
      break;
    case RDLProperty::RDL_PROPERTY_HWSET:
      propTp = "hwset";
      break;
    case RDLProperty::RDL_PROPERTY_HWCLR:
      propTp = "hwclr";
      break;
    case RDLProperty::RDL_PROPERTY_SWMOD:
      propTp = "swmod";
      break;
    case RDLProperty::RDL_PROPERTY_SWACC:
      propTp = "swacc";
      break;
    case RDLProperty::RDL_PROPERTY_STICKY:
      propTp = "sticky";
      break;
    case RDLProperty::RDL_PROPERTY_STICKYBIT:
      propTp = "stickybit";
      break;
    case RDLProperty::RDL_PROPERTY_INTR:
      propTp = "intr";
      break;
    case RDLProperty::RDL_PROPERTY_ANDED:
      propTp = "anded";
      break;
    case RDLProperty::RDL_PROPERTY_ORED:
      propTp = "ored";
      break;
    case RDLProperty::RDL_PROPERTY_XORED:
      propTp = "xored";
      break;
    case RDLProperty::RDL_PROPERTY_COUNTER:
      propTp = "counter";
      break;
    case RDLProperty::RDL_PROPERTY_OVERFLOW:
      propTp = "overflow";
      break;
    case RDLProperty::RDL_PROPERTY_SHAREDEXTBUS:
      propTp = "sharedextbus";
      break;
    case RDLProperty::RDL_PROPERTY_ERREXTBUS:
      propTp = "errextbus";
      break;
    case RDLProperty::RDL_PROPERTY_RESET:
      propTp = "reset";
      break;
    case RDLProperty::RDL_PROPERTY_LITTLEENDIAN:
      propTp = "littleendian";
      break;
    case RDLProperty::RDL_PROPERTY_BIGENDIAN:
      propTp = "bigendian";
      break;
    case RDLProperty::RDL_PROPERTY_RSVDSET:
      propTp = "rsvdset";
      break;
    case RDLProperty::RDL_PROPERTY_RSVDSETX:
      propTp = "rsvdsetx";
      break;
    case RDLProperty::RDL_PROPERTY_BRIDGE:
      propTp = "bridge";
      break;
    case RDLProperty::RDL_PROPERTY_SHARED:
      propTp = "shared";
      break;
    case RDLProperty::RDL_PROPERTY_MSB0:
      propTp = "msb0";
      break;
    case RDLProperty::RDL_PROPERTY_LSB0:
      propTp = "lsb0";
      break;
    case RDLProperty::RDL_PROPERTY_SYNC:
      propTp = "sync";
      break;
    case RDLProperty::RDL_PROPERTY_ASYNC:
      propTp = "async";
      break;
    case RDLProperty::RDL_PROPERTY_CPUIF_RESET:
      propTp = "cpuif_reset";
      break;
    case RDLProperty::RDL_PROPERTY_FIELD_RESET:
      propTp = "field_reset";
      break;
    case RDLProperty::RDL_PROPERTY_ACTIVEHIGH:
      propTp = "activehigh";
      break;
    case RDLProperty::RDL_PROPERTY_ACTIVELOW:
      propTp = "activelow";
      break;
    case RDLProperty::RDL_PROPERTY_SINGLEPULSE:
      propTp = "singlepulse";
      break;
    case RDLProperty::RDL_PROPERTY_UNDERFLOW:
      propTp = "underflow";
      break;
    case RDLProperty::RDL_PROPERTY_INCR:
      propTp = "incr";
      break;
    case RDLProperty::RDL_PROPERTY_DECR:
      propTp = "decr";
      break;
    case RDLProperty::RDL_PROPERTY_INCRWIDTH:
      propTp = "incrwidth";
      break;
    case RDLProperty::RDL_PROPERTY_DECRWIDTH:
      propTp = "decrwidth";
      break;
    case RDLProperty::RDL_PROPERTY_INCRVALUE:
      propTp = "incrvalue";
      break;
    case RDLProperty::RDL_PROPERTY_DECRVALUE:
      propTp = "decrvalue";
      break;
    case RDLProperty::RDL_PROPERTY_SATURATE:
      propTp = "saturate";
      break;
    case RDLProperty::RDL_PROPERTY_DECRSATURATE:
      propTp = "decrsaturate";
      break;
    case RDLProperty::RDL_PROPERTY_THRESHOLD:
      propTp = "threshold";
      break;
    case RDLProperty::RDL_PROPERTY_DECRTHRESHOLD:
      propTp = "decrthreshold";
      break;
    case RDLProperty::RDL_PROPERTY_DONTCOMPARE:
      propTp = "dontcompare";
      break;
    case RDLProperty::RDL_PROPERTY_DONTTEST:
      propTp = "donttest";
      break;
    case RDLProperty::RDL_PROPERTY_INTERNAL:
      propTp = "internal";
      break;
    case RDLProperty::RDL_PROPERTY_ALIGNMENT:
      propTp = "alignment";
      break;
    case RDLProperty::RDL_PROPERTY_REGWIDTH:
      propTp = "regwidth";
      break;
    case RDLProperty::RDL_PROPERTY_FIELDWIDTH:
      propTp = "fieldwidth";
      break;
    case RDLProperty::RDL_PROPERTY_SIGNALWIDTH:
      propTp = "signalwidth";
      break;
    case RDLProperty::RDL_PROPERTY_ACCESSWIDTH:
      propTp = "accesswidth";
      break;
    case RDLProperty::RDL_PROPERTY_SW:
      propTp = "sw";
      break;
    case RDLProperty::RDL_PROPERTY_HW:
      propTp = "hw";
      break;
    case RDLProperty::RDL_PROPERTY_ADDRESSING:
      propTp = "addressing";
      break;
    case RDLProperty::RDL_PROPERTY_PRECEDENCE:
      propTp = "precedence";
      break;
    case RDLProperty::RDL_PROPERTY_ENCODE:
      propTp = "encode";
      break;
    case RDLProperty::RDL_PROPERTY_RESETSIGNAL:
      propTp = "resetsignal";
      break;
    case RDLProperty::RDL_PROPERTY_CLOCK:
      propTp = "clock";
      break;
    case RDLProperty::RDL_PROPERTY_MASK:
      propTp = "mask";
      break;
    case RDLProperty::RDL_PROPERTY_ENABLE:
      propTp = "enable";
      break;
    case RDLProperty::RDL_PROPERTY_HWENABLE:
      propTp = "hwenable";
      break;
    case RDLProperty::RDL_PROPERTY_HWMASK:
      propTp = "hwmask";
      break;
    case RDLProperty::RDL_PROPERTY_HALTMASK:
      propTp = "haltmask";
      break;
    case RDLProperty::RDL_PROPERTY_HALTENABLE:
      propTp = "haltenable";
      break;
    case RDLProperty::RDL_PROPERTY_HALT:
      propTp = "halt";
      break;
    case RDLProperty::RDL_PROPERTY_NEXT:
      propTp = "next";
      break;
    case RDLProperty::RDL_PROPERTY_USER_DEFINED:
      propTp = getPropertyDefinition()->getName();
      break;
    default :
      break;
  }
  return propTp;
}
void RDLProperty::decompile()
{ 
  cout << getPropertyModifierString() << " " << getPropertyString();
  const char* valueStr = getPropertyValue();

  if (valueStr)
  {
    cout << " = ";
    if (!strcmp(valueStr, "NUMBER"))
      getValue()->decompile();
    else
      cout << valueStr;
  }
  else
  {
    if (getNoItems() == 1)
      cout << " = ";
    RDLBase::decompile();
  }
  cout << ";" << endl;

}
