package _Pan3D.lineTri
{
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Vector3D;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class LineGrldSprite extends LineTri3DSprite
	{
		public function LineGrldSprite(context:Context3D)
		{
			super(context);
		}
		override public function update() : void {
			if (!this._visible) {
				return;
			}
			if (_objData && _objData.indexBuffer) {
				_context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				_context.setProgram(this.program);
			
				setVc();
				setVa();
				resetVa();
			}
		}

		override public function resetStage():void
		{
			_context=Scene_data.context3D;

			uplodToGpu();
		}
		override public function setLineData(obj:Object=null):void
		{
			thickness=1;
			colorVector3d=new Vector3D(1,0,0,0.5)
			var w:Number=1000;
			var n:Number=10;
			var skeep:Number=w/n;
			clear();
			var a:Vector3D;
			var b:Vector3D;
			a=new Vector3D(0,0,+w);
			b=new Vector3D(0,0,-w);
			makeLineMode(a,b,1,new Vector3D(0,0,1,1))
			a=new Vector3D(+w,0,0);
			b=new Vector3D(-w,0,0);
			makeLineMode(a,b,1,new Vector3D(1,0,0,1))
			thickness=0.5;
			colorVector3d=new Vector3D(0.5,0.5,0.5,1)
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