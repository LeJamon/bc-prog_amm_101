pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IExerciceSolution 
{
	function addLiquidity() external;

	function withdrawLiquidity() external;

	function swapYourTokenForDummyToken() external;

	function swapYourTokenForEth() external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract ExerciceSolution is IExerciceSolution{
    ERC20 public Token;
    ERC20 public WETH;  
    ERC20 public uniLiquid; 
    ERC20 public dummyToken; 
    IUniswapV2Router02 public router; 

    constructor(){
        Token = ERC20(address(0xB2511aeCD34894Ef71bAa4D54c84D0a6698801CC)); 
        WETH = ERC20(address(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6)); 
        uniLiquid = ERC20(address(0x1caEA8c0a8838B24CE15Ff00a165C1E4d167174e)); 
        dummyToken = ERC20(address(0x2aF483edaE4cce53186E6ed418FE92f8169Ad74E)); 
        router = IUniswapV2Router02(address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)); 
    }
    function addLiquidity() override external{
        uint tokenIn = 1000000; 
        uint wethIn = 1000; 
        require(Token.approve(address(router), tokenIn),"token approved failed");
        require(WETH.approve(address(router), wethIn),"WETH approved failed");
        router.addLiquidity(address(Token), address(WETH), tokenIn, wethIn, 0, 0, address(this), block.timestamp);

    }

	function withdrawLiquidity() override external{
        
        require(uniLiquid.approve(address(router), 10000), "Liquid Token approve failed");
        router.removeLiquidity(address(Token), address(WETH), 10000, 0, 0, address(this),block.timestamp);

    }

	function swapYourTokenForDummyToken() override external{
        require(Token.approve(address(router), 100000),"token approved failed");
        require(dummyToken.approve(address(router), 100000),"dummyToken approved failed");

        address [] memory path  = new address[](2); 
        path[0] = address(Token); 
        path[1]= address(dummyToken); 

        router.swapExactTokensForTokens(10000, 1000, path, address(this), block.timestamp);
    }

	function swapYourTokenForEth() override external{
        require(Token.approve(address(router), 100000),"token approved failed");
        require(WETH.approve(address(router), 1000),"WETH approved failed");

        address [] memory path  = new address[](2);  
        path[0] = address(Token); 
        path[1]= address(WETH); 

        router.swapExactTokensForTokens(100000, 1000, path, address(this), block.timestamp);
    }
}