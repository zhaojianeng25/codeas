package vo
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class H5UIFileNode extends AlighNode
	{
		public var sprite:InfoDataSprite
		public var type:uint=0;
		public var rect9:Rectangle;
		public var rowColumn:Point;
		public var modelType:uint=0
		private var _select:Boolean;
		public function H5UIFileNode()
		{
			super();
		}

		public function get select():Boolean
		{
			return _select;
		}

		public function set select(value:Boolean):void
		{
			_select = value;
		}
		public function clone(): H5UIFileNode
		{
			var $temp:H5UIFileNode=new H5UIFileNode;
			$temp.rect=this.rect.clone()
			$temp.type=this.type;
			if(this.rect9){
				$temp.rect9=this.rect9.clone()
			}
			if(this.rowColumn){
				$temp.rowColumn=this.rowColumn.clone()
			}
			return $temp;
			
		
		}

	}
}