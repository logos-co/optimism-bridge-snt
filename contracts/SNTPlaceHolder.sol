// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import { TokenController } from "@vacp2p/minime/contracts/TokenController.sol";
import { MiniMeBase } from "@vacp2p/minime/contracts/MiniMeBase.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

/*
    Copyright 2017, Jordi Baylina

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/// @title SNTPlaceholder Contract
/// @author Jordi Baylina
/// @dev The SNTPlaceholder contract will take control over the SNT after the contribution
///  is finalized and before the Status Network is deployed.
///  The contract allows for SNT transfers and transferFrom and implements the
///  logic for transferring control of the token to the network when the offering
///  asks it to do so.
contract SNTPlaceHolder is TokenController, Ownable2Step {
    MiniMeBase public snt;

    constructor(address _owner, address payable _snt) Ownable2Step(_owner) {
        snt = MiniMeBase(_snt);
    }

    /// @notice The owner of this contract can change the controller of the SNT token
    ///  Please, be sure that the owner is a trusted agent or 0x0 address.
    /// @param _newController The address of the new controller
    function changeController(address payable _newController) public onlyOwner {
        snt.changeController(_newController);
        emit ControllerChanged(_newController);
    }

    //////////
    // MiniMe Controller Interface functions
    //////////

    // In between the offering and the network. Default settings for allowing token transfers.
    function proxyPayment(address) public payable override returns (bool) {
        return false;
    }

    function onTransfer(address, address, uint256) public pure override returns (bool) {
        return true;
    }

    function onApprove(address, address, uint256) public pure override returns (bool) {
        return true;
    }
    
    /// @notice This method can be used by the controller to extract mistakenly
    ///  sent tokens to this contract.
    /// @param _token The address of the token contract that you want to recover
    ///  set to 0 in case you want to extract ether.
    function claimTokens(MiniMeToken _token) public onlyOwner {
        if (address(_token) == address(0)) {
            payable(owner).transfer(address(this).balance);
            return;
        }

        uint256 balance = _token.balanceOf(address(this));
        _token.transfer(owner, balance);
        emit ClaimedTokens(address(_token), owner, balance);
    }

    event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
    event ControllerChanged(address indexed _newController);
}
