/******************************************************************************
 * Progression
 *
 * Version: 1.3
 *
 * License:
 *     $(LINK2 www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 *
 * Authors: 新井 浩平 (ARAI Kohei)
 *
 * Macros:
 *     SUB= <sub style="vertical-align: sub; font-size: 80%">$0</sub>
 *     SUP= <sup style="vertical-align: super; font-size: 80%">$0</sup>
 *     SUM_EQUALS= <td>
 *            <table>
 *              <tr>
 *                <td style="padding:0; border:none;">
 *                  <span>$2</span><br>
 *                  <span style= "font-size: 250%;">&Sigma;</span><br>
 *                  <span>$1</span>
 *                </td>
 *                <td style="font-size: 120%; padding: 0; border: none;"><span>$3</span></td>
 *                <td style="padding: 0; border: none;"><span>&thinsp;$4</span></td>
 *              </tr>
 *            </table>
 *          </td>
 *
 *     FRAC= <span style="display: inline-block; vertical-align: middle; text-align: center; font-size: 0.9rem; line-height: 1;">
 *             <span style="display: block; padding: 0 0.1em; border-bottom: 1px solid #000;">$1</span>
 *             <span style="display: block; padding: 0 0.1em;">$2</span>
 *           </span>
 *
 ******************************************************************************/
module mathematic.progression;

import std.traits: isIntegral;
/**************************************************************
 * Sum of integers from 0
 *
 * Calculates the sum of the natural numbers up to $(I n),
 * like 0+1+2+…+$(I n), using following equation
 * $(SUM_EQUALS $(I i)=0, $(I n), $(I i), =&thinsp;$(FRAC $(I n)&thinsp;($(I n)+1), 2)&thinsp;.)
 *
 * Params:
 *     n= end of the progression
 **************************************************************/
Z sumFromZero(Z)(in Z n) @safe pure nothrow @nogc
if(isIntegral!Z)
in(n >= 0, "Negative number is not allowed.")
in((is(Z == byte) && n <= 15) ||
   (is(Z == ubyte) && n <= 22) ||
   (is(Z == short) && n <= 255) ||
   (is(Z == ushort) && n <= 361) ||
   (is(Z == int) && n <= 65_535) ||
   (is(Z == uint) && n <= 92_681) ||
   (is(Z == long) && n <= 4_294_967_295) ||
   (is(Z == ulong) && n <= 6_074_000_000)){
	if(n > 0){
		static if(Z.sizeof < 8){
			ulong x;
			if(n%2){
				x= (n+1)/2;
				x *= n;
			}
			else{
				x= n/2;
				x *= n+1;
			}
		}
		else{
			import std.int128: Int128;
			Int128 x;
			if(n%2){
				x= Int128((n+1uL)/2u);
				x *= n;
			}
			else{
				x= Int128(n/2uL);
				x *= n+1UL;
			}
		}
		return cast(Z)x;
	}
	else{
		return Z(0);
	}
}
unittest{
	assert(sumFromZero!byte(0) == 0);
	assert(sumFromZero!ushort(5) == 15);
	assert(sumFromZero!int(65_535) == 2_147_450_880);
	assert(sumFromZero!uint(92_681) == 4_294_930_221U);
	assert(sumFromZero!long(4_294_967_295L) == 9_223_372_034_707_292_160L);
	assert(sumFromZero!ulong(6_074_000_000UL) == 18_446_738_003_037_000_000UL);
}


/**************************************************************
 * Sum of the part of natural numbers
 *
 * $(SUM_EQUALS $(I i)=u, $(I v), $(I i), =&thinsp;$(FRAC ($(I u)+$(I v))($(I v)-$(I u)+1), 2)&thinsp;.)
 *
 * Params:
 *     st= start number u
 *     en= end number v
 **************************************************************/
Z partialSum(Z)(in Z st, in Z en) @safe pure nothrow @nogc
if(isIntegral!Z && Z.sizeof < 8)
in(st >= 0u && en >= st){
	if(st != en){
		ulong result= (st+en)*(en-st+1u)/2u;
		return cast(Z)result;
	}
	else{
		return Z(0);
	}
}
unittest{
	assert(partialSum(9, 9) == 0);
	assert(partialSum(5, 12) == 68);
}

/**********************************************
 * Squared sum of integers from 0
 *
 * Calculates the squared sum of the natural numbers up to $(I n),
 * like 0+1+4+…+$(I n)$(SUP 2), using following equation
 *  $(SUM_EQUALS $(I i)=0, $(I n), $(I i)&thinsp;$(SUP 2), =&thinsp;$(FRAC $(I n)&thinsp;($(I n)+1)(2$(I n)+1), 6)&thinsp;.)
 *
 * Params:
 *     n= end of the progression
 **********************************************/
auto squaredSumFromZero(Z)(in Z n) @safe pure nothrow @nogc
if(isIntegral!Z)
in(n >= 0, "Negative number is not allowed.")
in((is(Z == byte) && n <= 6) ||
   (is(Z == ubyte) && n <= 8) ||
   (is(Z == short) && n <= 45) ||
   (is(Z == ushort) && n <= 57) ||
   (is(Z == int) && n <= 1_860) ||
   (is(Z == uint) && n <= 2_343) ||
   (is(Z == long) && n <= 3_024_616) ||
   (is(Z == ulong) && n <= 3_810_777)){
	if(n > 0){
		static if(Z.sizeof < 8){
			ulong x= n*(n+1u)/2u;
		}
		else{
			import std.int128: Int128;
			Int128 x= n*(n+1)/2;
		}
		x *= (2u*n+1u);
		x /= 3u;
		return cast(Z)x;
	}
	else return Z(0);
}
unittest{
	assert(squaredSumFromZero!ubyte(0) == 0);
	assert(squaredSumFromZero!int(1_860) == 2_146_682_110);
	assert(squaredSumFromZero!uint(2_343) == 4_290_161_084U);
	assert(squaredSumFromZero!long(3_024_616L) == 9_223_371_388_520_336_796L);
	assert(squaredSumFromZero!ulong(3_810_777UL) == 18_446_735_571_075_162_805UL);
}
