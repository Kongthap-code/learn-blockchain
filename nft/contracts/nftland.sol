// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

import "hardhat/console.sol";

contract NFTLand is IERC721Receiver {
    IERC20 currencyToken;
    IERC721 itemToken;

    uint256 tradeCounter;
    mapping(uint256 => address) poster;
    mapping(uint256 => uint256) price;

    constructor(address _currencyTokenAddress, address _itemTokenAddress) {
        currencyToken = IERC20(_currencyTokenAddress);
        itemToken = IERC721(_itemTokenAddress);
        tradeCounter = 0;
    }

    function onERC721Received(
        address,
        address,
        uint256 tokenId,
        bytes memory data
    ) public override returns (bytes4) {
        poster[tokenId] = msg.sender;
        price[tokenId] = toUint256(data);
        return this.onERC721Received.selector;
    }

    function toUint256(bytes memory _bytes)
        internal
        pure
        returns (uint256 value)
    {
        assembly {
            value := mload(add(_bytes, 0x20))
        }
    }

    function buy(uint256 tokenId) public {
        currencyToken.transferFrom(msg.sender, poster[tokenId], price[tokenId]);
        itemToken.transferFrom(address(this), msg.sender, tokenId);
        price[tokenId] = 0;
    }

    function cancel(uint256 tokenId) public {
        require(
            msg.sender == poster[tokenId],
            "Trade can be cancelled only by poster."
        );
        itemToken.transferFrom(address(this), poster[tokenId], tokenId);
    }

    function items() public {}
}
