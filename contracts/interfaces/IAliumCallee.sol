pragma solidity =0.5.15;

interface IAliumCallee {
    function aliumCall(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}
