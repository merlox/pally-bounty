# Pally Bug Bounty
This is the bug bounty repository for Pally. You can get ether for finding vulnerabilities
in the contracts `Crowdsale.sol`, `PallyCoin.sol` and `RefundVault.sol`. The amount depends
on the severity of the vulnerability:

- For low severity vulnerabilities: up to 2 ETH. These are the ones that could cause problems
in the way the contract works without affecting much the users.

- For medium severity vulnerabilities: up to 5 ETH. These are the ones where a hacker could
manipulate the way the code is supposed to work to cause damage and do unexpected things with the code.

- For high severity vulnerabilities: up to 10 ETH. These are the ones where a hacker could
steal money from the contracts or modify the base code causing a lot of damage to the users or owners.

The severity will be decided by the core developers of Pally and will be anounced in this repository.

You can use the PallyCoin Smart Contract deployed to the following test networks for your testing:

Rinkeby:
0x208530d162f57e69f3a35665900260a56bf1dc18

Ropsten:
0xD8457E306cF1dF2847910855c5230118a179F20B

You can clone this github repo and do whatever you want with the code in order to find vulnerabilities.

# Description of each contract
**PallyCoin.sol**: Is the main contract of Pally. The ERC20 token for Pally.co.
We have created 4 custom functions to simplify the process of distributing tokens during the crowdsale:
-	**setCrowdsaleAddress (address \_Crowdsale)**: This is used to set the address of the Crowdsale contract in order to allow it to distribute tokens up to a limit of 50 million tokens.
-	**distributePresaleTokens (address \_buyer, uint tokens)**: To send the corresponding tokens to the people that participated in the pre-ICO. This is done by the owner of the token which is a multisignature wallet for the core developers of Pally.
-	**distributeICOTokens (address \_buyer, uint tokens)**: To send the corresponding tokens when a user purchases tokens during the crowdsale.
-	**refundTokens (address \_buyer, uint256 tokens)**: To refund the tokens in case the minimum goal (15% of of target, $675,000) of the crowdsale is not reached. Users will be able to get their refund from the Pally website if the goal is not reached.

*Crowdsale.sol*: The ICO Smart Contract to distribute 50 million tokens with 4 rates depending on how many tokens have been sold.
For instance, up to 12.5M tokens sold, the price will be `rate`.
After 12.5M tokens have been sold, the price will be `rateTier2`.
After 25M tokens have been sold, the price will be `rateTier3`.
After 37.5M tokens have been sold, the price will be `rateTier4`.
This is the main function of the contract:
-	**buyTokens()**: When you send Ether to the contract without specifiying any function, this one is called. Which allows you to buy tokens just by sending Ether to the ICO contract. You send Ether to it and you get tokens in return. The price of each token depends on how many tokens have already been purchased. It’s calculated depending on which of the four tiers the ICO is at during that moment in time. Here’s the breakdown of tiers:

*RefundVault.sol*: The contract that will be used to store the funds of the buyers until the minimum goal of 7.5 million tokens sold have been reached.

In order to use the Crowdsale.sol contract you need to do the following:
1. Deploy the PallyCoin smart contract.
2. Deploy the Crowdsale smart contract using the PallyCoin address in the constructor and setting the actual timestamp for the 3rd parameter instead of 0 to start the Crowdsale immediately.
3. Set the crowdsale address in the PallyCoin contract with the function setCrowdsaleAddress()
4. Set the tier rates of the crowdsale with the function setTierRates(),
5. Use the contracts.

# How to participate
Everybody is welcome to participate in this bug bounty. The only requisite is that you have to
provide a detailed explanation of how you found the vulnerability to replicate it and verify it.

Essentially a text file with these contents:
- How did you find the vulnerability
- How to replicate it
- How severe it is in your opinion
- Your ethereum address for the reward

Send an email with the contents discussed above to *merunasgrincalaitis@gmail.com* with the subject *Pally Bounty*
and we'll contact you with the results. Feel free to ask any questions you may have.
