/*-=-=-=-=-=-=-=-=-=-=-=-=*/
/*-=-=-=-=Home work-=-=-=-*/
/* Task 1. upload and import anything from internet*/
filename csv url "http://www.stat.uni-muenchen.de/service/datenarchiv/kredit/kredit.asc";
/* take a look at what's there*/
data _null_;
   infile csv length=len;
   input record $varying200. len;
   put record $varying200. len;
   if _n_=15 then stop;
run;

PROC IMPORT DATAFILE=CSV
		    OUT=WORK.MYCSV
		    DBMS=CSV
		    REPLACE;
		    DELIMITER=" ";
		    GETNAMES=yes;/*by default*/
RUN;

PROC PRINT DATA=WORK.MYCSV(obs=10); RUN;

FILENAME CSV;