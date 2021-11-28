// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library Utils {
    /**
   * @param fromToken Address of the source token
   * @param fromAmount Amount of source tokens to be swapped
   * @param toAmount Minimum destination token amount expected out of this swap
   * @param expectedAmount Expected amount of destination tokens without slippage
   * @param beneficiary Beneficiary address
   * 0 then 100% will be transferred to beneficiary. Pass 10000 for 100%
   * @param path Route to be taken for this swap to take place

   */

    struct BuyData {
        address fromToken;
        address toToken;
        uint256 fromAmount;
        uint256 toAmount;
        address payable beneficiary;
        string referrer;
        bool useReduxToken;
        Utils.BuyRoute[] route;
    }

    struct BuyRoute {
        address payable exchange;
        address targetExchange;
        uint256 fromAmount;
        uint256 toAmount;
        bytes payload;
        uint256 networkFee;//Network fee is associated with 0xv3 trades
    }

    struct SellData {
        address fromToken;
        uint256 fromAmount;
        uint256 toAmount;
        uint256 expectedAmount;
        address payable beneficiary;
        Utils.Path[] path;
        address payable partner;
        uint256 feePercent;
        bytes permit;
        uint256 deadline;
        bytes16 uuid;
    }

    struct MegaSwapSellData {
        address fromToken;
        uint256 fromAmount;
        uint256 toAmount;
        uint256 expectedAmount;
        address payable beneficiary;
        Utils.MegaSwapPath[] path;
        address payable partner;
        uint256 feePercent;
        bytes permit;
        uint256 deadline;
        bytes16 uuid;
    }

    struct SimpleData {
        address fromToken;
        address toToken;
        uint256 fromAmount;
        uint256 toAmount;
        uint256 expectedAmount;
        address[] callees;
        bytes exchangeData;
        uint256[] startIndexes;
        uint256[] values;
        address payable beneficiary;
        address payable partner;
        uint256 feePercent;
        bytes permit;
        uint256 deadline;
        bytes16 uuid;
    }

    struct Adapter {
        address payable adapter;
        uint256 percent;
        uint256 networkFee;
        Route[] route;
    }

    struct Route {
        uint256 index;//Adapter at which index needs to be used
        address targetExchange;
        uint percent;
        bytes payload;
        uint256 networkFee;//Network fee is associated with 0xv3 trades
    }

    struct MegaSwapPath {
        uint256 fromAmountPercent;
        Path[] path;
    }

    struct Path {
        address to;
        uint256 totalNetworkFee;//Network fee is associated with 0xv3 trades
        Adapter[] adapters;
    }
}
interface IParaswap {
    // function simplBuy(
    //     address fromToken,
    //     address toToken,
    //     uint256 fromAmount,
    //     uint256 toAmount,
    //     address[] memory callees,
    //     bytes memory exchangeData,
    //     uint256[] memory startIndexes,
    //     uint256[] memory values,
    //     address payable beneficiary,
    //     string memory referrer,
    //     bool useReduxToken
    // )
    // external
    // payable;

    function simpleSwap(
        Utils.SimpleData calldata data
    )
    external
    payable
    returns (uint256 receivedAmount);

    function buy(
        Utils.BuyData memory data
    )
    external
    payable
    returns (uint256);

    function multiSwap(
        Utils.SellData calldata data
    )
    external
    payable
    returns (uint256);

    function simpleBuy(
        Utils.SimpleData calldata data
    )
    external
    payable;

    function swapOnUniswap(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path
    )
    external
    payable;
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface ITokenTransferProxy {
    function transferFrom(
        address token,
        address from,
        address to,
        uint256 amount
    )
    external;
}

contract Exchanger {
    address private token1address = 0xaD6D458402F60fD3Bd25163575031ACDce07538D; // DAI
    address private token2address = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE; // ETH?

    uint private SLIPPAGE = 1; // 1%

    address private tokenTransferAddress = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;
    address private augustusSwapperAddress = 0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57;

    // IParaswap private paraswapContract;

    constructor() {
        IERC20(token1address).approve(tokenTransferAddress, 100000000000000000000);
        // IERC20(token2address).approve(tokenTransferAddress, 100000000000000000000);
        // IERC20(token1address).approve(tokenTransferAddress, 100000000000000000000);
        // IERC20(token2address).approve(tokenTransferAddress, 100000000000000000000);
    }

    //     constructor(
    //         address token1_,
    //         address paraswap_
    //     ) {
    //         token1address = token1_;
    //         paraswapContract = IParaswap(paraswap_);

    // // IERC20(token1_).approve(address(this), _amountIn);
    //         // IERC20(token1_).approve(address(this), 100000000000000000000);
    //     }

    receive() external payable {
    }

    fallback() external payable {}

    function swap(uint256 fromAmount) public {

        // IERC20(token1address).approve(tokenTransferAddress, fromAmount);

        // address[] memory callees;
        // bytes memory exchangeData;
        uint256[] memory startIndexes = new uint256[](1); // execution reverted: Start indexes must be 1 greater then number of callees
        startIndexes[1] = 1;

        // uint256[] memory values;
        // address payable beneficiary = payable(address(this));
        // address payable partner;
        // bytes memory permit;
        // bytes16 uuid;
        // Utils.BuyRoute[] memory buyRoute;

        uint toAmount = fromAmount * (1 - SLIPPAGE / 100);

        // Utils.SellData memory data = Utils.SellData({
        //     fromToken: token2address,
        //     toToken: token1address,
        //     fromAmount: fromAmount,
        //     toAmount: toAmount,

        //     beneficiary: beneficiary,
        //     referrer: '',
        //     useReduxToken: false,
        //     route: buyRoute
        // });

        address[] memory path = new address[](2);
        path[1] = token2address;
        path[2] = token1address;

        // uint8 referrer;


        //         function transferTokens(
        //     address token,
        //     address payable destination,
        //     uint256 amount
        // )
        // internal
        // {
        //     if (amount > 0) {
        //         if (token == ETH_ADDRESS) {
        //             (bool result, ) = destination.call{value: amount, gas: 10000}("");
        //             require(result, "Failed to transfer Ether");
        //         }
        //         else {
        //             IERC20(token).safeTransfer(destination, amount);
        //         }
        //     }

        // }


        (bool result, ) = augustusSwapperAddress.call{value: fromAmount, gas: 10000}(
            abi.encodeWithSignature("swapOnUniswap(uint256 amountIn, uint256 amountOutMin, address[] calldata path)",
            fromAmount,
            toAmount,
            path
            )
        );


        // IParaswap(augustusSwapperAddress).swapOnUniswap({
        //     amountIn: fromAmount,
        //     amountOutMin: toAmount,
        //     path: path
        // });

        // Utils.BuyData memory data = Utils.BuyData({
        //     fromToken: token2address,
        //     toToken: token1address,
        //     fromAmount: fromAmount,
        //     toAmount: toAmount,

        //     beneficiary: beneficiary,
        //     referrer: '',
        //     useReduxToken: false,
        //     route: buyRoute
        // });

        // IParaswap(augustusSwapperAddress).buy(data);


        // Utils.SimpleData memory data = Utils.SimpleData({
        //     fromToken: token2address,
        //     toToken: token1address,
        //     fromAmount: fromAmount,
        //     toAmount: toAmount,
        //     expectedAmount: 0,

        //     callees: callees,
        //     exchangeData: exchangeData,
        //     startIndexes: startIndexes,
        //     values: values,

        //     beneficiary: beneficiary,
        //     partner: partner,

        //     feePercent: 0,
        //     permit: permit,

        //     deadline: 2637785152,
        //     uuid: uuid
        // });

        // IParaswap(augustusSwapperAddress).simpleSwap(data);

    }

    // function swapBack() public {}

    function getBalance() public view returns(uint, uint) {
        return (
        address(this).balance,
        IERC20(token1address).balanceOf(address(this))
        );
    }

    // function topup() public payable {
    // }

    // function _safeTransferFrom(
    //     IERC20 token,
    //     address sender,
    //     address recipient,
    //     uint amount
    // ) private {
    //     bool sent = token.transferFrom(sender, recipient, amount);
    //     require(sent, "Token transfer failed");
    // }

    // function getBalance() public view returns (uint) {
    //     return address(this).balance;
    // }
}