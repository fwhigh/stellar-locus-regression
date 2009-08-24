#ifndef STELLAR_LOCUS_REGRESSION_UTILITIES
#define STELLAR_LOCUS_REGRESSION_UTILITIES


#include <iostream>
#include <fstream>
#include <exception>
using namespace std;

namespace slr {

  namespace utilities {

    // Member methods
    bool fileExists( string fileName );
    bool fileWriteable( string fileName );

  } // utilities
}

#endif 
