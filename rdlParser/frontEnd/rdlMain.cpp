#include "rdlMain.h"

extern RDLBase* rdlRoot;
int main(int argc, char **argv)
{
  int status = 0;
//printf("%s, %s\n", argv[0], argv[1]);
  yyin = fopen(argv[1], "r");
  yyparse();
  rdlRoot->decompile();
  return status;
}
