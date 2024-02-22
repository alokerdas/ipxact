#include <iostream>
#include <iomanip>
#include <string>
#include "rdlNumber.h"

RDLNumber::RDLNumber()
{
  size = 0;
  isSigned = 0;
  base = 'd';
  actualValue = 0;
}
void RDLNumber::setSigned(unsigned char s)
{
  isSigned = s;
}
unsigned char RDLNumber::getSigned()
{
  return isSigned;
}
void RDLNumber::setBase(char bs)
{
  base = bs;
}
char RDLNumber::getBase()
{
  return base;
}
void RDLNumber::setSize(int bs)
{
  size = bs;
}
int RDLNumber::getSize()
{
  return size;
}
RDLNumber::RDLNumber(const char* orgVal)
{
  string textValue = orgVal;
  char tick = '\'';
  string::size_type tickPosition = textValue.find(tick);
  if (tickPosition != string::npos)
  {
    string sizeNum(textValue, 0, tickPosition);
    size = atoi(sizeNum.c_str());

    if (textValue[tickPosition+1] == 's' || textValue[tickPosition+1] == 'S')
    {
      isSigned = 1;
      base = textValue[tickPosition + 2];
      textValue.erase(0, tickPosition + 3);
    }
    else
    {
      base = textValue[tickPosition+1];
      textValue.erase(0, tickPosition + 2);
    }
  }
  else
  {
    base = 'd';
    string::size_type oxPosition = textValue.find("0x");
    if (oxPosition != string::npos)
    {
      base = 'x';
      textValue.erase(0, 2);
    }
  }

  for (string::size_type underScorePos = textValue.find('_'); underScorePos != string::npos; underScorePos = textValue.find('_'))
  {
    textValue.erase(underScorePos);
  }

  int baseNum;
  switch (base)
  {
    case 'b':
      baseNum = 2;
      break;
    case 'd':
      baseNum = 10;
      break;
    case 'h':
    case 'x':
      baseNum = 16;
      break;
    case 'o':
      baseNum = 8;
      break;
    default:
      baseNum = 10;
      break;
  }
  actualValue = strtoull(textValue.c_str(), 0, baseNum);
}
unsigned long long RDLNumber::getActualValue()
{
  return actualValue;
}
void RDLNumber::decompile()
{ 
  if (getSize())
  {
    char baseCr = getBase();
    cout << getSize() << "'" << baseCr;
    switch (baseCr)
    {
      case 'b':
        cout << setbase(2) << getActualValue();
        break;
      case 'h':
      case 'x':
        cout << hex << getActualValue();
        break;
      case 'o':
        cout << oct << getActualValue();
        break;
      default:
        cout << getActualValue();
        break;
    }
  }
  else
  {
    if (getBase() == 'd')
      cout << getActualValue();
    else if (getBase() == 'x')
      cout << hex << getActualValue();
  }
}
