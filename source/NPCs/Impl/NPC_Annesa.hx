package;

/**
 * ...
 * @author 
 */
class NPC_Annesa extends NPC
{

	
	public function new(s:PlayState) 
	{
		super(s);
		this.loadGraphic(AssetPaths.Annesa__png, true, 16, 16);
		animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 2], 7); 
		animation.add("walk_south", [0, 1, 2, 3], 8);
		animation.add("walk_north", [4, 5, 6, 7], 8);
		animation.add("walk_east", [8, 9, 10, 11], 8);
		animation.add("walk_west", [12, 13, 14, 15], 8);
		this.animation.play("idle");
		
		this.objectName = "annesa";
	}
	
}