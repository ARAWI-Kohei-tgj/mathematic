/****************************************************************************
 * Basic mathematic functions
 *
 * Version: 1.2
 *
 * License:
 *     $(LINK2 www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 *
 * Authors:
 *     新井浩平 (ARAI Kohei)
 *****************************************************************************/
module mathematic.basic;

import std.traits: isIntegral, isUnsigned, isFloatingPoint;

/************************************************************
 * Identity element of additive and multiplicative.
 ************************************************************/
template Identity(T, string OP)
if((isFloatingPoint!T || isIntegral!T) &&
   (OP == "+" || OP == "*")){
	static if(OP == "+") enum T Identity= cast(T)0;
	else static if(OP == "*") enum T Identity= cast(T)1;
}


/************************************************************
 * Computes whether $(B num) is approximately equal to zero.
 *
 * Params:
 *     num= The variable to be computed.
 *     maxDiffAbs= Maximum absolute difference.
 ************************************************************/
bool isCloseToZero(T)(in T num, in T maxDiffAbs= 1.0E-6L)
if(isFloatingPoint!T){
	import std.math: fabs;
	return (num.fabs < maxDiffAbs)? true: false;
}
unittest{
	assert(isCloseToZero!double(9.0E-7));
}


/************************************************************
 * Calculation of the factorial $(I i)! by simple multiplication.
 *
 * The time complexity is $(I O)($(I n)).
 ************************************************************/
T factorial(T)(in T i) @safe pure nothrow @nogc
if(isIntegral!T && isUnsigned!T){
	typeof(return) result= Identity!(T, "*");

	if(i > 1){
		foreach(T j; 2u..i+1u) result *= j;
	}
	return result;
}
///
unittest{
	assert(factorial!uint(0) == 1);
	assert(factorial(1u) == 1);
	assert(factorial(6u) == 720);
}

/************************************************************
 * Calculation of the combination C($(I n), $(I k)).
 ************************************************************/
T combination(T)(in T n, in T k) @safe pure nothrow @nogc
if(isIntegral!T && isUnsigned!T)
in(n >= k){
	if(k == 0){
		return 1u;
	}
	else if(k == 1 || n-k == 1){
		return n;
	}
	else{
		typeof(return) numerator= Identity!(T, "*");
		for(T i= n; i > n-k; --i) numerator *= i;
		return numerator/factorial(k);
	}
}
///
unittest{
	assert(combination!uint(6, 0) == 1);
	assert(combination!uint(6, 1) == 6);
	assert(combination!uint(6, 5) == 6);
	assert(combination!uint(11, 6) == 462);
	assert(combination!ulong(32, 8) == 10_518_300);
}
