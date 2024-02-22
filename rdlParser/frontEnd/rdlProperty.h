#ifndef RDL_PROPERTY_H
#define RDL_PROPERTY_H

#include "rdlBase.h"
#include "rdlNumber.h"
#include "rdlPropertyDefinition.h"

using namespace std;

class RDLProperty : public RDLBase
{
  public:
  typedef enum
  {
    RDL_PROPERTY_NONE,
    RDL_PROPERTY_NAME,
    RDL_PROPERTY_DESC,
    RDL_PROPERTY_ARBITER,
    RDL_PROPERTY_RSET,
    RDL_PROPERTY_RCLR,
    RDL_PROPERTY_WOCLR,
    RDL_PROPERTY_WOSET,
    RDL_PROPERTY_WE,
    RDL_PROPERTY_WEL,
    RDL_PROPERTY_SWWE,
    RDL_PROPERTY_SWWEL,
    RDL_PROPERTY_HWSET,
    RDL_PROPERTY_HWCLR,
    RDL_PROPERTY_SWMOD,
    RDL_PROPERTY_SWACC,
    RDL_PROPERTY_STICKY,
    RDL_PROPERTY_STICKYBIT,
    RDL_PROPERTY_INTR,
    RDL_PROPERTY_ANDED,
    RDL_PROPERTY_ORED,
    RDL_PROPERTY_XORED,
    RDL_PROPERTY_COUNTER,
    RDL_PROPERTY_OVERFLOW,
    RDL_PROPERTY_SHAREDEXTBUS,
    RDL_PROPERTY_ERREXTBUS,
    RDL_PROPERTY_RESET,
    RDL_PROPERTY_LITTLEENDIAN,
    RDL_PROPERTY_BIGENDIAN,
    RDL_PROPERTY_RSVDSET,
    RDL_PROPERTY_RSVDSETX,
    RDL_PROPERTY_BRIDGE,
    RDL_PROPERTY_SHARED,
    RDL_PROPERTY_MSB0,
    RDL_PROPERTY_LSB0,
    RDL_PROPERTY_SYNC,
    RDL_PROPERTY_ASYNC,
    RDL_PROPERTY_CPUIF_RESET,
    RDL_PROPERTY_FIELD_RESET,
    RDL_PROPERTY_ACTIVEHIGH,
    RDL_PROPERTY_ACTIVELOW,
    RDL_PROPERTY_SINGLEPULSE,
    RDL_PROPERTY_UNDERFLOW,
    RDL_PROPERTY_INCR,
    RDL_PROPERTY_DECR,
    RDL_PROPERTY_INCRWIDTH,
    RDL_PROPERTY_DECRWIDTH,
    RDL_PROPERTY_INCRVALUE,
    RDL_PROPERTY_DECRVALUE,
    RDL_PROPERTY_SATURATE,
    RDL_PROPERTY_DECRSATURATE,
    RDL_PROPERTY_THRESHOLD,
    RDL_PROPERTY_DECRTHRESHOLD,
    RDL_PROPERTY_DONTCOMPARE,
    RDL_PROPERTY_DONTTEST,
    RDL_PROPERTY_INTERNAL,
    RDL_PROPERTY_ALIGNMENT,
    RDL_PROPERTY_REGWIDTH,
    RDL_PROPERTY_FIELDWIDTH,
    RDL_PROPERTY_SIGNALWIDTH,
    RDL_PROPERTY_ACCESSWIDTH,
    RDL_PROPERTY_SW,
    RDL_PROPERTY_HW,
    RDL_PROPERTY_ADDRESSING,
    RDL_PROPERTY_PRECEDENCE,
    RDL_PROPERTY_ENCODE,
    RDL_PROPERTY_RESETSIGNAL,
    RDL_PROPERTY_CLOCK,
    RDL_PROPERTY_MASK,
    RDL_PROPERTY_ENABLE,
    RDL_PROPERTY_HWENABLE,
    RDL_PROPERTY_HWMASK,
    RDL_PROPERTY_HALTMASK,
    RDL_PROPERTY_HALTENABLE,
    RDL_PROPERTY_HALT,
    RDL_PROPERTY_NEXT,
    RDL_PROPERTY_USER_DEFINED
  } rdl_property_type;

  typedef enum
  {
    RDL_PROPERTY_MODIFIER_NONE,
    RDL_PROPERTY_MODIFIER_LEVEL,
    RDL_PROPERTY_MODIFIER_POSEDGE,
    RDL_PROPERTY_MODIFIER_NEGEDGE,
    RDL_PROPERTY_MODIFIER_BOTHEDGE,
    RDL_PROPERTY_MODIFIER_NONSTICKY
  } rdl_property_modifier_type;

  private:
  unsigned char isDefaultValue;
  rdl_property_type propertyType;
  rdl_property_modifier_type propertyModifierType;
  RDLPropertyDefinition* userProperty;
  RDLNumber* numberValue;

  public:

  RDLProperty(rdl_property_type propType = RDL_PROPERTY_NONE, const char* nm = 0);
  void setPropertyType(rdl_property_type type);
  rdl_property_type getPropertyType();
  void setPropertyModifierType(rdl_property_modifier_type modType);
  rdl_property_modifier_type getPropertyModifierType();

  void setPropertyDefinition(RDLPropertyDefinition* propDefn);
  RDLPropertyDefinition* getPropertyDefinition();
  void setValue(RDLNumber* num);
  RDLNumber* getValue();
  void setPropertyValue(const char* nm);
  const char* getPropertyValue();

  void setAsDefault();
  unsigned char isDefault();
  void decompile();
  string getPropertyString();
  string getPropertyModifierString();

};

#endif
