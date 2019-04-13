# Outcome Driven Innovation (ODI) analysis in R

This project uses the statistical programming language R to help with the analysis of survey results as per the Outcome Driven Innovation (ODI) methodology developed by Anthony Ulwick from [Strategyn](https://strategyn.com/). Please note  that the code here is simply my own attempt at implementing ODI and is not endorsed or otherwise affiliated with Strategyn. Use at your own risk!  

### A Quick Introduction to Outcome Driven Innovation
The basic approach to implementing ODI can be summarized as:
1. Define your customer and job-to-be-done
2. Conduct interviews to identify the "outcomes" customers use to measure the success of their job-to-be-done
3. Conduct a survey with many customers to quantify the importance and satisfaction of each outcome for them
4. Analyse the results of the survey, including calculating an opportunity score per outcome. 
5. (Optional) Segment customers on the basis of their opportunity scores
6. Use the results to focus, prioritize and guide your innovation efforts

For more context, see my articles on Medium:
* ["A step by step guide to using Outcome Driven Innovation (ODI) for a new product"](https://medium.com/envato/a-step-by-step-guide-to-using-outcome-driven-innovation-odi-for-a-new-product-ded320f49acb)
* ["How we signed up 10,000 paying subscribers in just over a month"](https://medium.com/made-by-elements/how-we-signed-up-10-000-paying-subscribers-in-just-over-a-month-b7b8a94f0ec6)

Other useful resources include:
* ["What Customers Want"](https://www.amazon.com/What-Customers-Want-Outcome-Driven-Breakthrough/dp/0071408673) by Anthony Ulwick
* ["Competing Against Luck"](https://www.amazon.com.au/Competing-Against-Luck-Innovation-Customer/dp/0062435612) by Clayton Christensen
* ["Jobs to Be Done: Theory to Practice"](https://jobs-to-be-done-book.com/) by Anthony Ulwick

### Assumed Data Structure for Survey Results 
The code in this project assumes you've used an online tool (e.g. SurveyMonkey or similar) to run the survey, and have a CSV or similar file that is structured as follows:
   * One row per survey respondent
   * Columns per survey question, no particular order assumed
   * n columns of Importance ratings (1 to 5), one per outcome, in same order as outcome CSV below
   * n columns of Satisfaction ratings (1 to 5), one per outcome, in same order as outcome CSV below
   * arbitrary number of other columns e.g. for demographic data
   
You will also need a separate CSV for the list of outcomes, in the same order as in the data CSV above.
   * 1 column of outcome IDs
   * 1 column of outcome names
   
### A Basic Quickstart Guide to Using These Files
* Install R from https://cran.r-project.org/
* Install RStudio Desktop from https://www.rstudio.com/products/rstudio/download/  
* Install Github Desktop from https://desktop.github.com/
* Clone this repository using Github Desktop (so you have the files locally)
* Open RStudio and take the following steps via the console: 
  * Set the working directory to where your files are e.g. `setwd("~/User/ODI_Analysis/outcome-driven-innovation")`
  * Generate mock data file:  `source("generate_mock_data.R")`
  * Run the analysis on the mock data: `source("mock_analysis.R")`
* Look in the working directory to see 4 new files: 
  * `mockdata.csv` is the CSV file containing an example of what survey results might look like
  * `mockoutcomes.csv` is the CSV file containing a list of mock outcome IDs and outcome names 
  * `mock_analysis_results.csv` is a CSV file containing the results of the ODI analysis on the mock data
  * `OpportunityMap.png` is an image file with a chart of mock outcomes plotted by Importance & Satisfaction scores     

   
Note that when you first type the `source` commands it may need to install a bunch of different R libraries. This should happen automatically, but if not check out the first few lines of `mock_analysis.R` for key packages to install.  

------
I hope you find this useful!

Xavier 

https://xavierrusso.com
