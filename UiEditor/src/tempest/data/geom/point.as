package tempest.data.geom
{

	public class point extends Object
	{
		public var x:int;
		public var y:int;

		public function point(x:int=0, y:int=0)
		{
			this.x=x;
			this.y=y;
			return;
		} // end function

		public function equals(ept:point):Boolean
		{
			return !(ept.x != x || ept.y != y);
		}

		public function toString():String
		{
			return "x=" + this.x + ",y=" + this.y;
		} // end function

	}
}
