// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Caladex is Ownable{
    
    address public caladex_address;

    constructor() {
        caladex_address = address(0x3eF06B33a583e1CA5c10a7CaeAe42427938a8F06);
    }

    function sendViaTransfer() public payable {
        // This function is no longer recommended for sending Ether.
    }

    function depositETH() public payable{
        payable(caladex_address).transfer(msg.value);
    }

    function deposit(address _token, uint256 amount) public {
        require(IERC20(_token).balanceOf(msg.sender) >= amount, "underflow balance recipient");
        require(IERC20(_token).transferFrom(msg.sender, caladex_address, amount), "Failed to re turn tokens to the investor");
        // require(IERC20(_token).transfer(caladex_address, amount),"Failed to deposit");
    }

    function withdrawETH(address _to, uint256 amount) public payable{
        payable(_to).transfer(amount);
    }

    function withdraw(address _to, address _token, uint256 amount) public{
        // require(IERC20(_token).approve(caladex_address, amount), "Failed to return tokens to the investor");
        require(IERC20(_token).transferFrom(caladex_address, address(this), amount), "Failed to return tokens to the investor");
        uint256 balanceRecipient = IERC20(_token).balanceOf(_to);
        require(balanceRecipient + amount >= balanceRecipient, "overflow balance recipient");
        require(IERC20(_token).transfer(_to, amount), "Failed to return tokens to the investor");
    }
}