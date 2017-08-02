package  xyz.draw
{
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	
	public class TooRotationLevel extends TooUtilDisplay
	{
		
		private var _xSprite:TooRotationDisplay3DSprite
		private var _ySprite:TooRotationDisplay3DSprite
		private var _zSprite:TooRotationDisplay3DSprite
		public function TooRotationLevel(context:Context3D)
		{
			super(context);
			initData();
		}
		public function get rotationTpey():String
		{
			return _rotationTpey;
		}
		private function initData():void
		{
			_xSprite=new TooRotationDisplay3DSprite(_context3D)
			_ySprite=new TooRotationDisplay3DSprite(_context3D)
			_zSprite=new TooRotationDisplay3DSprite(_context3D)
				
			selectAxis("")

		}
		override public function update() : void {
			
			_xSprite.posMatrix=this.posMatrix.clone()
			_xSprite.update()
				
			_ySprite.posMatrix=this.posMatrix.clone()
			_ySprite.posMatrix.prependRotation(90,Vector3D.Z_AXIS)
			_ySprite.update()
				
			_zSprite.posMatrix=this.posMatrix.clone()
			_zSprite.posMatrix.prependRotation(90,Vector3D.Y_AXIS)
			_zSprite.update()
				

		
		}
		public function get spriteItem():Vector.<TooUtilDisplay>
		{
			var arr:Vector.<TooUtilDisplay>=new Vector.<TooUtilDisplay>
			arr.push(_xSprite)
			arr.push(_ySprite)
			arr.push(_zSprite)
			return arr
		}

		public function selectModelId($id:uint):void
		{
			if($id==0){
				selectAxis("x")
			}else
			if($id==1){
				selectAxis("y")
			}else
			if($id==2){
				selectAxis("z")
			}else
			{
				selectAxis("")
			}
			
		}
		private var _rotationTpey:String=""
		private  function selectAxis($temp:String):void
		{
			_rotationTpey=$temp
			_xSprite.colorV3d=new Vector3D(0.8,0,0,1);
			_ySprite.colorV3d=new Vector3D(0,0.8,0,1);
			_zSprite.colorV3d=new Vector3D(0,0,0.8,1);
			switch($temp)
			{
				case "x":
				{
					_xSprite.colorV3d=new Vector3D(1,0,0,1);
					break;
				}
					
				case "y":
				{
					_ySprite.colorV3d=new Vector3D(0,1,0,1);
					break;
				}
					
				case "z":
				{
					_zSprite.colorV3d=new Vector3D(0,0,1,1);
					break;
				}
					
				default:
				{
					break;
				}
			}

		}

		
	}
}


