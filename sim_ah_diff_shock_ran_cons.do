clear all

cd "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\Project\Data_ah_diff_shock_ran_cons"
set seed 123456

// different A and H to begin with
// productivity shock (type c)

capture program drop myprog
program define myprog, rclass
capture drop all
scalar a_a = 40
scalar a_b = 50
scalar l_a = 100000
scalar l_b = 100000
scalar h_a = 15*(1-exp(-0.1*8))
scalar h_b = 15*(1-exp(-0.1*10))
scalar alpha = 0.67
scalar beta = 0.33
scalar k_a = 100000
scalar k_b = 100000
scalar n = 0.02
scalar g = 0.02
scalar s = 0.02
scalar delta = 0.01
scalar r = 0.05
scalar Yl_apc = 0
scalar Yl_bpc = 0

matrix M=(0,0)
matrix A_a=(0)
matrix A_b=(0)
matrix L_a=(0)
matrix L_b=(0)
matrix K_a=(0)
matrix K_b=(0)
matrix H_a=(0)
matrix H_b=(0)
matrix Y_a=(0)
matrix Y_b=(0)
matrix w_a=(0)
matrix w_b=(0)
matrix yk_a=(0)
matrix yk_b=(0)

forvalues i = 1/40{
	local more = round(max(l_a, l_b))
set obs `more'
scalar Yt_a = ((a_a*h_a*l_a)^alpha)*(k_a^beta)
scalar Yt_b = ((a_b*h_b*l_b)^alpha)*(k_b^beta)

scalar Yl_apc = alpha*Yt_a/l_a 
scalar Yl_bpc = alpha*Yt_b/l_b 

scalar lY_apc = ln(Yl_apc)
scalar lY_bpc = ln(Yl_bpc)

scalar Y_ka = beta*Yt_a
scalar Y_kb = beta*Yt_b

local a = round(l_a)
local b = round(l_b)

gen y_a = exp(rnormal(lY_apc,2)) in 1/`a'
sum y_a
scalar mean_ya = r(mean)

gen y_b = exp(rnormal(lY_bpc,2)) in 1/`b' 
sum y_b
scalar mean_yb = r(mean)

gen D1 = (mean_yb - y_a)/(1+r) in 1/`a'
count if D1>0

gen cost1 = 0.5*mean_yb in 1/`a'
sum cost1

count if D1>cost1 in 1/`a'
scalar m1=r(N)

gen D2 = (mean_ya - y_b)/(1+r) in 1/`b'
count if D2>0

gen cost2 = 0.5*mean_ya in 1/`b'
sum cost2

count if D2>cost2 in 1/`b'
scalar m2=r(N)

matrix M=(M\m1, m2)
matrix A_a=(A_a\a_a)
matrix A_b=(A_b\a_b)
matrix L_a=(L_a\l_a)
matrix L_b=(L_b\l_b)
matrix K_a=(K_a\k_a)
matrix K_b=(K_b\k_b)
matrix H_a=(H_a\h_a)
matrix H_b=(H_b\h_b)
matrix Y_a=(Y_a\Yt_a)
matrix Y_b=(Y_b\Yt_b)
matrix w_a=(w_a\Yl_apc)
matrix w_b=(w_b\Yl_bpc)
matrix yk_a=(yk_a\Y_ka)
matrix yk_b=(yk_b\Y_kb)

scalar l_a = l_a*(1+n)-m1+m2
scalar l_b = l_b*(1+n)+m1-m2

scalar shock = abs(rnormal(0.01,0.005))
scalar a_a = a_a*(1+g+shock)
scalar a_b = a_b*(1+g+0.01) 

scalar k_a = s*Yt_a + (1-delta)*k_a
scalar k_b = s*Yt_b + (1-delta)*k_b

scalar h_a = 15*(1-exp(-1*(log(15/(15-h_a))+0.001*Yl_apc)))
scalar h_b = 15*(1-exp(-1*(log(15/(15-h_b))+0.001*Yl_bpc)))

drop _all 
}

matrix X = (A_a, H_a, L_a, K_a, Y_a, w_a, yk_a, A_b, H_b, L_b, K_b, Y_b, w_b, yk_b, M )
svmat X, names(x)
drop if _n==1
rename x1 A_a
rename x2 H_a
rename x3 L_a
rename x4 K_a
rename x5 Y_a
rename x6 w_a
rename x7 Yk_a
rename x8 A_b
rename x9 H_b
rename x10 L_b
rename x11 K_b
rename x12 Y_b
rename x13 w_b 
rename x14 Yk_b 
rename x15 m1
rename x16 m2

save dataset$datasetnum, replace
global datasetnum = $datasetnum + 1

return scalar h_a = h_a
return scalar h_b = h_b
return scalar yl_a = Yt_a/l_a
return scalar yl_b = Yt_b/l_b
return scalar a_a = a_a
return scalar a_b = a_b
end

global datasetnum = 1
simulate h_a = r(h_a) h_b = r(h_b) y_a = r(yl_a) y_b = r(yl_b) A_a=r(a_a) A_b=r(a_b), reps(50): myprog
save "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\Project\simdata_ah_diff_shock_ran_cons", replace