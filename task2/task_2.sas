%let n = 4;

data permutations (drop=x position_m);
	array result{&n} $ 10;

	do position_m = 1 to &n;
		result[position_m] = position_m;
	end;
 
	do x = 1 to fact(&n);
		call allperm(x, of result[*]);
		output;
	end;
run;