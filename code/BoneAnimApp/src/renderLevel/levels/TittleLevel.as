package renderLevel.levels
{
	import flash.geom.Vector3D;
	
	import _Pan3D.base.BaseLevel;
	
	import xyz.draw.TooBoxDisplay3DSprite;
	import xyz.draw.TooLineTri3DSprite;
	
	public class TittleLevel extends BaseLevel
	{
		private static var instance:TittleLevel;
		private var _tittleSprite:TooBoxDisplay3DSprite;
		private var _hitBoxSprite:TooLineTri3DSprite;
		public static function getInstance():TittleLevel{
			if(!instance){
				instance = new TittleLevel();
			}
			return instance;
		}
		public function TittleLevel()
		{
			super();
		}
		override protected function initData():void
		{
			_tittleSprite=new TooBoxDisplay3DSprite(_context3D)
			_hitBoxSprite=new TooLineTri3DSprite(_context3D)
				

		}

		
		public static var visible:Boolean=false;
	
		override public function upData():void
		{
			if(TittleLevel.visible){
				_tittleSprite.posMatrix.identity();
				_tittleSprite.posMatrix.prependTranslation(0, AppDataBone.tittleHeight, 0);
				_tittleSprite.posMatrix.prependScale(0.5,0.5,0.5);
				_tittleSprite.update()
					
					this.makeHitBoxLine();
				_hitBoxSprite.posMatrix.identity();
				_hitBoxSprite.update();
				
			}

		}
		private function  makeHitBoxLine():void
		{
			_hitBoxSprite.colorVector3d=new Vector3D(1,1,1,1)
			_hitBoxSprite.clear();
			var w:Number=AppDataBone.hitBoxPoint.x;
			var h:Number=AppDataBone.hitBoxPoint.y;
		
		
			var a:Vector3D=new Vector3D(-w,0,-w);
			var b:Vector3D=new Vector3D(w,0,-w);
			var c:Vector3D=new Vector3D(w,0,w);
			var d:Vector3D=new Vector3D(-w,0,w);
			
			var a1:Vector3D=new Vector3D(-w,h,-w);
			var b1:Vector3D=new Vector3D(w,h,-w);
			var c1:Vector3D=new Vector3D(w,h,w);
			var d1:Vector3D=new Vector3D(-w,h,w);
			
			
			_hitBoxSprite.makeLineMode(a,b);
			_hitBoxSprite.makeLineMode(b,c);
			_hitBoxSprite.makeLineMode(c,d);
			_hitBoxSprite.makeLineMode(d,a);
			
			
			_hitBoxSprite.makeLineMode(a,a1);
			_hitBoxSprite.makeLineMode(b,b1);
			_hitBoxSprite.makeLineMode(c,c1);
			_hitBoxSprite.makeLineMode(d,d1);
			
			_hitBoxSprite.makeLineMode(a1,b1);
			_hitBoxSprite.makeLineMode(b1,c1);
			_hitBoxSprite.makeLineMode(c1,d1);
			_hitBoxSprite.makeLineMode(d1,a1);

			_hitBoxSprite.reSetUplodToGpu();
				
		}
	
		
	}
}