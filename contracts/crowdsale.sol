pragma solidity ^0.4.18;

import './solutoken.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol';

contract crowdsale is CappedCrowdsale, RefundableCrowdsale {

  CrowdsaleStage public stage = CrowdsaleStage.PreICO; 

  uint256 public maxTokens = 100000000000000000000; 
  uint256 public tokensForEcosystem = 20000000000000000000;
  uint256 public tokensForTeam = 10000000000000000000;
  uint256 public tokensForBounty = 10000000000000000000;
  uint256 public totalTokensForSale = 50000000000000000000; 
  uint256 public totalTokensForSaleDuringPreICO = 30000000000000000000; 

  uint256 public totalWeiRaisedDuringPreICO;
  
  // Eventsevent EthTransferred(string text);event EthRefunded(string text);


  // Constructor// ============function HashnodeCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap) CappedCrowdsale(_cap) FinalizableCrowdsale() RefundableCrowdsale(_goal) Crowdsale(_startTime, _endTime, _rate, _wallet) public {
      require(_goal <= _cap);
  }
 

  // Token Deployment// =================function createTokenContract() internal returns (MintableToken) {return new solutoken(); 
  }
  
  // Change Crowdsale Stage. Available Options: PreICO, ICOfunction setCrowdsaleStage(uint value) public onlyOwner {

      CrowdsaleStage _stage;

      if (uint(CrowdsaleStage.PreICO) == value) {
        _stage = CrowdsaleStage.PreICO;
      } else if (uint(CrowdsaleStage.ICO) == value) {
        _stage = CrowdsaleStage.ICO;
      }

      stage = _stage;

      if (stage == CrowdsaleStage.PreICO) {
        setCurrentRate(0.01);
      } else if (stage == CrowdsaleStage.ICO) {
        setCurrentRate(0.02);
      }
  }

  // Change the current ratefunction setCurrentRate(uint256 _rate) private {
      rate = _rate;
  }

  function () external payable {
      uint256 tokensThatWillBeMintedAfterPurchase = msg.value.mul(rate);
      if ((stage == CrowdsaleStage.PreICO) && (token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO)) {
        msg.sender.transfer(msg.value);
        EthRefunded("PreICO Limit Hit");
        return;
      }

      buyTokens(msg.sender);

      if (stage == CrowdsaleStage.PreICO) {
          totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);
      }
  }

  function forwardFunds() internal {
      if (stage == CrowdsaleStage.PreICO) {
          wallet.transfer(msg.value);
          EthTransferred("forwarding funds to wallet");
      } else if (stage == CrowdsaleStage.ICO) {
          EthTransferred("forwarding funds to refundable vault");
          super.forwardFunds();
      }
  }
    function finish(address _teamFund, address _ecosystemFund, address _bountyFund) public onlyOwner {

      require(!isFinalized);
      uint256 alreadyMinted = token.totalSupply();
      require(alreadyMinted < maxTokens);

      uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
      if (unsoldTokens > 0) {
        tokensForEcosystem = tokensForEcosystem + unsoldTokens;
      }

      token.mint(_teamFund,tokensForTeam);
      token.mint(_ecosystemFund,tokensForEcosystem);
      token.mint(_bountyFund,tokensForBounty);
      finalize();
  }
 
  }
}
