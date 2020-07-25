/*
The dataset “Graduate Admissions” is inspired by the UCLA Graduate Dataset and owned by Mohan S Acharya. 

The dataset contains several parameters which are considered important during the application for Masters Programs. The variables included are: 
1. GRE Scores (out of 340, continuous)
2. TOEFL Scores (out of 120, continuous) 
3. University Rating (out of 5, categorical) 
4. Statement of Purpose(out of 5, categorical)
5. Letter of Recommendation Strength (out of 5, categorical) 
5. Undergraduate GPA (out of 10, continuous) 
6. Research Experience (either 0 or 1, categorical) 
7. Probability of being Admitted (ranging from 0 to 1, continuous)

According to its owner, the dataset was built with the purpose of helping international students in shortlisting universities with their profiles. 
This is also our intention that optimizing the discriminant models so that the predicted output could give those students a fairly good idea about 
their chances for a particular university.
*/

ods rtf file = 'C:\Users\rveramonroy\Desktop\STAT 520\projectdraft_allvarbadstu.rtf';

data original;
infile 'C:\Users\rveramonroy\Desktop\STAT 520\badstu.csv'
     delimiter=','
     missover
     firstobs=2
     DSD
     LRECL=32767;
input OBS GRE TOEFL UNI SOP LOR CGPA RES ADMIT;
run;

proc print data =orignal;
run;

proc sort data=original;
by OBS;
run;

proc surveyselect data=original outall SEED=14786557
   method=srs n=400 out=original2;
run;

DATA train;
    SET original2;
    IF (Selected = 0) THEN DELETE;
RUN;

proc print data=train;
run;

DATA test;
    SET original2;
    IF (Selected = 1) THEN DELETE;
RUN;

proc print data=test;
run;

proc print data = train;
run;

proc sort data=train;
by OBS;
run;

%include "C:\Users\rveramonroy\Desktop\STAT 520\multinorm_macro.sas";
%multnorm(data=train, var=GRE TOEFL UNI SOP LOR CGPA RES);


proc means data = train maxdec=3;
class ADMIT;
var GRE TOEFL UNI SOP LOR CGPA RES;
run;

proc sgscatter data = train;
matrix GRE TOEFL UNI SOP LOR CGPA RES/group = ADMIT diagonal=
(histogram normal);
run;

* Model 1/2/3
proc discrim data=train outstat=astat out=trainout testdata=test testout=testout1
method=normal pool=test manova listerr crosslisterr;
class ADMIT; var GRE TOEFL UNI SOP LOR CGPA RES; 
priors prop;
run;

* Model 4
proc discrim data=train outstat=astat out=trainout testdata=test testout=testout1
method=normal pool=test manova listerr crosslisterr;
class ADMIT; var GRE TOEFL CGPA; 
priors prop;
run;

*Model 5
proc discrim data=train outstat=astat out=trainout testdata=test testout=testout1
method=npar k=3 manova listerr crosslisterr;
class ADMIT; var GRE TOEFL UNI SOP LOR CGPA RES; 
priors prop;
run;

proc print data=testout1;
run;

ods rtf close;
