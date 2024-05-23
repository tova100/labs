include "../util/number.dfy"
include "../util/math.dfy"

module Lending {
    import opened Number
    import opened Math

    function Proportion(num1: real, num2: real): bool
        requires num2 != 0.0 
        ensures Proportion(num1, num2) == (num1 / num2 <= 0.8) 
    {
        num1 / num2 <= 0.8
    }
}