pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Adoption.sol";

contract TestAdoption {
  Adoption adoption = Adoption(DeployedAddresses.Adoption());

  // test user can adotp a pet
  function testUserCanAdoptPet() public {
    uint returnedId = adoption.adopt(8);

    uint expected = 8;

    Assert.equal(returnedId, expected, "Adoption of pet ID 8 should be recorded.");
  }

  // testing retrieval of a single pet's owner
  function testGetAdoptedAddressByPetId() public {

    // expected owner is this contracts
    address expected = this;
    address adopted = adoption.adopters(8);

    Assert.equal(adopted, expected, "Owner of pet ID 8 should be recorded.");
  }

  function testGetAdoptedAddressByPetIdInArray() public {
    address expected = this;

    address[16] memory adopters = adoption.getAdopters();

    Assert.equal(adopters[8], expected, "Owner of pet ID 8 should be recorded.");
  }
}
