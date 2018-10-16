package materials
{
	import flash.geom.Vector3D;
	
	import curves.Curve;
	

	public class DynamicConstItem
	{
		public var target:ConstItem;
		public var paramName:String;
		public var indexID:int;
		private var _type:int; 
		public var curve:Curve;
		public var currentValue:Vector3D;
		
		public function DynamicConstItem()
		{
		}
		
		public function getData():Object{
			var obj:Object = new Object;
			obj.paramName = this.paramName;
			obj.indexID = this.indexID;
			obj.type = this.type;
			obj.curve = curve.getData();
			return obj;
		}
		
		public function update(t:Number):void{
			currentValue = curve.getValue(t);
			target.setDynamic(this);
		}
		
		public function updateBase():void{
			if(this.target){
				target.setDynamic(this);
			}
		}
		
		public function setData(obj:Object):void{
			this.paramName = obj.paramName;
			this.indexID = obj.indexID;
			this.type = obj.type;
			curve = new Curve;
			curve.setData(obj.curve);
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
			curve = new Curve;
			curve.type = value;
		}
		
		public function getCurve():Curve{
			return curve;
		}
		
		public function setCurve($curve:Curve):void{
			curve = $curve;
		}
		
		
		
	}
}