**# CHANGELOG
*Added more logarithmic variables.
*Added regression for logarithmic variables
*Added fixed effects regression and logarithmic variables.
*Changed labels for country variable values.
*Added variables delta_loghousehold and delta_logpublic
*Added spmap graphs.
*Removed debt/GDP ratio variables, logarithms, and consequent maps (too far from the question of interest).

**# Introduction
/*
The analysis contained in this do-file focuses on the empirical verification of Ricardian equivalence, a macroeconomic theory according to which an increase in government spending is always offset by an increase in consumer savings, with the expectation that the new public spending will have to be repaid with new taxes in the future. In particular, the intuition behind this research is as follows: if a nation's public debt increases, then the aggregate effect on private debt must be negative (and therefore decreases). I verify this idea using EUROSTAT data on the Euro Area from 2001 to 2021. It also takes into account and controls for other variables, such as the number of working-age and over-65 people, the interest rate, and inflation. Furthermore, the model takes into account fixed effects and any heteroscedasticity of the error, as well as any recession years (defined as years in which GDP contracted compared to the previous year).

The main assumption is that the effect between the variables is linear. It is verified through the use of logarithms of public and private debt and a possible time lag.

The results find that public debt, in logarithmic form or not, does not show significance on private debt except in the early stages of the regression, without any control variables.

There is significance of the working-age population on private debt in every regression except 4 and 5. The logarithm of disposable income is also significant in regressions 4 and 5.

When introduced, the recession dummy has a significantly positive effect on private debt, leading to an increase in debt.

In addition to the regression results tables, the average growth of public and private debt throughout the euro area is also shown, using SPMAP and geographic coordinates.

*/

**# PRELIMINARY OPERATIONS - Cleaning and project setup----------------

*First of all, we clean any data that is in memory, from datasets to all temporary files in memory.
clear all

*We close any log and cmdlog, if they are open. Using cap before the command, we inform stata not to block the do file if the command does not succeed, as happens when there is no log or cmdlog file open. We use log to record the result of the commands we have in the do-file, and it is one of the best practices when using STATA.
cap cmdlog close
cap log close

*We set our working folder, i.e., the folder that Stata will automatically use for the project when we do not specify the file path to use:

cd "I:\Econometria\Progetto-Vivera"

*From here, we set log and cmdlog
cap cmdlog using CMDlog-econometria, replace
cap log using log-econometria, replace

**#Database Definition.-------------------------------------------------------
*All data comes from Eurostat. Each dataset will have notes on any new variable

//Database 1 - Private debt. -------------------------------------------------
*We import the csv data into STATA
import delimited "I:\Econometria\Progetto-Vivera\Dati\csv2\Household debt, consolidated, 1995-2022- %GDP1.csv"
*There are several variables that are not useful for our analysis, so we remove them.
keep geo time_period obs_value

*We rename the variables, to have a clear and unique name.
rename (geo time_period obs_value) (country year household_debt)

*We give labels to our variables, to make it easily understandable which variables we are working on.
label variable household_debt "The value of liabilities held by households, expressed as a percentage of national GDP"

*We remove observations that are superfluous and/or contain missing data
drop if country=="EA19" | country=="EA20"
drop if year <2000 | year >2021

*We save our dataset, updating it from time to time with the new variables.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace

//Dataset 2 - Public debt - ------------------------------------------------

*We import the csv data into STATA
import delimited "I:\Econometria\Progetto-Vivera\Dati\csv2\General government gross debt, million euro -2000-2020.csv", clear

*There are several variables that are not useful for our analysis, so we remove them again.
keep geo time_period obs_value

*We rename the variables, to have a clear and unique name.
rename (geo time_period obs_value) (country year public_debt)

*We give labels to our variables, to make it easily understandable which variables we are working on.
label variable public_debt "The amount, in millions of euros, of liabilities held by the general government."

*We remove observations that are superfluous and/or contain missing data
drop if country=="EA19" | country=="EA20"
drop if year <2000 | year >2021

*With merge, we combine the two datasets by combining our reference variables, taking the year and state as reference variables.
merge m:m country year using "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta"

*The merge variable gives us information on the result of the merging process, we remove it once the process has gone well, in order to proceed with the other merges.
drop _merge

*We save the new dataset formed.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace

//Dataset 3 - Inflation -------------------------------------------------------

*We import the csv data into STATA
import delimited "I:\Econometria\Progetto-Vivera\Dati\csv2\Inflation, HICP all average rate of change, 1994-2000.csv", clear

*There are several variables that are not useful for our analysis, so we remove them again.
keep geo time_period obs_value

*We rename the variables, to have a clear and unique name.
rename (geo time_period obs_value) (country year inflation)

*We give labels to our variables, to make it easily understandable which variables we are working on.
label variable inflation "Annual change in prices in a given country."

*We remove observations that are superfluous and/or contain missing data
drop if country=="EA19" | country=="EA20"
drop if year <2000 | year >2021

*With merge, we combine the two datasets by combining our reference variables, taking the year and state as reference variables.
merge m:m country year using "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta"

*The merge variable gives us information on the result of the merging process, we remove it once the process has gone well, in order to proceed with the other merges.
drop _merge

*We save the new dataset formed.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace

//dataset 4 - Net disposable income

*We import the csv data into STATA
import delimited "I:\Econometria\Progetto-Vivera\Dati\csv2\Net Disposable income, 1995-2022, current prices million euros.csv", clear

*There are several variables that are not useful for our analysis, so we remove them again.
keep geo time_period obs_value

*We rename the variables, to have a clear and unique name.
rename (geo time_period obs_value) (country year disposable_income)

*We give labels to our variables, to make it easily understandable which variables we are working on.
label variable disposable_income "the net disposable income for households, expressed in millions of euros"

*We remove observations that are superfluous and/or contain missing data
drop if country=="EA19" | country=="EA20"
drop if year <2000 | year >2021

*With merge, we combine the two datasets by combining our reference variables, taking the year and state as reference variables.
merge m:m country year using "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta"

*The merge variable gives us information on the result of the merging process, we remove it once the process has gone well, in order to proceed with the other merges.
drop _merge

*We save the new dataset formed.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace

//Dataset 5 -GDP

*We import the csv data into STATA
import delimited "I:\Econometria\Progetto-Vivera\Dati\csv2\GDP, 1995-2022, current prices million euros.csv", clear

*There are several variables that are not useful for our analysis, so we remove them again.
keep geo time_period obs_value

*We rename the variables, to have a clear and unique name.
rename (geo time_period obs_value) (country year GDP)

*We give labels to our variables, to make it easily understandable which variables we are working on.
label variable GDP "The gross domestic product of a State, expressed in millions of euros"

*We remove observations that are superfluous and/or contain missing data
drop if country=="EA19" | country=="EA20"
drop if year <2000 | year >2021

*With merge, we combine the two datasets by combining our reference variables, taking the year and state as reference variables.
merge m:m country year using "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta"

*The merge variable gives us information on the result of the merging process, we remove it once the process has gone well, in order to proceed with the other merges.
drop _merge

*We save the new dataset formed.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace

//dataset 6 - Working-age population.

*We import the csv data into STATA
import delimited "I:\Econometria\Progetto-Vivera\Dati\csv2\Population, 15-64, 1994-2022.csv", clear

*There are several variables that are not useful for our analysis, so we remove them again.
keep geo time_period obs_value

*We rename the variables, to have a clear and unique name.
rename (geo time_period obs_value) (country year pop_working)

*We give labels to our variables, to make it easily understandable which variables we are working on.
label variable pop_working "working-age population (15 to 65 years old) of a given State"

*We remove observations that are superfluous and/or contain missing data
drop if country=="EA19" | country=="EA20"
drop if year <2000 | year >2021

*With merge, we combine the two datasets by combining our reference variables, taking the year and state as reference variables.
merge m:m country year using "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta"

*The merge variable gives us information on the result of the merging process, we remove it once the process has gone well, in order to proceed with the other merges.
drop _merge

*We save the new dataset formed.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace

//Dataset 7 - interest rate *control variable for the confidence of a given country's system.

*We import the csv data into STATA
import delimited "I:\Econometria\Progetto-Vivera\Dati\csv2\12-month interest rates, 1995-2022.csv", clear

*There are several variables that are not useful for our analysis, so we remove them again.
keep time_period obs_value

*We rename the variables, to have a clear and unique name.
rename (time_period obs_value) (year interest_rate)

*We give labels to our variables, to make it easily understandable which variables we are working on.
label variable interest_rate "The interest rate in the money market, with a duration of 12 months"

*We remove observations that are superfluous and/or contain missing data.
drop if year <2000 | year >2021

*With merge, we combine the two datasets by combining our reference variables, taking the year and state as reference variables.
merge m:m year using "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta"

*The merge variable gives us information on the result of the merging process, we remove it once the process has gone well, in order to proceed with the other merges.
drop _merge

*We save the new dataset formed.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace

//Dataset 8 - tax revenues

*We import the csv data into STATA
import delimited "I:\Econometria\Progetto-Vivera\Dati\csv2\Taxes on imports and production less subsidies, million euros, 1994-2022.csv", clear

*There are several variables that are not useful for our analysis, so we remove them again.
keep geo time_period obs_value

*We rename the variables, to have a clear and unique name.
rename (geo time_period obs_value) (country year taxes)

*We give labels to our variables, to make it easily understandable which variables we are working on.
label variable taxes "The tax revenues of a State, expressed in millions of euros"

*We remove observations that are superfluous and/or contain missing data
drop if country=="EA19" | country=="EA20"
drop if year <2000 | year >2021

*With merge, we combine the two datasets by combining our reference variables, taking the year and state as reference variables.
merge m:m country year using "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta"

*The merge variable gives us information on the result of the merging process, we remove it once the process has gone well, in order to proceed with the other merges.
drop _merge

*We save the new dataset formed.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace

//Dataset 9 - Population over 65 years old *to control if the aging of the population has an effect on saved savings,

*We import the csv data into STATA
import delimited "I:\Econometria\Progetto-Vivera\Dati\csv2\Population, 65+,1994-2022.csv", clear

*There are several variables that are not useful for our analysis, so we remove them again.
keep geo time_period obs_value

*We rename the variables, to have a clear and unique name.
rename (geo time_period obs_value) (country year pop65)

*We give labels to our variables, to make it easily understandable which variables we are working on.
label variable year "Reference year"
label variable pop65 "Population of retirement age, over 65 years of age"

*We remove observations that are superfluous and/or contain missing data
drop if country=="EA19" | country=="EA20"
drop if year <2000 | year >2021

*With merge, we combine the two datasets by combining our reference variables, taking the year and state as reference variables.
merge m:m country year using "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta"

*The merge variable gives us information on the result of the merging process, we remove it once the process has gone well, in order to proceed with the other merges.
drop _merge

*We save the new dataset formed.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace

**# Generation of variables and rearrangements.
*Our data allows us to find the debt of households in absolute value, having GDP and household debt as a percentage of GDP and coming from the same source.
generate household_debt_n = (household_debtGDP)/100

*We can create dummies for each country, associating each State with a value.
encode country, gen(country_id)
drop country
rename country_id country

*The Isec2c codes are not easily intelligible, so we replace them with the names of the countries.
label define country_id 1 "Austria"2 "Belgium"3 "Cyprus"4 "Germany"5 "Estonia"6 "Greece"7 "Spain"8 "Finland"9 "France"10 "Ireland"11 "Italy"12 "Lithuania"13 "Luxembourg"14 "Latvia"15 "Malta"16 "Netherlands"17 "Portugal"18 "Slovenia"19 "Slovakia", replace

*We set our dataset as a panel data set, telling Stata the country and time variables
xtset country year

*Before using the recession dummy variable (GDP contraction between one year and the next), after setting the dataset as a panel on Stata with xtset.
generate recession = (D.GDP)<0 

*The logarithm of public debt can help us during the linear regression to verify how the dependent variable varies as the percentage of public debt varies. Log allows us to create a variable that is the natural logarithm of the variable itself.
generate logpublic =log(public_debt)

*In the same way, we can create the logarithms of different variables. By doing this, we could not only evaluate in the regression how much the dependent variable varies as the control or independent variable varies by one unit, but also how it varies as a percentage of the regressors (since a unit increase in log is equivalent to a percentage increase of the ordinary variable.)
generate logGDP =log(GDP)
generate logtaxes =log(taxes)
generate logdisposable_income=log(disposable_income)
*and other variables as well:
generate logpop65 =log(pop65)
generate logpopw=log(pop_working)

*It is also useful to express the logarithm of the private household debt variable, but having the original value as a percentage of GDP, we will use the variable that we have already generated in millions of euros.
generate loghousehold_debt=log(household_debt_n)

//Extra variables, not included in the regression but used for the graphs.

*We can also make maps with spmap on the average growth of our public and private debt in Europe, to do this, first we generate the variables that indicate the difference in the logarithms of public and private debt from one year to the next, then we take the average of this variable. It is important to categorize by country and year, otherwise the difference will be taken in the order of the dataset, without distinction between countries.
by country (year): generate delta2_logpublic = D.logpublic
by country (year): generate delta2_loghousehold = D.loghousehold_debt
by country (year): egen delta_loghousehold = mean(delta2_loghousehold*100)
by country (year): egen delta_logpublic = mean(delta2_logpublic*100)

*We do not need the intermediate variables, we discard them:
drop delta2_loghousehold
drop delta2_logpublic


*We add the last labels to the variables.
label variable country "Euro Area Countries (19 States)"
label variable household_debt_n "Private household debt converted to millions of euros, combining GDPhousehold_debt."
label variable recession "Dummy variable that takes the value 1 when annual GDP undergoes a contraction compared to current GDP"
label variable logpublic "Logarithm of public debt"
label variable logGDP "Logarithm of gross domestic product"
label variable logdisposable_income "Logarithm of annual net income"
label variable logpop65 "Logarithm of the population aged at least 65"
label variable logpopw "Logarithm of the working-age population"
label variable logtaxes "Logarithm of tax revenues"
label variable loghousehold_debt "Logarithm of household debt, based on the value in millions of euros generated with houshold_debt_n"
label variable delta_loghousehold "Average change in the logarithm of private debt. Can be interpreted as the percentage growth in the geometric mean of household private debt."
label variable delta_logpublic "Average change in the logarithm of public debt. Can be interpreted as the percentage growth in the geometric mean of public debt."



*We add some notes to make the source and characteristics of the variables even more understandable.
note country: "Abbreviation of the 19 States belonging to the Euro Area, before the inclusion of Croatia in 2023"
note year: "Year in the reference period 2000-2021 (22 years)"
note household_debt: "The sum of all loans and debt securities held by consumers in a given state, as of December 31. Source: https://ec.europa.eu/eurostat/databrowser/view/NASA_10_F_BS__custom_7482767/default/table?lang=en"
note public_debt: "Total consolidated liabilities at current market prices, considering deposits, debt securities and loans. For general government, this means general government and local and intermediate administrations, such as regions or departments. Source: https://ec.europa.eu/eurostat/databrowser/view/SDG_17_40/default/table"
note GDP: "National accounts are a coherent set of macroeconomic indicators that provide a general picture of the economic situation and are widely used for economic analysis and forecasting, policy design and definition. They are recorded in millions of euros, at current prices and therefore not adjusted for inflation. Source: https://ec.europa.eu/eurostat/databrowser/view/naida_10_gdp/default/table?lang=en"
note interest_rate: "The rate offered in the money market for a period of 12 months, as emerged from the EURIBOR, the benchmark that represents a panel of banks. Source: https://ec.europa.eu/eurostat/databrowser/view/IRT_ST_A__custom_7482695/default/table?lang=en"
note pop65: "Persons residing on January 1 in a given State, according to data collected from EU country data. They may be derived from an adjustment from the last census, or based on resident registers. Source: https://ec.europa.eu/eurostat/databrowser/view/DEMO_PJANBROAD__custom_7439880/default/table"
note pop_working:"Persons residing on January 1 in a given State, according to data collected from EU country data. They may be derived from an adjustment from the last census, or based on resident registers. Source: https://ec.europa.eu/eurostat/databrowser/view/DEMO_PJANBROAD__custom_7439880/default/table"
note disposable_income: "Starting from Eurostat statistics, the GDP aggregate that represents the annual net income that consumers have in a given year, expressed in millions of euros at current prices. Source: https://ec.europa.eu/eurostat/databrowser/view/NAIDA_10_GDP__custom_7482595/default/table?lang=en"
note inflation: "The average annual growth rate of inflation for the complete European HICP basket, compiled directly from Eurostat. The values are expressed as a percentage change. Source: https://ec.europa.eu/eurostat/databrowser/view/PRC_HICP_AIND__custom_7438580/default/table"

*We save the dataset with the generated variables.
save "I:\Econometria\Progetto-Vivera\Database progetto econometria.dta", replace



**#Data Overview

*We can check if there are duplicate observations in multiple files, in order to be sure that we have not accidentally taken other variables. *there was no need for cap, but it gave an error before for another reason
duplicates list

*There are two ways we can view our dataset. The first is to use the browse command to view the data directly from STATA.
br
*If, instead, we want to see our observations directly from the results window and possibly record them in the log file, we can use list, with the sepby option to divide them by State.
list, sepby(country)

*summarize allows us to give basic descriptive statistics of our variables.
summarize

*We do a correlation analysis, in order to verify if there are any collinearities
correlate

**# Regression analysis
*Fixed effects analysis, we use xtreg to take into account that we have panel data, which does not change within groups.

*First we analyze private debt as a percentage with nominal public debt
xtreg household_debt public_debt, fe r
*With xtreg we do a regression with panel data, fe is the option to indicate that we are estimating a fixed effects model, while r is the robust option, to calculate standard errors robust to heteroscedasticity.
outreg2 using "Regression.doc", word replace

xtreg household_debt public_debt pop_working, fe r
*We add the other variables, noting how the coefficients change when they are inserted.
outreg2 using "Regression.doc", word append
xtreg household_debt public_debt pop_working taxes, fe r
outreg2 using "Regression.doc", word append
xtreg household_debt public_debt pop_working taxes GDP, fe r
outreg2 using "Regression.doc", word append
xtreg household_debt public_debt pop_working taxes GDP disposable_income, fe r
outreg2 using "Regression.doc", word append
xtreg household_debt public_debt pop_working taxes GDP disposable_income inflation, fe r
outreg2 using "Regression.doc", word append
xtreg household_debt public_debt pop_working taxes GDP disposable_income inflation , fe r
outreg2 using "Regression.doc", word append
xtreg household_debt public_debt pop_working taxes GDP disposable_income inflation pop65 , fe r
outreg2 using "Regression.doc", word append
xtreg household_debt public_debt pop_working taxes GDP disposable_income inflation pop65 interest_rate, fe r
outreg2 using "Regression.doc", word append
xtreg household_debt public_debt pop_working taxes GDP disposable_income inflation pop65 interest_rate recession, fe r
outreg2 using "Regression.doc", word append

*Then nominal private debt (obtained by multiplying GDP) with nominal public debt
xtreg household_debt_n public_debt, fe r
*With xtreg we do a regression with panel data, fe is the option to indicate that we are estimating a fixed effects model, while r is the robust option, to calculate standard errors robust to heteroscedasticity.
outreg2 using "Regression2.doc", word replace
xtreg household_debt_n public_debt pop_working, fe r
*We add the other variables, noting how the coefficients change when they are inserted.
outreg2 using "Regression2.doc", word append
xtreg household_debt_n public_debt pop_working taxes, fe r
outreg2 using "Regression2.doc", word append
xtreg household_debt_n public_debt pop_working taxes GDP, fe r
outreg2 using "Regression2.doc", word append
xtreg household_debt_n public_debt pop_working taxes GDP disposable_income, fe r
outreg2 using "Regression2.doc", word append
xtreg household_debt_n public_debt pop_working taxes GDP disposable_income inflation, fe r
outreg2 using "Regression2.doc", word append
xtreg household_debt_n public_debt pop_working taxes GDP disposable_income inflation , fe r
outreg2 using "Regression2.doc", word append
xtreg household_debt_n public_debt pop_working taxes GDP disposable_income inflation pop65 , fe r
outreg2 using "Regression2.doc", word append
xtreg household_debt_n public_debt pop_working taxes GDP disposable_income inflation pop65 interest_rate, fe r
outreg2 using "Regression2.doc", word append
xtreg household_debt_n public_debt pop_working taxes GDP disposable_income inflation pop65 interest_rate recession, fe r
outreg2 using "Regression2.doc", word append

*Private public debt as a percentage of GDP with the logarithm of public debt (therefore, how does household income influence the increase of one percentage point of public debt, expressed as a percentage of GDP)
xtreg household_debt logpublic, fe r
*With xtreg we do a regression with panel data, fe is the option to indicate that we are estimating a fixed effects model, while r is the robust option, to calculate standard errors robust to heteroscedasticity.
outreg2 using "Regression3.doc", word replace
xtreg household_debt logpublic pop_working, fe r
*We add the other variables, noting how the coefficients change when they are inserted.
outreg2 using "Regression3.doc", word append
xtreg household_debt logpublic pop_working taxes, fe r
outreg2 using "Regression3.doc", word append
xtreg household_debt logpublic pop_working taxes GDP, fe r
outreg2 using "Regression3.doc", word append
xtreg household_debt logpublic pop_working taxes GDP disposable_income, fe r
outreg2 using "Regression3.doc", word append
xtreg household_debt logpublic pop_working taxes GDP disposable_income inflation, fe r
outreg2 using "Regression3.doc", word append
xtreg household_debt logpublic pop_working taxes GDP disposable_income inflation , fe r
outreg2 using "Regression3.doc", word append
xtreg household_debt logpublic pop_working taxes GDP disposable_income inflation pop65 , fe r
outreg2 using "Regression3.doc", word append
xtreg household_debt logpublic pop_working taxes GDP disposable_income inflation pop65 interest_rate, fe r
outreg2 using "Regression3.doc", word append
xtreg household_debt logpublic pop_working taxes GDP disposable_income inflation pop65 interest_rate recession, fe r
outreg2 using "Regression3.doc", word append

*Finally, we can calculate the elasticity (percentage change in Y following a percentage change in X) of private debt in relation to public debt, having both in logarithmic form.
*We will also use the other variables for which we have made the logarithm, to see if the regression can provide us with new information.

xtreg loghousehold_debt logpublic, fe r
*With xtreg we do a regression with panel data, fe is the option to indicate that we are estimating a fixed effects model, while r is the robust option, to calculate standard errors robust to heteroscedasticity.
outreg2 using "Regression4.doc", word replace
xtreg loghousehold_debt logpublic pop_working, fe r
*We add the other variables, noting how the coefficients change when they are inserted.
outreg2 using "Regression4.doc", word append
xtreg loghousehold_debt logpublic pop_working logtaxes, fe r
outreg2 using "Regression4.doc", word append
xtreg loghousehold_debt logpublic pop_working logtaxes logGDP, fe r
outreg2 using "Regression4.doc", word append
xtreg loghousehold_debt logpublic pop_working logtaxes logGDP logdisposable_income, fe r
outreg2 using "Regression4.doc", word append
xtreg loghousehold_debt logpublic pop_working logtaxes logGDP logdisposable_income inflation, fe r
outreg2 using "Regression4.doc", word append
xtreg loghousehold_debt logpublic pop_working logtaxes logGDP logdisposable_income inflation , fe r
outreg2 using "Regression4.doc", word append
xtreg loghousehold_debt logpublic pop_working logtaxes logGDP logdisposable_income inflation pop65 , fe r
outreg2 using "Regression4.doc", word append
xtreg loghousehold_debt logpublic pop_working logtaxes logGDP logdisposable_income inflation pop65 interest_rate, fe r
outreg2 using "Regression4.doc", word append
xtreg loghousehold_debt logpublic pop_working logtaxes logGDP logdisposable_income inflation pop65 interest_rate recession, fe r
outreg2 using "Regression4.doc", word append


*We expand our analysis with a fixed time effects model, since in our time period it is more than reasonable to think of a change in European rules, e.g. on the deficit/GDP ratio or other. We apply the fixed time effects model by adding the i.year variable
xtreg household_debt logpublic i.year, fe r

*Now, we add all the other variables.
xtreg household_debt logpublic pop_working taxes GDP disposable_income inflation pop65 interest_rate recession i.year, fe r

*Assuming that it takes some time before households adjust their debt based on public spending, then it would be more convenient to regress household private debt in year t with public debt in year t-1. To do this, we can use l.public_debt:
xtreg household_debt l.public_debt pop_working taxes GDP disposable_income inflation pop65 interest_rate recession,  fe r


*Now, let's redo the multiple regression analysis, including fixed time effects and the lag of the variable.
xtreg loghousehold_debt l.logpublic i.year, fe r
*with xtreg we perform a regression with panel data, fe is the option to indicate that we are estimating a fixed effects model, while r is the robust option, to compute robust standard errors to heteroscedasticity.
outreg2 using "Regressione5.doc", word replace
xtreg loghousehold_debt l.logpublic logpopw i.year, fe r
*we add the other variables, noting how the coefficients change when they are included.
outreg2 using "Regressione5.doc", word append
xtreg loghousehold_debt l.logpublic logpopw logtaxes i.year, fe r
outreg2 using "Regressione5.doc", word append
xtreg loghousehold_debt l.logpublic logpopw logtaxes logGDP i.year, fe r
outreg2 using "Regressione5.doc", word append
xtreg loghousehold_debt l.logpublic logpopw logtaxes logGDP logdisposable_income i.year,  fe r
outreg2 using "Regressione5.doc", word append
xtreg loghousehold_debt l.logpublic logpopw logtaxes logGDP logdisposable_income inflation i.year,  fe r
outreg2 using "Regressione5.doc", word append
xtreg loghousehold_debt l.logpublic logpopw logtaxes logGDP logdisposable_income inflation i.year,  fe r
outreg2 using "Regressione5.doc", word append
xtreg loghousehold_debt l.logpublic logpopw logtaxes logGDP logdisposable_income inflation logpop65 i.year,  fe r
outreg2 using "Regressione5.doc", word append
xtreg loghousehold_debt l.logpublic logpopw logtaxes logGDP logdisposable_income inflation logpop65 interest_rate i.year,  fe r
outreg2 using "Regressione5.doc", word append
xtreg loghousehold_debt l.logpublic logpopw logtaxes logGDP logdisposable_income inflation logpop65 interest_rate recession i.year,  fe r
outreg2 using "Regressione5.doc", word append
**# Time Series Graphics Processing

*We can use graphs to visually present some of our data. The most interesting is certainly the household debt/GDP ratio. Through the xtline command, we can show all the aggregated data in a single image:
xtline household_debt, addplot((line household_debt year)) ytitle(household debt/GDP) ttitle(Time) byopts(legend(off))
*we can also make a scatterplot for all groups, using the sepscatter package:
ssc inst sepscatter

**# Territorial Graphics Processing

*Our research is based on the Euro Area countries, relatively close to each other. It would be appropriate and interesting to also display the data in the form of a map. To do this, it is necessary to install the spmap and shp2dta packages, which allow us to use maps in ESRI format directly through Stata commands.

*the first thing to do is to install the two commands.
ssc install spmap
ssc install shp2dta

*we have already found a map of the European Union, with data divided by NUTS (Nomenclature of Territorial Units for Statistics) import this file and convert it into a STATA dataset.

spshape2dta "I:\Econometrics\Project-Vivera\Data\Shapefile\NUTS_RG_20M_2021_3035.shp", replace

*this command allows us to convert the shapefile into dta format, compatible with STATA. Import the generated dataset and see its structure.
use NUTS_RG_20M_2021_3035.dta, clear
describe

*the dataset in question contains data for both COUNTRIES (LEVL_CODE = 0) and regions or provinces. We are interested in a macroeconomic analysis, so we keep only the national variables.
drop if LEVL_CODE != 0

*keep only the variables we are interested in:
keep _ID _CX _CY CNTR_CODE LEVL_CODE

*there are more countries that are not part of our project, we remove them.

drop if CNTR_CODE != "FR" & CNTR_CODE != "BE" & CNTR_CODE != "AT" & CNTR_CODE != "EE" & CNTR_CODE != "ES" & CNTR_CODE != "DE" & CNTR_CODE != "CY" & CNTR_CODE != "IE" & CNTR_CODE != "IT" & CNTR_CODE != "LT" & CNTR_CODE != "MT" & CNTR_CODE != "NL" & CNTR_CODE != "LU" & CNTR_CODE != "LV" & CNTR_CODE != "FI" & CNTR_CODE != "SI" & CNTR_CODE != "SK" & CNTR_CODE != "PT" & CNTR_CODE != "NL" & CNTR_CODE != "EL"

*now, we don't need the level code anymore:
drop LEVL_CODE

*change the name of the variable CNTR_CODE
rename CNTR_CODE country

*We now have a cleaned file for the regions we are interested in and that we can include in the master dataset, but there is a problem: in our master dataset we already have a file with country variables modified into numeric values and with modified value labels (with label define). In the master dataset, the numeric values of country have been numbered following alphabetical order (AT=1, BE=2, etc.) so by sorting our variables and encoding, we could merge the two datasets based on the country variable.
sort country

*now we can perform encoding:
encode country, gen(country_id)
drop country
rename country_id country

*also change the labels:
label define country_id 1 "Austria" 2 "Belgium" 3 "Cyprus" 4 "Germany" 5 "Estonia" 6 "Greece" 7 "Spain" 8 "Finland" 9 "France" 10 "Ireland" 11 "Italy" 12 "Lithuania" 13 "Luxembourg" 14 "Latvia" 15 "Malta" 16 "Netherlands" 17 "Portugal" 18 "Slovenia" 19 "Slovakia", replace

*reorder by ID
sort _ID 

*save the dataset as is to use it as a dataset for spmap.
save NUTS_RG_20M_2021_3035.dta, replace

*now we can merge:
merge m:m country using "I:\Econometrics\Project-Vivera\Database econometrics project.dta"

*the merge was successful, we can save the new dataset.
drop _merge

*reorder variables 
order year country
order _ID _CX _CY, last

*restore the old label
label variable country "Euro Area Countries (19 States)"

save "I:\Econometrics\Project-Vivera\Database econometrics project.dta", replace


*at this point, we can use the spmap command to create a map of the states showing public debt visually for each state, using the delta_logpublic and delta_logpublic variables we created earlier (command placed as a comment for convenience in running the do-file):
//spmap delta_loghousehold using NUTS_RG_coord.dta, id(_ID) fcolor(Blues)

*the graph is successful, but overseas territories are included, making the map harder to read. How can we modify them? 
*We can remove overseas territories by removing them from the coordinates file, physically removing references to territories with coordinates too distant from those of the European continent.
use NUTS_RG_coord.dta, clear
drop if _X <  2100000
drop if _Y < 0
*save the new coordinate file.
save NUTS_RG_coord2.dta, replace

*now we reuse the new graph. 
use "Database progetto econometria.dta", clear

*spmap is not perfectly compatible with panel data, so we keep only observations for the year 2000 since the graphical representation of the mean does not vary for the years.
drop if year!=2000

*try with the new graph. 
spmap delta_loghousehold using NUTS_RG_coord2.dta, id(_ID) fcolor(Blues)  legtitle("Private debt growth")
spmap delta_logpublic using NUTS_RG_coord2.dta, id(_ID) fcolor(Reds)  legtitle("Public debt growth")   

*after several legend modifications, here are the final graphs:
graph use "I:\Econometria\Progetto-Vivera\Privatemap.gph"
graph use "I:\Econometria\Progetto-Vivera\Publicmap.gph"

*we can then export the graphs: 
graph export "I:\Econometria\Progetto-Vivera\Publicmap.jpg", as(jpg) name("Publicmap") quality(90)
graph export "I:\Econometria\Progetto-Vivera\Privatemap.jpg", as(jpg) name("Privatemap") quality(90)











