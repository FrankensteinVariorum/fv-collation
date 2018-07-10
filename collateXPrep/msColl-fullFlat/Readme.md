# prepping SGA for collation

Before collation, did you remember to:
1. Run Id_Trans_sgaMSLocators.xsl over the msColl (full) files to set the location beacons on the lb elements? Use this to transform full to fullFlat.
1. Run sga-flattenHIerarchiesIDtrans.xsl over the fullFlat to flatten the rest of the hierarchies.
1. I should really collapse these two into a single process.
