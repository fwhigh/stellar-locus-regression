#include <slr/utilities.hpp>


bool slr::utilities::fileReadable( string FileName )
{
  ifstream fin(FileName.c_str());
  return fin;
}

bool slr::utilities::fileWriteable( string FileName )
{
  fstream finout(FileName.c_str());
  return finout;
}
