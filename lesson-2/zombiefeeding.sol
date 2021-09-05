pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    // Verify only owner of zombie can feed said zombie
    require(msg.sender == zombieToOwner[_zombieId]);
    // Get a hold of this new zombies DNA
    Zombie storage myZombie = zombies[_zombieId];
  }

}
