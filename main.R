# Gert Sterenborg and Job de Pater
# 20160113
# 

source("R/mainFunction.R")

## per province:
mainFunction()

## per municipality:
mainFunction(area="city") ##takes a long time!!!! (around 60 seconds on my pc)
