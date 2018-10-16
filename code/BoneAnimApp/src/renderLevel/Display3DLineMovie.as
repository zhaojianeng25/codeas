package renderLevel
{
	import _Pan3D.base.ObjectBound;
	import _Pan3D.lineTri.LineTri3DSprite;
	
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DLineMovie extends LineTri3DSprite
	{
		
		public function Display3DLineMovie(context:Context3D)
		{
			super(context);
		}
		/**
		 * 根据一个包围盒对象绘制图形 
		 * @param bounds
		 * 
		 */		
		public function draw(bounds:ObjectBound):void{
			clear();
			var newM:Matrix3D = new Matrix3D;
			newM.appendRotation(-90,Vector3D.X_AXIS);
			var max:Vector3D = newM.transformVector(bounds.maxPos);
			var min:Vector3D = newM.transformVector(bounds.minPos);
			
			var b1:Vector3D = new Vector3D(min.x,min.y,min.z);
			var b2:Vector3D = new Vector3D(max.x,min.y,min.z);
			var b3:Vector3D = new Vector3D(max.x,max.y,min.z);
			var b4:Vector3D = new Vector3D(min.x,max.y,min.z);
			
			var a1:Vector3D = new Vector3D(min.x,min.y,max.z);
			var a2:Vector3D = new Vector3D(max.x,min.y,max.z);
			var a3:Vector3D = new Vector3D(max.x,max.y,max.z);
			var a4:Vector3D = new Vector3D(min.x,max.y,max.z);
			
			makeLineMode(b1,b2,1,new Vector3D(1,1,1,1));
			makeLineMode(b2,b3,1,new Vector3D(1,1,1,1));
			makeLineMode(b3,b4,1,new Vector3D(1,1,1,1));
			makeLineMode(b4,b1,1,new Vector3D(1,1,1,1));
			
			makeLineMode(a1,a2,1,new Vector3D(1,1,1,1));
			makeLineMode(a2,a3,1,new Vector3D(1,1,1,1));
			makeLineMode(a3,a4,1,new Vector3D(1,1,1,1));
			makeLineMode(a4,a1,1,new Vector3D(1,1,1,1));
			
			makeLineMode(a1,b1,1,new Vector3D(1,1,1,1));
			makeLineMode(a2,b2,1,new Vector3D(1,1,1,1));
			makeLineMode(a3,b3,1,new Vector3D(1,1,1,1));
			makeLineMode(a4,b4,1,new Vector3D(1,1,1,1));
			
			refreshGpu();
			
		}
		/**
		 * 根据八个点的数据绘制包围盒图形 
		 * @param ary
		 * 
		 */		
		public function drawByAry(pointV3d:Vector.<Vector3D>):void{
			clear();
			
			var b1:Vector3D = pointV3d[0];
			var b2:Vector3D = pointV3d[1];
			var b3:Vector3D = pointV3d[2];
			var b4:Vector3D = pointV3d[3];
			
			var a1:Vector3D = pointV3d[4];
			var a2:Vector3D = pointV3d[5];
			var a3:Vector3D = pointV3d[6];
			var a4:Vector3D = pointV3d[7];
			
			makeLineMode(b1,b2,1,new Vector3D(1,1,1,1));
			makeLineMode(b2,b3,1,new Vector3D(1,1,1,1));
			makeLineMode(b3,b4,1,new Vector3D(1,1,1,1));
			makeLineMode(b4,b1,1,new Vector3D(1,1,1,1));
			
			makeLineMode(a1,a2,1,new Vector3D(1,1,1,1));
			makeLineMode(a2,a3,1,new Vector3D(1,1,1,1));
			makeLineMode(a3,a4,1,new Vector3D(1,1,1,1));
			makeLineMode(a4,a1,1,new Vector3D(1,1,1,1));
			
			makeLineMode(a1,b1,1,new Vector3D(1,1,1,1));
			makeLineMode(a2,b2,1,new Vector3D(1,1,1,1));
			makeLineMode(a3,b3,1,new Vector3D(1,1,1,1));
			makeLineMode(a4,b4,1,new Vector3D(1,1,1,1));
			
			refreshGpu();
			
		}
		
	}
}