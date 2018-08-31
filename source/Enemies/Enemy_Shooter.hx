package;
import flixel.FlxG;
import flixel.math.FlxVector;

/**
 * ...
 * @author 
 */
class Enemy_Shooter extends Enemy
{

	private var _thinkTime    : Float = 0;
	private var _playerLocked : Bool = false;
	
	private var _aggroRangeInTiles : Float = 6.0;
	
	private static var _normalRandomWalkSpeed : Float = 58;
	private static var _normalDrag : Float  = 250;
	private var _distanceToPlayer : Float = 0;
	
	private var _walkBetweenShootTime : Float  = 0;
	
	private var _preferredDistance : Float;
	
	private var _rightGuy : Bool;
	private var _rightGuyCounter : Int = 0;
	
	private var _shootTimer : Float = 0;
	private var _animationTimer : Float = 0;
	
	
	public function new(s:PlayState) 
	{
		super(s);
		
		//this.makeGraphic(24, 12);
		this.loadGraphic(AssetPaths.mage__png, true, 16, 20);
		this.animation.add("walk_south", [0, 1, 2, 3], 8);
		this.animation.add("walk_north", [11, 12, 13, 14], 8);
		this.animation.add("walk_east", [15, 16, 17, 18], 8);
		this.animation.add("walk_west", [19, 20, 21, 22], 8);
		this.animation.add("attack", [9,8,9,8,9,10], 8,false);
		
		
		maxVelocity.set(_normalRandomWalkSpeed, _normalRandomWalkSpeed);
		drag.set(_normalDrag, _normalDrag);
		_preferredDistance = _aggroRangeInTiles - 1.5 + FlxG.random.float( -1, 1);
		_rightGuy = FlxG.random.bool();
		_rightGuyCounter = FlxG.random.int(2, 4);
		health = 10;
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		
		
		var playerVector = new FlxVector(_state.player.x + _state.player.width/2.0, _state.player.y + _state.player.height/2.0);
		var enemyVector = new FlxVector(x + width/2.0, y + height/2);
		_distanceToPlayer = playerVector.dist(enemyVector);
		var direction :FlxVector = playerVector.subtractNew(enemyVector).normalize();
		
		if (!_playerLocked)
		{
			_thinkTime -= elapsed;
			
			
			if (_thinkTime <= 0)
			{
				_thinkTime = GameProperties.EnemyMovementRandomWalkThinkTime;
				velocity.set();
					acceleration.set(
						FlxG.random.float(-1.0, 1.0) * 550,
						FlxG.random.float(-1.0, 1.0) * 550 
					);
			}
			if (_distanceToPlayer < _aggroRangeInTiles * GameProperties.TileSize)
			{
				_playerLocked = true;
				this.velocity.set();
				this.acceleration.set();
				this.animation.play("attack", false);
			}
			else
			{
				_animationTimer += elapsed;
				if (_animationTimer >= 0.7)
				{
					_animationTimer = 0;
					doAnimations();
				}
			}
			
			
		}
		else
		{
			
			// trigger: switch back to Random Walk
			if (_distanceToPlayer >= (_aggroRangeInTiles + 2) * GameProperties.TileSize)
			{
				_playerLocked = false;
			}
			
			_shootTimer -= elapsed;
			if (_shootTimer <= 0)
			{
				shoot(direction);
				this.animation.play("attack", true);
			}
			
			
			var d2 : Float = (_distanceToPlayer - _preferredDistance * GameProperties.TileSize) / GameProperties.TileSize;
			if (d2 > 0.35 ) 
			{
				// walk towards player
				this.velocity.set(
				direction.x * _normalRandomWalkSpeed * 0.9, 
				direction.y * _normalRandomWalkSpeed * 0.9);
			}
			else if (d2 < -0.35)
			{
				// walk away from player
				this.velocity.set(
				- direction.x * _normalRandomWalkSpeed * 0.75, 
				-direction.y * _normalRandomWalkSpeed * 0.75);
			}
			else
			{	
				this.acceleration.set();
				if (_rightGuy)
					this.velocity.set( -direction.x * _normalRandomWalkSpeed, 1.0 / (direction.y * _normalRandomWalkSpeed));
				else
					this.velocity.set( 1.0/(direction.x * _normalRandomWalkSpeed), -(direction.y * _normalRandomWalkSpeed));
			}
			
			
			
			
			
		}
		
	}
	
	function shoot(dir : FlxVector) 
	{
		
		_shootTimer = 0.9;
		var s : EnemyShot = new EnemyShot(x + this.width / 2.0, y + this.height / 2.0, dir.x , dir.y );
		_state.level.allEnemyShots.add(s);
		
		_rightGuyCounter--;
		//trace();
		if (_rightGuyCounter <= 0)
		{
			//trace("switch direction");
			_rightGuy = ! _rightGuy;
			_rightGuyCounter = FlxG.random.int(3, 6);
		}
	}
	
	
	
}