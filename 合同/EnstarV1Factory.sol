// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import './interfaces/IEnstarV1Project.sol';
import './interfaces/IEnstarV1Factory.sol';
import './EnstarV1Project.sol';

contract EnstarV1Factory is IEnstarV1Factory{


    
    //合约管理员,总账户,创建工厂合约时传入
    address public admin;

    //全部项目地址
    address[] public allProjects;

    //全部名称编码
    bytes[] public project_name;

    //项目名称编码，项目部署地址
    mapping(bytes => address) public getProject;

    event ProjectCreated(string name, bytes name_code, address project, uint);

    constructor(address _admin) {
        require(_admin != address(0), 'Enstar: ZERO_ADDRESS');
        admin = _admin;
    }

    /// @inheritdoc IEnstarV1Factory
    function allProjectsLength() external view returns (uint) {
        return allProjects.length;
    }

    /// @inheritdoc IEnstarV1Factory
    function isProjectExist(string calldata _name) external view returns (bool) {
        bytes memory name_code = abi.encode(_name);
        return getProject[name_code] != address(0) ? true : false;
    }

    /// @inheritdoc IEnstarV1Factory
    function getAddressByName(string calldata _name) external view returns (address) {
        bytes memory name_code = abi.encode(_name);
        address add = getProject[name_code];
        return add;
    }

    /// @inheritdoc IEnstarV1Factory
    function getAllProject() external view returns (bytes [] memory) {
        // string [] memory names;
        // for(uint i = 0 ; i < project_name.length ; i++){
        //     names[i] = abi.decode(project_name[i],(string));
        // }
        return project_name;
    }

    /// @inheritdoc IEnstarV1Factory
    function createProject(IEnstarV1Project.Project memory _project) external returns (address project_address) {
        //判断项目名称是否为空
        require(keccak256(abi.encodePacked(_project.name)) != keccak256(abi.encodePacked("")) , 'Enstar: PROJECT_REPEAT');
        bytes memory code = type(EnstarV1Project).creationCode;
        bytes memory bytecode = abi.encodePacked(code, abi.encode(msg.sender));
        bytes memory name_code = abi.encode(_project.name);
        bytes32 salt = keccak256(name_code);
        //判断项目是否重复
        require(getProject[name_code] == address(0), 'Enstar: PROJECT_REPEAT');
        assembly {
            project_address := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        require(project_address != address(0), 'Enstar: ZERO_ADDRESS');
        getProject[name_code] = project_address;
        allProjects.push(project_address);
        project_name.push(name_code);
        IEnstarV1Project(project_address).setProject(_project);
        emit ProjectCreated(_project.name, name_code, project_address, allProjects.length);
    }


    /// @inheritdoc IEnstarV1Factory
    function setAdmin(address _admin) external {
        require(admin == msg.sender, 'Enstar: FORBIDDEN');
        admin = _admin;
    }

    /// @inheritdoc IEnstarV1Factory
    function investorWithdraw(address _erc20Addr,address _project,uint256 _amount) external returns (bool){
        return IEnstarV1Project(_project).investorWithdraw(_erc20Addr, _amount);
        //TODO
    }

    /// @inheritdoc IEnstarV1Factory
    function projectWithdraw(address _erc20Addr,address _project) external returns (bool){
        return IEnstarV1Project(_project).projectWithdraw(_erc20Addr);
    }


}