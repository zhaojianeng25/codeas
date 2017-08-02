package modules.collision
{
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	
	import PanV2.xyzmove.lineTriV2.LineTri3DSprite;
	
	public class CollisionGridLine extends LineTri3DSprite
	{
		public function CollisionGridLine($context3D:Context3D)
		{
			super($context3D);
		}
		override public function setLineData(obj:Object=null):void
		{
			clear();
			colorVector3d=new Vector3D(1,0,0,0.5)
			var w:Number=400;
			var n:Number=10;
			var skeep:Number=w/n;
			
		
			var a:Vector3D;
			var b:Vector3D;
			a=new Vector3D(0,0,+w);
			b=new Vector3D(0,0,-w);
			makeLineMode(a,b,0.5,new Vector3D(0,0,1,1))
			a=new Vector3D(+w,0,0);
			b=new Vector3D(-w,0,0);
			makeLineMode(a,b,0.5,new Vector3D(1,0,0,1))
	
			colorVector3d=new Vector3D(0.6,0.6,0.6,0.5)
			_thickness=0.3
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


