// =================================================================================================    
//    
//	CoreApp Framework    
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.    
//    
//	This program is free software. You can redistribute and/or modify it    
//	in accordance with the terms of the accompanying license agreement.    
//    
// =================================================================================================  

package core.app.util;

class Easing
{  
	//-----V--- Back ---V--------    
	// back easing in - backtracking slightly, then reversing direction and moving to target    
	// t: current time, b: beginning value, c: change in value, d: duration, s: overshoot amount (optional)    
	// t and d can be in frames or seconds/milliseconds    
	// s controls the amount of overshoot: higher s means greater overshoot    
	// s has a default value of 1.70158, which produces an overshoot of 10 percent    
	// s==0 produces cubic easing with no overshoot  
	public static function easeInBack(t : Float, b : Float, c : Float, d : Float, s : Float = 1.70158) : Float
	{
		return c * (t /= d) * t * ((s + 1) * t - s) + b;
    }
	
	public static function easeOutBack(t : Float, b : Float, c : Float, d : Float, s : Float = 1.70158) : Float
	{
		return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
    }
	
	public static function easeInOutBack(t : Float, b : Float, c : Float, d : Float, s : Float = 1.70158) : Float
	{
		if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
		return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
    }  
	
	//-----^--- Back ---^--------    
	//-----V--- Bounce ---V--------  
	public static function easeOutBounce(t : Float, b : Float, c : Float, d : Float) : Float
	{
		if ((t /= d) < (1 / 2.75)) {
			return c * (7.5625 * t * t) + b;
        } else if (t < (2 / 2.75)) {
			return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
        } else if (t < (2.5 / 2.75)) {
			return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
        } else {
			return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
        }
    }
	
	public static function easeInBounce(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c - easeOutBounce(d - t, 0, c, d) + b;
    }
	
	public static function easeInOutBounce(t : Float, b : Float, c : Float, d : Float) : Float 
	{ 
		if (t < d / 2){
			return (easeInBounce(t * 2, 0, c, d)) * 0.5 + b;
        } else return easeOutBounce(t * 2 - d, 0, c, d) * .5 + c * .5 + b;
    }  
	
	//-----^--- Bounce ---^--------
    
	//-----V--- Circ ---V--------  
	public static function easeInCirc(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
    }
	
	public static function easeOutCirc(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
    }
	
	public static function easeInOutCirc(t : Float, b : Float, c : Float, d : Float) : Float
	{
		if ((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
		return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
    }  
	
	//-----^--- Circ ---^--------    
	
	//-----V--- Cubic ---V--------  
	public static function easeInCubic(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * (t /= d) * t * t + b;
    }
	
	public static function easeOutCubic(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * ((t = t / d - 1) * t * t + 1) + b;
    }
	
	public static function easeInOutCubic(t : Float, b : Float, c : Float, d : Float) : Float
	{
		if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
		return c / 2 * ((t -= 2) * t * t + 2) + b;
    }  
	
	//-----^--- Cubic ---^--------    
	
	//-----V--- Elastic ---V--------    
	// t: current time, b: beginning value, c: change in value, d: duration, a: amplitude (optional), p: period (optional)    
	// t and d can be in frames or seconds/milliseconds  
	public static function easeInElastic(t : Float, b : Float, c : Float, d : Float, a : Float, p : Float) : Float
	{
		if (t == 0) return b;
		if ((t /= d) == 1) return b + c;
		if (p == 0) p = d * .3;
		var s : Float = 0;
		if (a == 0 || a < Math.abs(c)) {
			a = c;s = p / 4;
        } else s = p / (2 * Math.PI) * Math.asin(c / a);
		return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
    }
	
	public static function easeOutElastic(t : Float, b : Float, c : Float, d : Float, a : Float = 0, p : Float = 0) : Float
	{
		if (t == 0) return b;
		if ((t /= d) == 1) return b + c;
		if (p == 0) p = d * .3;
		var s : Float;
		if (a == 0 || a < Math.abs(c)) {
			a = c;s = p / 4;
        } else s = p / (2 * Math.PI) * Math.asin(c / a);
		return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b);
    }
	
	public static function easeInOutElastic(t : Float, b : Float, c : Float, d : Float, a : Float, p : Float) : Float
	{
		if (t == 0) return b;
		if ((t /= d / 2) == 2) return b + c;
		if (p == 0) p = d * (.3 * 1.5);
		var s : Float;
		
		if (a == 0 || a < Math.abs(c)) {
			a = c;
			s = p / 4;
        } else s = p / (2 * Math.PI) * Math.asin(c / a);
		
		if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
		return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
    }  
	
	//-----^--- Elastic ---^--------   
	
	//-----V--- Expo ---V--------  
	public static function easeInExpo(t : Float, b : Float, c : Float, d : Float) : Float 
	{
		return ((t == 0)) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
    }
	
	public static function easeOutExpo(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return ((t == d)) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
    }
	
	public static function easeInOutExpo(t : Float, b : Float, c : Float, d : Float) : Float
	{
		if (t == 0) return b;
		if (t == d) return b + c;
		if ((t /= d / 2) < 1) return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
		return c / 2 * (-Math.pow(2, -10 * --t) + 2) + b;
    }  
	
	//-----^--- Expo ---^--------    
	
	//-----V--- Linear ---V--------  
	
	public static function easeInLinear(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * t / d + b;
    }
	
	public static function easeOutLinear(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * t / d + b;
    }
	
	public static function easeInOutLinear(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * t / d + b;
    }  
	
	//-----^--- Linear ---^--------    
	
	//-----V--- Quad ---V--------  
	
	public static function easeInQuad(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * (t /= d) * t + b;
    }
	
	public static function easeOutQuad(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return -c * (t /= d) * (t - 2) + b;
    }
	
	public static function easeInOutQuad(t : Float, b : Float, c : Float, d : Float) : Float
	{
		if ((t /= d / 2) < 1) return c / 2 * t * t + b;
		return -c / 2 * ((--t) * (t - 2) - 1) + b;
    }  
	
	//-----^--- Quad ---^--------    
	
	//-----V--- Quart ---V--------  
	
	public static function easeInQuart(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * (t /= d) * t * t * t + b;
    }
	
	public static function easeOutQuart(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return -c * ((t = t / d - 1) * t * t * t - 1) + b;
    }
	
	public static function easeInOutQuart(t : Float, b : Float, c : Float, d : Float) : Float
	{
		if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
		return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
    }  
	
	//-----^--- Quart ---^--------    
	
	//-----V--- Quint ---V--------  
	
	public static function easeInQuint(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * (t /= d) * t * t * t * t + b;
    }
	
	public static function easeOutQuint(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
    }
	
	public static function easeInOutQuint(t : Float, b : Float, c : Float, d : Float) : Float
	{
		if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
		return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
    }  
	
	//-----^--- Quint ---^--------    
	
	//-----V--- Sine ---V--------  
	
	public static function easeInSine(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
    }
	
	public static function easeOutSine(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return c * Math.sin(t / d * (Math.PI / 2)) + b;
    }
	
	public static function easeInOutSine(t : Float, b : Float, c : Float, d : Float) : Float
	{
		return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
    }  
	
	//-----^--- Sine ---^--------  
	
	public static function cos(t : Float, start : Float, offset : Float, length : Float) : Float
	{
		var ratio : Float = (((Math.cos((t / length) * Math.PI * 2)) + 1) / 2);
		return (ratio * start) + ((1 - ratio) * (start + offset));
    }
	
	public static function sin(t : Float, start : Float, offset : Float, length : Float) : Float
	{
		var ratio : Float = (((Math.sin((t / length) * Math.PI * 2)) + 1) / 2);
		return (ratio * start) + ((1 - ratio) * (start + offset));
    }

    public function new()
    {
    }
}