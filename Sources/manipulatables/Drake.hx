package manipulatables;
import kha.Loader;
import kha.Sprite;
import manipulatables.UseableSprite;
import manipulatables.ManipulatableSprite.OrderType;

// (mytischer) Drache
class Drake extends Director {
	public function new(px : Int, py : Int) {
		super(px, py, "Drake", Loader.the.getImage("dragon"), 240 * 2 / 3, 64 * 2);
	}
}