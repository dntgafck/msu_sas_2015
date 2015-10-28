data emps2008;
	set ecprg1.emps2008;
	length country $ 10;
	output;
run;

data emps2009;
	set ecprg1.emps2009;
	length country $ 10;
	output;
run;

data emps2010;
	set ecprg1.emps2010;
	output;
run;

proc append base=emps2008 data=emps2009;run;

proc append base=emps2008 data=emps2010;run;

proc sort data=emps2008 out=ecprg1.emps2008;
	by HireYear;
run;

proc print data=ecprg1.emps2008; run;