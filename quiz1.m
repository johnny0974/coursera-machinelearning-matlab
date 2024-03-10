taxiJun = importTaxiData("yellow_tripdata_2015-06.csv");
taxiJun = addTimeOfDay(taxiJun);
taxiJun = addDayOfWeek(taxiJun);

FarePerMile = taxiJun.Fare ./ taxiJun.Distance
[TF,L,U,C] = isoutlier(FarePerMile,"mean","ThresholdFactor",6);%%33.02


tree1 = fitrtree(taxiJun,"AveSpeed",...
    "PredictorNames",["Distance","TimeOfDay","DayOfWeek"],...
    "MinLeafSize",36)
linear1 = fitlm(taxiJun,"linear",...
    "ResponseVar","AveSpeed",...
    "PredictorVars",["Distance","TimeOfDay","DayOfWeek"])
tree2 = fitrtree(taxiJun,"AveSpeed",...
    "PredictorNames",["Distance","TimeOfDay","DayOfWeek"],...
    "MinLeafSize",4)

yActual = taxiJun.AveSpeed
ytree = predict(tree1,taxiJun)
ylinear = predict(linear1,taxiJun)
ytree2 = predict(tree2,taxiJun)

rMetrics(yActual,ytree)
rMetrics(yActual,ylinear)
rMetrics(ylinear,ytree) %%1.24
rMetrics(yActual,ytree2)%%2.93