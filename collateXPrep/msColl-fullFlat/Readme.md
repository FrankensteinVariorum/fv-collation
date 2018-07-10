# prepping SGA for collation

Before collation, did you remember to:
1. Run Id_Trans_sgaMSLocators.xsl to set the location beacons on the lb elements? 
1. Run sga-flattenHIerarchiesIDtrans.xsl to flatten the rest of the hierarchies.
1. I should really collapse these two into a single process.
