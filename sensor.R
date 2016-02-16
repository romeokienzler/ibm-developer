library(ibmdbR)
mycon <- idaConnect("BLUDB", "", "")
idaInit(mycon)

df <- as.data.frame(ida.data.frame('"DASH110683"."TEMPERATURE"')[ ,c('NAME', 'TEMPERATURE', 'TIMESTAMP')])

pattern="%Y-%m-%d %H:%M:%S.000000"

timestamp=as.numeric(strptime(df$TIMESTAMP, pattern))


maxTimestamp=max(timestamp)
cutOffTimestamp=maxTimestamp - 10
idx = which(timestamp>cutOffTimestamp)
#idx
workingSubset=df[idx,]
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

#dfalert <- as.data.frame(ida.data.frame('"DASH110683"."alert"')[ ,c('sensor')])
#dfalert
#idaUpdate(mycon, dfrm=dfalert)
idadf(mycon,paste('update DASH110683.alert set sensor=\'',devideIdOutlier,'\''))

