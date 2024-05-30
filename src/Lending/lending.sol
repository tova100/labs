// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./mathLending.sol";

interface ILendingPool {
    function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;

    function withdraw(address asset, uint256 amount, address to) external returns (uint256);
}

interface IWETHGateway {
    function depositETH(address lendingPool, address onBehalfOf, uint16 referralCode) external payable;

    function withdrawETH(address lendingPool, uint256 amount, address onBehalfOf) external;
}

contract Lending {
    using Mathl for uint256;

    ILendingPool public constant aave = ILendingPool(0x56Ab717d882F7A8d4a3C2b191707322c5Cc70db8);
    IWETHGateway public constant wethGateway = IWETHGateway(0x2Fa2e7a6dEB7bb51B625336DBe1dA23511914a8A);
    mapping(address => uint256) borrowedUsers;
    mapping(address => uint256) collateralUsers;
    uint256 public baseRate = 20000000000000000;
    uint256 public borrowRate = 300000000000000000;

    uint256 public totalBorrowed;
    uint256 public totalReserve;
    uint256 public totalDeposit;
    uint256 public totalCollateral;
    IERC20 DAI;
    
    IERC20 tokenDai;
    IERC20 tokenETH;
    uint256 public maxLTV = 4;

    receive() external payable {}
    //מחזיר את הערך הנוכחי של HTE

    function getLatestPrice() public view returns (int256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        return price * 10 ** 10;
    }

    function withdrawWethFromAave(uint256 _amount) internal {
        aWeth.approve(address(wethGateway), _amount);
        wethGateway.withdrawETH(address(aave), _amount, address(this));
    }

    function withdrawDaiFromAave(uint256 _amount) internal {
        aave.withdraw(address(tokenDai), _amount, msg.sender);
    }

    function _sendWethToAave(uint256 _amount) internal {
        wethGateway.depositETH{value: _amount}(address(aave), address(this), 0);
    }

    function sendDaiToAave(uint256 amount) internal {
        //לאשר לפרוטוקול אבה לקבל כסף
        tokenDai.approve(address(aave), amount);
        aave.deposit(address(tokenDai), amount, address(this), 0);
    }

    modifier isCorrect(uint256 amount) {
        require(amount > 0, "MUST BE BEGGER ZERO");
        _;
    }

    constructor(address _DAI, address _token) public {
        tokenDai = IERC20(_token);
        DAI = IERC20(_DAI);
    }

    function depositDAI(uint256 Dai) public isCorrect(Dai) {
        //get Dai and transfer tokens of dai
        //transfer to smart contract
        require(DAI.balanceOf(msg.sender) >= Dai, "you dont have enough dai");
        DAI.approve(address(this), Dai);
        DAI.transferFrom(msg.sender, address(this), Dai);
        sendDaiToAave(Dai);
        totalDeposit += Dai;
        uint256 tokenDaiAmount = getExp(Dai, getExchangeRate());

        //transfer to user token dai
        tokenDai.mint(msg.sender, tokenDaiAmount); //מנפיקה טוקנים שיהיה לי להחזיר למי שמפקיד דאי
    }
    //withdraw dai

    function withdrawDai(uint256 amount) public isCorrect(amount) {
        require(amount <= msg.sender.balanceOf(msg.sender), "Not enough Token!");
        DAI.transferFrom(address(this), msg.sender, amount);
        uint256 daiToReceive = mulExp(amount, getExchangeRate());
        tokenDai.burn(amount);
        withdrawDaiFromAave(amount);
        totalDeposit -= daiToReceive;
    }

    function addCollateral(uint256 amount) public payable isCorrect(amount) {
        //get ETH and transfer DAI
        totalCollateral += amount;
        collateralUsers[msg.sender] += amount;
        _sendWethToAave(amount);
    }

    function removeCollateral(uint256 amount) public isCorrect(amount) {
        // remove ETH
        //אתריום ששוה עכשיו בשוק
        uint256 wethPrice = uint256(getLatestPrice());
        //כמות הביטחונות של משתמש ספציפי
        uint256 collateral = collateralUsers[msg.sender];
        require(collateral >= amount, "cant take ETH ");
        uint256 borrowed = borrowedUsers[msg.sender];
        //amount left -כמה ביטחונות ישארו לאחר שיחזיר את ההלואה שלקח
        uint256 left = mulExp(collateral, wethPrice).sub(borrowed);
        //amount to remove  כמה אתריום בטחונות רוצה למשוך
        uint256 toRemove = mulExp(amount, wethPrice);
        //בודק האם הבטחונות שישארו לאחר שיחזיר הלוואה יותר גדול מכמות הביטחונות שרוצה למשוך
        require(toRemove < left, "Not enough collateral to remove");
        collateralUsers[msg.sender] -= amount;
        totalCollateral -= amount;
        withdrawWethFromAave(amount);
        //explain
        payable(address(this)).transfer(amount);
    }
    //borrow

    function borrowDai(uint256 amount) public {
        require(collateralUsers[msg.sender] > 0, "you dont have any collateral");
        uint256 borrowed = borrowedUsers[msg.sender];
        uint256 collateral = collateralUsers[msg.sender];
        //בודק את הערך של האתריום היום בשוק ומכפיל בסך הביטחונות שיש למשתמש
        uint256 left = mulExp(collateral, uint256(getLatestPrice())) - borrowed;
        //מחזיר כמה יש אפשרות להלוואות
        uint256 borrowLimit = percentage(left, maxLTV);
        require(borrowLimit >= amount, "you cant borrow");
        DAI.transferFrom(address(this), msg.sender, amount);
        borrowedUsers[msg.sender] += amount;
        totalBorrowed += amount;
        withdrawDaiFromAave(amount);
    }

    function repay(uint256 amount) public {
        require(borrowedUsers[msg.sender] > 0, "you dont have any debt to return ");
        uint256 ratio = getExp(totalBorrowed, totalDeposit);
        uint256 interestMul = getExp(borrowRate - baseRate, ratio);
        uint256 rate = mulExp(ratio, interestMul) + baseRate;
        uint256 fee = amount * rate;
        uint256 paid = amount - fee;
        totalReserve += fee;
        totalBorrowed -= paid;
        borrowedUsers[msg.sender] -= paid;
        sendDaiToAave(amount);
    }

    function triggerLiquidation(address user) public {
        uint256 barrowed = borrowedUsers[user];
        uint256 collateral = collateralUsers[user];
        uint256 left = mulExp(collateral, getLatestPrice()) - barrowed;

        percentage(left, maxLTV);
    }

    function getExchangeRate() public view returns (uint256) {
        if (totalSupply() == 0) {
            return 1000000000000000000;
        }
        uint256 cash = totalDeposit - (totalBorrowed);
        uint256 num = cash + (totalBorrowed) + (totalReserve);
        return getExp(num, totalSupply());
    }
}
