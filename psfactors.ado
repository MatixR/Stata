*! Date     : 2018-03-12
*! version  : 0.1
*! Author   : Richard Herron
*! Email    : richard.c.herron@gmail.com

*! get Pastor-Stambaugh liquidity factor from Pastor's website

/* 
2018-03-12 v0.1 first upload to GitHub
*/

program define psfactors

	version 13.1
	syntax , clear [ KEEPfiles ]


	/* {{{ get file and read */
	local file "liq_data_1962_2016.txt"
	local cloud "https://faculty.chicagobooth.edu/lubos.pastor/research/`file'"
	copy "`cloud'" "`file'", replace
	import delimited using "`file'", `clear' rowrange(12) varnames(nonames)
	/* }}} */


	/* {{{ fix variable names */
	rename v2 agg_liq
	label variable agg_liq "Aggregated Liquidity"

	rename v3 innov_liq
	label variable innov_liq "Innovations to Liquidity"

	rename v4 traded_liq
	label variable traded_liq "Traded Liquidity"
	/* }}} */


	/* {{{ fix dates */
	generate int date = ym(floor(v1/100), mod(v1, 100)) 
	label variable date "Date"
	format date %tm
	tsset date
	/* }}} */

	
	/* {{{ clean up (remove files by default) */
	drop v1 v5
	compress

	if ("`keepfiles'" == "") {
		rm "`file'"
	}
	/* }}} */


end
