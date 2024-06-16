pragma solidity 0.8.20;
//transient storage -זה נתונים שלאחר הטרנזקציה הם נמחקים 
contract TransientStorge{
    interface ITest{
        function val()external view returns (uint256);
        function test()external; 
    }
    contract Callback{
        uint256 public val;
        fallback()external{
            val=ITest(msg.sender).val();
        }
        function test(address target)external {
            ITest(target).test();
        }
    }
    contract TestStorage{
        uint256 public val;
        function test()public{
            val=123;
            bytes memory b ="";
            msg.sender.call(b);
        }
    }

    function TestrasientStorage{
        bytes32 constant SOLT;
        function test()public {
            assembly{
                tstore(SOLT,321)
            }
            bytes memory b="";
            msg.sender.call(b);
        }
        function val()public view returns(uint256 v){
            assembly{
                v:=tload(SOLT)
            }
        }
    }
    contract ReentrancyGuard{
        bool private lock;
        modifier lock{
            require(!lock);
                lock=true;
            _;
            lock=false;
        }
        function test() lock public{
            bytes b= "";
            msg.sender.call(b);
        }
    }
    contract ReentrancyGuardTransient{
        bytes32 constant SOLT=0;
        modifier{
            if(tload(SOLT){revert(0,0)}tstore (SOLT,1))
            _;
            assembly{
                tstore(SOLT,0)
            }
        }
        function test()external lock{
            bytes memory b="";
            msg.sender.call(b);
        }
    }
}