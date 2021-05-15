*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

/*
create macro variable with path to directory where this file is located,
enabling relative imports
*/
%let path=%sysfunc(tranwrd(%sysget(SAS_EXECFILEPATH),%sysget(SAS_EXECFILENAME),));

/*
execute data-prep file, which will generate final analytic dataset used to
answer the research questions below
*/
%include "&path.STAT660-01_s21-team-4_data_preparation.sas";

*******************************************************************************;
* Research Question 1 Analysis Starting Point;
*******************************************************************************;
/*
Limitations: There are no missing values or values that are zero in exit and entry
columns.

Methodolgy:Compare Columns Entry, 2009_01 and 2010_01 from Ridership_merged dataset 
using proc means. This will give an output for the means of the two years per station.
Using proc corr and proc sgplot,the results can be visualized.By looking at the mean 
values, it is possible to compare entries for each station. To look for the stations 
with the highest difference between riders, it is useful to look at the sgplot.
Although the percentage increase stayed somewhat stable for these two years,MacArthur 
station such showed a more visible increase in 2010 compared to 2009.
 
Followup Steps: Further analysis such as modeling and regression could be done if data 
has more covariates such as average age of riders per area, breakdown by Male or Female,
etc. to study the usefuleness of bart to different populations. 

Notes: This analyzes the two columns of entries and exits to see which has the 
highest count. 
*/
title1 justify=left
'Question 1 of 3: Which of the stations experienced the highest increase in frequency of entries, between January 2009 and January 2010?';

title2 justify=left 
'Rationale: This question helps us to understand which station is frequented or busy in general, and if there was a significant difference in ridership from 2009 to 2010.';

footnote1 justify=left
'The output shows comparison of summary statistics for riders in 2009 versus 2010.';

footnote2 justify=left 
'Result shows that the stations with the highest mean of Entries are Concord, Glen Park, and Millbrae.';

footnote3 justify=left
'Result shows that most bay area commuters reside in opposite parts. The assumption is that entries on average represent city residents.';

footnote4 justify=left
'The result and the assumption makes sense since Concord and Glen Park are largely residential and suburban areas.';

proc means 
    data=Ridership
    maxdec=1
    missing
    n /* number of observations */
    nmiss /* number of missing values */
    min q1 median q3 max  /* five-number summary */
    mean std /* two-number summary */
  ;
    class
      Entry;
    var 
      Ride0901 Ride1001 
  ;
    output out=Ridership_output1;
run;
title;
footnote;

/*data visualization to study question number one */
title "Plot of Riders in 2009 vs 2010";
footnote "The output shows that stations GlenPark, 24th and 16th showed a decrease in ridership in 2010";
proc sgplot data=Ridership_output1;
    hbox Ride0901 /category=Entry boxwidth=0.8 NOOUTLIERS GROUPDISPLAY=CLUSTER;
    hbox Ride1001 /category=Entry boxwidth=0.8 NOOUTLIERS GROUPDISPLAY=CLUSTER; 
  ;
run;
title;
footnote;

*******************************************************************************;
* Research Question 2 Analysis Starting Point;
*******************************************************************************;

/*
Limitations: There are no missing values or values that are zero in exit and entry
columns.

Methodolgy: Compare Columns Entry, 2020_01 and 2021_01 from Ridership_merged dataset 
using proc means. To look at the changes, using proc sgplot can help us visualize
the difference. proc sgplot supports result from procmeans. 

Followup Steps: Since this was a peculiar time, further analysis can be done per station.
For example, areas showing the highest changes can be looked at further, given additional
information on riders.

Notes: This analyzes the two columns of entries and exits to see which has the 
highest count. 
*/
title1 justify=left
'Question 2 of 3: Which of the stations experienced the highest decrease in frequency of entries, between January 2020 and January 2021?';

title2
'Rationale: To see how Covid-19 affected Bart Ridership during State of Emergency.';

footnote1 justify=left
'The output shows comparison of riders in January of 2020 versus January of 2021.';

footnote2 justify=left 
'Result shows that all stations sharply decreased in riders in January of 2021 but Montgomery street,Embarcadero and Concord showed the most significant changes.';

footnote3 justify=left
'Result reflect stay at home, work from home and quarantine interventions with the advent of COVID-19.';

proc means 
    data=Ridership
    maxdec=1
    missing
    n /* number of observations */
    nmiss /* number of missing values */
    min q1 median q3 max  /* five-number summary */
    mean std /* two-number summary */
  ;
    class
      Entry;
    var 
      Ride2001 Ride2101 
  ;
    output out=Ridership_output2;
run;
title;
footnote;

/*data visualization to study question number two */
title "Comparison of Riders in 2020 vs 2021";
footnote "Result shows that all stations sharply decreased in riders in January of 2021 but Montgomery street,Embarcadero and Concord showed the most significant changes.";

proc sgplot data=Ridership_output2;
    hbox Ride2001 /category=Entry boxwidth=0.8 NOOUTLIERS GROUPDISPLAY=CLUSTER;
    hbox Ride2101 /category=Entry boxwidth=0.8 NOOUTLIERS GROUPDISPLAY=CLUSTER; 
  ;
run;
title;
footnote;

*******************************************************************************;
* Research Question 3 Analysis Starting Point;
*******************************************************************************;

/*
Limitation: Any values that are missing or duplicates should be excluded from 
data analysis.

Methodology: Using proc corr, we can study the relationship amongst the four years. 
Each of the years are seen as an independent variable.  

Followups Steps: Output shows that the correlation procedure is not ideal for
our categories dataset. Further analysis can be done using time series analysis
to get a more vivid picture of the trend.

Notes: This looks at the correlation amongst the four columns. 
*/
title1 justify=left
'Question 3 of 3: Can the Exit station with the highest number of riders in 2009 be used to predict the following year trend?';

title2 justify=left
'Rationale: This could help us understand whether or not people move around within the bay area for work as well as for residence.';

footnote1 justify=left
'Results of correlation procedure show there is not a strong correlation between 2009 and 2010 ridership, where as 2020 and 2101 not.';

footnote2 justify=left 
'The results somewhat make sense although the trends between 2009 and 2010 are very similar,there is not a linear relationship between the years.';
title;
footnote;

/*correlation coefficient to look at trend amongst the four years*/
title "Ridership Correlation of Four Years";
footnote 'The results somewhat make sense although the trends between 2009 and 2010 are very similar,there is not a linear relationship between the years.';
proc corr data= Ridership outp=correlation_output;
run;
proc print data=correlation_output;proc print;run;
title;
footnote;
