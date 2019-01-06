# ----------------------------------------------------------
#
# This file contains useful functions for the analysis of
# survey results as per the ODI methodology. 
#
# ----------------------------------------------------------


# 1. CALCULATE SCORE FOR ONE OUTCOME FROM RAW DATA
# Use raw data in the form of 1 to 5 ratings 
# Calculate the proportion with 4 or 5 ratings
# Scale it so that the maximum is 10 (as per book)

calc_scores <-function(x)(sum(x==4)+sum(x==5))/length(x)*10


# 2. CALCULATE IMPORTANCE or SATISFACTION SCORES FOR ALL OUTCOMES
# Use calc_scores function and apply to all columns in dataset
# This can be used separately for importance & satisfaction

scores <-function(data){
  apply(data[,1:(ncol(data))],2,calc_scores)
}

# 3. CALCULATE OPPORTUNITY SCORES FOR ALL OUTCOMES
# Use formula as per book: opp = imp + max(imp - sat, 0)
# Note I've avoided use of max function due to vectorization
# Simpler to find rows where 2nd part is negative and set to imp 

opportunities <- function(imp_scores, sat_scores){
  opp_scores = imp_scores +imp_scores - sat_scores
  neg = ((imp_scores-sat_scores)<=0)
  opp_scores[neg]<-imp_scores[neg]
  return(opp_scores)
}


# 4. CLASSIFY OPPORTUNITY SCORES INTO CATEGORIES (& COLOR THEM ACCORDINGLY) 
# Classify opportunity as limited, good, very good, or excellent 
# Define as overserved if satisfaction exceeds importance 

categories <- function(imp_scores,sat_scores){
  opp_scores = opportunities(imp_scores,sat_scores)
  categories <-rep(NA,length(opp_scores))
  categories[(opp_scores<=10)] <- "limited"
  categories[(opp_scores>10)&(opp_scores<=12)] <- "good"
  categories[(opp_scores>12)&(opp_scores<=15)] <- "verygood"
  categories[opp_scores>15] <- "excellent"
  categories[sat_scores>imp_scores] <- "overserved"
  return(categories)
}

colors <- function(opp_categories){
  colors <-rep(NA,length(opp_categories))
  colors[opp_categories=="limited"] <- "orange"
  colors[opp_categories=="good"] <- "lawngreen"
  colors[opp_categories=="verygood"] <- "forestgreen"
  colors[opp_categories=="excellent"] <- "darkgreen"
  colors[opp_categories=="overserved"] <- "red"
  return(colors)
}


# 5. DRAW OPPORTUNITY MAP WITH OUTCOMES PLOTTED
# outputs a chart with importance on X axis and satisfacton on Y axis
# marks out the standard areas based on opportunity category (e.g. good, overserved, etc)
# plots each outcome as one point, and colors it based on opportunity category

draw_opportunitymap <- function(imp_scores,sat_scores,export=FALSE,filename="OpportunityMap.png",width=800,height=800){
  opp_scores = opportunities(imp_scores,sat_scores)
  opp_categories = categories(imp_scores,sat_scores)
  opp_colors = colors(opp_categories)
  
  if(export){png(file=filename,width=width,height=height)}  # activate PNG graphic device if export flag set
    
  par(usr=c(0, 10, 0, 10),xaxs="i",yaxs="i",cex.axis=1.1,cex.lab=1.2,pch=19,mar=c(6,6,6,3)+0.1)
  plot(imp_scores,sat_scores,col=opp_colors,
       xlim=c(0,10),ylim=c(0,10),
       xlab="Importance",ylab="Satisfaction",
       main="Opportunity Map",
       xaxp=c(0,10,10),yaxp=c(0,10,10)
       )
  
  im<-c(0,1,2,3,4,5,6,7,8,9,10)
  opp15=im-(15-im)
  opp12=im-(12-im)
  opp10=im-(10-im)
  
  lines(x=c(0,10),y=c(0,10),col="orange")
  lines(im,opp15,col="darkgreen")
  lines(im,opp12,col="forestgreen")
  lines(im,opp10,col="lawngreen")
  text(x=8,y=9.5,labels="Overserved",col="red")
  text(x=8,y=7.5,labels="Appropriately \nServed",col="orange",srt=45)
  text(x=9.25,y=7.6,labels="Good \n(Opp>10)",col="lawngreen",srt=60)
  text(x=9.25,y=5.5,labels="Very Good \n(Opp>12)",col="forestgreen",srt=60)
  text(x=9.4,y=3,labels="Excellent \n(Opp>15)",col="darkgreen",srt=60)

  if(export){dev.off()}  # activate PNG graphic device if export flag set
  print("Opportunity Map successfully exported to PNG")
  }

# 6. OUTPUT CSV WITH ALL INFORMATION PER OUTCOME
# set sorted flag to TRUE if you'd like results sorted from highest opportunity score to lowest
# set printout flag to TRUE if you'd like to see exported data on the screen as well as sent to CSV file

export_csv <- function(outcome_names,imp_scores,sat_scores,filename="ODI-export.csv",sorted=FALSE,printout=FALSE){
  opp_scores = opportunities(imp_scores,sat_scores)
  opp_categories = categories(imp_scores,sat_scores)
  exportdata <- data.frame(outcome_names,imp_scores,sat_scores,opp_scores,opp_categories,row.names=NULL)
  if(sorted){
    exportdata <- exportdata[with(exportdata,order(-opp_scores)),]
  }
  write.csv(exportdata,file=filename,row.names=FALSE)
  print("Results successfully exported to CSV")
  if(printout) return(exportdata)
  }


# 7. DEFINE COLUMN NUMBERS EASILY TO HELP EXTRACT IMPORTANCE VS SATISFACTION DATA
# Convenience function to help define and extract particular column numbers from a dataset
# Returns a list of length = "number" values, starting at "start", and either consecutive or alternating
# for example: if you have 93 outcomes with satisfaction columns alternating from column #11, then use
#             sat_cols = data[,colnums(11,93,"alternating")]

colnums <- function(start,number,type="consecutive"){
  if(type=="consecutive"){
    ans = c(0:(number-1))+start
  }
  if(type=="alternating"){
    ans = c(0:(number-1))*2+start
  }
  return(ans)
}

