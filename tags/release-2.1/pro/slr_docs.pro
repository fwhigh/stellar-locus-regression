pro slr_docs

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
;  slr_docs
;
; PURPOSE:
;  Make this documentation automatically.
;
; EXPLANATION:
;  Searches for all *.pro files and compiles an HTML documentation
;  page from their headers.
;
; CALLING SEQUENCE:
;  slr_docs
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

install_dir=getenv('SLR_INSTALL')
outfile=install_dir+path_sep()+'docs'+path_sep()+'www'+$
        path_sep()+'idl_help.html'

make_html_help,$
   file_search(install_dir+path_sep()+'pro','*.pro'),$
   outfile,title='IDL Help for Stellar Locus Regression',$
   /strict,/verbose,/link
    

end
