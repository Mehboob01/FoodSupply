//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

library SafeMath {
    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

contract preSale is Ownable {
    using SafeMath for uint;

    IERC20 public tokenAddress;
    uint public price = 0.001 ether;
    uint public tokenSold;
    address payable public seller;

    mapping(address => bool) public whitelist;

    event TokenPurchased(address buyer, uint price, uint tokenValue);
    event TokenSell(address seller, uint price, uint tokenValue);

    constructor() {
        tokenAddress = IERC20(0x50Ae3579146ba3E69C2f713a1E13Cd440C028066);
        seller = payable(_msgSender());
        whitelist[_msgSender()] = true;
    }

    function tokenForSale() public view returns (uint) {
        return tokenAddress.allowance(seller, address(this));
    }

    receive() external payable {
        buy();
    }

    function _buyToken() external payable {
        buy();
    }

    function buy() private {
        require(msg.value > 0, "Enter Creact Price");
        require(_msgSender() != address(0), "Null address can't buy token");
        require(whitelist[_msgSender()], "User not whitelisted");
        uint _tokenValue = _buyableTokens();
        require(_tokenValue <= tokenForSale(), "Remaining token less value");
        tokenAddress.transferFrom(seller, _msgSender(), _tokenValue);
        tokenSold = tokenSold.add(_tokenValue);

        emit TokenPurchased(_msgSender(), price, _tokenValue);
    }

    function _buyableTokens() private view returns (uint256) {
        uint256 buyableTokens = (msg.value * 10 ** 18) / price;
        return buyableTokens;
    }

    function addToWhitelist(address[] memory users) public onlyOwner {
        for (uint i = 0; i < users.length; i++) {
            whitelist[users[i]] = true;
        }
    }

    function removeFromWhitelist(address[] memory users) public onlyOwner {
        for (uint i = 0; i < users.length; i++) {
            whitelist[users[i]] = false;
        }
    }

    function setToken(IERC20 _token) public onlyOwner {
        tokenAddress = _token;
    }

    function withdraw() public onlyOwner returns (bool) {
        seller.transfer(address(this).balance);
        return true;
    }

    function setPrice(uint set) public onlyOwner {
        price = set;
    }
}
