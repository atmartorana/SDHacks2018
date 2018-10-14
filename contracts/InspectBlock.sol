pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./ERC721.sol";
import "./Address.sol";

contract InspectBlock is ERC721 {
  using SafeMath for uint256;
  using Address for address;

  struct weaponDecal {

	  //Name of specific weapon
	  string name;
	  //Weapon type i.e. Classified; Covert; Consumer; Industrial
	  string weaponDecalType;
	  //Weapon class i.e. AK47; M4A4; AWP; M4A1S
	  string weaponClass;
	  //The wear of the weapon (this determines its uniqueness)
	  uint itemWear;
  }

  weaponDecal[] internal allWeaponDecals;

  /*TODO: WOULD LIKE TO IMPLEMENT SOMETIME IN THE FUTURE
  // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
  // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
  bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
  */

  // Mapping from token ID to owner
  mapping (uint256 => address) private _decalOwner;

  // Mapping from token ID to approved address
  mapping (uint256 => address) private _decalApprovals;

  // Mapping from owner to number of owned token
  mapping (address => uint256) private _ownedDecalsCount;

  /*
   *TODO: WOULD LIKE TO IMPLEMENT SOMEITME IN THE FUTURE
   */
  //bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
  /*
   * 0x80ac58cd ===
   *   bytes4(keccak256('balanceOf(address)')) ^
   *   bytes4(keccak256('ownerOf(uint256)')) ^
   *   bytes4(keccak256('approve(address,uint256)')) ^
   *   bytes4(keccak256('getApproved(uint256)')) ^
   *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
   *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
   *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
   *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
   */

  /*
   *TODO: WOULD LIKE TO IMPLEMENTSOMETIME IN THE FUTURE
  constructor()
    public
  {
    // register the supported interfaces to conform to ERC721 via ERC165
    _registerInterface(_InterfaceId_ERC721);
  }
  */

  /**
   * @dev Gets the balance of the specified address
   * @param owner address to query the balance of
   * @return uint256 representing the amount owned by the passed address
   */
  function balanceOf(address owner) public view returns (uint256) {
    require(owner != address(0));
    return _ownedDecalsCount[owner];
  }

  /**
   * @dev Gets the owner of the specified token ID
   * @param decalId uint256 ID of the token to query the owner of
   * @return owner address currently marked as the owner of the given token ID
   */
  function ownerOf(uint256 decalId) public view returns (address) {
    address owner = _decalOwner[decalId];
    require(owner != address(0));
    return owner;
  }

  /**
   * @dev Approves another address to transfer the given token ID
   * The zero address indicates there is no approved address.
   * There can only be one approved address per token at a given time.
   * Can only be called by the token owner or an approved operator.
   * @param to address to be approved for the given token ID
   * @param decalId uint256 ID of the token to be approved
   */
  function approve(address to, uint256 decalId) public {
    address owner = ownerOf(decalId);
    require(to != owner);
    require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

    _decalApprovals[decalId] = to;
    emit Approval(owner, to, decalId);
  }

  /**
   * @dev Gets the approved address for a token ID, or zero if no address set
   * Reverts if the token ID does not exist.
   * @param decalId uint256 ID of the token to query the approval of
   * @return address currently approved for the given token ID
   */
  function getApproved(uint256 decalId) public view returns (address) {
    require(_exists(decalId));
    return _decalApprovals[decalId];
  }

  /**
   * @dev Sets or unsets the approval of a given operator
   * An operator is allowed to transfer all tokens of the sender on their behalf
   * @param to operator address to set the approval
   * @param approved representing the status of the approval to be set
   */
  function setApprovalForAll(address to, bool approved) public {
    require(to != msg.sender);
    emit ApprovalForAll(msg.sender, to, approved);
  }

  /**
   * @dev Tells whether an operator is approved by a given owner
   * @param owner owner address which you want to query the approval of
   * @param operator operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
  function isApprovedForAll(address owner,address operator) public view returns (bool)
  {
    return false;
  }

  /**
   * @dev Transfers the ownership of a given token ID to another address
   * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
   * Requires the msg sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param decalId uint256 ID of the token to be transferred
  */
  function transferFrom(address from, address to, uint256 decalId) public
  {
    require(_isApprovedOrOwner(msg.sender, decalId));
    require(to != address(0));

    _clearApproval(from, decalId);
    _removeTokenFrom(from, decalId);
    _transfer(from,to, decalId);

    emit Transfer(from, to, decalId);
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   *
   * Requires the msg sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param decalId uint256 ID of the token to be transferred
  */
  function safeTransferFrom(address from, address to, uint256 decalId) public
  {
    // solium-disable-next-line arg-overflow
    safeTransferFrom(from, to, decalId, "");
  }

  /**
   * @dev Safely transfers the ownership of a given token ID to another address
   * If the target address is a contract, it must implement `onERC721Received`,
   * which is called upon a safe transfer, and return the magic value
   * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
   * the transfer is reverted.
   * Requires the msg sender to be the owner, approved, or operator
   * @param from current owner of the token
   * @param to address to receive the ownership of the given token ID
   * @param decalId uint256 ID of the token to be transferred
   * @param _data bytes data to send along with a safe transfer check
   */
  function safeTransferFrom(address from, address to, uint256 decalId, bytes _data) public
  {
    transferFrom(from, to, decalId);
    // solium-disable-next-line arg-overflow
    require(_checkAndCallSafeTransfer(from, to, decalId, _data));
  }

  /**
   * @dev Returns whether the specified token exists
   * @param decalId uint256 ID of the token to query the existence of
   * @return whether the token exists
   */
  function _exists(uint256 decalId) internal view returns (bool) {
    address owner = _decalOwner[decalId];
    return owner != address(0);
  }

  /**
   * @dev Returns whether the given spender can transfer a given token ID
   * @param spender address of the spender to query
   * @param decalId uint256 ID of the token to be transferred
   * @return bool whether the msg.sender is approved for the given token ID,
   *  is an operator of the owner, or is the owner of the token
   */
  function _isApprovedOrOwner(address spender, uint256 decalId) internal view returns (bool)
  {
    address owner = ownerOf(decalId);
    // Disable solium check because of
    // https://github.com/duaraghav8/Solium/issues/175
    // solium-disable-next-line operator-whitespace
    return (
      spender == owner ||
      getApproved(decalId) == spender ||
      isApprovedForAll(owner, spender)
    );
  }

  /**
   * @dev Internal function to mint a new token
   * Reverts if the given token ID already exists
   * @param to The address that will own the minted token
   * @param decalId uint256 ID of the token to be minted by the msg.sender
   */
  function _addNewGunDecal(address to, string _name, string _weaponType, string _weaponClass, uint _itemWear) internal returns (uint){
    require(to != address(0));

	weaponDecal memory _tempDecal = _weaponDecal({
		name: _name,
		weaponType: _weaponType,
		weaponClass: _weaponType,
		itemWear: _itemWear
	});

	uint256 newDecalId = allWeaponDecals.push(_weaponDecal) - 1;

    _transfer(address(0), to, decalId);
    emit Transfer(address(0), to, newDecalId);
  }

  /**
   * @dev Internal function to clear current approval of a given token ID
   * Reverts if the given address is not indeed the owner of the token
   * @param owner owner of the token
   * @param decalId uint256 ID of the token to be transferred
   */
  function _clearApproval(address owner, uint256 decalId) internal {
    require(ownerOf(decalId) == owner);
    if (_decalApprovals[decalId] != address(0)) {
      _decalApprovals[decalId] = address(0);
    }
  }

  /**
   * @dev Internal function to add a token ID to the list of a given address
   * @param to address representing the new owner of the given token ID
   * @param decalId uint256 ID of the token to be added to the tokens list of the given address
   */
  function _transfer(address from, address to, uint256 decalId) internal {
	require(to != address(0));
	require(to != address(this));
	require(from != to);

    _decalOwner[decalId] = to;
    _ownedDecalsCount[to]++;

	if(from != address(0)) {
		_ownedDecalsCount[from]--;
		delete _decalApprovals[decalId];
	}

	Transfer(from,to,decalId);
  }

  /**
   * @dev Internal function to remove a token ID from the list of a given address
   * @param from address representing the previous owner of the given token ID
   * @param decalId uint256 ID of the token to be removed from the tokens list of the given address
   */
  function _removeTokenFrom(address from, uint256 decalId) internal {
    require(ownerOf(decalId) == from);
    _decalApprovals[from] = _decalApprovals[from].sub(1);
    _decalOwner[decalId] = address(0);
  }

  /**TODO: WOULD LIKE TO IMPLEMENT FUNCTION SOMETIME IN THE FUTURE
   * @dev Internal function to invoke `onERC721Received` on a target address
   * The call is not executed if the target address is not a contract
   * @param from address representing the previous owner of the given token ID
   * @param to target address that will receive the tokens
   * @param decalId uint256 ID of the token to be transferred
   * @param _data bytes optional data to send along with the call
   * @return whether the call correctly returned the expected magic value
   */
  /**
  function _checkAndCallSafeTransfer(
    address from,
    address to,
    uint256 decalId,
    bytes _data
  )
    internal
    returns (bool)
  {
    if (!to.isContract()) {
      return true;
    }
    bytes4 retval = IERC721Receiver(to).onERC721Received(
      msg.sender, from, decalId, _data);
    return (retval == _ERC721_RECEIVED);
  }
  */

  function weaponDecalsOfOwner() external view returns(uint[] ownerDecals) {
	  uint decalCount = balanceOf(msg.sender);

	  if(decalCount == 0) {
		  return new uint[](0);
	  }
	  else {
		  uint[] memory result = new uint[](decalCount);
		  uint totalDecals = totalSupply();
		  uint resultIndex = 0;

		  uint skinId;

		  for(skinId = 0; skinId <= totalDecals; skinId++){
			  if(_decalOwner[skinId] == msg.sender) {
				  result[resultIndex] = skinId;
				  resultIndex++;
			  }
		  }

		  return result;
	  }
  }

  function totalSupply() public view returns(uint) {
	  return allWeaponDecals.length - 1;
  }

}
*/
