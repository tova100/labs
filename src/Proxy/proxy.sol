// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract CounterV1{
    uint256 public count ;
    function inc ()external {
        count+=1;
    }
}
    contract CounterV2{
        uint256  public count;
        function inc ()external{
            count+=1;
        }
        function dec()external{
            count-=1;
        }
    }
    contract BuggyProxy{
        address public implementation;
        address public admin ;
        constructor(){
            admin=msg.sender;
        }
        function delegate () private{
            (bool,ok)=implementation.delegatecall(msg.sender);
            require(ok,"delegatecall failed");
        }
        _fallback () external payable{
            delegate();
        }
        receive() external payable{
            delegate();
        }
        function upgradeTo(address _implementation)external{
            require(msg.sender == admin,"not authorized");
            implementation=_implementation;
        }
    }
    contract Dev {
        function selector()external view returns (bytes4,bytes4,bytes4){
            return (
                Proxy.admin.selector,
                Proxy.implementation.selector,
                Proxy.upgradeTo.selector
            );
        }
    }
    /** המטרה של חוזה חכם פרוקסי 
     * (Proxy Contract) היא להפריד בין הלוגיקה של החוזה והאחסון של הנתונים, 
     * כך שניתן יהיה לשדרג את הלוגיקה של החוזה מבלי לשנות את המידע המאוחסן או כתובת החוזה. 
     * זה חשוב במיוחד בסביבות שבהן לא ניתן לשנות את החוזה לאחר פריסתו,
     *  כמו ברשת האת'ריום. */
    contract Proxy{
        bytes32 private constant  IMPLEMENTATION_SLOT=
        bytes32(uint256(keccak256("eip1967.proxy.implementation"))-1);
        bytes32 private constant ADMIN_SLOT =
        //המרה מספר מסוג bytes32 ל uint256 וכן מפחיתים -1 כי  ולהפחית את הסיכון להתנגשויות.
        bytes32(uint256(keccak256("epi1967.proxy.admin"))-1);
        constructor(){
            //מעדכן את הכתובת הלוגית של החוזה לבצע שינויים 
            setAdmin(msg.sender);
        }
        modifier ifAdmin(){
            if(msg.sender == getAdmin()){
                _;
            }
            else {
                fallback();
            }
        }
        //view: מציין שהפונקציה רק קוראת נתונים מהבלוקצ'יין ולא משנה אותם.
        function getAdmin()private view returns(address){
            return StorageSolt.getAddressSolt(ADMIN_SLOT).value;
        }
        function setAdmin(address admin)private{
            require(admin!=address(0),"admin =zero address");
            StorageSlot.getAddressSlot(ADMIN_SLOT).value=admin;
        }
        function getImplementation()private view returns (address){
            return StorageSolt.getAddressSlot(IMPLEMENTATION_SLOT).value;
        }
        function setImplementation(address implementation)private{
            require(implementation.code.length>0,"implementation is not contract");
            StorageSolt.getAddressSlot(IMPLEMENTATION_SLOT).value=implementation;
        }
        //ADMIN
        function changeAdmin(address admin)external ifAdmin{
            setAdmin(admin);
        }
        function upgradeTo(address implementation)external ifAdmin{
            setImplementation(implementation);
        }
        function admin()external ifAdmin returns(address){
            return getAdmin();
        }
        function implementation()external ifAdmin returns(address){
            return getAdmin();
        }
        function delegate(address implementation )internal virtual{
           //virtual מאפשר לחוזים שיורשים ממנה לדרוס אותה
            assembly {
                // מעתיק את כל הנתונים שהועברו לפונקציה (calldata) לזיכרון המתחיל בכתובת 0.
                //מחזירה את גודל הנתונים שהועברו לפונקציה.
                calldatacopy(0,0,calldatasize())
            }
            //מבצע קריאה לפונקציה שנמצאת בחוזה חכם של כתובת ה implementation
            let result:= delegetecall(gas(),implementation,0,calldatasize(),0,0)
            //מעתיק את כל התנונים שהוחזרו מהפונקציה לכתובת 0 ומחזירה את גודל הנתונים שהוחזרו 
            returndatacopy(0,0,returndatasize())
            //אם הוחזר 0 סימן שכשל ואם לא הצליח 
            switch result
            case 0 {
                revert (0,returndatasize())
            }
            default {
                return(0,returndatasize())
            }
        }
        function fallback()private{
            delegate(getImplementation());
        }
        fallback()external payable{
            _fallback();
        }
        receive()external payable{
            _fallback();
        }
    }
    contract ProxyAdmin{
        address public owner;
        constructor(){
            owner=msg.sender;
        }
        modifier onlyOwner{
            require(msg.sender == owner,"you are not owner");
            _;
        }
        function getProxyAdmin(address proxy)external view  returns(address){
         //staticcall קריאה בלבד 
         //הפונקציה הזאת  מטרתה להחזיר את כתובת המנהל לקריאה בלבד 
         //encodeCallמקודדת את הקוד לבינארי 
            (bool,ok,bytes memory res)=proxy.staticcall(abi.encodeCall(proxy.admin,()));
        }
        require(ok,"call failed");
        return abi.decode(res,(address));
//עד כאן
//         function getProxyImplementation(address proxy)
//         external
//         view
//         returns (address)
//     {
//         (bool ok, bytes memory res) =
//             proxy.staticcall(abi.encodeCall(Proxy.implementation, ()));
//         require(ok, "call failed");
//         return abi.decode(res, (address));
//     }
//     function changeProxyAdmin(address payable proxy, address admin)
//         external
//         onlyOwner
//     {
//         Proxy(proxy).changeAdmin(admin);
//     }
//     function upgrade(address payable proxy, address implementation)
//         external
//         onlyOwner
//     {
//         Proxy(proxy).upgradeTo(implementation);
//     }
// }
// library StorageSlot {
//     struct AddressSlot {
//         address value;
//     }
    }
    library StorageSolt{
        struct AddressSolt{
            address value;
        }
        function getAddressSolt(bytes32 solt)
        // דרך גישה בטוחה יותר לגשת לנתונים לאיחסון 
            internal //מציין שהפונקציה יכולה להיקרא רק מתוך החוזה שבו היא הוגדרה או מחוזים אחרים שיורשים ממנו.
            pure returns (AddressSolt storage r){
                assembly{
                    //מאחסן את המיקום שצריך לגשת אליו 
                    r.solt:=solt;
                }
            }
    }
    contract TestSolt{
        bytes32 public constant solt=keccak256("Test_solt");
        function getSolt()external view returns(address){
            return StorageSolt.getAddressSlot(solt).value;
        }
        function writeSolt(address addr)external {
            StorageSolt.getAddressSlot(solt).value=addr;
        }
    }