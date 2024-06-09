rule transferSpec (address recipient,uint amount){
    env e ;
    //mathint -type like intgert
    mathint balance_sender_before = balanceOf(e.msg.sender);
    mathint balance_recipe_before = balanceOf(recipient);
    transfer(e,recipient,amount);
    mathint balance_sender_after = balanceOf(e.msg.sender);
    mathint balance_recipe_after = balanceOf(recipient);
    assert balance_sender_after == balance_sender_before - amount ,"transfer nust decrease sender balance by amount";
    assert balance_recipe_after == balance_recipe_before + amount ,
    "transfer must increas recipient balance by amount"
}