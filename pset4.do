*** health.dta - what groups of people exhibit the highest freq of depression
use /health.dta, clear

** First consider demograph - race and age grup
* some entries have indicators that the age group is both 18-24 and 25-34 (for example) which is not possible so we filter them out
preserve
keep if tm1_dem_age_band_1824 + tm1_dem_age_band_2534 + tm1_dem_age_band_3544 + tm1_dem_age_band_4554 + tm1_dem_age_band_5564 + tm1_dem_age_band_6574 + tm1_dem_age_band_75 == 1

* creates a readable age_group column
generate age_group = 0
replace age_group = 20 if tm1_dem_age_band_1824 == 1
replace age_group = 30 if tm1_dem_age_band_2534 == 1
replace age_group = 40 if tm1_dem_age_band_3544 == 1
replace age_group = 50 if tm1_dem_age_band_4554 == 1
replace age_group = 60 if tm1_dem_age_band_5564 == 1
replace age_group = 70 if tm1_dem_age_band_6574 == 1
replace age_group = 80 if tm1_dem_age_band_75 == 1

* regressions for age and race respectively
regress tm1_depression_elixhauser age_group
regress tm1_depression_elixhauser tm1_dem_black

* plots graph of percentage of white age groups and black age groups who have depression
collapse (mean) tm1_depression_elixhauser, by (age_group race)
twoway line tm1_depression_elixhauser age_group if race == "white" || line tm1_depression_elixhauser age_group if race == "black", legend(order(1 "White" 2 "Black")) ytitle("Percentage of age group with depression") xtitle("Age")


** We then consider other factors such as obesity, alcohol abuse and drug abuse
restore

* Compare obese vs not obese
generate obesity = "Is not obese"
replace obesity = "Is obese" if tm1_obesity_elixhauser == 1
graph bar tm1_depression_elixhauser, over(obesity) ytitle("Population affected by depression") sort() yscale(range(0.4)) xsize(3)

* Compare drug abuse vs no drug abuse
generate drug_abuse = "No drug abuse"
replace drug_abuse = "Signs of drug abuse" if tm1_drugabuse_elixhauser == 1
graph bar tm1_depression_elixhauser, over(drug_abuse) ytitle("Population affected by depression") sort() yscale(range(0.4)) xsize(3)

* Compare alcohol abuse vs no alcohol abuse
generate alc_abuse = "No alcohol abuse"
replace alc_abuse = "Signs of alcohol abuse" if tm1_alcohol_elixhauser == 1
graph bar tm1_depression_elixhauser, over(alc_abuse) ytitle("Population affected by depression") sort() yscale(range(0.4)) xsize(3)

** Performs various regressions
regress tm1_depression_elixhauser tm1_obesity_elixhauser
regress tm1_depression_elixhauser tm1_drugabuse_elixhauser
regress tm1_depression_elixhauser tm1_alcohol_elixhauser


