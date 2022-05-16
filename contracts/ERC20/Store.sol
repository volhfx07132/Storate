pragma solidity ^0.8.0;

import "./ERC20.sol";
contract Store is ERC20{

    uint256 private FEE_USE_APP = 10000000000000000; // 0.01 ETH
    uint256 private VALUE_SWAP_TOKEN = 1000; // 1ETH = 1000 token
    uint256 private SPACE_TIME_CLAIM = 10; // after 100 seconds ==> can claim token
    uint256 private SPACE_TIME_REFUND = 20; // after 200 seconds ==> can refund token
    address private ADMIN = 0x3Cb06A7709a2511e48a091979b9b68B27999AfaB;

    event deposit(address user, uint256 amount_in);
    event claim(address sender, address indexed receiver, uint256 token_out);
    event refund(address sender, address indexed receiver, uint256 token_out);

    struct BuyerInfo{
        uint256 valueInput;
        uint256 valueOutput;
        uint256 countTime;
        uint256 currentTimeDeposit;
        uint256 currnetTimeClaim;
        uint256 currentTimeRefund;
    }

    modifier onlyAdmin(){
        require(msg.sender == ADMIN, "ONLY ADMIN CAN ACTION");
        _;
    }

    mapping(address => BuyerInfo) public listBuyerInfor;

    constructor() ERC20("TokenERC20 ", "TKE")  onlyAdmin{
         _mint(ADMIN, 10000000000000000000000);
    }

    function depositETH(uint256 amount_in) external payable {
        payable(msg.sender).transfer(msg.value - amount_in - FEE_USE_APP);
        listBuyerInfor[msg.sender].valueInput = amount_in;
        listBuyerInfor[msg.sender].valueOutput = amount_in * VALUE_SWAP_TOKEN / (10 ** 18);
        listBuyerInfor[msg.sender].countTime++;
        listBuyerInfor[msg.sender].currentTimeDeposit = block.timestamp;
        listBuyerInfor[msg.sender].currnetTimeClaim = block.timestamp + SPACE_TIME_CLAIM;
        listBuyerInfor[msg.sender].currentTimeRefund = block.timestamp + SPACE_TIME_REFUND;
        emit deposit(msg.sender, amount_in);
    }

    function claimToken() external {
        require(listBuyerInfor[msg.sender].currnetTimeClaim < block.timestamp, "NOT TIME TO CLIAM TOKEN");
        transferFrom(ADMIN, msg.sender, listBuyerInfor[msg.sender].valueOutput);
        BuyerInfo memory buyerInfo;
        listBuyerInfor[msg.sender] = buyerInfo;
        emit claim(ADMIN, msg.sender, listBuyerInfor[msg.sender].valueOutput);
    }

    function refundEth() external{
        require(listBuyerInfor[msg.sender].currentTimeRefund < block.timestamp, "NOT TIME TO CLIAM TOKEN");
        payable(msg.sender).transfer(listBuyerInfor[msg.sender].valueInput - FEE_USE_APP);
        BuyerInfo memory buyerInfo;
        listBuyerInfor[msg.sender] = buyerInfo;
        emit refund(address(this), msg.sender, listBuyerInfor[msg.sender].valueOutput * (10 ** 18));
    }
    //1000000000000000000000
    //100000000000000000
    function getBalance(address _address) public view returns(uint256){
        return _address.balance;
    }

    function getBuyerInformation() public view returns(BuyerInfo memory){
        return listBuyerInfor[msg.sender];
    }
}