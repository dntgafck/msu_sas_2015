filename txt1 "~/ones_flew.txt";

data result;
	length word $ 200;
	*format word ;
	infile txt1 dlm=" ,.():;-[]?""";
	input word@@;
run;
 
proc freq data=result noprint;
	tables word/out=count;
run;

proc sort data=count;
	by DESCENDING count;
run;

data most_freq_words(keep=word count);
	set count;
	if _n_<=50 then output;
	else stop;
run;

proc print data=most_freq_words;run;

data collocations;
	length coll $ 200;
	infile txt1 dlm=",.():;-[]?""";
	input coll@@;
run;

data couples(keep=coup);
	set collocations;
	del = " ";
	modif = "i";
	cnt=countw(coll, del, modif);
	do i = 1 to cnt-1;
		cur = scan(coll, i, del, modif);
		next = scan(coll, i + 1, del, modif);
		put i cur next;
  		coup = lowcase(cur || " " || next);
  		output;
  	end;
run;

proc freq data=couples noprint;
	tables coup/out=couples_count;
run;

proc sort data=couples_count;
	by DESCENDING count;
run;

proc print data=couples_count;run;
 /*найти 50 самых часто встречающихся слов*/
 /*найти 50 самых часто встречающихся букв*/
 /*найти 50 самых часто встречающихеся словосочетаних 
 (из двух следующих друг за другом слов) */