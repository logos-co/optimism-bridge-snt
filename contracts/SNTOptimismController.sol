// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import { TokenController } from "@vacp2p/minime/contracts/TokenController.sol";
import { MiniMeBase } from "@vacp2p/minime/contracts/MiniMeBase.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 * @title SNTOptimismController
 *  @author Ricardo Guilherme Schmidt, r4bbit
 *  @dev Contract for keeping the SNT token in Optimism.
 *  It does nothing, but can be replaced by other contract that does something.
 */
contract SNTOptimismController is TokenController, Ownable2Step {
    MiniMeBase public snt;

    /**
     * @param _snt The address of the SNT token
     */
    constructor(address payable _snt) {
        snt = MiniMeBase(_snt);
    }

    /**
     * @notice The owner of this contract can change the controller of the SNT token
     *  Please, be sure that the owner is a trusted agent or 0x0 address.
     * @param _newController The address of the new controller
     */
    function changeController(address payable _newController) public onlyOwner {
        snt.changeController(_newController);
        emit ControllerChanged(_newController);
    }

    /**
     * @dev proxyPayment set to reject all Ether.
     */
    function proxyPayment(address) public payable override returns (bool) {
        return false;
    }

    /**
     * @dev onTransfer set to accept any transfer
     */
    function onTransfer(address, address, uint256) public pure override returns (bool) {
        return true;
    }

    /**
     * @dev onApprove set to accept any approval
     */
    function onApprove(address, address, uint256) public pure override returns (bool) {
        return true;
    }

    /**
     * @notice Send tokens or ether from this contract to owner.
     * @param _token Token contract to recover, 0 to extract ether.
     */
    function claimTokens(MiniMeBase _token) public onlyOwner {
        uint256 balance;
        if (address(_token) == address(0)) {
            balance = address(this).balance;
            payable(msg.sender).transfer(balance);
            return;
        } else {
            balance = _token.balanceOf(address(this));
            _token.transfer(msg.sender, balance);
        }
        emit ClaimedTokens(address(_token), msg.sender, balance);
    }

    event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
    event ControllerChanged(address indexed _newController);
}
