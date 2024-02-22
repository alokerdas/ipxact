#include <iostream>
#include <fstream>
#include <sys/stat.h>

using namespace std;

void processVerilog(const char* fileName)
{
  const int max=20000;
  char buffer[max];
  int perlCount = 0;
  ifstream veriFile(fileName);

  cout << "Reading " << fileName << endl;
  while(veriFile.good() && !veriFile.eof())
  {
    veriFile.getline(buffer, max);
    string line = buffer;
  }
}

void processPerl(char* fileName, string workArea)
{
  const int max=20000;
  char buffer[max];
  int perlCount = 0;
  string perlOutFileName = workArea + "/" + fileName + ".pp";
  ifstream perlFile(fileName);
  ofstream perlOutFile(perlOutFileName.c_str());

  cout << "Reading " << fileName << endl;
  while(perlFile.good() && !perlFile.eof())
  {
    perlFile.getline(buffer, max);
    string line = buffer;
    if (strcmp(buffer,""))
    {
      int printDeleted = 0;
      for (string::size_type quotPos = line.find('"'); quotPos != string::npos; quotPos = line.find('"', quotPos+2))
      {
        line.insert(quotPos, 1, '\\');
      }
      for (string::size_type atPos = line.find('@'); atPos != string::npos; atPos = line.find('@', atPos+2))
      {
        line.insert(atPos, 1, '\\');
      }
      line.insert(0, "print \"");
      for (string::size_type perlPos = line.find("<%="); perlPos != string::npos; perlPos = line.find("<%="))
      {
        line.replace(perlPos, 3, "\"; print ");
        string::size_type closePerlPos = line.find("%>", perlPos);
        if (closePerlPos != string::npos)
          line.replace(closePerlPos, 2, "; print \"");
      }
      for (string::size_type perlPos = line.find("<%"); perlPos != string::npos; perlPos = line.find("<%"))
      {
        perlCount++;
        line.erase(perlPos, 2);
        line.erase(0, 7);
        printDeleted = 1;
      }
      if (!perlCount)
        line.insert(line.size(), "\\n\";");
      if (perlCount && !printDeleted)
        line.erase(0, 7);
        
      for (string::size_type closePerlPos = line.find("%>"); closePerlPos != string::npos; closePerlPos = line.find("%>"))
      {
        line.erase(closePerlPos, 2);
        if (perlCount)
          perlCount = 0;
        else
          line.insert(closePerlPos, 1, ';');
      }
      perlOutFile << line << endl;
    }
  }
  cout << "Running perl on " << perlOutFileName << endl;
  string perlProsdFileName = perlOutFileName + ".rdl";
  string perlCmd = "perl " + perlOutFileName + " >& " + perlProsdFileName;
  system(perlCmd.c_str());
  processVerilog(perlProsdFileName.c_str());
}

int main(int argc, char** argv)
{
  string tmpArea = getenv("PWD");
  tmpArea += "/TEMP";
  mkdir(tmpArea.c_str(), S_IRWXU);

  char* rdlFileName = argv[1];
  processPerl(rdlFileName, tmpArea);
  return 0;
}
