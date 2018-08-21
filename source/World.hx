package;

/**
 * ...
 * @author 
 */
class World
{

	var allLevels : Map<String,  TiledLevel>;

	public function new(_state : PlayState) 
	{
		var filenames :Array<String> = FileList.getFileList("assets/data/", ".tmx");
		allLevels = new Map<String, TiledLevel>( );
		var count : Int = 0;
		for (fi in filenames)
		{
			var f : String = fi; 
			
			var short = StringTools.replace(f, "assets/data/", "").toLowerCase();
			
			//trace(f);
			
			var lv : TiledLevel = new TiledLevel(f, _state);
			
			allLevels.set(short, lv);
			count++;
		}
		
		trace("World has been initialized with N=" + Std.string(count) + " levels.");
	}
	
	public function getLevelByName (name : String) : TiledLevel
	{
		return allLevels.get(name);
	}
	
	
}