// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/upgrades-core/contracts/Initializable.sol";

contract Caladex is Initializable{
    
    address public caladex_address;

    function initialize() public  {
        caladex_address = address(0x3eF06B33a583e1CA5c10a7CaeAe42427938a8F06);
    }
    
    function sendViaTransfer() public payable {
        // This function is no longer recommended for sending Ether.
    }

    function deposit(address _token, bytes32 symbol, uint256 amount) public payable{
        bytes32  eth_data = "ETH";
        if(symbol == eth_data) {
            payable(caladex_address).transfer(amount);
            return;
        }
        require(IERC20(_token).balanceOf(msg.sender) >= amount, "underflow balance recipient");
        require(IERC20(_token).transferFrom(msg.sender, caladex_address, amount), "Failed to return tokens to the investor");
    }

    function withdraw(address _address, address token_address, bytes32 symbol, uint256 amount) public payable{
        bytes32  eth_data = "ETH";
        if(symbol == eth_data) {
            payable(_address).transfer(amount);
            return;
        }
        require(IERC20(token_address).approve(caladex_address, amount), "Failed to return tokens to the investor");
        require(IERC20(token_address).transferFrom(caladex_address, address(this), amount), "Failed to return tokens to the investor");
        uint256 balanceRecipient = IERC20(token_address).balanceOf(_address);

        require(balanceRecipient + amount >= balanceRecipient, "overflow balance recipient");
        require(IERC20(token_address).transfer(_address, amount), "Failed to return tokens to the investor");
    }
}