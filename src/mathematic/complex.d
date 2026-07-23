/****************************************************************************
 * Utilities for the codes containing mix of complex number types and real number types.
 *
 * Version: 1.0
 *
 * License:
 *     $(LINK2 www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 *
 * Authors:
 *     新井浩平 (ARAI Kohei)
 ****************************************************************************/
module mathematic.complex;

import std.traits: isFloatingPoint, isIntegral;
import std.complex: Complex;

/************************************************************
 * Detects whether $(B T) is a complex number types of standard library.
 ************************************************************/
template isComplex(T){
	enum isComplex= is(T == Complex!R, R);
}

/************************************************************
 * Gets the base type of complex numbers.
 * Additionally, the real number types are also accepted as the template argument.
 ************************************************************/
template BaseRealType(T)
if(isFloatingPoint!T){
	alias BaseRealType = T;
}
/// ditto
template BaseRealType(C : Complex!R, R){
	alias BaseRealType = R;
}
///
unittest{
	import std.complex: Complex;
	assert(is(BaseRealType!(Complex!double) == double));
	assert(is(BaseRealType!real == real));
}

@safe pure nothrow @nogc:
/************************************************************
 * Computes whether the imaginary part of $(B num) is apploximately equal to zero.
 *
 * Params:
 *     num= The variable in complex number type.
 *     maxDiffAbs= Maximum absolute difference.
 ************************************************************/
bool isRegardedAsRealNum(CT)(in CT num, in BaseRealType!CT maxDiffAbs= 1E-6L)
if(isComplex!CT){
	import mathematic.basic: isCloseToZero;
	return isCloseToZero(num.im, maxDiffAbs)? true: false;
}
///
unittest{
	import std.complex: Complex;
	assert( isRegardedAsRealNum!(Complex!double)(Complex!double(2.0, 9.0E-7)) );
	assert( !isRegardedAsRealNum!(Complex!double)(Complex!double(2.0, 3.0)) );
}

/************************************************************
 * Computes whether $(B num) is approximately equal to zero.
 *
 * Params:
 *     num= The variable to be computed.
 *     maxDiffAbs= Maximum absolute difference.
 ************************************************************/
bool isCloseToZero(T)(in T num, in BaseRealType!T maxDiffAbs= 1E-6L)
if(isComplex!T){
	import std.complex: abs;
	return (num.abs < maxDiffAbs)? true: false;
}

@property:
/************************************************************
 * Represents the method 're' of 'Complex!T' with assuming $(B T) as a complex number.
 *
 * Returns:
 *     Always itself as real part.
 ************************************************************/
T re(T)(in T num) if(isFloatingPoint!T ||isIntegral!T){return num;}
///
unittest{
	double foo= 4.0;
	assert(foo.re == 4.0);
}

/************************************************************
 * Represents the method 'im' of 'Complex!T' with assuming $(B T) as a complex number.
 *
 * Returns:
 *     Always zero as imaginally part.
 ************************************************************/
T im(T)(in T num) if(isFloatingPoint!T || isIntegral!T){return T(0);}
///
unittest{
	double foo= -3.0;
	assert(foo.im == 0.0);
}

/************************************************************
 * Represents the function 'conj' defined in std.complex.d with assuming $(B T) as a complex number.
 *
 * Returns:
 *     Always itself as conjugate.
 ************************************************************/
T conj(T)(in T num) if(isFloatingPoint!T || isIntegral!T){return num;}
///
unittest{
	double foo= 4.0;
	assert(foo.conj == 4.0);
}

/************************************************************
 * Represents the function 'sqAbs' defined in 'std.complex.d with assuming $(B T) as a complex number.
 *
 * Returns:
 *     The squared of itself.
 ************************************************************/
T sqAbs(T)(in T num) if(isFloatingPoint!T || isIntegral!T){return num^^2;}
///
unittest{
	double foo= -3.0;
	assert(foo.sqAbs == 9.0);
}
