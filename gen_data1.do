clear all

cd "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\Project"
use simdata1.dta

hist y_a, frac width(10) xtitle("A's Y/L after 40 periods")
graph save y_a1,replace
hist y_b, frac width(10) xtitle("B's Y/L GDP after 40 periods")
graph save y_b1, replace
 
hist A_a,frac width(2) xtitle("A's productivity after 40 periods")
graph save A_a1,replace
hist A_b,frac width(2) xtitle("B's productivity after 40 periods")
graph save A_b1,replace

graph combine y_a1.gph y_b1.gph, row(1)
graph save hist_y1.gph, replace
graph combine A_a1.gph A_b1.gph, row(1)
graph save hist_A1.gph, replace

sum y_a y_b h_a h_b A_a A_b 

forvalues i =12(12)50{
    clear all
    cd "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\Project\Data1"
	use dataset`i'
	gen year =_n
	
	line Y_a year || line Y_b year, ylabel(,angle(0))
	graph save y`i', replace
	
	gen Y_apc = Y_a/L_a 
	gen Y_bpc = Y_b/L_b
	line Y_apc year || line Y_bpc year, ylabel(,angle(0))
	graph save y_pc`i', replace
	
	line K_a year || line K_b year, ylabel(,angle(0))
	graph save k_r`i', replace
	
	line L_a year || line L_b year, ylabel(,angle(0))
	graph save l_r`i', replace

	line A_a year || line A_b year, ylabel(,angle(0))
	graph save a_r`i', replace
}

graph combine y24.gph y_pc24.gph k_r24.gph l_r24.gph a_r24.gph
graph save case1.gph, replace
graph combine y12.gph y24.gph y36.gph y48.gph, title("GDP trend")
graph save y, replace
graph combine y_pc12.gph y_pc24.gph y_pc36.gph y_pc48.gph, title("Per Capita GDP trend")
graph save y_pc, replace
graph combine k_r12.gph k_r24.gph k_r36.gph k_r48.gph, title("capital trend")
graph save k_r, replace
graph combine l_r12.gph l_r24.gph l_r36.gph l_r48.gph, title("labor trend")
graph save l_r, replace
graph combine a_r12.gph a_r24.gph a_r36.gph a_r48.gph, title("productivity trend")
graph save a_r, replace