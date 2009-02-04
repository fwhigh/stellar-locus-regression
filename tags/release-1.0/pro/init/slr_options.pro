function slr_options

;$Rev::               $:  Revision of last commit
;$Author::            $:  Author of last commit
;$Date::              $:  Date of last commit
;
; Copyright 2009 by F. William High.
;
; This file is part of Stellar Locus Regression (SLR).
;
; SLR is free software: you can redistribute it and/or modify it under
; the terms of the GNU General Public License as published by the Free
; Software Foundation, either version 3 of the License, or (at your
; option) any later version.
;
; SLR is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
; License for more details.
;
; You should have received a copy of the GNU General Public License
; along with SLR.  If not, see <http://www.gnu.org/licenses/>.
;
;+
; NAME:
;  slr_options
;
; PURPOSE:
;  Return a structure containing the default global options.
;
; EXPLANATION:
;  It's always nice to have common options set in one place.
;  This is that place.  This does NOT make use of common blocks, but
;  rather returns a structure which must be passed to and recognized
;  by the SLR subroutines.
;
; CALLING SEQUENCE:
;  options=slr_options()
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;
; OPIONAL OUTPUTS:
;       
; NOTES:
;
; EXAMPLES:
;
; PROCEDURES USED:
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

  option=create_struct(       "use_cal",'')
  option=create_struct(option,"use_raw",'')
  option=create_struct(option,"use_ir",1)
  option=create_struct(option,"postscript",0)
  option=create_struct(option,"plot",1)
  option=create_struct(option,"interactive",0)
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
