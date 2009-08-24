#ifndef STELLAR_LOCUS_REGRESSION_OPTIONS
#define STELLAR_LOCUS_REGRESSION_OPTIONS


#include <boost/program_options.hpp>
namespace po = boost::program_options;
#include <utilities.hpp>

#include <iostream>
#include <fstream>
#include <iterator>
#include <exception>
using namespace std;

namespace slr {

  class options {
    po::variables_map vm;

  public:
    // Constructors
    options();
    options(int ac, char* av[]);

    // Destructor
    ~options();

    // Member methods
    void init(int ac, char* av[]);
    string show_all();
    void check();

  }; // class options
}

#endif 
