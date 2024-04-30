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
%token LPRNTH RPRNTH LBRAC RBRAC LSQ RSQ
%token AT HASH SEMI EQ COMA OR DREF INC MOD DOT COLON
%token k_abstr k_accesstype k_accesswidth k_activehigh k_activelow
%token k_addressing k_addressingtype k_addrmap k_alias k_alignment
%token k_all k_anded k_async k_bit k_bigendian k_bothedge k_boolean
%token k_bridge k_component k_compact k_componentwidth k_constraint
%token k_counter k_cpuif_reset k_decr k_decrsaturate
%token k_decrthreshold k_decrvalue k_decrwidth k_default k_desc
%token k_dontcompare k_donttest k_enable k_encode k_enum
%token k_errextbus k_external k_false k_field k_field_reset
%token k_fieldwidth k_fullalign k_halt k_haltenable k_haltmask
%token k_hw k_hwclr k_hwenable k_hwmask k_hwset
%token k_incr k_incrvalue k_incrwidth k_inside k_internal k_intr
%token k_level k_littleendian k_lsb0 k_longint k_mask k_msb0 k_mem
%token k_na k_name k_negedge k_next k_nonsticky k_number
%token k_onreadtype k_onwritetype k_ored k_overflow
%token k_posedge k_precedence k_precedencetype k_property k_r
%token k_rclr k_reg k_regalign k_regfile k_regwidth k_reset k_resetsignal
%token k_rset k_rsvdset k_rsvdsetX k_ruser k_rw k_rw1 k_saturate k_shared
%token k_sharedextbus k_signal k_signalwidth k_singlepulse
%token k_sticky k_stickybit k_string k_struct k_sw k_swacc
%token k_swmod k_swwe k_swwel k_sync k_ref k_this k_threshold k_true k_type
%token k_underflow k_unsigned k_w k_w1 k_we k_wel k_wclr k_woclr k_woset k_wot k_wr k_wset k_wuser k_wzc k_wzs k_wzt k_xored

%type <Number> number constant_expression
%%

  /* A degenerate source file can be completely empty. */
main : source_file
  |
  ;
source_file : description
  | source_file description
  ;
description : component_definition //this is done
  | enum_definition //this is done
  | struct_definition //this is done
  | constraint_definition //this is done
  | explicit_component_inst //this is done
  | property_assignment //this is done
  | property_definition //this is done
  ;
component_definition : component_named_definition component_instance_type_opt component_instances_opt SEMI
  | component_anonymous_definition component_instance_type_opt component_instances SEMI
  | component_instance_type component_named_definition component_instances SEMI
  | component_instance_type component_anonymous_definition component_instances SEMI
  ;
component_instance_type_opt : component_instance_type
  |
    {
      instType = RDLInstance::RDL_INSTANCE_NONE;
    }
  ;
component_instance_type : k_internal
    {
      instType = RDLInstance::RDL_INSTANCE_INTERNAL;
    }
  | k_external
    {
      instType = RDLInstance::RDL_INSTANCE_EXTERNAL;
    }
  ;
component_named_definition : component_type IDENTIFIER parameter_definitions_opt
    {
      tmpComp->setName($2);
      tmpComp->setScope(currentScope);
      currentScope->addItem(tmpComp);
      currentScope = tmpComp;
    }
    component_body
    {
      currentScope = currentScope->getScope();
    }
  ;
component_anonymous_definition : component_type
    {
      tmpComp->setScope(currentScope);
      currentScope->addItem(tmpComp);
    }
    component_body
    {
      currentScope = currentScope->getScope();
    }
  ;
component_type : k_mem
    {
      tmpComp = new RDLComponent(RDLComponent::RDL_COMPONENT_MEM);
    }
  | k_reg
    {
      tmpComp = new RDLComponent(RDLComponent::RDL_COMPONENT_REG);
    }
  | k_regfile
    {
      tmpComp = new RDLComponent(RDLComponent::RDL_COMPONENT_REGFILE);
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
  ;
parameter_definitions_opt : HASH LPRNTH parameter_definitions RPRNTH
  |
  ;
parameter_definitions : parameter_definition
  | parameter_definitions COMA parameter_definition
  ;
parameter_definition : parameter_type IDENTIFIER array_type_opt parameter_value_opt
    {
      char ss[32];
      sprintf(ss, "_internal%d", tmpComp);
//      $$ = strdup(ss);
    }
  ;
parameter_type : k_boolean
  | k_string
  | k_bit
  | k_longint
  | k_unsigned
  | k_longint k_unsigned
  | k_accesstype
  | k_addressingtype
  | k_onreadtype
  | k_onwritetype
  ;
array_type_opt : LBRAC RBRAC
  |
  ;
parameter_value_opt : EQ constant_expression
  |
  ;
component_body : LBRAC component_items RBRAC
  ;
component_items : component_item
  | component_items component_item
  ;
component_item : component_definition //this is done
  | explicit_component_inst //this is done
  | enum_definition //this is done
  | struct_definition //this is done
  | constraint_definition //this is done
  | property_assignment //this is done
  ;
component_instances_opt : component_instances
  |
  ;
component_instances : parameter_intstances_opt component_instance_items
  ;
component_instance_items : component_instance
  | component_instance_items COMA component_instance
  ;
component_instance : IDENTIFIER
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
      if (definedObj)
      {
          tmpInstRef->addInstanceReference(definedObj, $2);
      }
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
element_opt : element
    {
      cout << "INFO:\tCurrently optr_num is not supported" << endl;
    }
  |
  ;
element : EQ constant_expression
  | AT constant_expression
  | INC constant_expression
  | MOD constant_expression
  | AT constant_expression INC constant_expression
  | AT constant_expression MOD constant_expression
  ;
explicit_component_inst : component_instance_type_opt component_instance_alias_opt IDENTIFIER component_instances SEMI
    {
      definedObj = currentScope->isAlreadyDefined($3);
      if (!definedObj)
      {
        cout << "ERROR: Cannot find \"" << $3 << "\" in \"" << currentScope->getName() << "\" or higher scope onwards." << endl;
        exit (-1);
      }
    }
  ;
component_instance_alias_opt : component_instance_alias
  |
  ;
component_instance_alias : k_alias IDENTIFIER
    {
      instType = RDLInstance::RDL_INSTANCE_NONE;
      // tmpInst->setAliasName($2); implement it
    }
  ;
parameter_intstances_opt : HASH LPRNTH parameter_intstances RPRNTH
  |
  ;
parameter_intstances : parameter_intstance
  | parameter_intstances COMA parameter_intstance
  ;
parameter_intstance : DOT IDENTIFIER LPRNTH constant_expression RPRNTH
  ;
property_assignment : post_property_assign SEMI
    {
      currentScope = currentScope->getScope();
    }
  | default_opt property_modifier IDENTIFIER SEMI
    {
      tmpProp->setAsDefault();
    }
  | default_opt explicit_property_assign SEMI
  ;
default_opt : k_default
  |
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
  | k_encode EQ IDENTIFIER
    {
      tmpProp->setPropertyModifierType(propModTyp);
      tmpProp->setScope(currentScope);
      currentScope->addItem(tmpProp);
    }
  ;
post_property_assign : property_reference EQ property_assign_rhs
    {
      currentScope = currentScope->getScope();
    }
  | instance_reference DREF k_encode EQ IDENTIFIER
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
property_assign_rhs : constant_expression
  | k_hw
    {
      tmpEnum = new RDLEnum();
      tmpEnum->setScope(currentScope);
      currentScope->addItem(tmpEnum);
      currentScope = tmpEnum;
      tmpProp->setPropertyValue("hw");
    }
  | k_sw
    {
      tmpProp->setPropertyValue("sw");
      currentScope = currentScope->getScope();
    }
  ;
constraint_definition : k_constraint IDENTIFIER constraint_body SEMI
  | k_constraint IDENTIFIER constraint_body constraint_insts SEMI
  | k_constraint constraint_body constraint_insts SEMI
  ;
constraint_insts : IDENTIFIER
  | constraint_insts COMA IDENTIFIER
  ;
constraint_body : LBRAC constraint_items RBRAC
  ;
constraint_items : constraint_item SEMI
  | constraint_items constraint_item SEMI
  ;
constraint_item : constant_expression
  | constraint_prop_assignment
  | constraint_lhs k_inside IDENTIFIER
  | constraint_lhs k_inside LBRAC constraint_values RBRAC
  ;
constraint_lhs : k_this
  | instance_reference
  ;
constraint_prop_assignment : IDENTIFIER EQ constant_expression
  ;
constraint_values : constraint_value
  | constraint_values COMA constraint_value
  ;
constraint_value : constant_expression
  | LSQ constant_expression COLON constant_expression RSQ
  ;
property_definition : k_property IDENTIFIER
    {
      tmpPropDef = new RDLPropertyDefinition($2);
      tmpPropDef->setScope(currentScope);
      currentScope->addItem(tmpPropDef);
    }
    property_body SEMI
  ;
property_body : LBRAC property_items RBRAC
  ;
property_items : property_item
  | property_items property_item
  ;
property_item : property_type
  | property_usage
  | property_default
  | property_constraint
  ;
property_type : k_type EQ property_type_item array_type_opt SEMI
  ;
property_type_item : k_ref
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_REF);
    }
  | k_number
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_NUMBER);
    }
  | k_boolean
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_BOOLEAN);
    }
  | k_string
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_STRING);
    }
  | k_bit
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_BIT);
    }
  | k_longint
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_LONGINT);
    }
  | k_longint k_unsigned
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_LONGINT_UNSIGN);
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
  | k_mem
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_MEM);
    }
  | k_regfile
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_REGFILE);
    }
  | IDENTIFIER
    {
      tmpPropDef->setPropertyTypeType(RDLPropertyDefinition::RDL_PROPERTY_TYPE_USER);
    }
  ;
property_usage : k_component EQ property_components SEMI
  ;
property_components : property_component
  | property_components OR property_component
  ;
property_component : k_all
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_ALL);
    }
  | k_constraint
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_CONSTRAINT);
    }
  | k_reg
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_REG);
    }
  | k_regfile
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_REGFILE);
    }
  | k_field
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_FIELD);
    }
  | k_addrmap
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_ADDRMAP);
    }
  | k_mem
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_FIELD);
    }
  | k_signal
    {
      tmpPropDef->setPropertyComponentType(RDLPropertyDefinition::RDL_PROPERTY_COMPONENT_SIGNAL);
    }
  ;
property_constraint : k_constraint EQ k_componentwidth
  ;
property_default : k_default EQ constant_expression SEMI
  ;
constant_expression : constant_primary
  | unary_operator constant_primary
  | constant_expression binary_operator constant_primary
  | constant_expression '?' constant_expression ':' constant_primary
  ;
unary_operator : '!' | '+' | '-' | '~' | '&' | '|' | '^' | "~&" | "~|" | "~^" | "^~"
  ;
binary_operator : '<' | '>' | '-' | '%' | '&' | '|' | '^' | "&&" | "||" | "~^"
  | "^~" | "<=" | ">=" | "==" | "!=" | ">>" | "<<" | "*" | "**" | "/" | '+'
  ;
constant_primary : primary_literal
  | constant_cast
  | LPRNTH constant_expression RPRNTH
  | LBRAC constant_concatenation RBRAC
  | instance_or_prop_ref
  | struct_literal
  | array_literal
  ;
primary_literal : k_this
  | number
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
  | enumerator_literal
  | addressingtype_literal
  | accesstype_literal
  | onreadtype_literal
  | onwritetype_literal
  ;
enumerator_literal : IDENTIFIER "::" IDENTIFIER
  ;
addressingtype_literal : k_compact
  | k_regalign
  | k_fullalign
  ;
onreadtype_literal : k_rclr
  | k_rset
  | k_ruser
  ;
accesstype_literal : k_na
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_FALSE);
    }
  | k_rw
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_FALSE);
    }
  | k_wr
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_FALSE);
    }
  | k_r
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_FALSE);
    }
  | k_w
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_FALSE);
    }
  | k_rw1
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_FALSE);
    }
  | k_w1
    {
      tmpPropDef->setPropertyDefaultType(RDLPropertyDefinition::RDL_PROPERTY_DEFAULT_FALSE);
    }
  ;
onwritetype_literal : k_woset
  | k_woclr
  | k_wot
  | k_wzs
  | k_wzc
  | k_wzt
  | k_wclr
  | k_wset
  | k_wuser
  ;
constant_cast : k_boolean '\'' LPRNTH constant_expression RPRNTH
  | k_longint '\'' LPRNTH constant_expression RPRNTH
  | k_bit '\'' LPRNTH constant_expression RPRNTH
// | constant_primary '\'' LPRNTH constant_expression RPRNTH
  ;
constant_concatenation : constant_expression
  | constant_concatenation COMA constant_expression
  ;
property_reference : instance_reference deref
  ;
instance_or_prop_ref : instance_reference
    {
      stratOfInstRef = 1;
    }
  | property_reference
  ;
deref : DREF property
    {
      tmpProp->setScope(currentScope);
      currentScope->addItem(tmpProp);
      currentScope = tmpProp;
    }
/*
  | DREF IDENTIFIER
    {
      // need to change
      tmpProp->setScope(currentScope);
      currentScope->addItem(tmpProp);
      currentScope = tmpProp;
    }
*/
  ;
instance_reference : instance_ref_elem
  | instance_reference DOT instance_ref_elem
  ;
instance_ref_elem : IDENTIFIER array_opt
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
      if (!definedObj)
      {
        cout << "ERROR: Cannot find " << $1 << " in " << (currentScope->getScope())->getName() << " or higher scope onwards." << endl;
        exit (-1);
      }
    }
  ;
property : k_hw
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_HW);
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
  | k_sw
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_SW);
    }
  | k_rset
    {
      tmpProp = new RDLProperty(RDLProperty::RDL_PROPERTY_RSET);
    }
  ;
array_literal : '\'' LBRAC array_literal_items RBRAC
  ;
array_literal_items : constant_expression
  | array_literal_items COMA constant_expression
  ;
struct_literal : IDENTIFIER '\'' LBRAC struct_literal_items RBRAC
  ;
struct_literal_items : struct_literal_item
  | struct_literal_items COMA struct_literal_item
  ;
struct_literal_item : IDENTIFIER COLON constant_expression
  ;
enum_definition : k_enum IDENTIFIER
    {
      tmpEnum = new RDLEnum($2);
      tmpEnum->setScope(currentScope);
      currentScope->addItem(tmpEnum);
      currentScope = tmpEnum;
    }
    enum_body SEMI
    {
      currentScope = currentScope->getScope();
    }
  ;
enum_body : LBRAC enum_items RBRAC 
  ;
enum_items : enum_item
  | enum_items enum_item
  ;
enum_item : IDENTIFIER EQ constant_expression
    {
      tmpEnum->setEntryValue($1, $3);
    }
    enum_property_assign_block_opt SEMI
  | IDENTIFIER enum_property_assign_block_opt SEMI
  ;
enum_property_assign_block_opt : enum_property_assign_block
  |
  ;
enum_property_assign_block : LBRAC enum_property_assignments RBRAC
  ;
enum_property_assignments : explicit_property_assign SEMI
  | enum_property_assignments explicit_property_assign SEMI
  ;
struct_definition : abstr_opt k_struct IDENTIFIER derive_opt struct_body
  ;
abstr_opt : k_abstr
  |
  ;
derive_opt : COLON IDENTIFIER
  |
  ;
struct_body : LBRAC struct_items RBRAC
  ;
struct_items : struct_item SEMI
  | struct_items struct_item SEMI
  ;
struct_item : parameter_type IDENTIFIER array_type_opt
  | component_type IDENTIFIER array_type_opt
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
