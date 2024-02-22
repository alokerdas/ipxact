#ifndef RDL_NUMBER_H
#define RDL_NUMBER_H

using namespace std;

class RDLNumber
{
  private:
  int size;
  char base;
  unsigned char isSigned;
  unsigned long long actualValue;

  public:
  RDLNumber();
  RDLNumber(const char* orgVal);
  void setSigned(unsigned char s);
  unsigned char getSigned();
  void setBase(char base);
  char getBase();
  void setSize(int siz);
  int getSize();
  void processOriginalValue(const char* orgVal);
  unsigned long long getActualValue();
  void decompile();
};

#endif
