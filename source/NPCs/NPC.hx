package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class NPC extends FlxSprite
{
	
	private var _state : PlayState;
	
	public var objectName : String;
	
	public var closeRangeDistance: Float = 32;

	private var _speechText : FlxText;
	private var _speechDisplayTimer : Float = -1;
	
	public  var overrideMessage: String = "";
	
	private var age : Float = 0;
	
	public function new(s : PlayState) 
	{
		super();
		_state = s;
		this.immovable = true;
		
		_speechText = new FlxText(0, 0, 128, "");
		_speechText.setBorderStyle(FlxTextBorderStyle.OUTLINE,FlxColor.BLACK,1,1);
		
		age += FlxG.random.float(0, 1.5);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		checkCloseRange();
		
		
		updateSpeech(elapsed);
	}
	
	function checkCloseRange() 
	{
		var dx = _state.player.x - x;
		var dy = _state.player.y - y;
		
		var dsq : Float = dx * dx + dy * dy;
		
		if (dsq < closeRangeDistance * closeRangeDistance)
		{
			onCloseRange();
		}
	}
	
	function updateSpeech(elapsed: Float):Void 
	{
		age+= elapsed;
		
		
		_speechText.offset.set(0, Math.sin(age) * 4);
		
		_speechText.update(elapsed);
		
		_speechDisplayTimer -= elapsed;
		
		if (_speechDisplayTimer <= 0)
			_speechText.alpha = 0;
		else if (_speechDisplayTimer >= GameProperties.NPCSpeechFadeOutTime)
			_speechText.alpha = 1;
		else
			_speechText.alpha = _speechDisplayTimer / GameProperties.NPCSpeechFadeOutTime;
	}
	
	public function speak (str: String, time : Float = 1.5) : Void
	{
		
		_speechText.setPosition(x + width +2, y - 12);
		_speechText.text = (overrideMessage == "") ?  str : overrideMessage;
		_speechDisplayTimer = time;
	}
	
	public function interact () : Void
	{
		// do nothing
	}
	
	public function onCloseRange () : Void
	{
		
	}
	
	public function drawOverlay() : Void
	{
		_speechText.draw();
	}
	
}