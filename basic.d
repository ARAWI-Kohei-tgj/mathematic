/*****************************************************************************
 * basic mathematic functions
 *
 * Authors: 新井浩平 (Kohei ARAI), arai-kohei-xg@ynu.jp
 * Version: 1.0
 *****************************************************************************/
module mathematic.basic;

import std.traits: isIntegral, isUnsigned, isFloatingPoint;

/**
 * Additive and multiplicative identity
 */
template Identity(T, string OP)
if(isFloatingPoint!T && (OP == "+" || OP == "*")){
	static if(OP == "+") enum T Identity= T(0.0L);
	else static if(OP == "*") enum T Identity= T(1.0L);
}

/*************************************************************
 * Factorial
 *
 * simply prod
 *************************************************************/
T factorial(T)(in T i) @safe pure nothrow @nogc
if(isIntegral!T && isUnsigned!T){
	typeof(return) result= void;
	if(i == 0u || i == 1u) result= 1u;
	else{
		result= 1u;
		foreach(T j; 2u..(i+1u)) result *= j;
	}
	return result;
}
unittest{assert(factorial(6u) == 720u);}

/*************************************************************
 * Combination
 *************************************************************/
T combination(T)(in T n, in T i) @safe pure nothrow @nogc
if(isIntegral!T && isUnsigned!T)
in(n >= i){
	return factorial!T(n)/(factorial!T(cast(T)(n-i))*factorial!T(i));
}
