# This is an example ODI analysis using the simulated data generated via the mock_data_generator. 
# It analyses survey responses for 100 outcomes and generates a CSV file of results per outcome, as well as a PNG file with the opportunity map showing the outcomes color-coded based on the opportunity category they are in. 
# To adjust this code for other datasets, modify the 'import data' section based on your data structure. Depending on the exact format output by your survey tool, you may need to do extra work (e.g. convert strings to numbers, etc) 

# import functions
require("Hmisc")
require("lattice")
require("survival")
require("Formula")
require("ggplot2")
source("ODI_functions.R")

# import data 
survey <- read.csv("mockdata.csv")
outcomes <- survey[,1]   # define the column containing outcome names
dem<-survey[,2:12]       # define the columns containing demographic data
imp<-survey[,13:112]     # define the columns containing importance ratings (1 to 5)
sat<-survey[,113:212]    # define the columns containing importance ratings (1 to 5)

# calculate importance & satisfaction scores
imp_scores = scores(imp)
sat_scores= scores(sat)
opp_scores = opportunities(imp_scores,sat_scores)

# draw opportunity map and export PNG
draw_opportunitymap(imp_scores,sat_scores,export=TRUE)

# export CSV with results of analysis
export_csv(outcomes,imp_scores,sat_scores,filename="mock_analysis_results.csv",sorted=TRUE,printout=TRUE)