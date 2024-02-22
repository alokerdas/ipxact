#ifndef RDL_INSTANCE_REFERENCE_H
#define RDL_INSTANCE_REFERENCE_H

#include "rdlBase.h"

class RDLNumber;
class RDLInstanceRef : public RDLBase
{
  private:
  map<RDLBase*, RDLNumber*> instanceIndexArr;

  public:
  RDLInstanceRef::RDLInstanceRef();
  void addInstanceReference(RDLBase* inst, RDLNumber* idx);
  void decompile();
};

#endif
