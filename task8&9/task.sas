options nosymbolgen;
%let ncol=%sysfunc(rand(UNIFORM));
%let ncol=%sysevalf(&ncol.*10.+4.,integer);
%put &ncol;
data wide_table;
drop i;
array col{&ncol};
do j=1 to 10;
do i=1 to &ncol;
   col{i}=rand('uniform');
   if (rand('uniform')<0.2) then col{i}=.;
end;
output;
end;
run;
%symdel ncol;

%let dim_even = 0;
%let dim_odd = 0;

data _null_;
	retain e_cnt 0;
	retain o_cnt 0;
	set sashelp.vcolumn;
	tmp = substr(name, 1, 3);
	if memname="WIDE_TABLE" AND tmp="col" then
	do;
		i = substr(name, 4);
		if mod(i, 2) = 0 then 
			do;
				e_cnt = e_cnt + 1;
				call symput(catt("", "even",e_cnt), name);
				call symput("dim_even", e_cnt);
			end;
		else 
			do;
				o_cnt = o_cnt + 1;
				call symput(catt("","odd",o_cnt), name);
				call symput("dim_odd", o_cnt);
			end;
	end;
run;

%macro sum_even;
	e_sum = 0;
	%do i = 1 %to &dim_even;
		e_sum = e_sum + coalesce(&&even&i, 0);
	%end;
%mend;

%macro avg_odd;
	o_avg = 0;
	o_cnt = 0;
	%do i = 1 %to &dim_odd;
		o_avg = o_avg + coalesce(&&odd&i, 0);
		if &&odd&i ^= . then o_cnt = o_cnt+1;
	%end;
	if o_cnt ^= 0 then o_avg=o_avg/o_cnt;
%mend;

data result(keep=e_sum o_avg);
	set wide_table;
	%avg_odd;
	%sum_even;
run;

%macro avg_even; 
	%do i = 1 %to &dim_even;
		if _n_ = 1 then do;
			call symput(catt("","avg_even", &i), 0);
			call symput(catt("","cnt_even", &i), 0);
		end;
		tmp = symget(catt("","avg_even", &i)) + coalesce(&&even&i, 0);
		call symput(catt("","avg_even", &i), tmp);
		if &&even&i ^= . then call symput(catt("","cnt_even", &i), symget(catt("","cnt_even", &i)) + 1);
		put tmp;
	%end;
%mend;

%macro odd_hsum;
	%do i = 1 %to &dim_odd;
		if _n_=1 then do;
			call symput(catt("","min_odd",&i), &&odd&i);
			call symput(catt("","max_odd",&i), &&odd&i);
		end;
		if symget(catt("","min_odd",&i)) > &&odd&i then call symput(catt("","min_odd",&i), &&odd&i);
		if symget(catt("","max_odd",&i)) < &&odd&i then call symput(catt("","max_odd",&i), &&odd&i);
	%end;
%mend;

%macro imput_even;
	%do i = 1 %to &dim_even;
		if &&even&i = . then do;
			if &&cnt_even&i > 0 then &&even&i=&&avg_even&i/&&cnt_even&i;
			else &&even&i = 0;
		end;
	%end;
%mend;

%macro imput_odd;
	%do i = 1 %to &dim_odd;
		if &&odd&i = . then do;
			min_v = &&min_odd&i;
			max_v = &&max_odd&i;
			if min_v = . then min_v=0;
			if max_v = . then max_v=0;
			&&odd&i = (min_v + max_v)/2;
		end;
	%end;
	drop min_v max_v;
%mend;

data _null_;
	set wide_table;
	put _n_;
	%avg_even;
	%odd_hsum;
run;

data imputed_result;
	set wide_table;
	%imput_even;
	%imput_odd;
run;
			
proc print data=wide_table;run;

proc print data=result;run;

proc print data=imputed_result;run;


