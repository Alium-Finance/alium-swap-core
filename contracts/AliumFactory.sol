// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity =0.8.15;

import "./interfaces/IAliumFactory.sol";
import "./interfaces/IAliumPair.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract AliumFactory is IAliumFactory {
    address public feeTo;
    address public feeToSetter;

    address public immutable pairImplementation;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    constructor(address _feeToSetter, address _pairImplementation) {
        require(_feeToSetter != address(0) || _pairImplementation != address(0), "Alium: ZERO_ADDRESS");

        feeToSetter = _feeToSetter;
        pairImplementation = _pairImplementation;
    }

    function allPairsLength() external view returns (uint256) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, "Alium: IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), "Alium: ZERO_ADDRESS");
        require(getPair[token0][token1] == address(0), "Alium: PAIR_EXISTS"); // single check is sufficient
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        pair = Clones.cloneDeterministic(pairImplementation, salt);
        IAliumPair(pair).initialize(address(this), token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "Alium: FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "Alium: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
