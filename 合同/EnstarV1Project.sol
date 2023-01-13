// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import './interfaces/IEnstarV1Project.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract EnstarV1Project is IEnstarV1Project{

    event Transfer(string message, address from, address to, uint256 amount);

    Project public project;

    mapping(address=>Investor) public investors;

    address[] public investor_list;

    address private uni_fund;

    constructor(address _contract) {
        uni_fund = _contract;
    }


    /// @inheritdoc IEnstarV1Project
    function setProject(Project memory _project)
        external
        {
            project = _project;
        }


    /// @inheritdoc IEnstarV1Project
    function checkProjectBalance()
        external
        view
        returns (uint256)
    {
        return project.balance;
    }


    /// @notice Get the current balance of project.
    function _transfer(
        address _contract,
        address to,
        uint256 amount
    ) internal returns (bool) {
        // bytes memory data = abi.encodeWithSignature(
        //     "transfer(address,uint256)",
        //     to,
        //     amount
        // );
        // (bool success, ) = _contract.call(data);
        (bool success, bytes memory data) = 
            _contract.call(abi.encodeWithSelector(IERC20.transfer.selector, to, amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
        emit Transfer("_transfer", _contract, to, amount);
        return success;
    }


    /// test
    function transferTest(
        address _contract,
        address sender,
        address to,
        uint256 amount
    ) external returns (bool) {
        IERC20(_contract).transferFrom(sender, to, amount);
        emit Transfer("_transfer", _contract, to, amount);
        return true;
    }
    

    /// test
    function balanceOfTest(
        address _contract,
        address _token
    ) external view returns (uint256) {
        uint256 balanceToken = IERC20(_contract).balanceOf(_token);
        return balanceToken;
    }


    /// @inheritdoc IEnstarV1Project
    function authorizeInvestor(address _investor) 
        public 
        view
        returns (bool)
    {
       if(investor_list.length>0){
            for (uint i = 0;i < investor_list.length;i++){
                if (investor_list[i] == _investor){
                    return true;
                }
            }
        }
        return false;
    }


    /// @inheritdoc IEnstarV1Project
    function invest(address _investor, uint256 amount, uint256 timestamp) 
        external 
        payable 
        returns (bool)
    {
        bool success = _transfer(_investor, uni_fund, amount);
        if(success){
            //record investor
            bool recorded = authorizeInvestor(_investor);
            if(!recorded){
                investor_list.push(_investor);
                investors[_investor] = Investor(_investor,amount,timestamp,timestamp);
            }else{
                //If it has been recorded, the amount is accumulated.
                Investor storage iv = investors[_investor];
                iv.amount += amount;
                iv.update_time = timestamp;
                investors[_investor] = iv;
            }

            //record project
            project.balance += amount;
        }

        return success;
    }

    /// @inheritdoc IEnstarV1Project
    function investorWithdraw(address _erc20Addr, uint256 _amount) external override view returns (bool){
        return true;
    }

    /// @inheritdoc IEnstarV1Project
    function projectWithdraw(address _erc20Addr) external returns (bool){
    }



}