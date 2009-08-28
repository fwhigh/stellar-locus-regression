#include <slr/options.hpp>

// A helper function to simplify the main part.
template<class T>
ostream& operator<<(ostream& os, const vector<T>& v)
{
  copy(v.begin(), v.end(), ostream_iterator<T>(cout, " ")); 
  return os;
}


slr::options::options() {

}


slr::options::~options() {

}

slr::options::options(int ac, char* av[]) {
  init(ac, av);
}

void slr::options::init(int ac, char* av[])
{
  // Based on Boost's program_options class, specifically their example
  // file multiple_sources.cpp
  try {
    string usage1 = "slr infile outfile [options]";
    string usage2 = "slr --input_file infile --output_file outfile [options]";

    string config_file;
	
    // 
    //
    // Declare a group of options that will be allowed only on command
    // line
    //
    //
    po::options_description cmdline_only("Commandline-only options");
    cmdline_only.add_options()
      ("version", 
       "Print version string and quit.")
      ("help,h", 
       "Produce short help message and quit.")    
      ("long_help,h", 
       "Produce long help message and quit.")    
      ("input_file,i", 
       po::value< string >(), 
       "Input colortable. Required.")
      ("output_file,o", 
       po::value< string >(), 
       "Output colortable. Required.")
      ("config_file,c", 
       //po::value<string>(&config_file)->default_value("default_slr.config"), 
       po::value<string>(), 
       "Configuration file")
      ;
    
    //
    //
    // Declare a group of options that will be allowed both on command
    // line and in config file
    //
    //
    // Options affecting basic program function
    po::options_description program_options("Options affecting basic program function");
    program_options.add_options()
      ("verbosity,v", 
       po::value< int >()->default_value(1), 
       "Verbosity level, an integer from 0 (silent) to 3 (debug).")
      ("transform_only", 
       po::value< int >()->default_value(0), 
       "Transform photometry using input parameters only? If yes, no regression is performed.")
      ("have_sfd", 
       po::value< int >()->default_value(0), 
       "Are the dust maps of Schegel, Finkbeiner, & Davis (1998) available?")
      ("write_output_file", 
       po::value< int >()->default_value(1), 
       "Write results to the specified output file?")
      ;
    // Options relating to the photometry
    po::options_description photometry_options("Options relating to photometry");
    photometry_options.add_options()
      ("colors2calibrate", 
       po::value< string >(), 
       "The color vector to regress.")
      ("kappa_fix", 
       po::value< string >(), 
       "Fix the corresponding kappa component during regression?")
      ("kappa_guess", 
       po::value< string >(), 
       "The kappa vector used as the initial guess in the regression.")
      ("kappa_guess_err", 
       po::value< string >(), 
       "The kappa error vector. Comma separated list of real numbers.")
      ("kappa_guess_range", 
       po::value< string >(), 
       "The area of kappa parameter space that the numerical fitter should explore.")
      ("colorterms", 
       po::value< string >(), 
       "Colorterms to apply.")
      ("colortermbands", 
       po::value< string >(), 
       "The bands to which the colorterms apply.")
      ("colormult", 
       po::value< string >(), 
       "The colors that the colorterms multiply.")
      ("mags2write", 
       po::value< string >(), 
       "Calibrated magnitudes to write to output file.")
      ("mag_zeropoints", 
       po::value< string >()->default_value("none"), 
       "Comma separated list of colors from which the magnitude zeropoints are derived.")
      ;
    // Options affecting the fitter
    po::options_description fitter_options("Options affecting the fitter");
    fitter_options.add_options()
      ("weighted_residual", 
       po::value< int >()->default_value(1), 
       "Use error-weighted residual as goodness of fit statistic?")
      ("nbootstrap", 
       po::value< int >()->default_value(5), 
       "Number of bootstraps to perform.")
      ;
    // Basic conditions to apply to the data
    po::options_description data_options("Basic conditions to apply to the data");
    data_options.add_options()
      ("type", 
       po::value< int >()->default_value(1), 
       "Type value signifying which are point-sources.")
      ("tmixed", 
       po::value< int >()->default_value(0), 
       "Whether ambiguous --type's should be included in regression.")
      ("deredden", 
       po::value< int >()->default_value(0), 
       "Correct colors and magnitudes for Galactic extinction before fitting? Must --have_sfd.")
      ("cutdiskstars", 
       po::value< int >()->default_value(0), 
       "Cut disk stars before regression? Requires the r band.")
      ("zeelow", 
       po::value< float >()->default_value(0), 
       "Galactic |Z| lower threshold in kpc, used only if --cutdiskstars is set.")
      ("beelow", 
       po::value< float >()->default_value(0), 
       "Galactic |b| lower threshold in deg.")
      ("snlow", 
       po::value< float >()->default_value(0), 
       "Lower threshold on signal-to-noise for each filter used in fit.")
      ("color_min", 
       po::value< float >()->default_value(-50), 
       "Lower threshold on each color, in mag.")
      ("color_max", 
       po::value< float >()->default_value(50), 
       "Upper threshold on each color, in mag.")
      ("mag_min", 
       po::value< float >()->default_value(-50), 
       "Lower threshold on each magnitude, in mag.")
      ("mag_max", 
       po::value< float >()->default_value(+50), 
       "Upper threshold on each magnitude, in mag.")
      ("magerr_floor", 
       po::value< float >()->default_value(0), 
       "Value to add in quadrature to all input magnitude errors.")
      ("max_locus_dist", 
       po::value< float >()->default_value(1), 
       "Maximum hyper-dimensional vector color distance from standard locus line allowable, in mag.")
      ("max_weighted_locus_dist", 
       po::value< float >()->default_value(1), 
       "Maximum error-weighted hyper-dimensional vector color distance from standard locus line allowable, in mag.")
      ;
       
    po::options_description cmdline_options;
    cmdline_options
      .add(cmdline_only)
      .add(program_options)
      .add(photometry_options)
      .add(fitter_options)
      .add(data_options)
      ;

    po::options_description config_file_options;
    config_file_options
      .add(program_options)
      .add(photometry_options)
      .add(fitter_options)
      .add(data_options)
      ;

    po::options_description visible_short("options");
    visible_short
      .add(cmdline_only)
      ;

    po::options_description visible("options");
    visible.add(cmdline_only)
      .add(program_options)
      .add(photometry_options)
      .add(fitter_options)
      .add(data_options)
      ;

    po::positional_options_description p;
    p.add("input_file", 1).add("output_file", 2);

    try
      {
	po::command_line_parser cmd(ac, av);
	store(cmd.
	      options(cmdline_options).positional(p).run(), vm);
      }
    catch(exception& e)
      {
	cout << e.what() << "\n";
	exit(0);
      }    

    cout << "cfg " << vm["config_file"].as<string>() << endl;

    try
      {
	ifstream ifs((vm["config_file"].as<string>()).c_str());
	po::basic_parsed_options<char> cfg = parse_config_file(ifs, config_file_options);
	store(cfg, vm);
      }
    catch(exception& e)
      {
	cout << e.what() << "\n";
	exit(0);
      }    

    notify(vm);

    po::variables_map::iterator iter;
    for(iter = vm.begin(); iter != vm.end(); iter++)
      cout << "*** "<< iter->first << endl;

    
    if (vm.count("help")) {
      cout << "Usage: " << usage1 << "\n";
      cout << "Usage: " << usage2 << "\n\n";
      cout << visible_short << "\n";
      exit(0);
    }

    if (vm.count("long_help")) {
      cout << "Usage: " << usage1 << "\n";
      cout << "Usage: " << usage2 << "\n\n";
      cout << visible << "\n";
      exit(0);
    }

    if (vm.count("version")) {
      cout << "Stellar Locus Regression version 2.0\n";
      exit(0);
    }

  } // try
  catch(exception& e)
    {
      cout  << "slr::options::init: "<< e.what() << "\n";
    }    
}

void slr::options::show(string par)
{
  char* par_is_val;
  if ( par == "verbosity" ) {
    int val = vm[par].as< int >();
    sprintf(par_is_val,"%s = %d\n",par.c_str(),val);
  } else if ( par == "input_file" ) {
    string val = vm[par].as< string >();
    sprintf(par_is_val,"%s = %s\n",par.c_str(),val.c_str());
  } else if ( par == "output_file" ) {
    string val = vm[par].as< string >();
    sprintf(par_is_val,"%s = %s\n",par.c_str(),val.c_str());
  } else if ( par == "config_file" ) {
    string val = vm[par].as< string >();
    sprintf(par_is_val,"%s = %s\n",par.c_str(),val.c_str());
  } else if ( par == "transform_only" ) {
    int val = vm[par].as< int >();
    sprintf(par_is_val,"%s = %d\n",par.c_str(),val);
  } else if ( par == "have_sfd" ) {
    int val = vm[par].as< int >();
    sprintf(par_is_val,"%s = %d\n",par.c_str(),val);
  } else if ( par == "write_output_file" ) {
    int val = vm[par].as< int >();
    sprintf(par_is_val,"%s = %d\n",par.c_str(),val);
  } else if ( par == "colors2calibrate" ) {
    string val = vm[par].as< string >();
    sprintf(par_is_val,"%s = %s\n",par.c_str(),val.c_str());
  } else if ( par == "kappa_fix" ) {
    vector<int> val = vm[par].as< vector<int> >();
    sprintf(par_is_val,"%s = ",par.c_str());
    vector<int>::iterator i;
    for ( i = val.begin(); i != val.end(); i++) {
      sprintf(par_is_val,"%s%d ",par_is_val,*i);
    }
    sprintf(par_is_val,"%s\n",par_is_val);
  } else {
    throw runtime_error("Parameter "+par+" not recognized");
  }

  slr::io::print(1,par_is_val);
}

void slr::options::showAll()
{
  po::variables_map::iterator p;

  for(p = vm.begin(); p != vm.end(); p++) {
    try 
      { 
	show(p->first); 
      }
    catch(exception& e)
      {
	cout << e.what() << "\n";
	//	exit(1);
      }
  }
}

// string slr::options::showAll()
// {
//   po::variables_map::iterator p;

//   string summary;

//   if ( vm["verbosity"].as<int>() >= 1 ) {
//     try 
//       {
// 	if (vm.count("verbosity"))
// 	  {
// 	    char buffer [14];
// 	    sprintf(buffer,"verbosity: %d\n",vm["verbosity"].as< int >());
// 	    summary += buffer;
// 	  }
// 	if (vm.count("input_file"))
// 	  {
// 	    summary += "input_file: " + vm["input_file"].as< string >() + "\n";
// 	  }
// 	else
// 	  {
// 	    throw logic_error("Must specify one input file");
// 	  }
  
// 	if (vm.count("output_file"))
// 	  {
// 	    summary += "output_file: " + vm["output_file"].as< string >() + "\n";
// 	  }
//       }
//     catch(exception& e)
//       {
// 	cout << "slr::options::showAll: " << e.what() << "\n";
//       }
//   } // if verbosity >= 1

//   return summary;
// }

// Validate the overall configuration
void slr::options::validate(string par)
{
  char* errmsg;
  if ( par == "verbosity" ) {
    if ( (int) vm.count(par) == 1 ) {
      int val = vm[par].as< int >();
      if ( val < 0 || val > 3 ) {
	sprintf(errmsg,"Verbosity must be an integer between 0 and 3: %d",val);
	throw runtime_error(errmsg);
      }
    } else {
      throw runtime_error("Must specify verbosity once");
    }
  } else if ( par == "input_file" ) {
    if ( (int) vm.count(par) == 1 ) {
      string val = vm[par].as< string >();
      if ( ! slr::utilities::fileReadable( val ) ) {
	sprintf(errmsg,"Cannot access input file: %s",val.c_str());
	throw runtime_error(errmsg);
      }
    } else {
      throw runtime_error("Must specify one input file");
    }
  } else if ( par == "output_file" ) {
    if ( vm.count(par) == 1 ) {
      string val = vm[par].as< string >();
      if ( ! slr::utilities::fileWriteable( val ) ) {
	sprintf(errmsg,"Cannot access output file: %s",val.c_str());
	throw runtime_error(errmsg);
      }
    } else {
      throw runtime_error("Must specify one output file");
    }
  } else if ( par == "config_file" ) {
    if ( vm.count(par) ) {
      string val = vm[par].as< string >();
      if ( ! slr::utilities::fileReadable( val ) ) {
	sprintf(errmsg,"Cannot access config file: %s",val.c_str());
	throw runtime_error(errmsg);
      }
    } else {
      throw runtime_error("Must specify one config file");
    }
  } else if ( par == "transform_only" ) {
    if ( vm.count(par) ) {
      int val = vm[par].as< int >();
      if ( val != 0 && val != 1 ) {
	sprintf(errmsg,"transform_only must be 0 or 1: %d",val);
	throw runtime_error(errmsg);
      }
    } else {
      throw runtime_error("Must specify transform_only once");
    }
  } else if ( par == "have_sfd" ) {
    if ( vm.count(par) ) {
      int val = vm[par].as< int >();
      if ( val != 0 && val != 1 ) {
	sprintf(errmsg,"have_sfd must be 0 or 1: %d",val);
	throw runtime_error(errmsg);
      }
    } else {
      throw runtime_error("Must specify have_sfd once");
    }
  } else if ( par == "write_output_file" ) {
    if ( vm.count(par) ) {
      int val = vm[par].as< int >();
      if ( val != 0 && val != 1 ) {
	sprintf(errmsg,"write_output_file must be 0 or 1: %d",val);
	throw runtime_error(errmsg);
      }
    } else {
      throw runtime_error("Must specify write_output_file once");
    }
  } else if ( par == "colors2calibrate" ) {
    if ( vm.count(par) ) {
      string val = vm[par].as< string >();
      if ( 0 ) {
	sprintf(errmsg,"colors2calibrate must be : %s",val.c_str());
	throw runtime_error(errmsg);
      }
    } else {
      throw runtime_error("Must specify colors2calibrate once");
    }
  } else {
    throw runtime_error("Parameter "+par+" not recognized");
  }
}

void slr::options::validateAll()
{
  po::variables_map::iterator p;

  for(p = vm.begin(); p != vm.end(); p++) {
    slr::io::print(2,"Validating " + p->first + "... ");
    //    cout << p->first << endl;
    try 
      { 
	validate(p->first); 
	slr::io::print(2,"ok\n");
      }
    catch(exception& e)
      {
	slr::io::print(2,"fail\n");
	cout << e.what() << "\n";
	//	exit(1);
      }
  }
}

// void validateAll2()
// {
//   vector<string> requiredOptions;
//   requiredOptions.push_back("input_file");
//   requiredOptions.push_back("output_file");
//   requiredOptions.push_back("config_file");
//   requiredOptions.push_back("config_file");

//   for (vector<string>::iterator i = requiredOptions.begin(); 
//        i != requiredOptions.end(); 
//        ++i) {
//     string par = *i;
//     slr::io::print(2,"Validating " + par + ": ");
//     try 
//       { 
// 	validate(par); 
//       }
//     catch(exception& e)
//       {
// 	slr::io::print(2,"fail\n");
// 	cout << e.what() << "\n";
// 	exit(1);
//       }
//     slr::io::print(2,"ok\n");
//   }

// }

int slr::options::verbose()
{
  return vm["verbosity"].as< int >();
}

string slr::options::nameOf (int ID)
{
  string name="";
  switch (ID) {
  case verbosity:
    name="verbosity";
    break;
  case input_file:
    name="input_file";
    break;
  case output_file:
    name="output_file";
    break;
  case config_file:
    name="config_file";
    break;
  default:
    char* error_msg;
    sprintf(error_msg,"Don't recognize parameter ID %d",ID);
    throw logic_error(error_msg);
  }
  return name;
}
