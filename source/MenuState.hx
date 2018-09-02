package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxState;
import flixel.text.FlxText;

#if (flash)
import kong.Kongregate;
import kong.KongregateApi;
#end

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	public static var MyDate : String = "2018-08";
	public static var MyJam : String = "5th Kajam 'Retro'";
	public static var MyName : String = "Thyl's Tale";
	public static var Authors: String = "@Thunraz, @xXBloodyOrange, @KaramBharj and @Laguna_999";
	

	public static var Controls : String = "WASD/Arrows to move\nX to attack/interact\nC to dash\nQ for bow\nF for stats";
	
	
	public static var HighScore : Int = 0;
	public static var LastScore : Int = 0;
	
	private var vignette :Vignette;
	
	private var overlay : FlxSprite;
	private var overlayTween : FlxTween;
	
	private var started : Bool = false;
	
	private var age : Float = 0;
	
		
#if(flash)
	public static var kongregate : KongregateApi = null;
#end
	
	public static function setNewScore (s: Int)
	{
		LastScore = s;
		if (s > HighScore)
		{
			HighScore = s;
#if(flash)
			kongregate.stats.submit("highscore", HighScore);
#end	
		}
	}
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
	
		FlxG.mouse.visible = false;
		
		FlxG.sound.playMusic(AssetPaths.town_music__ogg,0.6);
				
#if(flash)
		Kongregate.loadApi(function(api:KongregateApi) {
        // Save Kongregate API reference.
        kongregate = api;
		// Connect to the back-end.
        kongregate.services.connect();
#end

		
		var backgroundSprite : FlxSprite = new FlxSprite();
		backgroundSprite.makeGraphic(FlxG.width, FlxG.height);
		backgroundSprite.color = FlxColor.fromRGB(132,126,135);
		add(backgroundSprite);
		
		var title : FlxSprite = new FlxSprite();
		title.loadGraphic(AssetPaths.thylstale__png, true, 166, 43);
		title.animation.add("idle", [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 1, 2, 3, 4, 5, 6, 7, 8], 10);
		title.animation.play("idle");
		title.scale.set(3.5,3.5);
		title.screenCenter(FlxAxes.X);
		title.y = 75;
		title.offset.set(0, 150);
		add(title);
		FlxTween.tween(title.offset, { y:0 }, 0.5, {ease : FlxEase.bounceOut, startDelay: 0.2});
		
		
		
		var t1 : FlxText = new FlxText (100, 250, 500, "" , 14);
		t1.text += Controls;
		//t1.text += "Last Score: " + Std.string(LastScore) + "    HighScore: " + Std.string(HighScore);
		t1.color = FlxColor.BLACK;
		add(t1);
		t1.offset.set(950,0);
		FlxTween.tween(t1.offset, { x:0 }, 0.5, { ease : FlxEase.bounceOut, startDelay: 0.55 } );
		
		
		
		var t2 : FlxText = new FlxText (20, 300, 600, "", 10);
		t2.text = "created by " + Authors + " for " + MyJam + "\n";
		t2.text += MyDate + "\n"; 
		t2.text += "visit us at https://runvs.io";
		t2.y = FlxG.height - t2.height - 20;
		t2.color = FlxColor.fromRGB(69,40,60);
		add(t2);
		t2.offset.set(0, -100);
		FlxTween.tween(t2.offset, { y:0 }, 0.5, { ease : FlxEase.bounceOut, startDelay: 1.0 } );
		
		vignette = new Vignette(FlxG.camera);
		add(vignette);
		
		
		overlay = new FlxSprite(0, 0);
		overlay.makeGraphic(FlxG.width, FlxG.height);
		overlay.color = FlxColor.BLACK;
		add(overlay);
		
		overlayTween = FlxTween.tween(overlay, { alpha :0 }, 0.3);

#if(flash)
		MenuState.kongregate.stats.submit("initialized", 1);
    });
#end		



	//var vals : Array<Float> = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.7, 0.9, 1.1, 1.5, 9.5, 9.7];
	//
	//for (v in vals)
	//{
		//trace(v + " " + MathExtender.castToHalfSteps(v));
	//}

		
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed : Float):Void
	{	
		MyInput.update();
		super.update(elapsed );
		age += elapsed;
		if (age > 0.5)
		{
			if (MyInput.AnyButtonJustPressed)
			{
				StartGame();
			}
		}
	}	
	
	function StartGame():Void 
	{
		if (!started)
		{
			started = true;
			overlayTween.cancel();
			overlayTween = FlxTween.tween(overlay, { alpha : 1 }, 0.5, { onComplete: function (t) {FlxG.switchState(new PlayState());} } );
		}
	}
}