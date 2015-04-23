timestamp=as.numeric(df1429616120827$TIMESTAMP)

maxTimestamp=max(timestamp)
cutOffTimestamp=maxTimestamp - 600
idx = which(df1429616120827$TIMESTAMP>cutOffTimestamp)
idx
workingSubset=df1429616120827[idx,]
workingSubset
values=as.numeric(workingSubset$VALUE)
globalMean=mean(values)
globalSD=sd(values)

devideIds=unique(workingSubset$DEVICEID)
devideIds
scores = 1:length(devideIds)
for (i in 1:length(devideIds)) {
    idx = which(workingSubset$DEVICEID==devideIds[i])
    df=workingSubset[idx,]
    values=as.numeric(df$VALUE)
    #scores[i]=sqrt((globalMean+ mean(values))^2) +sqrt((globalSD+ sd(values))^2)
    scores[i]=abs(globalSD- sd(values))
}
scores
if (max(scores)>10) {
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
idadf(mycon,paste('update DASH100527.ALERT set SENSOR=',devideIdOutlier))


#plot(df$TIMESTAMP,df$VALUE)
#plot(Re(fft(as.numeric(df$VALUE)))^2)


