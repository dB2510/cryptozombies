pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    // events are a way for our contract to communicate that something happened on the blockchain
    // to your app frontend which can be listening for certain events and take action when they happen
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // here memory keyword means that we are passing _name by reference
    // in solidity when passing strings, arrays or structs pass by reference is used
    // conventionally we use _ before every private function and function parameters 
    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // and fire it here
        emit NewZombie(id, _name, _dna);
    }

    // view keyword means that function is viewing the data in app but not modifying it
    // on the other hand pure keyword will be responsible not even accessing any data
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
