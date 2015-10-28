data random;
	do x=1 to 100;
	y=1+x/10+3*sin(x*20);
	output;
	end;
run;

proc sgplot;
	series x=x y=y;
run;

data filtered(keep=med_x med_y);
	set random nobs=n;
	cur = _n_;
	array pts_x {8} _temporary_;
	array pts_y {8} _temporary_;
	do ix = 1 to 8;
		px = _n_ - 4 + ix;
		if px < 1 then px = 1;
		if px > n then px = n;
		set random point=px;
		pts_x{ix} = x;
		pts_y{ix} = y;
	end;
	med_x = median(of pts_x{*});
	med_y = median(of pts_y{*});
run;

proc sgplot data=filtered;
	series x=med_x y=med_y;
run;
	