pragma solidity ^0.4.22;


/** 07_fundraising
* fundraising has the goal to reach (amount is set on creation)
* fundraising has the time limit (time is set on creation)
* anyone can add any amount until time is up or the goal is reached
* when the time is up but the goal is not reached users can withdraw their funds
* when the goal is reached owner can withdraw all the money
*/



contract fundraising {
      uint public Goal;        //fundraising goal
      uint public StartTime;     //start tome for fundraising
      uint public Endtime;     //time limit for fundraising
      uint public LeftTime;    //left time for fundraising
      address public Owner;    //contract owner
      uint public WeitoEth;
      uint public ContractBalance;  //contract balance
      uint public UserNum;    //Number of User
      uint public LeftFund;   //left fund
      bool public FundrasingState;    //true is start, false is end


      //e vent when adding fund
      event AddFundEvent (address _sender , uint _value);

      // event for Owner withdraw
      event OwnerWithdrawEvent (uint _value);

      //event for user withdraw
      event UserWithdrawEvent (address _from, uint _value);

      struct UserData {
        uint Nth;       //Nth user
        uint Fund;      //user Fund
        address Addr;   //uset address
      }


      //Nth => UserData mapping
      mapping (address => UserData) public userdata;

      /*
       * @dev initialize. set fundraising goal and end time
       * @param uint _goal, uint _endtime
       */
      constructor () {
          //set goal and Endtime on contract creation
          UserNum = 0;
          Endtime = 90 ;   //how long to fundraising (second)
          WeitoEth = 10 ** 18;    //one eth = 10 ** 18 wei
          Goal = 10 * WeitoEth;   //10 Eth
          Owner = msg.sender;
          StartTime = now;
          FundrasingState = true;

      }

      /*
       * @dev only contract can use specify function
       * @return bool success
       */
      modifier onlyOwner () {
          require (msg.sender == Owner, 'Not contract owner.');
          _;
      }

      /*
       * @dev add fund by eth
       * @return bool success
       */
      function Addfund () public payable returns (bool success) {
          //check fundraising is StartTime
          require (FundrasingState, 'fundraising is end.');

          //check the ggoal to reach
          //tips: msg.value + this.balance is wrong because this.balance including msg.value.
          require (msg.value + ContractBalance <= Goal, 'The Goal is reached.');


          //check the time is end
          require (StartTime +  Endtime >= now, 'Time is up.');

          //new user, record user address Number and fund
          if (userdata[msg.sender].Nth == 0) {
              UserNum ++;
              userdata[msg.sender].Nth = UserNum;
              userdata[msg.sender].Fund = msg.value;
              userdata[msg.sender].Addr = msg.sender;
          //old user, increase fund
          } else {
              userdata[msg.sender].Fund =+ msg.value;
          }
          AddFundEvent (msg.sender, userdata[msg.sender].Fund);
          ContractBalance = this.balance;
          return true;
      }

      /*
       * @dev owner withdraw all fund when gold is reached
       * @return bool success
       */
       function OwnerWithdraw () public onlyOwner returns (bool success) {
            require (ContractBalance == Goal, 'The Goal is not reached.');
            require (FundrasingState, 'already withdraw');


            Owner.transfer (ContractBalance);
            OwnerWithdrawEvent (ContractBalance);
            FundrasingState = false;
            return true;
       }

       /*
        * @dev user withdraw their fund when time is up and goal not to reach
        * @return bool success
        */
        function UserWithdraw () public returns (bool success) {
            require (StartTime + Endtime < now, 'fundraising is running, can not withdraw.');
            require (ContractBalance < Goal, 'fund is reached goal, cant withdraw.');
            require (userdata[msg.sender].Nth != 0, 'you are not user with fundraising.');
            require (userdata[msg.sender].Fund > 0, 'your Fund is zero.');

            userdata[msg.sender].Addr.transfer(userdata[msg.sender].Fund);
            UserWithdrawEvent (msg.sender, userdata[msg.sender].Fund);
            userdata[msg.sender].Fund = 0;
            FundrasingState = false;
            return true;
        }

        /*
         * @dev left time
         * @return bool success
         */
         function GetLeftTime () public view returns (uint) {
            require (StartTime +  Endtime > now, 'time is up.');
            LeftTime = (StartTime +  Endtime) - now;
            return LeftTime;
         }

         /*
          * @dev get contract balance
          * @return bool success
          */
          function GetContractBalance () public view returns (uint) {
            return this.balance;
          }

          function GetLeftFund () public view returns (uint) {
              LeftFund = Goal - ContractBalance;
            return LeftFund;
          }

}
