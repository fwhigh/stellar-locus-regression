#include <slr.hpp>

slr::options opt;

int main(int ac, char* av[])
{
  try
    {
      slr::init(ac, av); // Need a way to store/pass config options to
			 // subsequent procedures!
      //slr::run(); // Not yet implemented
      //slr::fin(); // Not yet implemented
    }
  catch (exception& e)
    {
      cout << "slr::main: " << e.what() << "\n";
    }
  return 0;
}


void slr::init(int ac, char* av[])
{
  try
    {
      // Declare and parse commandline and config file options
      opt.init(ac, av);
      opt.validateAll();
      cout << opt.showAll();
    }
  catch (exception& e)
    {
      cout << "slr::init: " << e.what() << "\n";
    }  
}
