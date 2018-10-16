package guiji
{
	import _Pan3D.base.Object3D;
	import _Pan3D.triPoint.TriPoint3DSprite;
	
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class GuijiPoint3DSprite extends TriPoint3DSprite
	{
		public function GuijiPoint3DSprite(context:Context3D)
		{
			super(context);
		}
		override public function setLineData(obj:Object=null):void
		{
			clear();
	
			if(obj.PointArr){
				for(var i:int=0;i<obj.PointArr.length;i++)
				{
					var object3D:Object3D=obj.PointArr[i];
					makeLineMode(new Vector3D(object3D.x,object3D.y,object3D.z),(i%3)==0?3.5:2.5,(i%3)==0?new Vector3D(1,0,0,1):new Vector3D(1,1,0,1))
				}
			}

			uplodToGpu();
		}
	}
}