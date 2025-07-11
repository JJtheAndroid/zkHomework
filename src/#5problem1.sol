// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract ProblemOne {

   struct ECpoint {


    uint256 x;
    uint256 y;
   }

   uint256 public constant CURVEORDER = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
   

   ECpoint public G = ECpoint(1, 2);


        //Claim: “I know two rational numbers that add up to num/den”
   function rationalAdd(ECpoint calldata A, ECpoint calldata B, uint256 num, uint256 dem) public view returns (bool verified ){


    //here we do EC addition 


    (uint256 Cx, uint256 Cy) = ECAddition(A.x, A.y, B.x, B.y);

    //we must calculate the modular inverse of dem as (num/dem) cannot normally be calculated with division 
    //modular inverse  a^{p-2}

    uint demInverse = modExp(dem,CURVEORDER -2, CURVEORDER);



     // This scalar represents the rational number (num/den) in the finite field.
    uint256 target_scalar = mulmod(num, demInverse, CURVEORDER);



    //we then scalar multiply the target with the generator (1,2)
    (uint Gx, uint Gy) = scalarMultiply((G.x),(G.y), target_scalar);



    if (Cx == Gx && Cy == Gy) {

        return true;

    }
    
    return false ;





   }



//

   function modExp(uint256 base, uint256 exp, uint256 mod)
		public
		view
		returns (uint256) {
		
		bytes memory precompileData = abi.encode(32, 32, 32, base, exp, mod);
    (bool ok, bytes memory data) = address(5).staticcall(precompileData);
    require(ok, "expMod failed");
    return abi.decode(data, (uint256));
}



    //Here we use the address 6 precomoile to compute the EC addition of 2 points 
        function ECAddition(
        uint256 Ax,
        uint256 Ay,
        uint256 Bx,
        uint256 By
    ) public view returns (uint256 Cx, uint Cy) {
        bytes memory payload = abi.encode(Ax, Ay, Bx, By);
        (bool ok, bytes memory answer) = address(6).staticcall(payload);
        require(ok, "ECAddition Failed");
        (Cx, Cy) = abi.decode(answer, (uint, uint));
    }



        function scalarMultiply(
        uint Ax,
        uint Ay,
        uint scalar
    ) public view returns (uint256 Cx, uint Cy) {
        bytes memory payload = abi.encode(Ax, Ay, scalar);
        (bool ok, bytes memory answer) = address(7).staticcall(payload);
        require(ok, "scalarMultiply failed");
        (Cx, Cy) = abi.decode(answer, (uint, uint));
    }





}