package _Pan3D.light
{
	import flash.geom.Vector3D;

	public class Light
	{
		public static const AMBIENT:String = "Ambient";
		
		public static const POINT:String = "Point";
		
		public static const DIRECTIONAL:String = "Directional";
		
		public var type:String;
		
		public var color:Vector3D;
		
		public var intensity:Number;
		
		private var _dircet:Vector3D;
		
		public var radius:Number;
		

		
		public function Light($type:String=null,$color:Vector3D=null,$intensity:Number=1)
		{
			this.type = $type;
			this.color = $color;
			this.intensity = $intensity;
		}
		
		public function get dircet():Vector3D
		{
			return _dircet;
		}

		public function set dircet(value:Vector3D):void
		{
			_dircet = value;
		}

		public function readObject():Object{
			var obj:Object = new Object;
			obj.type = type;
			obj.color = {x:color.x,y:color.y,z:color.z};
			obj.intensity = intensity;
			if(dircet){
				obj.dircet = {x:dircet.x,y:dircet.y,z:dircet.z};
			}
		
			obj.radius = radius;
			return obj;
		}
		
		public function writeObject(obj:Object):void{
			type = obj.type;
			color = new Vector3D(obj.color.x,obj.color.y,obj.color.z);
			intensity = obj.intensity;
			if(obj.dircet){
				dircet = new Vector3D(obj.dircet.x,obj.dircet.y,obj.dircet.z);
				
			}else{
				dircet=new Vector3D(0,1,0);
			}
			radius = obj.radius;
		}
		
	}
}