# Gert Sterenborg and Job de Pater
# 20160113
# 

source("R/mainFunction.R")

## per province:
mainFunction()

## per municipality:
mainFunction(area="municipality") ##takes a long time!!!! (around 60 seconds on my pc)

##per sub state in Germany:
mainFunction(country = "Germany", area="provinces")

##per sub state in Belgium:
mainFunction(country = "Belgium", area="provinces")

##per province in Belgium:
mainFunction(country = "Belgium", area="belgiumMunicipality")