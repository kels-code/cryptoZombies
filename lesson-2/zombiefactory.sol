pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);
    // DNA sequence character limit
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;
    // Map zombie's ID with the user's address
    mapping (uint => address) public zombieToOwner;
    // Map the user's address to the zombie count
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) internal {
        // Create zombie ID using 'zombies' array index
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // At index ID, map the value of Message Sender
        zombieToOwner[id] = msg.sender;
        // Add 1 to the owner's zombie count
        ownerZombieCount[msg.sender]++;
        // Trigger event of new zombie creation
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        // Create random dna of zombie with keccak256 hash
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        // Be sure zombie DNA length is equal to dnaDigits
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        // Require that the Message Sender has no zombies before easily creating random ones
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
