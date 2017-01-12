/* test */
proc sgplot data=_temp0.deuformort;
   where age=99;
   series x=year y=smoothed_beffect;
run;




/* mortality surface*/
proc g3d data=_temp0.combined3; /* the proc g3d is unavailable in SAS studio*/
   plot Year*Age=lmr;  
run;

/* alternative way of making 3d plot in SAS */
/* define plot surface function with GTL */
proc template;                        /* surface plot with continuous color ramp */
define statgraph SurfaceTmplt;
dynamic _X _Y _Z _Title;              /* dynamic variables */
 begingraph;
 entrytitle _Title;                   /* specify title at run time (optional) */
  layout overlay3d;
    surfaceplotparm x=_X y=_Y z=_Z /  /* specify variables at run time */
       name="surface" 
       surfacetype=fill
       colormodel=threecolorramp      /* or =twocolorramp */
       colorresponse=_Z;              /* prior to 9.4m2, use SURFACECOLORGRADIENT= */
    continuouslegend "surface";
  endlayout;
endgraph;
end;
run;

/* male mortality surface*/
proc sgrender data=_temp0.combined3 template=SurfaceTmplt; 
   dynamic _X='Year' _Y='Age' _Z='lmr' _Title="Male Mortality Surface";
run;

/* female mortality surface*/
proc sgrender data=_temp0.combined3 template=SurfaceTmplt; 
   dynamic _X='Year' _Y='Age' _Z='lfr' _Title="Female Mortality Surface";
run;





/* GDP growth */
proc gplot data=_temp0.combined3; /* the proc gplot is unavailable in SAS studio  */
      plot lgdp*Year=1
           lgdp*Year=2     / overlay
                             haxis=axis1
                             vaxis=axis2;
      title  'GDP Growth';
      axis1 offset=(1 cm) label=('Year');
      axis2 label=(angle=90 'GDP per Capita');
      symbol1 i=join l=1 c=red;
      symbol2 h=2 pct v=star c=blue;
run;
quit;
title;

/* alternative way of making GDP plot*/ 
/* GDP and health data*/  
proc sgplot data=_temp0.combined3;
  xaxis type=discrete;
  series x=year y=lgdp;
  yaxis LABEL= "Log GDP per Capita (lgdp) ";
  series x=year y=lhealth / y2axis;
  y2axis LABEL= "Log Health Expenditures per Inhabitant (lhealth) ";
run;

/* GDP growth and health share data*/ 
proc sgplot data=_temp0.combined3;
  xaxis type=discrete;
  series x=year y=GDPpercapitagrowth;
  yaxis LABEL= "GDP per Capita Growth (%)";
  series x=year y=healthingdp / y2axis;
  y2axis LABEL= "Share of Health Expenditures in GDP (healthingdp, %) ";
run;







/* mixed effect model by years*/
proc sort data=_temp2.deuformixedyearsim;  /* sort the data by year */
   by year;
run;
proc sgplot data=_temp2.deuformixedyearsim;
   title "Confidence Band for Year Effect";
   where a99=1; /* year efffect on age group 99*/
   band x=year lower=smoothed_lower_year_d upper=smoothed_upper_year_d /
       legendlabel="95% Confidence Band" name="band1";
   scatter x=year y=forecast_year_d;
   series x=year y=smoothed_year_d / lineattrs=GraphPrediction
       legendlabel="Smoothed Effect" name="series";
   yaxis LABEL= "Year Effect";
   keylegend "series" "band1" / location=inside position=bottomright;
run;

proc sgplot data=_temp2.deuformixedyearsim;
   title "Confidence Band for Year Effect";
   where a10=1; /* year efffect on age group 10*/
   band x=year lower=smoothed_lower_year_d upper=smoothed_upper_year_d /
       legendlabel="95% Confidence Band" name="band1";
   scatter x=year y=forecast_year_d;
   series x=year y=smoothed_year_d / lineattrs=GraphPrediction
       legendlabel="Smoothed Effect" name="series";
   yaxis LABEL= "Year Effect";
   keylegend "series" "band1" / location=inside position=bottomright;
run;

/* year effect surface*/
proc sort data=_temp2.combined3;  /* sort the deu data by year and age */
   by lgdp;
run;

proc sort data=_temp2.deuformixedyearsim;  /* sort the deu data by year and age */
   by lgdp;
run;

data temp1;
merge _temp2.combined3 _temp2.deuformixedyearsim;
by lgdp;
run;

proc sgrender data=temp1 template=SurfaceTmplt; 
   dynamic _X='Year' _Y='Age' _Z='smoothed_year_d' _Title="Year Effect Surface";
run;







/* mixed effect model by age*/
proc sort data=_temp3.deuformixedagesim;  /* sort the data by year */
   by year;
run;
proc sgplot data=_temp3.deuformixedagesim;
   title "Confidence Band for Age Effect";
   where year=2010;
   band x=age lower=smoothed_lower_age_d upper=smoothed_upper_age_d /
       legendlabel="95% Confidence Band" name="band1";
   /* scatter x=age y=forecast_age_d; */
   series x=age y=smoothed_age_d / lineattrs=GraphPrediction
       legendlabel="Age Effect" name="series";
   yaxis LABEL= "Age Effect";
   keylegend "series" "band1" / location=inside position=bottomright;
run;

proc sgplot data=_temp3.deuformixedagesim;
   title "Confidence Band for Age Effect";
   where year=1993;
   band x=age lower=smoothed_lower_age_d upper=smoothed_upper_age_d /
       legendlabel="95% Confidence Band" name="band1";
   /* scatter x=age y=forecast_age_d; */
   series x=age y=smoothed_age_d / lineattrs=GraphPrediction
       legendlabel="Age Effect" name="series";
   yaxis LABEL= "Age Effect";
   keylegend "series" "band1" / location=inside position=bottomright;
run;

/* age effect surface*/
proc sgrender data=_temp3.deuformixedagesim template=SurfaceTmplt; 
   dynamic _X='Year' _Y='Age' _Z='smoothed_age_d' _Title="Age Effect Surface";
run;


