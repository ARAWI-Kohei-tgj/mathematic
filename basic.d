/****************************************************************************
 * Basic mathematic functions
 *
 * Version: 1.1
 *
 * Authors: 新井浩平 (ARAI Kohei)
 *****************************************************************************/
module mathematic.basic;

import std.traits: isIntegral, isUnsigned, isFloatingPoint;

/************************************************************
 * Identity of additive and multiplicative.
 ************************************************************/
template Identity(T, string OP)
if(isFloatingPoint!T && (OP == "+" || OP == "*")){
	static if(OP == "+") enum T Identity= T(0.0L);
	else static if(OP == "*") enum T Identity= T(1.0L);
}

/************************************************************
 * Calculation of the factorial $(I i)! by simple multiplication.
 *
 * The time complexity is $(I O)($(I n)).
 ************************************************************/
T factorial(T)(in T i) @safe pure nothrow @nogc
if(isIntegral!T && isUnsigned!T){
	typeof(return) result= 1u;

	if(i > 1){
		foreach(T j; 2u..i+1u) result *= j;
	}
	return result;
}
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
		typeof(return) numerator= 1u;
		foreach(T i; 2u..n-k+1u) numerator *= i;
		return numerator/factorial(k);
	}
}

unittest{
	assert(combination!uint(6, 0) == 1);
	assert(combination!uint(6, 1) == 6);
	assert(combination!uint(6, 5) == 6);
	assert(combination!uint(11, 6) == 462);
	assert(combination!uint(32, 8) == 10_518_300);
}
