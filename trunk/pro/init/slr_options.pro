function slr_options

;+
; Set default global options.
;-

  option=create_struct(       "use_cal",'')
  option=create_struct(option,"use_raw",'')
  option=create_struct(option,"use_ir",0)
  option=create_struct(option,"postscript",0)
  option=create_struct(option,"plot",1)
  option=create_struct(option,"interactive",1)
  option=create_struct(option,"animate_regression",0)
  option=create_struct(option,"weighted_residual",1)
  option=create_struct(option,"verbose",1)
  option=create_struct(option,"debug",0)
  option=create_struct(option,"do_hard_ones",1)
  option=create_struct(option,"get_color_offset",1)
  option=create_struct(option,"get_color_terms",0)
  option=create_struct(option,"match_objects",1)
  option=create_struct(option,"cut_outliers",0)
;  option=create_struct(option,"instrument",instrument)

  option=create_struct(option,"simulate",0)
  option=create_struct(option,"sample_study",0)
  option=create_struct(option,"max_sample_size",-1)
  option=create_struct(option,"nbootstrap",0)
;  option=create_struct(option,"cutranges",~option.simulate)
  option=create_struct(option,"cutranges",0)
  option=create_struct(option,"basis",1)
  option=create_struct(option,"minimizer",0)
  option=create_struct(option,"line_fittype",3)
  option=create_struct(option,"dist_fittype",0)
  option=create_struct(option,"nbins",25)
  option=create_struct(option,"startfrac",0.1)
  option=create_struct(option,"stopfrac",1.0)
  option=create_struct(option,"fitimp_thresh",0.4)

return,option

end
