include "../util/number.dfy"
include "../util/math.dfy"

module Lending {
    import opened Number
    import opened Math

    //יחס הניצול -היחס שהוא לוקח בהתאם למשיכות מהבריכה 
    function utilizationRatio(borrow: real, deposit: real): bool
        requires deposit != 0.0 
        ensures utilizationRatio(borrow, deposit) == (borrow / deposit <= 0.8) 
    {
        borrow / deposit <= 0.8
    }
    function  interestMult(utilizationRatio : real ,baseRate:real , annualBorrow:real ) : real
        requires utilizationRatio != 0.0
        ensures interestMult(utilizationRatio ,baseRate, annualBorrow) == ((annualBorrow / baseRate) / utilizationRatio > )
    {
         
    }



}