/*******************************************************************************
 Program for calculating the standardized cumulative abnormal return  
    Inputs:
        varlist = a list of names of coefficient names that are used to calculate car

    Mandatory Options:
        b = the name of the matrix of the coefficients from an event study regression i.e. e(b)
        vcov = the name of the variance-covariance matrix from the event study regression i.e. e(V)

    Returns:
        r(car) = the cumulative abnormal return associated with the event
        r(scar) = the standardized cumulative abnormal return associated with the event

    Example:

    reg ret mkt event_lag1 event event_lead1, vce(robust)  // where event_* is an indicator for the day of the event
    matrix b = e(b)
    matrix v = e(V)
    scar event_lag1 event event_lead1, b(b) vcov(v)

    Jonathan Kalodimos <jonathan.kalodimos@gmail.com>
    2013-06-26
*******************************************************************************/


capture program drop scar
program define scar, rclass
    version 12
    syntax varlist, b(namelist) vcov(namelist)
    tempname scar car var
    matrix `scar'     = J(1, 1, 0)
    matrix `car'      = J(1, 1, 0)
    matrix `var'      = J(1, 1, 0)

    foreach i of local varlist {
        foreach j of local varlist {

        // not correct
*        matrix `var'[1, 1] = `vcov'["`i'", "`j'"] + `var'[1, 1]

        }
        
        matrix `car'[1, 1] = `b'[1, "`i'"] + `car'[1, 1]

    }

    matrix `scar'[1, 1] = `car'[1, 1] / sqrt(`var'[1, 1])

    return scalar car = `car'[1, 1]
    return scalar var = `var'[1, 1]
    return scalar scar = `scar'[1, 1]

end

