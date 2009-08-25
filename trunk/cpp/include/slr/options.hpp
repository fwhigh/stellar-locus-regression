#ifndef STELLAR_LOCUS_REGRESSION_OPTIONS
#define STELLAR_LOCUS_REGRESSION_OPTIONS


#include <boost/program_options.hpp>
namespace po = boost::program_options;
#include <boost/regex.hpp>
#include <slr/io.hpp>
#include <slr/utilities.hpp>

#include <iostream>
#include <fstream>
#include <iterator>
#include <exception>
using namespace std;

namespace slr {

  class options {
    /*
     * enum optID {
     * input_file,
     * output_file,
     * config_file
     * }; 
    */

  public:
    // Constructors
    options();
    options(int ac, char* av[]);

    // Destructor
    ~options();

    // Member methods
    void init(int ac, char* av[]);
    string showAll();
    void validateAll();
    void validate(string par);

    int verbose();

  private:
    po::variables_map vm;

  }; // class options
}


#endif 
