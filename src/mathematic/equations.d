/*****************************************************************************
 * Solver of Linear equations and Quadratic equations
 *
 * Version: 1.0
 *
 * License:
 *    $(LINK2 www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 *
 * Authors: 新井 浩平 (ARAI Kohei)
 *
 * Macros:
 *     SUP= <sup style="vertical-align:super;font-size:80%">$0</sup>
 *****************************************************************************/
module mathematic.equations;

import std.traits: isFloatingPoint;
import mathematic.complex: isComplex, BaseRealType;

/*************************************************************
 * List of solution types
 *************************************************************/
enum SolutionType: ubyte{
	OneR,	/// One solution of real number
	RepeatedR,	/// Double root of real number
	TwoR,	/// Two solutions of real numbers
	OneC,	/// One solution of complex number
	RepeatedC,	/// Double root of complex number
	TwoC	/// Two solutions of complex numbers
}

/*************************************************************
 * Linear equation
 * $(I y) $thinsp;= $(I ax) +$(I b)
 *************************************************************/
struct LinearEq(T) if(isFloatingPoint!T || isComplex!T){
	this(in T a, in T b) @safe pure nothrow @nogc{	///
		_cff[0]= b;
		_cff[1]= a;
	}

	@safe pure nothrow @nogc const{
		/************************
		 * Get the value at given $(I x)
		 ************************/
		T value(in T x){return _cff[1]*x +_cff[0];}

		/************************
		 * Get the solution which satisfies $(I y)=0.
		 ************************/
		T solve() @property{return -_cff[0]/_cff[1];}
	}

private:
	T[2] _cff;
}

/*************************************************************
 * Quadratic equation
 * $(I y)$thinsp;= $(I ax)$(SUP 2)$thinsp;+$(I bx)$thinsp;+$(I c)
 *************************************************************/
struct QuadraticEq(T) if(isFloatingPoint!T || isComplex!T){
	static if(isFloatingPoint!T){
		import std.complex: Complex;
		alias CT= Complex!T;
	}
	else{
		alias CT= T;
	}
	alias BRT= BaseRealType!T;
	enum maxDiffAbs= 1E-6;	// TEMP: to avoid compiler bug

	this(in T a, in T b, in T c) @safe pure nothrow @nogc{	///
		static if(isFloatingPoint!T) import mathematic.basic: isCloseToZero;
		else import mathematic.complex: isCloseToZero;

	  _cff[2]= a;
		_cff[1]= b;
		_cff[0]= c;

		if(isCloseToZero!T(_cff[2], maxDiffAbs)){	// a=0
			static if(is(T == BRT)) _solTyp= SolutionType.OneR;
			else _solTyp= SolutionType.OneC;
		}
		else{
			T d= this.discriminant;
			static if(is(T == BRT)){
				if(isCloseToZero!BRT(d, maxDiffAbs)) _solTyp= SolutionType.RepeatedR;
				else if(d > 0.0) _solTyp= SolutionType.TwoR;
				else _solTyp= SolutionType.TwoC;
			}
			else{
				if(isCloseToZero!(CT)(d, maxDiffAbs)) _solTyp= SolutionType.RepeatedC;
				else _solTyp= SolutionType.TwoC;
			}
		}
	}

  @safe pure nothrow @nogc const{
		/************************
		 * Get the value at given $(I x)
		 ************************/
		T value(in T x){return _cff[2]*x^^2 +_cff[1]*x +_cff[0];}

		SolutionType solutionType(){
			return this._solTyp;
		}

		/************************
		 * Get the solution which satisfies $(I y)$thinsp;=0.
		 ************************/
		CT[2] solve() @property{

			import std.complex: complex;
			typeof(return) result= void;

			static if(isFloatingPoint!T){
				import std.math: sqrt;
				import mathematic.basic: isCloseToZero;
			}
			else{
				import std.complex: sqrt;
				import mathematic.complex: isCloseToZero;
			}

			final switch(_solTyp){
			case SolutionType.OneR, SolutionType.OneC:
				static if(isFloatingPoint!T) result[0]= complex!BRT(-_cff[0]/_cff[1]);
				else result[0]= -_cff[0]/_cff[1];
				result[1]= complex(BRT.nan, BRT.nan);
				break;

			case SolutionType.RepeatedR, SolutionType.RepeatedC:
				static if(isFloatingPoint!T) result[0]= complex!BRT(-0.5*_cff[1]/_cff[2]);
				else result[0]= -_cff[1]/_cff[2]/2;
				result[1]= result[0];
				break;

			case SolutionType.TwoR:
				static if(isFloatingPoint!T){
					T d_sqrt= sqrt(discriminant);
					result[0]= complex!BRT( (-_cff[1] -d_sqrt)/(2*_cff[2]) );
					result[1]= complex!BRT( (-_cff[1] +d_sqrt)/(2*_cff[2]) );
				}
				else assert(0);
				break;

			case SolutionType.TwoC:
				static if(is(T == BRT)){
					BRT d_sqrt= sqrt(-discriminant);	// std.math.sqrt
					result[0]= complex!(BRT, BRT)(-_cff[1], -d_sqrt);
					result[1]= complex!(BRT, BRT)(-_cff[1], d_sqrt);
					foreach(ref num; result) num /= 2*_cff[2];
				}
				else{
					CT d_sqrt= sqrt(discriminant);	// std.complex.sqrt
					result[0]= (-_cff[1] -d_sqrt)/(2*_cff[2]);
					result[1]= (-_cff[1] +d_sqrt)/(2*_cff[2]);
				}
			}

			return result;
		}
	}

	private:
	T discriminant() @safe pure nothrow @nogc @property const{
		return _cff[1]^^2 -4*_cff[2]*_cff[0];
	}

	T[3] _cff;
	SolutionType _solTyp;
}
unittest{
	import std.math: isClose;
	import std.complex: Complex;
	Test_R: {
		Complex!double[2] result= void;
		QuadraticEq!double eq;

		import std.math: sqrt, isClose;
		// P(x)= x^2-1/2x-5/2
		eq= QuadraticEq!double(1.0, -0.5, -2.5);
	  result= eq.solve;
	  assert(isClose(result[0].re, 0.25-sqrt(41.0)/4.0) &&
					 isClose(result[1].re, 0.25+sqrt(41.0)/4.0));

		// P(x)= x^2-2\sqrt{2}x +2
		eq= QuadraticEq!double(1.0, -2.0*sqrt(2.0), 2.0);
	  result= eq.solve;
	  assert(isClose(result[0].re, sqrt(2.0)) && result[0].im == 0.0 &&
					 result[1] == result[0]);

		// P(x)= 2x^2 +3x +4
		eq= QuadraticEq!double(2.0, 3.0, 4.0);
		result= eq.solve;
		assert(isClose(result[0].re, -3.0/4.0) && isClose(result[0].im, -sqrt(23.0)/4.0));
		assert(isClose(result[1].re, -3.0/4.0) && isClose(result[1].im, sqrt(23.0)/4.0));
	}

	Test_C: {
		// P(z)= (1+i)z^2 +(-2+i)z +(-1+2i)
		Complex!double[2] results;
		Complex!double a, b, c;
		a= Complex!double(1.0, 1.0);
		b= Complex!double(-2.0, 1.0);
		c= Complex!double(-1.0, 2.0);
		auto eq= QuadraticEq!(Complex!double)(a, b, c);
		results= eq.solve;
		assert(isClose(results[0].re, -0.5) && isClose(results[0].im, 0.5));
		assert(isClose(results[1].re, 1.0) && isClose(results[1].im, -2.0));
	}
}
