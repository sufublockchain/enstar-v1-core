// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import './IEnstarV1Project.sol';

interface IEnstarV1Factory
{
    
    //获取全部项目数量
    function allProjectsLength() external view returns (uint);

    //项目名称是否已存在
    function isProjectExist(string calldata _name) external view returns (bool);

    //通过项目名称获取地址
    function getAddressByName(string calldata _name) external view returns (address);

    //获取全部项目名称
    function getAllProject() external view returns (bytes [] memory);

    //创建项目
    function createProject(IEnstarV1Project.Project memory _project) external returns (address);

    //设置管理员,总账户
    function setAdmin(address _admin) external;

    //投资者撤回资金
    function investorWithdraw(address _erc20Addr,address _project,uint256 _amount) external returns (bool);

    //项目方提取资金
    function projectWithdraw(address _erc20Addr,address _project) external returns (bool);


}