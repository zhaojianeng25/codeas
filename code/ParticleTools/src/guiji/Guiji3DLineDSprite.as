package guiji
{
	import _Pan3D.base.Object3D;
	import _Pan3D.lineTri.LineTri3DSprite;
	
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Guiji3DLineDSprite extends LineTri3DSprite
	{
		public function Guiji3DLineDSprite(context:Context3D)
		{
			super(context);
		}
		override public function setLineData(obj:Object=null):void
		{
			clear();
			var pointeArr:Array=new Array;
			if(obj.PointArr){
				for(var i:int=0;i<obj.PointArr.length;i++)
				{
					var object3D:Object3D=obj.PointArr[i];
					pointeArr.push(new Vector3D(object3D.x,object3D.y,object3D.z))
				}
			}
			drawLinkLine(pointeArr);
			uplodToGpu();
		}
		private function drawLinkLine(arr:Array):void
		{

			for(var i:int=0;i<arr.length-1;i++)
			{
				makeLineMode(Vector3D(arr[i]),Vector3D(arr[i+1]),1,colorVector3d)
			}
		}
			
		
	}
}