# Ricardian-Equivalence-Euro-test
This repository contains the STATA do-file and data sets from EUROSTAT used for a econometrics project focusing on the empirical verification of Ricardian equivalence, a macroeconomic theory positing that an increase in government spending is offset by an increase in consumer savings, anticipating future taxes levied on citizens to repay the new public spending. 

## Overview

The analysis utilizes EUROSTAT data spanning from 2001 to 2021, specifically focusing on the Euro Area. It aims to examine the relationship between public debt and private debt, accounting for control variables such as demographics (working-age and over-65 populations), interest rates, inflation, fixed effects, and potential heteroscedasticity. Recession years, defined as periods of GDP contraction compared to the previous year, are also incorporated into the model.

## Methodology

The analysis assumes linearity between variables and employs logarithmic transformations of public and private debt, along with potential time lags. Regression models are utilized to assess the significance of various factors on private debt, including public debt, demographic variables, disposable income, and recession dummies.

The results suggest that public debt, in logarithmic form and not, does not exhibit significant effects on private debt, except in the early stages of the regression without control variables. However, the working-age population demonstrates consistent significance in influencing private debt across most regressions, along with the logarithm of disposable income in certain cases. The introduction of a recession dummy reveals a significantly positive effect on private debt.

In addition to regression results, the repository also presents visualizations depicting the average growth of public and private debt throughout the Euro Area. This includes the utilization of SPMAP and geographic coordinates to provide comprehensive insights into debt trends, they can be find out 

## Repository Structure

- `Equivalence-eng.do`: Stata do-file containing the regression analysis and data processing steps.
- `dati/`: Directory containing EUROSTAT data files.
- `Regression#`: The text files of the diverse linear regression results.

## License

This repo is under the GNL 3.0 License. 
