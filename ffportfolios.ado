*! Date		: 2018-03-25
*! version	: 0.2
*! Author	: Richard Herron
*! Email	: richard.c.herron@gmail.com

*! get Fama-French portfolios from French Data Library

/* {{{ version history
2018-03-25 v0.2 added option to select one of ten data sections
2018-03-18 v0.1 first upload to GitHub
}}} */

program define ffportfolios

	version 13.1
	syntax , clear [ KEEPfiles 5x5 10x10 SECtion(integer 1) ]
	
	/* parameters */
	local web "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp"
	
	/* {{{ data sections in file
		1--VW monthly returns
		2--EW monthly returns
		3--VW annual returns
		4--EW annual returns
		5--number of firms in portfolio
		6--average ME
		7--average VW BE/ME
		8--average VW BE/ME (alternate scheme)
		9--average VW OP
		10--average VW dA/A
	}}} */

	if ("`5x5'" == "5x5") {
		local zip "25_Portfolios_5x5_CSV.zip"
		local csv "25_Portfolios_5x5.CSV"
	}
	else if ("`10x10'" == "10x10") {
		local zip "100_Portfolios_10x10_CSV.zip"
		local csv "100_Portfolios_10x10.CSV"
	}
	else {
		display as error "Please select either 5x5 or 10x10 portfolios"
		exit
	}

	/* get file */
	copy "`web'/`zip'" "`zip'", replace
	unzipfile "`zip'", replace

	/* read file */
	import delimited using "`csv'", ///
		`clear' numericcols(_all) varnames(16) rowrange(17)
	compress

	/* select data section */

	generate temp = sum(missing(v1))	// flag sections in file
	drop if missing(v1)			// drop section breaks
	egen temp2 = group(temp)		// number sections
	keep if (temp2 == `section')		// see section list above
	drop temp temp2

	/* fix date */
	generate int Date = ym(floor(v1/100), mod(v1, 100)) 
	format Date %tm
	label variable Date "Date"
	order Date
	drop v1

	/* fix labels */
	quietly ds, not(varlabel)
	foreach v in `r(varlist)' {
		label variable `v' "`v'"
	}

	/* by default, remove files */
	if ("`keepfiles'" == "") {
		rm "`zip'"
		rm "`csv'"
	}

end
