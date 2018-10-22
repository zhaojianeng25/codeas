package guiji
{
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Object3D;
	import _Pan3D.core.MathClass;
	import _Pan3D.particle.locusball.Display3DLocusBallPartilce;
	
	public class Line3DArrDisplay3DLocusBallSprite extends Line3DArrSprite
	{
		public function Line3DArrDisplay3DLocusBallSprite(context:Context3D)
		{
			super(context);
		}
		override public function setLineData(obj:Object=null):void
		{
			clear();
			var pointeArr:Array=new Array;
			if(obj.guijiLizhiVO){
				beginVector3D=Display3DLocusBallPartilce(obj.guijiLizhiVO).beginVector3D
				endVector3D=new Vector3D
			}
			
			if(obj.PointArr){
				for(var i:int=0;i<obj.PointArr.length;i++)
				{
					var object3D:Object3D=obj.PointArr[i];
					pointeArr.push(new Vector3D(object3D.x,object3D.y,object3D.z))
				}
				drawLinkLine(obj.PointArr);
				uplodToGpu();
			}
		}
		override protected function drawLinkLine(arr:Array):void
		{
			
			for(var i:int=0;i<arr.length;i++)
			{
				
				var c:Object3D=Object3D(arr[i]);
				var backA:Vector3D=MathClass.math_change_point(beginVector3D,c.angle_x,c.angle_y,c.angle_z);
				var s:Vector3D=new Vector3D(backA.x+c.x,backA.y+c.y,backA.z+c.z)

				makeLineMode(new Vector3D(c.x,c.y,c.z),s,1,new Vector3D(0,0.8,0.2,1))
		
			}
		}
	}
}