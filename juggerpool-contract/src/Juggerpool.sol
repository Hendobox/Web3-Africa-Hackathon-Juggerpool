// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

struct Collateral {
    address token;
    uint256 deposits;
}

struct Param {
    address token;
    uint256 amount;
}

contract Juggerpool is Ownable {
    using SafeERC20 for IERC20;

    address[] public whitelistList;

    mapping(address user => mapping(address token => uint256 deposits)) public userCollateral;
    mapping(address token => bool whitelisted) public isWhitelisted;

    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);
    event CollateralWithdrawn(address indexed user, address indexed token, uint256 amount);
    event Whitelisted(address indexed token);

    constructor(address token1, address token2, address owner_) Ownable(owner_) {
        _whitelist(token1);
        _whitelist(token2);
    }

    function whitelist(address token) external onlyOwner {
        isWhitelisted[token] = true;
        _whitelist(token);
    }

    function _whitelist(address token) private {
        isWhitelisted[token] = true;
        whitelistList.push(token);
        emit Whitelisted(token);
    }

    function depositCollateral(Param[] calldata params) external {
        uint256 len = params.length;
        Param memory param;
        for (uint256 i; i < len;) {
            param = params[i];
            require(isWhitelisted[param.token], "Cannot deposit non whitelisted tokens");
            require(param.amount > 0, "Cannot deposit 0 tokens");
            emit CollateralDeposited(msg.sender, param.token, param.amount);
            IERC20(param.token).safeTransferFrom(msg.sender, address(this), param.amount);
            unchecked {
                userCollateral[msg.sender][param.token] = userCollateral[msg.sender][param.token] + param.amount;
                ++i;
            }
        }
    }

    function withdrawCollateral(Param[] calldata params) external {
        uint256 len = params.length;
        Param memory param;
        for (uint256 i; i < len;) {
            param = params[i];
            require(param.amount > 0, "Cannot withdraw 0 tokens");
            require(param.amount <= userCollateral[msg.sender][param.token], "Cannot withdraw 0 tokens");
            emit CollateralWithdrawn(msg.sender, param.token, param.amount);
            unchecked {
                userCollateral[msg.sender][param.token] = userCollateral[msg.sender][param.token] - param.amount;
                ++i;
            }
            IERC20(param.token).safeTransfer(msg.sender, param.amount);
        }
    }

    function getUserCollateral(address user) public view returns (uint256) {
        uint256 len = whitelistList.length;
        uint256 collateralAmount;
        Param memory param;
        address token;

        for (uint256 i = 0; i < len; i++) {
            token = whitelistList[i];
            param = Param(token, userCollateral[user][token]);
            unchecked {
                collateralAmount = collateralAmount + someFunkyOracleToReturnValueInUSD(param);
                ++i;
            }
        }
        return collateralAmount;
    }

    function someFunkyOracleToReturnValueInUSD(Param memory param) public pure returns (uint256) {
        return param.amount * 34578656;
    }
}
