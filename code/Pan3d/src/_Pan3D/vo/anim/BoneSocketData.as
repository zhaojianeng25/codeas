package _Pan3D.vo.anim
{
	public class BoneSocketData
	{
		public var name:String;
		public var boneName:String;
		public var isSocket:Boolean = true;
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var rotationX:Number;
		public var rotationY:Number;
		public var rotationZ:Number;
		public var index:int;
		
		public function BoneSocketData()
		{
		}
		
		public function getObj():Object{
			var obj:Object = new Object;
			obj.name = this.name;
			obj.boneName = this.boneName;
			obj.isSocket = this.isSocket;
			obj.x = this.x;
			obj.y = this.y;
			obj.z = this.z;
			obj.rotationX = this.rotationX;
			obj.rotationY = this.rotationY;
			obj.rotationZ = this.rotationZ;
			obj.index = this.index;
			return obj;
		}
		
		public function setObj(obj:Object):void{
			this.name = obj.name;
			this.boneName = obj.boneName;
			this.isSocket = obj.isSocket;
			this.x = obj.x;
			this.y = obj.y;
			this.z = obj.z;
			this.rotationX = obj.rotationX;
			this.rotationY = obj.rotationY;
			this.rotationZ = obj.rotationZ;
			this.index = obj.index;
		}
		
		
		
		
	}
}