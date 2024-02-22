%{

#include <iostream>
#include <vector>
#include "rdlBase.h"
#include "rdlEnum.h"
#include "rdlInstance.h"
#include "rdlProperty.h"
#include "rdlComponent.h"
#include "rdlInstanceRef.h"
#include "rdlPropertyDefinition.h"

using namespace std;

extern int  yylex();
extern void yyerror (char *s);
int stratOfInstRef = 1;

RDLEnum* tmpEnum;
RDLInstance* tmpInst;
RDLProperty* tmpProp;
RDLComponent* tmpComp;
RDLInstanceRef* tmpInstRef;
RDLPropertyDefinition* tmpPropDef;
RDLBase* rdlRoot = new RDLBase();
RDLBase* currentScope = rdlRoot;
RDLBase* definedObj = 0;
RDLInstance::rdl_instance_type instType;
RDLProperty::rdl_property_modifier_type propModTyp;

%}

%union {
  char* text;
  class RDLEnum* Enum;
  class RDLNumber* Number;
  class RDLInstance* Instance;
  class RDLProperty* Property;
  class RDLComponent* Component;
  class RDLInstanceRef* InstanceRef;
  class RDLPropertyDefinition* PropertyDefinition;
};

%token <text> HEX_NUMBER BASED_NUMBER DEC_NUMBER
%token <text>   IDENTIFIER SYSTEM_IDENTIFIER STRING
%token AT LBRAC RBRAC SEMI EQ COMA LSQ RSQ OR DREF INC MOD DOT COLON
%token k_accesswidth k_activehigh k_activelow k_addressing k_addrmap
%token k_alias k_alignment k_all k_anded k_arbiter
%token k_async k_bigendian k_bothedge k_bridge k_clock
%token k_compact k_counter k_cpuif_reset k_decr k_decrsaturate
%token k_decrthreshold k_decrvalue k_decrwidth k_default k_desc
%token k_dontcompare k_donttest k_enable k_encode k_enum
%token k_errextbus k_external k_false k_field k_field_reset
%token k_fieldwidth k_fullalign k_halt k_haltenable k_haltmask
%token k_hw k_hwclr k_hwenable k_hwmask k_hwset
%token k_incr k_incrvalue k_incrwidth k_internal k_intr
%token k_level k_littleendian k_lsb0 k_mask k_msb0
%token k_na k_name k_negedge k_next k_nonsticky
%token k_ored k_overflow k_posedge k_precedence k_property
%token k_r k_rclr k_reg k_regalign k_regfile
%token k_regwidth k_reset k_resetsignal k_rset k_rsvdset
%token k_rsvdsetX k_rw k_saturate k_shared k_sharedextbus
%token k_signal k_signalwidth k_singlepulse k_sticky k_stickybit
%token k_sw k_swacc k_swmod k_swwe k_swwel
%token k_sync k_threshold k_true k_underflow k_w
%token k_we k_wel k_woclr k_woset k_wr k_xored
%token k_type k_component k_boolean k_number k_string k_ref

%type <Number> number index_opt
%type <text> id_opt explicit_component_inst_front
%%

  /* A degenerate source file can be completely empty. */
main : source_file
  |
  ;
source_file : description
  | source_file description
  ;
description : component_def_item
  | property_definition
  ;
component_def : component_def_kword id_opt LBRAC
    {
      tmpComp->setName($2);
      tmpComp->setScope(currentScope);
      currentScope->addItem(tmpComp);
      currentScope = tmpComp;
    }
    component_def_items RBRAC
    {
      currentScope = currentScope->getScope();
    }
    inst_elems_opt SEMI
  | component_def_kword id_opt LBRAC RBRAC
    {
      tmpComp->setName($2);
      tmpComp->setScope(currentScope);
      currentScope->addItem(tmpComp);
    }
    inst_elems_opt SEMI
  ;
component_def_kword : k_reg
    {
      tmpComp = new RDLComponent(RDLComponent::RDL_COMPONENT_REG);
    }
  | k_field
    {
      tmpComp = new RDLComponent(RDLComponent::RDL_COMPONENT_FIELD);
    }
  | k_signal
    {
      tmpComp = new RDLComponent(RDLComponent::RDL_COMPONENT_SIGNAL);
    }
  | k_addrmap
    {
      tmpComp = new RDLComponent(RDLComponent::RDL_COMPONENT_ADDRMAP);
    }
  | k_regfile
    {
      tmpComp = new RDLComponent(RDLComponent::RDL_COMPONENT_REGFILE);
    }
  ;
id_opt : IDENTIFIER
  |
    {
      char ss[32];
      sprintf(ss, "_internal%d", tmpComp);
      $$ = strdup(ss);
    }
  ;
component_def_items : component_def_item
  | component_def_items component_def_item
  ;
component_def_item : enum_def
  | explicit_component_inst
  | property_assign
  | component_def
  ;
inst_elems_opt : anonymous_component_inst_elems
  |
  ;
anonymous_component_inst_elems : external_opt
    {
      definedObj = tmpComp;
    }
    component_inst_elements
  ;
external_opt : k_external
    {
      instType = RDLInstance::RDL_INSTANCE_EXTERNAL;
    }
  |
    {
      instType = RDLInstance::RDL_INSTANCE_NONE;
    }
  ;
component_inst_elements : component_inst_elem
  | component_inst_elements COMA component_inst_elem
  ;
component_inst_elem : IDENTIFIER
    {
      tmpInst = new RDLInstance(instType, $1);
      tmpInst->setScope(currentScope);
      currentScope->addItem(tmpInst);
      currentScope = tmpInst;

      if (definedObj)
        tmpInst->setComponent(definedObj);
    }
    array_opt element_opt
    {
      currentScope = currentScope->getScope();
    }
  ;
array_opt : array
  |
  ;
array : LSQ number
    {
      tmpInst->setIndexLeft($2);
    }
    col_num_opt RSQ
  ;
col_num_opt :  COLON number
    {
      tmpInst->setIndexRight($2);
    }
  |
  ;
element_opt : oprtr_num
    {
      cout << "INFO:\tCurrently optr_num is not supported" << endl;
    }
  |
  ;
oprtr_num : EQ number
  | AT number INC number
  | AT number MOD number
  | AT number
  | INC number
  | MOD number
  ;
explicit_component_inst : explicit_component_inst_front
    {
      definedObj = currentScope->isAlreadyDefined($1);
      if (!definedObj)
      {
        cout << "ERROR: Cannot find \"" << $1 << "\" in \"" << currentScope->getName() << "\" or higher scope onwards." << endl;
        exit (-1);
      }
    }
    component_inst_elements SEMI
  ;
explicit_component_inst_front : IDENTIFIER
    {
      instType = RDLInstance::RDL_INSTANCE_NONE;
      $$ = $1;
    }
  | k_alias IDENTIFIER IDENTIFIER
    {
      instType = RDLInstance::RDL_INSTANCE_NONE;
      // tmpInst->setAliasName($2); implement it
      $$ = $3;
    }
  | k_internal IDENTIFIER
    {
      instType = RDLInstance::RDL_INSTANCE_INTERNAL;
      $$ = $2;
    }
  | k_external IDENTIFIER
    {
      instType = RDLInstance::RDL_INSTANCE_EXTERNAL;
      $$ = $2;
    }
  ;
property_assign : post_property_assign SEMI
    {
      currentScope = currentScope->getScope();
    }
  | explicit_property_assign SEMI
  | default_property_assign SEMI
  ;
default_property_assign : k_default explicit_property_assign
    {
      tmpProp->setAsDefault();
    }
  ;
explicit_property_assign : property
    {
      tmpProp->setScope(currentScope);
      currentScope->addItem(tmpProp);
    }
  | property EQ
    {
      tmpProp->setScope(currentScope);
      currentScope->addItem(tmpProp);
      currentScope = tmpProp;
    }
    property_assign_rhs
    {
      currentScope = currentScope->getScope();
    }
  | property_modifier property
    {
      tmpProp->setPropertyModifierType(propModTyp);
      tmpProp->setScope(currentScope);
      currentScope->addItem(tmpProp);
    }
  ;
post_property_assign : instance_ref EQ property_assign_rhs
    {
      currentScope = currentScope->getScope();
    }
  ;
property_modifier : k_level
    {
      propModTyp = RDLProperty::RDL_PROPERTY_MODIFIER_LEVEL;
    }
  | k_posedge
    {
      propModTyp = RDLProperty::RDL_PROPERTY_MODIFIER_POSEDGE;
    }
  | k_negedge
    {
      propModTyp = RDLProperty::RDL_PROPERTY_MODIFIER_NEGEDGE;
    }
  | k_bothedge
    {
      propModTyp = RDLProperty::RDL_PROPERTY_MODIFIER_BOTHEDGE;
    }
  | k_nonsticky
    {
      propModTyp = RDLProperty::RDL_PROPERTY_MODIFIER_NONSTICKY;
    }
  ;
property_assign_rhs : property_rvalue_constant
  | k_enum LBRAC
    {
      tmpEnum = new RDLEnum();
      tmpEnum->setScope(currentScope);
      currentScope->addItem(tmpEnum);
      currentScope = tmpEnum;
    }
    enum_body RBRAC
    {
      currentScope = currentScope->getScope();
    }
  | instance_ref
    {
      currentScope = currentScope->getScope();
    }
  | concat
    {
      tmpProp->setPropertyValue("CONCATANATION");
    }
  ;
property_rvalue_constant : k_true
    {
      tmpProp->setPropertyValue("true");
    }
  | k_false
    {
      tmpProp->setPropertyValue("false");
    }
  | k_rw
    {
      tmpProp->setPropertyValue("rw");
    }
  | k_wr
    {
      tmpProp->setPropertyValue("wr");
    }
  | k_r
    {
      tmpProp->setPropertyValue("r");
    }
  | k_w
    {
      tmpProp->setPropertyValue("w");
    }
  | k_na
    {
      tmpProp->setPropertyValue("na");
    }
  | k_compact
    {
      tmpProp->setPropertyValue("compact");
    }
  | k_regalign
    {
      tmpProp->setPropertyValue("regalign");
    }
  | k_fullalign
    {
      tmpProp->setPropertyValue("fullalign");
    }
  | k_hw
    {
      tmpProp->setPropertyValue("hw");
    }
  | k_sw
    {
      tmpProp->setPropertyValue("sw");
    }
  | number
    {
      tmpProp->setPropertyValue("NUMBER");
      tmpProp->setValue($1);
    }
  | STRING
    {
      string ss("\"");
      ss += $1;
      ss += "\"";
      tmpProp->setPropertyValue(ss.c_str());
    }
  ;
property_definition : k_property IDENTIFIER LBRAC
    {
      tmpPropDef = new RDLPropertyDefinition($2);
      tmpPropDef->setScope(currentScope);
      currentScope->addItem(tmpPropDef);
    }
    property_body RBRAC SEMI
  ;
property_body : property_type property_usage_default
  | property_usage property_type_default
  | property_default property_type_usage
;
property_usage_default : property_default property_usage
  | property_usage property_default_opt
  ;
property_type_default : property_default property_type
  | property_type property_default_opt
  ;
property_type_usage : property_type property_usage
  | property_usage property_type
  ;
property_default_opt : property_default
  |
  ;
property_type : k_type EQ property_type_item SEMI
  ;
property_type_item : property_ref_type
  | property_boolean_type
  | property_number_type
  | property_string_type
  ;
property_ref_type : k_ref
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_REF);
    }
  | k_reg
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_REG);
    }
  | k_field
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_FIELD);
    }
  | k_addrmap
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_ADDRMAP);
    }
  | k_regfile
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_REGFILE);
    }
  ;
property_string_type : k_string
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_STRING);
    }
  ;
property_number_type : k_number
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_NUMBER);
    }
  ;
property_boolean_type : k_boolean
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_BOOLEAN);
    }
  ;
property_usage : k_component EQ property_components SEMI
  ;
property_components : property_component
  | property_components OR property_component
  ;
property_default : k_default EQ default_value SEMI
  ;
default_value : number
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_NUMBER);
    }
  | STRING
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_STRING);
    }
  | k_true
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_TRUE);
    }
  | k_false
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_FALSE);
    }
  ;
property_component : k_all
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_ALL);
    }
  | k_reg
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_REG);
    }
  | k_field
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_FIELD);
    }
  | k_addrmap
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_ADDRMAP);
    }
  | k_regfile
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_REGFILE);
    }
  | k_signal
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_SIGNAL);
    }
  ;
instance_ref : instance_ref_elements dref_opt
    {
      stratOfInstRef = 1;
    }
  ;
dref_opt : DREF property
    {
      tmpProp->setScope(currentScope);
      currentScope->addItem(tmpProp);
      currentScope = tmpProp;
    }
  |
  ;
instance_ref_elements : instance_ref_elem
  | instance_ref_elements DOT instance_ref_elem
  ;
instance_ref_elem : IDENTIFIER index_opt
    {
      if (stratOfInstRef)
      {
        stratOfInstRef = 0;
        tmpInstRef = new RDLInstanceRef();
        tmpInstRef->setScope(currentScope);
        currentScope->addItem(tmpInstRef);
        currentScope = tmpInstRef;
      }
      definedObj = currentScope->isAlreadyDefined($1);
      if (definedObj)
          tmpInstRef->addInstanceReference(definedObj, $2);
      else
      {
        cout << "ERROR: Cannot find " << $1 << " in " << (currentScope->getScope())->getName() << " or higher scope onwards." << endl;
        exit (-1);
      }
    }
  ;
index_opt : LSQ number RSQ
    {
      $$ = $2;
    }
  |
    {
      $$ = 0;
    }
  ;
property : k_name
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_NAME);
    }
  | k_desc
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_DESC);
    }
  | k_arbiter
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ARBITER);
    }
  | k_rset
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_RSET);
    }
  | k_rclr
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_RCLR);
    }
  | k_woclr
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_WOCLR);
    }
  | k_woset
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_WOSET);
    }
  | k_we
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_WE);
    }
  | k_wel
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_WEL);
    }
  | k_swwe
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SWWE);
    }
  | k_swwel
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SWWEL);
    }
  | k_hwset
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_HWSET);
    }
  | k_hwclr
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_HWCLR);
    }
  | k_swmod
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SWMOD);
    }
  | k_swacc
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SWACC);
    }
  | k_sticky
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_STICKY);
    }
  | k_stickybit
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_STICKYBIT);
    }
  | k_intr
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_INTR);
    }
  | k_anded
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ANDED);
    }
  | k_ored
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ORED);
    }
  | k_xored
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_XORED);
    }
  | k_counter
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_COUNTER);
    }
  | k_overflow
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_OVERFLOW);
    }
  | k_sharedextbus
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SHAREDEXTBUS);
    }
  | k_errextbus
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ERREXTBUS);
    }
  | k_reset
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_RESET);
    }
  | k_littleendian
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_LITTLEENDIAN);
    }
  | k_bigendian
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_BIGENDIAN);
    }
  | k_rsvdset
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_RSVDSET);
    }
  | k_rsvdsetX
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_RSVDSETX);
    }
  | k_bridge
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_BRIDGE);
    }
  | k_shared
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SHARED);
    }
  | k_msb0
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_MSB0);
    }
  | k_lsb0
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_LSB0);
    }
  | k_sync
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SYNC);
    }
  | k_async
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ASYNC);
    }
  | k_cpuif_reset
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_CPUIF_RESET);
    }
  | k_field_reset
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_FIELD_RESET);
    }
  | k_activehigh
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ACTIVEHIGH);
    }
  | k_activelow
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ACTIVELOW);
    }
  | k_singlepulse
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SINGLEPULSE);
    }
  | k_underflow
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_UNDERFLOW);
    }
  | k_incr
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_INCR);
    }
  | k_decr
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_DECR);
    }
  | k_incrwidth
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_INCRWIDTH);
    }
  | k_decrwidth
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_DECRWIDTH);
    }
  | k_incrvalue
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_INCRVALUE);
    }
  | k_decrvalue
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_DECRVALUE);
    }
  | k_saturate
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SATURATE);
    }
  | k_decrsaturate
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_DECRSATURATE);
    }
  | k_threshold
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_THRESHOLD);
    }
  | k_decrthreshold
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_DECRTHRESHOLD);
    }
  | k_dontcompare
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_DONTCOMPARE);
    }
  | k_donttest
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_DONTTEST);
    }
  | k_internal
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_INTERNAL);
    }
  | k_alignment
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ALIGNMENT);
    }
  | k_regwidth
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_REGWIDTH);
    }
  | k_fieldwidth
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_FIELDWIDTH);
    }
  | k_signalwidth
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SIGNALWIDTH);
    }
  | k_accesswidth
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ACCESSWIDTH);
    }
  | k_sw
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SW);
    }
  | k_hw
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_HW);
    }
  | k_addressing
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ADDRESSING);
    }
  | k_precedence
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_PRECEDENCE);
    }
  | k_encode
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ENCODE);
    }
  | k_resetsignal
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_RESETSIGNAL);
    }
  | k_clock
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_CLOCK);
    }
  | k_mask
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_MASK);
    }
  | k_enable
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_ENABLE);
    }
  | k_hwenable
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_HWENABLE);
    }
  | k_hwmask
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_HWMASK);
    }
  | k_haltmask
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_HALTMASK);
    }
  | k_haltenable
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_HALTENABLE);
    }
  | k_halt
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_HALT);
    }
  | k_next
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_NEXT);
    }
  ;


concat : LBRAC concat_elements RBRAC
    {
      cout << "INFO:\tCurrently concat is not supported" << endl;
    }
  ;
concat_elements : concat_elem
  | concat_elements COMA concat_elem
  ;
concat_elem : number
  | instance_ref
  ;
enum_def : k_enum IDENTIFIER LBRAC
    {
      tmpEnum = new RDLEnum($2);
      tmpEnum->setScope(currentScope);
      currentScope->addItem(tmpEnum);
      currentScope = tmpEnum;
    }
    enum_body RBRAC SEMI
    {
      currentScope = currentScope->getScope();
    }
  ;
enum_body : enum_entry
  | enum_body enum_entry
  ;
enum_entry : IDENTIFIER EQ number
    {
      tmpEnum->setEntryValue($1, $3);
    }
    enum_property_assign_block_opt SEMI
  ;
enum_property_assign_block_opt : LBRAC enum_property_assignments RBRAC
  |
  ;
enum_property_assignments : enum_property_assign
  | enum_property_assignments enum_property_assign
  ;
enum_property_assign : enum_property_assign_kword EQ STRING SEMI
  ;
enum_property_assign_kword : k_name
  | k_desc
  ;
number : BASED_NUMBER
    {
      $$ = new RDLNumber($1);
    }
  | HEX_NUMBER
    {
      $$ = new RDLNumber($1);
    }
  | DEC_NUMBER
    {
      $$ = new RDLNumber($1);
    }
  | DEC_NUMBER BASED_NUMBER
    {
      string s = $1;
      s += $2;
      $$ = new RDLNumber(s.c_str());
    }
  ;

%%

void yyerror (char *s)
{
  cout << " <- here " << s << endl;
}
