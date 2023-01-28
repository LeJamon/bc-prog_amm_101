pragma solidity ^0.8.0; 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//supply : 367193875000000000000000000
//ticker : VQdN0
contract Token is ERC20{
    constructor()ERC20("VQdN0", "VQdN0"){
        _mint(msg.sender, 367193875000000000000000000); 
    }
}