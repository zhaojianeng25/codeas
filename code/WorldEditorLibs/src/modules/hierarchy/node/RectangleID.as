package modules.hierarchy.node
{
	import flash.geom.Rectangle;
	
	public class RectangleID extends Rectangle
	{
		public var id:int;
		public var type:int;
		public var z:Number;
		public var depth:Number;
		public var area:int;
		public function RectangleID(x:Number=0, y:Number=0, width:Number=0, height:Number=0,z:Number=0,depth:Number=0)
		{
			super(x, y, width, height);
			this.z = z;
			this.depth = depth;
			this.area = width * height;
		}
		
		public function intersectsRec(rec:RectangleID):Boolean{
			var rec1:Rectangle = new Rectangle(x,z,width,depth);
			var rec2:Rectangle = new Rectangle(rec.x,rec.z,rec.width,rec.depth);
			
			if(!rec1.intersection(rec2)){
				return false;
			}
			
			rec1 = new Rectangle(x,y,width,height);
			rec2 = new Rectangle(rec.x,rec.y,rec.width,rec.height);
			
			if(!rec1.intersection(rec2)){
				return false;
			}
			
			rec1 = new Rectangle(y,z,height,depth);
			rec2 = new Rectangle(rec.y,rec.z,rec.height,rec.depth);
			
			if(!rec1.intersection(rec2)){
				return false;
			}
			
			return true;
			
		}
		public function containsRect3D(rec:RectangleID):Boolean{
			var rec1:Rectangle = new Rectangle(x,z,width,depth);
			var rec2:Rectangle = new Rectangle(rec.x,rec.z,rec.width,rec.depth);
			
			if(!rec1.containsRect(rec2)){
				return false;
			}
			
			rec1 = new Rectangle(x,y,width,height);
			rec2 = new Rectangle(rec.x,rec.y,rec.width,rec.height);
			
			if(!rec1.containsRect(rec2)){
				return false;
			}
			
			rec1 = new Rectangle(y,z,height,depth);
			rec2 = new Rectangle(rec.y,rec.z,rec.height,rec.depth);
			
			if(!rec1.containsRect(rec2)){
				return false;
			}
			
			return true;
		}
		
	}
}