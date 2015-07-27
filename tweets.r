library(ibmdbR)
mycon <- idaConnect("BLUDB", "", "")
idaInit(mycon)


df1437654379199t <- as.data.frame(ida.data.frame('"DASH014237"."TWEETS"')[ ,c('PAYLOAD')])
df1437654379199sc <- as.data.frame(ida.data.frame('"DASH014237"."TWEETS"')[ ,c( 'SENTIMENT_SCORE')])
df1437658789453 <- as.data.frame(ida.data.frame('"DASH014237"."WORKBOOK1"')[ ,c('COMPANY_NAME')])


companiesPerTweet = apply(df1437654379199t,1,function(tweet) {
    tweet = tolower(tweet)
    mask = apply(df1437658789453,1,function(company) {
        company=tolower(company)
        if (grepl(company,tweet)) {
           company
        } else {
           NA
        }
    })
    #potentialCompanies = unique(mask)
    potentialCompanies = mask
    potentialCompaniesWithoutNone = potentialCompanies[!is.na(potentialCompanies)]
    if (length(potentialCompaniesWithoutNone)==1) {
        potentialCompaniesWithoutNone
    } else {
        NA
   }
})

results = cbind(df1437654379199sc,companiesPerTweet)

myMean = function(valueList) {
    numericList=as.numeric(valueList)
    mean(numericList)
} 

aggdata <-aggregate(results$SENTIMENT_SCORE,by=list(results$companiesPerTweet), FUN=myMean)
plot(aggdata)
plot(table(companiesPerTweet))