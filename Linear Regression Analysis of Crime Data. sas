/*
The County Demographic Information (CDI) data set available in Appendix C of the book, Applied Linear Regression 
Models Fourth Edition by Kutner et al., was used to explore the total number of serious crimes in 440 U.S. counties for 
the years of 1990 and 1992 in relation to 18 other demographic variables. The CDI data set has a total of 440 observations 
representing some of the most populous counties in the United States. Counties with missing data were not included in the 
data set. There are 17 continuous variables and 1 categorical variable (Geographic region).

The main goal of this study is to create the best multiple linear regression model that can be used to predict the total number 
of serious crimes based upon the values of the independent variables.
*/


ods rtf file = '/folders/myfolders/Stat610/Project/CDI_results.rtf' startpage=never;

option ls=80 ps=80 nodate;

* Input the data;
data a0;
length IdenNum $4 Country $20 State $4;
infile '/folders/myfolders/Stat610/Project/CDI.txt' dlm=' ';
input IdenNum Country State LandArea TotPopu PerPopu1834 PerPopu60 
      ActNum BedNum Totcrime PerHigh PerBach PerPover PerUnemploy CapIncome TotIncome GRegion;
popuden=TotPopu/LandArea;
NE=0;
NC=0;
S=0;
run;

data a;
set a0;
if GRegion=1 then NE=1;
if GRegion=2 then NC=1;
if GRegion=3 then S=1;
run;

proc print data=a ;
run;

proc means data=a n mean median std min max range;
run;

* check the nomality;
proc sgscatter data=a;
matrix Totcrime LandArea TotPopu popuden PerPopu1834 PerPopu60 ActNum BedNum  PerHigh PerBach 
       PerPover PerUnemploy CapIncome TotIncome GRegion/diagonal=(histogram kernel normal);
quit;
/* Here we can see there is inverse relationship between Totcrime and LandArea, 
so we introduce the new variable popuden*/

*check the association between each two variables;
ods select VarInformation PearsonCorr;
proc corr data=a;
var Totcrime popuden PerPopu1834 PerPopu60 ActNum BedNum  PerHigh PerBach 
    PerPover PerUnemploy CapIncome TotIncome GRegion;
run;
/* ActNum BedNum TotIncome have high correlation with each other; PerHigh has high correlation with PerBach*/

*check the multicollinearity;
proc reg data=a; *this is full model;
model Totcrime=popuden PerPopu1834 PerPopu60 ActNum BedNum PerHigh PerBach 
    PerPover PerUnemploy CapIncome TotIncome GRegion/vif;
run;
quit;
/* ActNum BedNum TotIncome have the high vif*/
/* remove the ActNum BedNum PerBach*/

*check the ouliers;
proc reg data=a;
model Totcrime=popuden PerPopu1834 PerPopu60 PerHigh 
    PerPover PerUnemploy CapIncome TotIncome GRegion/p r influence;
run;
quit;

* remove the outlier;
* data a1;
* set a;
* if IdenNum=6 then delete;
* run;

* check the outlier again;
proc reg data=a;
model Totcrime=popuden PerPopu1834 PerPopu60 PerHigh
    PerPover PerUnemploy CapIncome TotIncome GRegion/p r influence;
run;
quit;

* choose the predictor;
*ods select NObs SubsetSelSummary ;
proc reg data=a;
model Totcrime=popuden PerPopu1834 PerPopu60 PerHigh
    PerPover PerUnemploy CapIncome TotIncome NE NC S/selection=adjrsq cp AIC;
run;
quit;
