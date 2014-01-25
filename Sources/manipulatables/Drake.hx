package manipulatables;
import kha.Loader;
import kha.Sprite;
import manipulatables.UseableSprite;
import manipulatables.ManipulatableSprite.OrderType;

// (mytischer) Drache
class Drake extends Sprite implements ManipulatableSprite {
	public function new(px : Int, py : Int) {
		super(Loader.the.getImage("pizza_pixel"));
		x = px;
		y = py;
	}
	
	/* INTERFACE manipulatables.ManipulatableSprite */
	
	function get_name():String 
	{
		return "Drake";
	}
	
	public var name(get_name, null):String;
	
	public function getOrder(selectedItem:UseableSprite) : OrderType 
	{
		if (Std.is(selectedItem, Sword)) {
			return OrderType.Slay;
		}
		return OrderType.WontWork;
	}
	
	public function executeOrder(order:OrderType):Void 
	{
		if (order == OrderType.Slay) {
			// TODO: Slay Dragon
		}
	}
}