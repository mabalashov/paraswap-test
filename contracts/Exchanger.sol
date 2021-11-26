// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./paraswap/IParaswap.sol";
import "./paraswap/lib/Utils.sol";

contract Exchanger is Ownable {
    address private token1address;
    address private token2address;

    address private paraswapAddress;

//    IParaswap private paraswapContract;

    event EthDeposited(uint256 value);

    constructor(address token1_, address token2_, address paraswap_) {
        token1address = token1_;
        token2address = token2_;
        paraswapContract = IParaswap(paraswap_);
    }

    function depositEth() public payable {
        emit EthDeposited(msg.value);
    }

    // https://developers.paraswap.network/api/examples
    function swap(uint256 fromAmount) public onlyOwner {
        Utils.SimpleData memory swapData = Utils.SimpleData(
            token1address,
            token2address,
            fromAmount,

        );

        paraswapContract.simpleSwap(swapData);
    }

    function swapBack() public onlyOwner {}

    function balance() public view returns(uint256, uint256) {
        return (
//            address(this).balance,
            IERC20(token1address).balanceOf(address(this)),
            IERC20(token2address).balanceOf(address(this))
        );
    }
}