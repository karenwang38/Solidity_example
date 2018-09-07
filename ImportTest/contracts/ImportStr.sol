pragma solidity ^0.4.22;
import "./ReturnStr.sol";

/** Array wraper
* min() - returns minimal array element
* max() - returns maximal array element
* sum() - returns sum of all array elements
* set(uint []) - set array
* get() - returns stored array
* sort() - sorts all array elements
*/

contract ImportStr is ReturnStr {
      string CallStr;

  constructor() {

  }

  function ImportTest () public view returns (string) {
      //Min = min (UintArray);
      //return Min;
      CallStr = ShwoStr();
      return CallStr;
  }
}
