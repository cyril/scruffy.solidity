// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

/// @title A decentralized currency union.
/// @author Cyril Kato
/// @notice This contract could be used by a government to grant wallets.
contract CurrencyUnion {
    address payable private immutable OWNER_ADDR;

    mapping (address => bool) members;
    mapping (address => int256) wallets;

    /**
     * @dev Emitted when a new member is added to the currency union.
     */
    event Welcome(address indexed member);

    /**
     * @dev Emitted when `value` coins are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, int256 value);

    modifier onlyOwner() {
        require(isOwner(), "Not owner");

        _;
    }

    modifier onlyFromMember() {
        require(isMember(msg.sender), "Not from member");

        _;
    }

    modifier onlyToMember(address _to) {
        require(isMember(_to), "Not to member");

        _;
    }

    constructor() {
        OWNER_ADDR = payable(msg.sender);
    }

    /// @notice Add a member.
    function addMember(address _memberAddr) external onlyOwner() {
        members[_memberAddr] = true;

        emit Welcome(_memberAddr);
    }

    /// @notice Pay a member.
    function payMember(address _to, int256 _value) external onlyFromMember() onlyToMember(_to) {
        wallets[msg.sender] -= _value;
        wallets[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
    }

    function getBalance() external view returns (int256) {
        return wallets[msg.sender];
    }

    function isOwner() private view returns (bool) {
        return msg.sender == OWNER_ADDR;
    }

    function isMember(address _addr) private view returns (bool) {
        return members[_addr];
    }
}
