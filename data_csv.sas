/* input a CSV file */
proc import out=data_csv
datafile = “C:\Users\lei.fang\Desktop\MortEval_SSM\AUS_DNK_DEU.csv”
dbms=csv replace; getnames=yes; datarow=32746;
run;

proc print data=data_csv;
run;

data data_csv;
lfr = log(Female);
lmr = log(male);
lmt = log(total);
array ageArray{110} a1-a110;
do i=1 to 110;
     ageArray[i] = (age=i);  
end;

/*
proc freq data=mort;
   where Country='AUS';
   table age;
run;
proc freq data=mort;
   where Country='DNK';
   table age;
run;
proc freq data=mort;
   where Country='DEU';
   table age;
run;
*/
data aus;
  set data_csv;
  where Country='AUS';
run;
data dnk;
  set data_csv;
  where Country='DNK';
run;
data deu;
  set data_csv;
  where Country='DEU';
run;

proc sort data=deu;
   by year age;
run;
