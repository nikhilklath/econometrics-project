*******************
* Nikhil Kumar
* Project Do File
*******************
clear all

capture program drop project
program define project, rclass
syntax[,a_a(integer) a_b(integer) h_a(integer) h_b(integer) l_a(integer) l_b(integer) h_a(integer) h_b(integer) alpha(integer) beta(integer) g(integer) n(integer) s(integer) delta(integer)
set obs `l_a'

forvalues
scalar Y_a = ((`a_a'*`h_a'*`l_a')^`alpha')*(`k_a'^`beta')
scalar Y_b = ((`a_b'*`h_b'*`l_b')^`alpha'')*(`k_b'^`beta')

scalar lY_apc = ln(Y_a/`l_a')
scalar lY_bpc = ln(Y_b/`l_b')

gen y_a = exp(rnormal(lY_apc,0.5))
sum y_a
scalar mean_ya = r(mean)
scalar sum_ya = r(sum)

gen y_b = exp(rnormal(lY_bpc,0.5))
sum y_b
scalar mean_yb = r(mean)
scalar sum_yb = r(sum)

gen D = mean_yb -y_a
count if D>0

gen cost = 0.5*exp(rnormal(lY_bpc,0.5))
sum cost

count if D>cost
scalar m=r(N)

calar l_a = l_a*(1+n)-m
scalar l_b = l_b*(1+n)+m

di l_a
di l_b 

scalar a_a = a_a*(1+g)
scalar a_b = a_b*(1+g)

scalar k_a = s*Y_a + (1-delta)*k_a
scalar k_b = s*Y_b + (1-delta)*k_b

end

a_a a_b h_a h_b l_a l_b h_a h_b alpha beta g n s 
