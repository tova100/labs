// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Seaport{
    function name()internal pure  returns (string memory) {
        assembly{
            mstore(0x20, 0x20)
            mstore(0x47, 0x07536561706f7274)
            return(0x20, 0x60)
        }
    }
}
//solc --bin exO-1.sol6080604052600080fdfea265627a7a723158209d65599a686163bd4b8cca891e3f8ed681e8a134f530837b9bed39857b88639864736f6c63430005100032
//