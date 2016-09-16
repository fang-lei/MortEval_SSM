proc iml;
    use deu;
    read all var {age} into x;
    bsp = bspline(x, 2, ., 4);
    create spline var{c1 c2 c3 c4 c5 c6 c7};
    append from bsp;
 quit;
 data deu;
    merge deu spline;
 run;

%macro makeTerm;
   %do i=1 %to 110;
      %str( a&i + )
   %end;
%mend;
%let term = %makeTerm;

proc ssm data=deu plot=ao;
  id year;
  parms v1-v7 0.001;
  lambda = v1*c1 + v2*c2 + v3*c3 + v4*c4
       + v5*c5 + v6*c6 + v7*c7;
  if age=0 then lambda=1;
  parms lvar2;
  parms av1-av7;
  var1 = exp(av1*c1 + av2*c2 + av3*c3 + av4*c4
       + av5*c5 + av6*c6 + av7*c7);
  
  var2 = exp(lvar2);
  state slate(1) T(I) W(I) cov(d)=(var2) A1(1);
  comp beffect = (lambda)*slate[1];
  comp latent = slate[1];
  
  irregular wn variance=var1;
  model lmr = a1-a110 beffect wn;
  eval mpattern = &term beffect;
  output out=deuFor press pdv;
run;
proc sgplot data=deuFor;
   where age=10;
   series x=year y=smoothed_beffect;
run;
proc sgplot data=deuFor;
   where year=2000;
   series x=age y=lambda;
run;

proc sgplot data=deuFor;
   where age=10;
   series x=year y=smoothed_latent;
run;

proc sgplot data=deuFor;
   where age=10;
   series x=year y=smoothed_mpattern;
   scatter x=year y= lmr;
run;

proc iml;
    use dnk;
    read all var {age} into x;
    bsp = bspline(x, 2, ., 4);
    create spline var{c1 c2 c3 c4 c5 c6 c7};
    append from bsp;
 quit;
 data dnk;
    merge dnk spline;
 run;
proc ssm data=dnk plot=ao;
  id year;
  parms v1-v7 0.001;
  lambda = v1*c1 + v2*c2 + v3*c3 + v4*c4
       + v5*c5 + v6*c6 + v7*c7;
  if age=0 then lambda=1;
  parms lvar2;
  parms av1-av7;
  var1 = exp(av1*c1 + av2*c2 + av3*c3 + av4*c4
       + av5*c5 + av6*c6 + av7*c7);
  
  var2 = exp(lvar2);
  state slate(1) T(I) W(I) cov(d)=(var2) A1(1);
  comp beffect = (lambda)*slate[1];
  comp latent = slate[1];
  
  irregular wn variance=var1;
  model lmr = a1-a110 beffect wn;
  eval mpattern = &term beffect;
  output out=dnkFor press pdv;
run;

proc iml;
    use aus;
    read all var {age} into x;
    bsp = bspline(x, 2, ., 4);
    create spline var{c1 c2 c3 c4 c5 c6 c7};
    append from bsp;
 quit;
 data aus;
    merge aus spline;
 run;
proc ssm data=aus plot=ao;
  id year;
  parms v1-v7 0.001;
  lambda = v1*c1 + v2*c2 + v3*c3 + v4*c4
       + v5*c5 + v6*c6 + v7*c7;
  if age=0 then lambda=1;
  parms lvar2;
  parms av1-av7;
  var1 = exp(av1*c1 + av2*c2 + av3*c3 + av4*c4
       + av5*c5 + av6*c6 + av7*c7);
  
  var2 = exp(lvar2);
  state slate(1) T(I) W(I) cov(d)=(var2) A1(1);
  comp beffect = (lambda)*slate[1];
  comp latent = slate[1];
  
  irregular wn variance=var1;
  model lmr = a1-a110 beffect wn;
  eval mpattern = &term beffect;
  output out=ausFor press pdv;
run;
