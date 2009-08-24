#include <slr.hpp>

int main(int ac, char* av[])
{
  try
    {
      slr::init(ac, av);
    }
  catch (exception& e)
    {
      cout << e.what() << "\n";
    }
  return 0;
}


void slr::init(int ac, char* av[])
{
  try
    {
      // Declare and parse commandline and config file options
      slr::options opt(ac, av);
      opt.check();
      cout << opt.show_all();
    }
  catch (exception& e)
    {
      cout << e.what() << "\n";
    }  
}
