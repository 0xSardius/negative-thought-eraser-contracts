// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Base.sol";
import "@thirdweb-dev/contracts/extension/ContractMetadata.sol";

contract AffirmationNFT is ContractMetadata, ERC721Base {
    struct Thought {
        string negative;
        string[3] positives;
    }

    mapping(uint256 => Thought) private _thoughts;

    constructor(
        string memory _name,
        string memory _symbol,
        address _owner
    ) ERC721Base(_name, _symbol, _owner, _owner, 0) {
        _setupContractURI("");
    }

    function mintTo(
        address _to,
        string memory _negativeThought,
        string[3] memory _positivePhrases,
        string memory _tokenURI
    ) public virtual {
        uint256 tokenId = nextTokenIdToMint();
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        _thoughts[tokenId] = Thought({
            negative: _negativeThought,
            positives: _positivePhrases
        });
    }

    function getThought(uint256 tokenId)
        public
        view
        returns (string memory negative, string[3] memory positives)
    {
        require(_exists(tokenId), "Token does not exist");
        Thought memory t = _thoughts[tokenId];
        return (t.negative, t.positives);
    }

    function _canSetContractURI() internal view virtual override returns (bool) {
        return msg.sender == owner();
    }

    function contractURI() public view override returns (string memory) {
        return super.contractURI();
    }
}