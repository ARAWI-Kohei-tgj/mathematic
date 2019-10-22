/**************************************************************
 * Progression
 *
 * Authors: 新井 浩平 (Kohei ARAI), arai-kohei-xg@ynu.jp
 * Version: 1.1
 *************************************************************/

module mathematic.progression;

import std.traits: isIntegral, isUnsigned;
/******************************
 * Sum of an arithmetic progression
 *
 * \[
 *  \sum_{i=0}^n i= \dfrac{n(n+1)}{2}
 * \]
 *****************************/
Q sumFromZero(Q)(in Q n) @safe pure nothrow @nogc
if(isIntegral!Q && isUnsigned!Q){
	return cast(Q)((n == 0u)? 0u : n*(n+1u)/2u);
}
@safe pure nothrow @nogc unittest{
	assert(sumFromZero!ushort(8) == 36);
	assert(sumFromZero(5) == 15);
	assert(sumFromZero!ubyte(0) == 0);
}

/**
 * sum_{i=u}^v i
 */
auto summation(Q)(in Q st, in Q en) @safe pure nothrow @nogc
if(isIntegral!Q && isUnsigned!Q)
in(en >= st){
  return (st == en)? 0u: (st+en)*(en-st+1u)/2u;
}
@safe pure nothrow @nogc unittest{
	assert(sumTo(9, 9) == 0);
	assert(sumTo(5, 12) == 68);
}

/**
 *
 * \[
 *  \sum_{i=0}^n i^2= \dfrac{n(n+1)(2n+1)}{6}
 * \]
 */
auto squaredSumFromZero(Q)(in Q n) @safe pure nothrow @nogc
if(isIntegral!Q && isUnsigned!Q){
	return (n == 0u)? 0u : n*(n+1u)*(2*n+1u)/6u;
}
