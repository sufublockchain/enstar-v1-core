const { contract, accounts } = require('@openzeppelin/test-environment');
const { ether, constants, expectEvent } = require('@openzeppelin/test-helpers');
const ERC20Contract = contract.fromArtifact("ERC20FixedSupply");
const ProjectContract = contract.fromArtifact("EnstarV1Project");
const EnstarV1Factory = contract.fromArtifact("EnstarV1Factory");

//固定总量代币
const totalSupply = '1000';//发行总量
[factory, tokenCP, tokenVC, owner, receiver] = accounts;
EthValue = '10';
ERC20Instance = null;
EnstarV1FactoryInstance = null;
projectAddress = null;


describe("固定总量代币", function () {
    it('布署代币合约', async function () {
        ERC20Param = [
            "My Test Coin",   //代币名称
            "MTC",              //代币缩写
            18,                 //精度
            totalSupply,        //发行总量
        ];
        ERC20Instance = await ERC20Contract.new(...ERC20Param, { from: owner });
    });
});


describe("测试ERC20合约的标准方法", async function () {
    //测试账户余额
    it('balanceOf()', async function () {
        const bof = await ERC20Instance.balanceOf(owner);
        console.log("balanceOf owner: ", bof);
    });

    //测试代币发送
    it('transfer()', async function () {
        let receipt = await ERC20Instance.transfer(receiver, '13456', { from: owner });
        expectEvent(receipt, 'Transfer', {
            from: owner,
            to: receiver,
            value: '13456',
        });
    });

    it('balanceOf()', async function () {
        let bof = await ERC20Instance.balanceOf(receiver);
        console.log("balanceOf receiver: ", bof);
    });


    it('balanceOf()', async function () {
        const bof = await ERC20Instance.balanceOf(owner);
        console.log("balanceOf owner: ", bof);
    });


});


describe("测试Project合约的标准方法", async function () {
    
    it('projectTest->', async function () {

        ProjectInstance = await ProjectContract.new(receiver);

        ProjectParam = {
            "name": "tp1",
            "introduction": "this is ....",
            "operate" : "bank",
            "amount" : 100000,
            "create_time" : 16032146331,
            "account" : ERC20Instance.address,
            "balance" : 10,
            "website" : "www.",
            "creator" : "c1",
            "country" : "cn",
            "province" : "sh",
            "city" : "sh"
        }

        await ProjectInstance.setProject(ProjectParam);
        const project_info = await ProjectInstance.project();
        console.log("project_info: ", project_info);

        const project_balance = await ProjectInstance.checkProjectBalance();
        console.log("project_balance: ", project_balance);



        const bal1 = await ERC20Instance.balanceOf(owner);
        console.log("bal1111---------: ", bal1);

        //total coin in owern
        const bow =  await ProjectInstance.balanceOfTest(ERC20Instance.address,owner);
        console.log("bow: ", bow);
        
        const bof = await ERC20Instance.approve(ProjectInstance.address, 10, { from: owner });
        const aop =  await ERC20Instance.allowance(owner, ProjectInstance.address);
        console.log("Approved aop: ", aop);

        const bal = await ERC20Instance.balanceOf(owner);
        console.log("bal---------: ", bal);


        let receipt = await ERC20Instance.transfer(receiver, '134', { from: owner });
        expectEvent(receipt, 'Transfer', {
            from: owner,
            to: receiver,
            value: '134',
        });
        //console.log("receipt receiver: ", receipt);

        const bal_receiver = await ERC20Instance.balanceOf(receiver);
        console.log("balance of receiver", bal_receiver);

    });


});


describe("测试工厂合约的标准方法", async function () {
    
    

    //create project contract
    it('createProjectContract->', async function () {
        EnstarV1FactoryInstance = await EnstarV1Factory.new(receiver);
        ProjectParam = {
            "name": "tp1",
            "introduction": "this is ....",
            "operate" : "bank",
            "amount" : 100000,
            "create_time" : 16032146331,
            "account" : ERC20Instance.address,
            "balance" : 10,
            "website" : "www.",
            "creator" : "c1",
            "country" : "cn",
            "province" : "sh",
            "city" : "sh"
        }
        //create project contract
        projectAddress = await EnstarV1FactoryInstance.createProject(ProjectParam);
        console.log("project contract address: ", projectAddress);

        //get address by name
        const addr = await EnstarV1FactoryInstance.getAddressByName("tp1");
        console.log("project address: ", addr);
        
        //invest to project
        let receipt = await ERC20Instance.transfer(addr, '12', { from: receiver });
        expectEvent(receipt, 'Transfer', {
            from: receiver,
            to: addr,
            value: '12',
        });
        const bal_project = await ERC20Instance.balanceOf(addr);
        console.log("balance of project", bal_project);

        //project executor withdraw
        const flag = await EnstarV1FactoryInstance.projectWithdraw(ERC20Instance.address,addr);
        console.log("project executor withdraw: ", flag);

    });

    //get projects count
    it('allProjectsLength->', async function () {
        const len = await EnstarV1FactoryInstance.allProjectsLength();
        console.log("project count: ", len);
    });

    //is projects exist
    it('isProjectExist->', async function () {
        const flag = await EnstarV1FactoryInstance.isProjectExist("tp1");
        console.log("project exist flag: ", flag);
    });

    


    


});