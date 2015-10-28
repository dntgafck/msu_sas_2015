FILENAME REFFILE "/folders/myshortcuts/sas/pract/task1/task_1.xls" TERMSTR=CR;

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=mylib.task_1;
	GETNAMES=YES;
RUN;

data mylib.task_1_res (keep=mean_x mean_y);
	retain cnt 0;
	retain mean_x 0;
	retain mean_y 0;
	set mylib.task_1;
	cnt = cnt + 1;
	mean_x = mean_x + A;
	mean_y = mean_y + B;
	if mod(cnt,4)=0 or (last and cnt ne 0) then do;
		mean_x = mean_x / 4;
		mean_y = mean_y / 4;
		output;
		mean_x = 0;
		mean_y = 0;
		cnt = 0;
	end;
run;
	
proc sgplot data=mylib.task_1_res;	
	scatter y=mean_y x=mean_x;
run;
	