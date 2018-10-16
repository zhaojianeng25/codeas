package _Pan3D.display3D.modelLine
{
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	
	import PanV2.xyzmove.lineTriV2.LineTri3DSprite;
	
	public class ModelBoxSprite extends  LineTri3DSprite
	{
		public function ModelBoxSprite(context:Context3D)
		{
			super(context);
		}
		public function makeBoxLineObjData( $minPos:Vector3D, $maxPos:Vector3D):void
		{
		
			var a:Vector3D=new Vector3D($minPos.x,$minPos.y,$minPos.z)
			var b:Vector3D=new Vector3D($minPos.x+($maxPos.x-$minPos.x),$minPos.y,$minPos.z)
			var c:Vector3D=new Vector3D($minPos.x+($maxPos.x-$minPos.x),$minPos.y+($maxPos.y-$minPos.y),$minPos.z)
			var d:Vector3D=new Vector3D($minPos.x,$minPos.y+($maxPos.y-$minPos.y),$minPos.z)
			
			
			var a1:Vector3D=new Vector3D($minPos.x,$minPos.y,$minPos.z+($maxPos.z-$minPos.z))
			var b1:Vector3D=new Vector3D($minPos.x+($maxPos.x-$minPos.x),$minPos.y,$minPos.z+($maxPos.z-$minPos.z))
			var c1:Vector3D=new Vector3D($minPos.x+($maxPos.x-$minPos.x),$minPos.y+($maxPos.y-$minPos.y),$minPos.z+($maxPos.z-$minPos.z))
			var d1:Vector3D=new Vector3D($minPos.x,$minPos.y+($maxPos.y-$minPos.y),$minPos.z+($maxPos.z-$minPos.z))
			
			
			this.clear()
			this.thickness=0.2
			this.makeLineMode(a,b)
			this.makeLineMode(b,c)
			this.makeLineMode(c,d)
			this.makeLineMode(d,a)
			
			this.makeLineMode(a1,b1)
			this.makeLineMode(b1,c1)
			this.makeLineMode(c1,d1)
			this.makeLineMode(d1,a1)
			
			
			this.makeLineMode(a,a1)
			this.makeLineMode(b,b1)
			this.makeLineMode(c,c1)
			this.makeLineMode(d,d1)
			
			
			this.reSetUplodToGpu()
			
			return ;
			
		}
	}
}