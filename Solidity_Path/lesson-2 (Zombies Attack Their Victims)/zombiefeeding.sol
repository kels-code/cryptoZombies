pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

// Create interface with CryptoKitties getKitty function so that the zombie can feast on them
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

  // Address of CryptoKitties smart contract
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  // Point to the other contract using the KittyInterface we created
  KittyInterface kittyContract = KittyInterface(ckAddress);

  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    // Verify only owner of zombie can feed said zombie
    require(msg.sender == zombieToOwner[_zombieId]);
    // Get a hold of this new zombies DNA
    Zombie storage myZombie = zombies[_zombieId];
    // Make sure target dna is only dnaDigits long
    _targetDna = _targetDna % dnaModulus;
    // Create new dna for target zombie
    uint newDna = (myZombie.dna + _targetDna) / 2;
    // If species == kitty, modify dna for special kitty type
    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }
    // Create new zombie from target zombie
    _createZombie("NoName", newDna);
  }

  // extract and store kitty genes. Then feed.
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}