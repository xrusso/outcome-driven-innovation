# Outcome Driven Innovation (ODI) analysis in R

This project uses the statistical programming language R to help with the analysis of survey results as per the Outcome Driven Innovation (ODI) methodology described by Anthony Ulwick from Strategyn in his book "What Customers Want". 

The basic approach to implementing ODI can be summarized as:
1. Define your customer and job-to-be-done
2. Conduct interviews to identify the "outcomes" customers use to measure the success of their job-to-be-done
3. Conduct a survey with many customers to quantify the importance and satisfaction of each outcome for them
4. Analyse the results of the survey, including calculating an opportunity score per outcome. 
5. (Optional) Segment customers on the basis of their opportunity scores
6. Use the results to focus, prioritize and guide your innovation efforts

For an example case study of the ODI process in action, see my article:
https://medium.com/envato/a-step-by-step-guide-to-using-outcome-driven-innovation-odi-for-a-new-product-ded320f49acb

### Assumed Data Structure for Survey Results 
The code in this project assumes you've used an online tool (e.g. SurveyMonkey or similar) to run the survey, and have a CSV or similar file that is structured as follows:
   * One row per survey respondent
   * Columns per survey question, no particular order assumed
   * 1 column of outcome names
   * n columns of Importance ratings (1 to 5), one per outcome
   * n columns of Satisfaction ratings (1 to 5), one per outcome
   * arbitrary number of other columns e.g. for demographic data
   
   
