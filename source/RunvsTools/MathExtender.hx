package;

/**
 * ...
 * @author 
 */
class MathExtender
{
	public static function Rad2Deg (v: Float) : Float
	{
		return v * 180 / Math.PI;
	}
	
	public static function Deg2Rad (v:Float) : Float
	{
		return v * Math.PI / 180;
	}
	
	public static function roundForDisplay(input : Float) : String
    {
        var dec = Std.int((input * 10) % 10);
		if (dec < 0) dec *= -1;
		return '${Std.string(Std.int(input))}.${Std.string(dec)}';
    }

	/// this function takes an arbitrary float and returns a value that is quantized in 0.5 steps
	public static function castToHalfSteps (x:Float) : Float
	{
		var xi : Int = Std.int( Math.round( x  * 2));	
		var ret : Float = xi / 2.0;	// 0, 0.5, 1.0, 1.5, 2.0, 2.5, ...
		return ret;
	}
}