library(ibmdbR)
mycon <- idaConnect("BLUDB", "", "")
idaInit(mycon)

df1455094435404 <- as.data.frame(ida.data.frame('"DASH105608"."TEMPERATURE"')[ ,c('NAME', 'TEMPERATURE', 'TIMESTAMP')])


timestamp=as.numeric(strptime(df1455094435404$TIMESTAMP, "%Y-%m-%d %H:%M:%S.000000"))


maxTimestamp=max(timestamp)
cutOffTimestamp=maxTimestamp - 10
idx = which(timestamp>cutOffTimestamp)
#idx
workingSubset=df1455094435404[idx,]
#workingSubset
#values=as.numeric(workingSubset$TEMPERATURE)
#globalMean=mean(values)
#globalSD=sd(values)

#globalMean
#globalSD

devideIds=unique(workingSubset$NAME)
#devideIds
scores = 1:length(devideIds)
for (i in 1:length(devideIds)) {
    idx = which(workingSubset$NAME==devideIds[i])
    df=workingSubset[idx,]
    values=as.numeric(df$TEMPERATURE)
    #scores[i]=(sqrt((globalMean- mean(values))^2) +sqrt((globalSD- sd(values))^2))/2
    #scores[i]=abs(globalSD- sd(values))
    scores[i]=sd(values)
}
scores
if (max(scores)>1) {
devideIdOutlier=devideIds[scores==max(scores)]
} else {
devideIdOutlier=0;
}

#scores
#devideIds
devideIdOutlier

#f=file(paste('http://noderkie.mybluemix.net/srv?sensor=',devideIdOutlier))
#read.delim(f)

#channel <- odbcConnect("BLUDB",believeNRows=FALSE)
#df = data.frame(matrix(vector(length=2), 1, 2, dimnames=list(c(), c("SENSOR", "TIMESTAMP"))))
#df1429626163374$SENSOR[1]=devideIdOutlier
#df1429626163374$TIMESTAMP[1]=Sys.time()
#df$SENSOR[1]=devideIdOutlier
#df$TIMESTAMP[1]=Sys.time()
#df
#sqlSave(channel, df1429626163374, tablename = '"DASH100527"."ALERT2"')
#idaUpdate(mycon, updf=df,dfrm=df1429626163374,tablename = '"DASH100527"."ALERT"')
#idaSave(mycon, dfrm=df1429626163374)
#idadf(mycon,'insert into DASH100527.ALERT values ("test",0)')
#idadf(mycon,paste('update DASH100527.ALERT set SENSOR=',devideIdOutlier))
#idadf(mycon,paste('update DASH100527.ALERT set SENSOR=','18'))


#plot(df$TIMESTAMP,df$VALUE)
#plot(Re(fft(as.numeric(df$VALUE)))^2)

