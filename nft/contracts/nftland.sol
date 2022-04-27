// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "hardhat/console.sol";

contract NFTLand is IERC721Receiver {
    IERC20 currencyToken;
    IERC721 itemToken;
    ERC721Enumerable enumerable;
    ERC721URIStorage uriStorage;

    uint256 tradeCounter;
    mapping(uint256 => address) poster;
    mapping(uint256 => uint256) public price;

    constructor(address _currencyTokenAddress, address _itemTokenAddress) {
        currencyToken = IERC20(_currencyTokenAddress);
        itemToken = IERC721(_itemTokenAddress);
        enumerable = ERC721Enumerable(_itemTokenAddress);
        uriStorage = ERC721URIStorage(_itemTokenAddress);
        tradeCounter = 0;
    }

    function onERC721Received(
        address,
        address,
        uint256 tokenId,
        bytes memory data
    ) public override returns (bytes4) {
        poster[tokenId] = msg.sender;
        price[tokenId] = bytesToUint(data);
        return this.onERC721Received.selector;
    }

    function bytesToUint(bytes memory _bytes) public pure returns (uint256) {
        uint256 number;
        for (uint256 i = 0; i < _bytes.length; i++) {
            number =
                number +
                uint256(uint8(_bytes[i])) *
                (2**(8 * (_bytes.length - (i + 1))));
        }
        return number;
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

    function getAllTokens() public view returns (string[] memory) {
        uint256 total = enumerable.totalSupply();
        string[] memory a = new string[](total);

        for (uint256 i = 0; i < total; i++) {
            a[i] = (uriStorage.tokenURI(enumerable.tokenByIndex(i)));
        }

        return a;
    }
}
