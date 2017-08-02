package _Pan3D.base
{
	import _Pan3D.display3D.interfaces.IClone;
	
	import flash.geom.Vector3D;

	/**
	 * 包围盒基础类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class ObjectBound
	{
		/**
		 * 最小位置信息 
		 */		
		public var minPos:Vector3D;
		/**
		 * 最大位置信息 
		 */		
		public var maxPos:Vector3D;
		
		public function ObjectBound()
		{
			
		}
		
		public function setData(minX:Number,minY:Number,minZ:Number,maxX:Number,maxY:Number,maxZ:Number):void{
			minPos = new Vector3D(minX,minY,minZ);
			maxPos = new Vector3D(maxX,maxY,maxZ);
		}
		
		
	}
}