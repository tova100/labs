include "../util/number.dfy"
include "../util/math.dfy"

module Lending {
    import opened Number
    import opened Math

    function Proportion(borrow: real, deposit: real): bool
        requires deposit != 0.0 
        ensures Proportion(borrow, deposit) == (borrow / deposit <= 0.8) 
    {
        borrow / deposit <= 0.8
    }
}