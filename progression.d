/******************************************************************************
 * Progression
 *
 * Authors: 新井 浩平 (Kohei ARAI), arawi-kohei-takasaki@yahoo.co.jp
 * Version: 1.2
 ******************************************************************************/

module mathematic.progression;

import std.traits: isIntegral;
/**************************************************************
 * Sum of natural numbers
 *
 * This function calculates the sum of first $(I n) natural numbers,
 * like 1+2+...+n, using following equation
 * \[
 *  \sum_{i=0}^n i= \dfrac{n(n+1)}{2}.
 * \]
 *
 * Params:
 *	n= end of the progression
 **************************************************************/
Z sumFromZero(Z)(in Z n) @safe pure nothrow @nogc
if(isIntegral!Z)
in(n >= 0, "Argument is not allowed to be a negative number.")
in((is(Z == byte) && n <= 15) ||	// byte.max= 127
	 (is(Z == ubyte) && n <= 22) ||	// ubyte.max= 255
	 (is(Z == short) && n <= 255) ||	// short.max= 32767
	 (is(Z == ushort) && n <= 361 ) ||	// ushort.max= 65535
	 (is(Z == int) && n <= 65_535) ||	// int.max= 2_147_483_647
	 (is(Z == uint) && n <= 92_681) ||	// uint.max= 4_294_967_295
	 (is(Z == long) && n <= 4_294_967_295) ||	// long.max= 9_223_372_036_854_775_807
	 (is(Z == ulong) && n <= 6_074_000_000), "An overflow should occur."){

	return cast(Z)((n == 0u)? 0u : n*(n+1u)/2u);
}
@safe pure nothrow @nogc unittest{
	assert(sumFromZero!ushort(8) == 36);
	assert(sumFromZero(5) == 15);
	assert(sumFromZero!ubyte(0) == 0);
}

/**************************************************************
 * Sum of the part of natural numbers
 *
 * \[
 *  \sum_{i=u}^v i
 * \]
 *
 * Params:
 * 	st= start number u
 * 	en= end number v
 **************************************************************/
Z partialSum(Z)(in Z st, in Z en) @safe pure nothrow @nogc
if(isIntegral!Z)
in(st >= 0u && en >= st){
  return (st == en)? 0u: (st+en)*(en-st+1u)/2u;
}
@safe pure nothrow @nogc unittest{
	assert(partialSum(9, 9) == 0);
	assert(partialSum(5, 12) == 68);
}

/**********************************************
 * Squared sum of natural numbers
 *
 * \[
 *  \sum_{i=0}^n i^2= \dfrac{n(n+1)(2n+1)}{6}
 * \]
 **********************************************/
auto squaredSumFromZero(Z)(in Z n) @safe pure nothrow @nogc
if(isIntegral!Z && isUnsigned!Z){
	return (n == 0u)? 0u: n*(n+1u)*(2u*n+1u)/6u;
}
