pragma solidity 0.4.15;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}


/**
 * @title RefundVault
 * @dev This contract is used for storing funds while a crowdsale
 * is in progress. Supports refunding the money if crowdsale fails,
 * and forwarding it if crowdsale is successful.
 */
contract RefundVault is Ownable {
  using SafeMath for uint256;

  enum State { Active, Refunding, Closed }

  address public wallet;
  address private crowdsale;
  State public state;
  uint256 public weiBalance;

  mapping (address => uint256) public deposited;

  event RefundsEnabled();
  event Refunded(address indexed beneficiary, uint256 weiAmount);
  event LogDeposited(address indexed buyer, uint256 amount);
  event VaultClosed();

  modifier onlyCrowdsale() {
      require(msg.sender == crowdsale);
      _;
  }

  function RefundVault(address _wallet) {
    require(_wallet != 0x0);

    wallet = _wallet;
    crowdsale = msg.sender;
    state = State.Active;
  }

  function deposit(address investor) external payable onlyCrowdsale {
    require(state == State.Active);

    weiBalance = weiBalance.add(msg.value);
    deposited[investor] = deposited[investor].add(msg.value);
    LogDeposited(msg.sender, msg.value);
  }

  function close() external onlyCrowdsale {
    require(state == State.Active);

    state = State.Closed;
    wallet.transfer(weiBalance);
    VaultClosed();
  }

  function enableRefunds() external onlyCrowdsale {
    require(state == State.Active);

    state = State.Refunding;
    RefundsEnabled();
  }

  function refund(address investor) external onlyCrowdsale {
    require(state == State.Refunding);

    uint256 depositedValue = deposited[investor];
    weiBalance = weiBalance.sub(depositedValue);
    deposited[investor] = 0;
    investor.transfer(depositedValue);
    Refunded(investor, depositedValue);
  }
}
