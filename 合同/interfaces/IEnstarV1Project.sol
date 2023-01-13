// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

/// @title The interface for a Enstar project
/// @notice enstar project facilitates investing strictly conform to the ERC20 specification
interface IEnstarV1Project
{
    struct Project{
        string name;
        string introduction;
        string operate;
        uint256 amount;
        uint256 create_time;
        address account; ///Trading account
        uint256 balance; ///Current balance
        string website;
        string creator;
        string country;
        string province;
        string city;
    }

    struct Investor{
        address investor; ///Trading account
        uint256 amount;
        uint256 create_time;
        uint256 update_time;
    }

    /// @notice set the project information.
    function setProject(Project memory _project)
        external;

    /// @notice Get the current balance of project.
    function checkProjectBalance()
        external
        view
        returns (uint256);

    /// @notice Authority of identifying investors.
    function authorizeInvestor(address _address) 
        external 
        view 
        returns (bool);

    /// @notice Investor purchase share of project.
    function invest(address _investor, uint256 amount, uint256 timestamp) 
        external 
        payable 
        returns (bool);

    /// @notice Investor withdraw
    function investorWithdraw(address _erc20Addr, uint256 _amount) external returns (bool);

    /// @notice project withdraw
    function projectWithdraw(address _erc20Addr) external returns (bool);

    function transferTest(
        address _contract,
        address sender,
        address to,
        uint256 amount
    ) external returns (bool);

    function balanceOfTest(
        address _contract,
        address _token
    ) external view returns (uint256); 

    
}