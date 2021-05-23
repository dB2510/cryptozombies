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

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    // here memory keyword means that we are passing _name by reference
    // in solidity when passing strings, arrays or structs pass by reference is used
    // conventionally we use _ before every private function and function parameters 
    function _createZombie(string memory _name, uint _dna) internal { // internal keyword lets this function visible to its daughter contracts and private as well
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        // and fire it here
        emit NewZombie(id, _name, _dna);
    }

    // external s similar to public, except that these functions can ONLY be called outside
    // the contract — they can't be called by other functions inside that contract.

    // view keyword means that function is viewing the data in app but not modifying it
    // on the other hand pure keyword will be responsible not even accessing any data
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        // require keyword is basically assert keyword in other languages, it checks a condition and throws an error 
        // if it is false and it is true then only the following code will be executed
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
