// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {IERC20} from "openzeppelin/contracts/tokens/ERC20/IERC20.sol";
import {ITreasury} from "./interfaces/ITreasury.sol";

/// @notice Project Skafos
/// A Bancor-like system for generating OHM for liquidity pairs. LP token is locked in this contract until debt is paid off.
contract Skafos {
    ITreasury immutable treasury;
    address immutable ohm;

    struct DebtLock {
        address lpToken;
        uint256 lpTokenAmount;
        uint256 debtOwed;
    }

    constructor(address ohm_, address treasury_) {
        ohm = ohm_;
        treasury = ITreasury(treasury_);
    }

    function generateLiquidity(address pairedToken_, uint256 amount_) external {
        // TODO transfer paired token in
        // TODO call incurDebt and receive OHM
        // TODO create LP token
        // TODO record debt owed from sender
        // TODO lock token into this contract until debt is paid
    }

    function repayDebt(uint256 amount_) external {
        // TODO call repayDebtWithOHM
    }
}
