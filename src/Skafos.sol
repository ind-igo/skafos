// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

//import {IERC20} from "openzeppelin-contracts/interfaces/IERC20.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

import {ITreasury} from "./interfaces/ITreasury.sol";
import {IUniswapV2Router01} from "./interfaces/IUniswapV2Router01.sol";

/// @notice Project Skafos
/// A Bancor-like system for generating OHM for liquidity pairs. LP token is locked in this contract until debt is paid off.
contract Skafos {
    using SafeTransferLib for ERC20;

    error InsufficientAmount();

    ITreasury immutable treasury;
    ERC20 immutable ohm;
    IUniswapV2Router01 router;

    struct DebtLock {
        uint256 lpTokenAmount;
        uint256 debtOwed;
    }

    // debtor => lpToken => DebtLock
    mapping(address => mapping(address => DebtLock)) public debtLock;

    constructor(
        address ohm_,
        address treasury_,
        address router_
    ) {
        ohm = ERC20(ohm_);
        treasury = ITreasury(treasury_);
        router = IUniswapV2Router01(router_);
    }

    /// @notice Generate OHM to pair with given token using incurDebt
    function generateLiquidity(
        ERC20 pairedToken_,
        uint256 pairedAmount_,
        uint256 ohmAmount_
    ) external {
        if (pairedToken_.balanceOf(msg.sender) < pairedAmount_)
            revert InsufficientAmount();

        // transfer paired token in
        pairedToken_.safeTransferFrom(msg.sender, address(this), pairedAmount_);

        // call incurDebt and receive OHM
        treasury.incurDebt(ohmAmount_, address(ohm));

        // create LP token. Assumes pool is already created
        (, , uint256 liquidity) = router.addLiquidity(
            ohm,
            pairedToken_,
            0, //amountADesired,
            0, //amountBDesired,
            0, //amountAMin,
            0, //amountBMin,
            address(this),
            0, //deadline
        );

        // record debt owed from sender
        debtLock[msg.sender][lpToken_] = DebtLock({
            liquidity,
            ohmAmount_
        });

        // TODO lock token into this contract until debt is paid

        // think about how to record LP value to take diff at end
    }

    function repayDebt(uint256 amount_) external {
        // TODO transfer OHM into this contract
        // TODO record how much debt paid
        // TODO call repayDebtWithOHM
    }

    // TODO if debt is paid, allow caller to claim locked LP token
    function reclaimLP(address lpToken_) external {}
}
