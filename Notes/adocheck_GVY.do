foreach req in spmap wbopendata mergemany {
	cap findfile `req'.ado
	if _rc != 0 {
		di in green "worldstat is built using the functionality of the module wbopendata.  Installing..."
		qui ssc install `req', replace all
	}
}
