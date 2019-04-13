# This file generates some mock survey data for ODI analysis. It simulates a dataset with several clear signals that should show up in the results, and outputs a CSV file. 

# Basic structure is 11 columns of demographics, 100 columns of importance ratings on a 1-5 scale, 100 columns of satisfaction ratings on a 1-5 scale, and 200 records that represent individual survey responses. 

# The example is based on a job-to-be-done of "manage an agile software development project".  Hence demographic fields are JobTitle, OrgType (startup,Company,Consulting,NotForProfit,Government), OrgSize, TeamSize, Country, Name, EmailAddress, YearsAgileInd (i.e. # years individual has been using agile), YearsAgileOrg (i.e. #years organization has been using agile), RemoteTeam (i.e. % team members not in team leader's location), AgileMethod (Scrum, Scrum/XP Hybrid, XP, Other)

set.seed(1234)
library(Hmisc)
ID<-1:200
nam<-paste("Person",ID,sep="")
em<-paste(nam,"@example.com",sep="")
  
m<-matrix(nrow=200,ncol=212)
survey<-as.data.frame(m)

#assign names
impnames<-paste(rep("Imp-Outcome",100),formatC(1:100,width=3,flag="0"),sep="")
satnames<-paste(rep("Sat-Outcome",100),formatC(1:100,width=3,flag="0"),sep="")
othnames<-c("ID","Name","EmailAddress","JobTitle","OrgType","TeamSize","OrgSize","Country","YearsAgileInd","YearsAgileOrg","AgileMethod","ProductUsed")
names<-c(othnames,impnames,satnames)
names(survey)<-names

#outcome info
outcome_list<-data.frame(outcome_id=1:100,outcome_name=paste(rep("Outcome",100),formatC(1:100,width=3,flag="0"),sep=""))

#assign ID, name, email
survey[,1]<-ID; survey[,2]<-nam; survey[,3]<-em

#assign jobtitle and orgtype
jt<-as.integer(runif(200,min=1,max=6))
jt[jt==1]<-"CIO"; jt[jt==2]<-"VP Technology"; jt[jt==3]<-"Senior Developer"; jt[jt==4]<-"VP Product"; jt[jt==5]<-"Project Manager"
survey$JobTitle<-jt

ot<-as.integer(runif(200,min=1,max=6))
ot[ot==1]<-"Company"; ot[ot==2]<-"Startup"; ot[ot==3]<-"Consulting"; ot[ot==4]<-"NotForProfit"; ot[ot==5]<-"Government"
survey$OrgType<-ot

# calculate and assign team sizes
njob<-runif(200,min=1,max=5)
norg<-as.integer(rcauchy(200,location=50,scale=50))
norg[norg<1]<-1
norg[norg>500]<-499
nteam<-as.integer(norg/runif(200,min=3,max=10))
nteam[nteam<1]<-1
norg<-cut(norg,breaks=c(0,5,10,20,50,100,200,500))
nteam<-cut(nteam,breaks=c(0,5,10,20,50,100,200))
survey$TeamSize<-nteam
survey$OrgSize<-norg

# Assign country
ct<-as.integer(runif(200,min=1,max=6))
ct[ct==1]<-"Australia"; ct[ct==2]<-"New Zealand"; ct[ct==3]<-"USA"; ct[ct==4]<-"Canada"; ct[ct==5]<-"UK"
survey$Country<-ct

# Assign years agile individual & org
survey$YearsAgileInd<-as.integer(runif(200,min=0,max=10))
survey$YearsAgileOrg<-as.integer(runif(200,min=0,max=10))

#Assign AgileMethod
am<-as.integer(runif(200,min=1,max=5))
am[am==1]<-"XP"; am[am==2]<-"Scrum"; am[am==3]<-"XP/Scrum"; am[am==4]<-"Other"
survey$AgileMethod<-am

# Assign product used (i.e. competitors)
pu<-as.integer(runif(200,min=1,max=7))
pu[pu==1]<-"Manual"; pu[pu==2]<-"Spreadsheet"; pu[pu==3]<-"Product A"; pu[pu==4]<-"Product B" 
pu[pu==5]<-"Product C";pu[pu==6]<-"Product D"
survey$ProductUsed<-pu

# Assign Importance and Satisfaction ratings to 100 outcomes
survey[,13:112]<-sapply(matrix(data=as.integer(rnorm(100*200,mean=3.5, sd=2.5)),nrow=100,ncol=200),function(x) if(x<1){x=1}else if (x>5){x=5} else x) # Importance
survey[,113:212]<-sapply(matrix(data=as.integer(rnorm(100*200,mean=3.5, sd=2.5)),nrow=100,ncol=200),function(x) if(x<1){x=1}else if (x>5){x=5} else x) # Satisfaction

# Add in strong signals

  # first 5 outcomes have high importance but low satisfaction for the first X records
indStartup=(survey$OrgType=="Startup")
indRandom=(survey$ID<=150)
survey[indRandom,13:17]<-as.integer(runif(sum(indRandom),min=4,max=5)+1)
survey[indRandom,113:117]<-as.integer(runif(sum(indRandom),min=2,max=4)+0.2)

  # next 5 outcomes are high importance but low satisfaction to consulting firms
indConsulting=(survey$OrgType=="Consulting")
survey[indConsulting,18:22]<-as.integer(runif(sum(indConsulting),min=4,max=6))
survey[indConsulting,118:122]<-as.integer(runif(sum(indConsulting),min=1,max=3))

  # next 5 outcomes are high importance but equally well satisfied for startups
s<-as.integer(runif(sum(indStartup),min=4,max=6))
survey[indStartup,23:27]<-s
survey[indStartup,123:127]<-s

  # next 5 outcomes are high importance but equally well satisfied for consulting firms
s2<-as.integer(runif(sum(indConsulting),min=4,max=6))
survey[indConsulting,28:32]<-s2
survey[indConsulting,128:132]<-s2

  # next 5 outcomes are overserved for all firms (i.e. low importance, high satisfaction)
indOVER=rep(c(TRUE,FALSE),c(150,50))
indOVER
survey[indOVER,33:37]<-as.integer(runif(sum(indOVER),min=1,max=5))
survey[indOVER,133:137]<-as.integer(runif(sum(indOVER),min=3,max=6))
table(as.factor(survey[,33]),survey$Country)

  # next 5 outcomes are opportunities for USA & UK firms (i.e. high importance, low satisfaction)
indUSA=(survey$Country=="USA") | (survey$Country=="UK")
survey[indUSA,38:42]<-as.integer(runif(sum(indUSA),min=4,max=6))
survey[indUSA,138:142]<-as.integer(runif(sum(indUSA),min=1,max=3))
table(as.factor(survey[,38]),survey$Country)

  # next 5 outcomes should show up as very good opportunities
indRandom2=(survey$ID<=150)
survey[indRandom,43:47]<-as.integer(runif(sum(indRandom),min=4,max=6))
survey[indRandom,143:147]<-as.integer(runif(sum(indRandom),min=2,max=5))

  # adjust to satisfaction ratings based on Product Used
manual<-(survey$ProductUsed=="Manual")
spreadsheet<-(survey$ProductUsed=="Spreadsheet")
producta<-(survey$ProductUsed=="Product A")
productb<-(survey$ProductUsed=="Product B")
productc<-(survey$ProductUsed=="Product C")
productd<-(survey$ProductUsed=="Product D")

survey[producta,113:212]<-sapply(survey[producta,113:212]+rnorm(100*length(producta),mean=1.3,sd=0.8),function(x) as.integer(x))
survey[manual,113:212]<-sapply(survey[manual,113:212]-rnorm(100*length(manual),mean=0.5,sd=0.5),function(x) as.integer(x))
survey[productb,113:162]<-sapply(survey[productb,113:162]+rnorm(50*length(productb),mean=0.8,sd=0.5),function(x) as.integer(x))
survey[productc,163:212]<-sapply(survey[productc,163:212]+rnorm(50*length(productc),mean=0.5,sd=0.5),function(x) as.integer(x))
survey[spreadsheet,113:212]<-sapply(survey[spreadsheet,113:212]-rnorm(100*length(spreadsheet),mean=0.6,sd=0.5),function(x) as.integer(x))
survey[productd,113:212]<-sapply(survey[productd,113:212]+rnorm(100*length(productd),mean=0.7,sd=0.5),function(x) as.integer(x))

#head(survey)
#summary(survey)
write.csv(survey,"mockdata.csv",row.names=FALSE)
write.csv(outcome_list,"mockoutcomes.csv",row.names=FALSE)

