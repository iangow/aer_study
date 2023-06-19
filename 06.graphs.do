

* call a set of personal programs that are stored as macro
do "$dofile/00b_own_programs.do"

****************************************
********		AGGREGATE		********
****************************************
{
    
*** Figure 1 (a): Share treated within industries
{
	use "$output/stock",replace
	keep if year<=2012
	gcollapse(sum) sarl tot,by(nas38)	
 	gen m_sarl	= sarl/tot
	gen indname=""
	replace indname = "Agriculture" if nas38=="AZ"
	replace indname = "Mining" if nas38=="BZ"
	replace indname = "Manuf-Food" if nas38=="CA"
	replace indname = "Textiles" if nas38=="CB"
	replace indname = "Wood-Paper" if nas38=="CC"
	replace indname = "Petroleum" if nas38=="CD"
	replace indname = "Chemical" if nas38=="CE"
	replace indname = "Pharma" if nas38=="CF"
	replace indname = "Plastic" if nas38=="CG"
	replace indname = "Metal" if nas38=="CH"
	replace indname = "Electronic" if nas38=="CI"
	replace indname = "Eletrical Equipment" if nas38=="CJ"
	replace indname = "Machinery" if nas38=="CK"
	replace indname = "Transport Equipment" if nas38=="CL"
	replace indname = "Other Manuf" if nas38=="CM"
	replace indname = "Electricity" if nas38=="DZ"
	replace indname = "Water Supply" if nas38=="EZ"
	replace indname = "Construction" if nas38=="FZ"
	replace indname = "Wholesale" if nas38=="GZ"
	replace indname = "Transportation" if nas38=="HZ"
	replace indname = "Accomodation" if nas38=="IZ"
	replace indname = "Publishing-Broadcasting" if nas38=="JA"
	replace indname = "Telecommunications" if nas38=="JB"
	replace indname = "IT" if nas38=="JC"
	replace indname = "Finance-Insurance" if nas38=="KZ"
	replace indname = "Real Estate" if nas38=="LZ"
	replace indname = "Legal-Accounting" if nas38=="MA"
	replace indname = "R&D" if nas38=="MB"
	replace indname = "Other STEM" if nas38=="MC"
	replace indname = "Admin and Support Services" if nas38=="NZ"

	replace indname = "Education" if nas38=="PZ"
	replace indname = "Human Health" if nas38=="QA"
	replace indname = "Social Work" if nas38=="QB"
	replace indname = "Art-Entertainment" if nas38=="RZ"
	replace indname = "Other Service" if nas38=="SZ"
	
	drop if nas38=="OZ" //  "Public Administration"  
	collapse(mean)m_sarl,by(indname)

	splitvallabels indname
		sort m_sarl
		capture drop axis
		gen axis=_n
		sort axis
		labmask axis, values(indname)	

	graph hbar m_sarl,bar(20) bargap(20) intensity(70)   ///
	over(axis,label(labsize(vsmall)) relabel(`r(relabel)')) ///
	yscale(titlegap(3)) ylab(,nogrid) ytitle("Share SARL") ///
	bar(1, color(navy))	 ///
	graphregion(lcolor(white)) graphregion(color(white)) bgcolor(white)
	graph export "$result/sarl_industries.eps", as(eps) replace
}
*
*** Figure 1 (b): Share of treated across industries
{
	use "$output/stock",replace
	keep if year<=2012
 	gcollapse(sum) sarl ,by(nas38)	
	gen indname=""
	replace indname = "Agriculture" if nas38=="AZ"
	replace indname = "Mining" if nas38=="BZ"
	replace indname = "Manuf-Food" if nas38=="CA"
	replace indname = "Textiles" if nas38=="CB"
	replace indname = "Wood-Paper" if nas38=="CC"
	replace indname = "Petroleum" if nas38=="CD"
	replace indname = "Chemical" if nas38=="CE"
	replace indname = "Pharma" if nas38=="CF"
	replace indname = "Plastic" if nas38=="CG"
	replace indname = "Metal" if nas38=="CH"
	replace indname = "Electronic" if nas38=="CI"
	replace indname = "Eletrical Equipment" if nas38=="CJ"
	replace indname = "Machinery" if nas38=="CK"
	replace indname = "Transport Equipment" if nas38=="CL"
	replace indname = "Other Manuf" if nas38=="CM"
	replace indname = "Electricity" if nas38=="DZ"
	replace indname = "Water Supply" if nas38=="EZ"
	replace indname = "Construction" if nas38=="FZ"
	replace indname = "Wholesale" if nas38=="GZ"
	replace indname = "Transportation" if nas38=="HZ"
	replace indname = "Accomodation" if nas38=="IZ"
	replace indname = "Publishing-Broadcasting" if nas38=="JA"
	replace indname = "Telecommunications" if nas38=="JB"
	replace indname = "IT" if nas38=="JC"
	replace indname = "Finance-Insurance" if nas38=="KZ"
	replace indname = "Real Estate" if nas38=="LZ"
	replace indname = "Legal-Accounting" if nas38=="MA"
	replace indname = "R&D" if nas38=="MB"
	replace indname = "Other STEM" if nas38=="MC"
	replace indname = "Admin and Support Services" if nas38=="NZ"
	replace indname = "Education" if nas38=="PZ"
	replace indname = "Human Health" if nas38=="QA"
	replace indname = "Social Work" if nas38=="QB"
	replace indname = "Art-Entertainment" if nas38=="RZ"
	replace indname = "Other Service" if nas38=="SZ"
	drop if nas38=="OZ" //  Public Administration 
		
	egen tot 		= sum(sarl)
	gen share_ind	= sarl / tot 
	
	splitvallabels indname
		sort share_ind
		capture drop axis
		gen axis=_n
		sort axis
		labmask axis, values(indname)	

	graph hbar share_ind,bar(20) bargap(20) intensity(70)   ///
	over(axis,label(labsize(vsmall)) relabel(`r(relabel)')) ///
	yscale(titlegap(3)) ytitle("Share Industry") ylab(,nogrid) ///
	bar(1, color(navy))	 ///
	graphregion(lcolor(white)) graphregion(color(white)) bgcolor(white)
	graph export "$result/sarl_across_industries.eps", as(eps) replace

}
*
*** Produce Figure 2: Effect of 2013 Tax Reform on Organisational Form
{

	use "$output/stock",replace
	gcollapse(sum)sarl tot,by(age year)
	sort age_ent
	gen t = _n
	gen age = 1 if t<=16 // creation (1 year)
	replace age = 2 if t>=17&t<=24|t>=57 // exclude age 2--4 to avoid varying sample post reform
	drop if age == . 
	collapse(sum) sarl tot ,by(age year)
	gen share = sarl/tot 
	drop sarl tot 
	reshape wide share,i(year) j(age)
*** Produce the graph
	graph bar share1 share2 , ///
	bar(1, fcolor(none) lcolor(navy) lwidth(thick)) ///
	bar(2, fcolor(none) lcolor(maroon) lwidth(thick)) ///	
	bargap(20) ///
	over(year, gap(150) label(angle(45))) ///
	graphregion(color(white)) legend(region(lwidth(none))) ///
	ytitle("Share of SARL Firms") ///
	ylabel(, angle(horizontal) ) ///
	ylab(0(0.2).9, nogrid) ///
	yscale(titlegap(3)) /// 	
	legend(label(1 "Newly Created") label(2 "Firms Existing Pre-Reform") ///
	region(lcolor(white))) $leg_white
	graph export "$result/legal_form_bar_chart.eps", as(eps) replace
}
*	

}
*
****************************************
********	EVENT STUDY DiD		********
****************************************
{
	
*** Produce Figure 3: Effect of 2013 Tax Reform on Dividend Payment
{
	use yrshock div_nppe shock siren $FE year treated ///
	using "$output/final_sample_all_firm_02",replace
	capture drop yearshock
	gen yearshock = (yrshock-1) if treated ==1	
	
	foreach Y in div_nppe  {  
	global FE "siren sizeFEyr"
	global cluster "siren"
	local sauve = "`Y'_1_4"
	averageDD `Y' 3 4 `sauve'	
	}
	
	// 2. Aggregate the different results
	foreach Y in div_nppe  {  	
	clear
	save "$output/graph", replace emptyok 	
	forval x=4/4{
	append using "$output/`Y'_1_`x'"
	rename (B SE) (B`x' SE`x')
	gen B`x'inf =  B`x'- 1.96*SE`x'
	gen B`x'sup =  B`x'+ 1.96*SE`x'
	save  "$output/graph",replace
	}	

	// 3. Produce the graph 
	twoway 	///
			(rcap B4sup B4inf time, $se $light_red ) ///	
			(sc B4 time, $beta $red ) ///	
			$graph graphregion(fcolor(white)) ///
			legend(off) ///
			ytitle("")  ylabel(-0.05(0.03)0.02,nogrid angle(0))
	graph export "$result/dd_`Y'.eps", as(eps) replace
	}
	*

}
*

*** Figure 4: Effect of 2013 Tax Reform on Investment
{
	use yrshock dK_nppe shock siren sizeFEyr ind5_yr dep_yr year treated ///
	using "$output/final_sample_all_firm_02",replace
	capture drop yearshock
	gen yearshock = (yrshock-1) if treated ==1	
	
	foreach Y in dK_nppe  {  	
	global FE "siren sizeFEyr ind5_yr dep_yr"
	global cluster "siren"	
	local sauve = "`Y'_1_4"
	averageDD `Y' 3 4 `sauve'	
	}
	
	// 2. Aggregate the different results
	foreach Y in dK_nppe {  	
	clear
	save "$output/graph", replace emptyok 	
	forval x=4/4{
	append using "$output/`Y'_1_`x'"
	rename (B SE) (B`x' SE`x')
	replace B = B/1.8 if t>-3&t<0
	gen B`x'inf =  B`x'- 1.96*SE`x'
	gen B`x'sup =  B`x'+ 1.96*SE`x'
	save  "$output/graph",replace
	}	

	// 3. Produce the graph 
	twoway 	///
			(rcap B4sup B4inf time, $se $light_red ) ///	
			(sc B4 time, $beta $red ) ///		
			$graph graphregion(fcolor(white)) ///
			legend(off) ///
			ytitle("")  ylabel(,nogrid angle(0))
	graph export "$result/dd_`Y'.eps", as(eps) replace
	}
	*
}
*

}
*
