package  PanV2.xyzmove.lineTriV2
{
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	

	
	
	public class LineGrldSprite extends LineTri3DSprite
	{
		public function LineGrldSprite($context3D:Context3D)
		{
			super($context3D);
		}
		override public function setLineData(obj:Object=null):void
		{
			clear();
			colorVector3d=new Vector3D(1,0,0,0.5)
			var w:Number=1000;
			var n:Number=10;
			var skeep:Number=w/n;
		
			var a:Vector3D;
			var b:Vector3D;
			a=new Vector3D(0,0,+w);
			b=new Vector3D(0,0,-w);
			makeLineMode(a,b,1,new Vector3D(0,0,1,1))
			a=new Vector3D(+w,0,0);
			b=new Vector3D(-w,0,0);
			makeLineMode(a,b,1,new Vector3D(1,0,0,1))

			colorVector3d=new Vector3D(1,1,1,0.5)
			for(var i:int=1;i<=n;i++)
			{
				a=new Vector3D(+i*skeep,0,+w);
				b=new Vector3D(+i*skeep,0,-w);
				makeLineMode(a,b)
				a=new Vector3D(-i*skeep,0,+w);
				b=new Vector3D(-i*skeep,0,-w);
				makeLineMode(a,b)
				
				a=new Vector3D(+w,0,+i*skeep);
				b=new Vector3D(-w,0,+i*skeep);
				makeLineMode(a,b)
				a=new Vector3D(+w,0,-i*skeep);
				b=new Vector3D(-w,0,-i*skeep);
				makeLineMode(a,b)
			}
			
			uplodToGpu();
		}
	}
}