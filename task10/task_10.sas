%let library_name = ecprg1;
%let tbl_name = &library_name%nrstr(.country);

%macro check_errors;
	%if &SYSERR gt 0 %then %do;
		%put ERROR: An error occured while executing data step;
	%end;
%mend;

%macro data_step;
  %if (%sysfunc(libref(&library_name))) %then %do;
  	%put %sysfunc(sysmsg());
  %end;
  %else %do;
  	data _null_;
  		set &tbl_name;
  		put 123;
  	run;
  	%check_errors;
  %end;
%mend;

%data_step;

