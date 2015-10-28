%macro first_macro(l, s);
	cnct = &l || "- " || &s;
%mend;

data task7_report;
	set ecprg1.lookup_country;
	%first_macro(label, start);
	output;
run;

proc print data=task7_report;run;
	