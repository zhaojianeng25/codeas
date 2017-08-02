package proxy.pan3d.capture
{
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.capture.Display3DCaptureSprite;
	import _Pan3D.scene.SceneContext;
	
	import capture.CaptureStaticMesh;
	
	import pack.Prefab;
	
	import proxy.top.model.ICapture;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3dCapture implements ICapture
	{
		public var sprite:Display3DCaptureSprite
		private var _captureMesh:CaptureStaticMesh
		public function ProxyPan3dCapture()
		{
		}
		
		public function get captureMesh():CaptureStaticMesh
		{
			return _captureMesh;
		}
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function set captureMesh(value:CaptureStaticMesh):void
		{
			_captureMesh = value;
		}

		public function set uid(value:String):void
		{
		}
		
		public function get uid():String
		{
			return null;
		}
		
		public function set x(value:Number):void
		{
			sprite.x=value
		}
		
		public function get x():Number
		{
			return sprite.x;
		}
		
		public function set y(value:Number):void
		{
			sprite.y=value
		}
		
		public function get y():Number
		{
			return sprite.y;
		}
		
		public function set z(value:Number):void
		{
			sprite.z=value
		}
		
		public function get z():Number
		{
			return sprite.z;
		}
		
		public function set rotationX(value:Number):void
		{
		}
		
		public function get rotationX():Number
		{
			return 0;
		}
		
		public function set rotationY(value:Number):void
		{
		}
		
		public function get rotationY():Number
		{
			return 0;
		}
		
		public function set rotationZ(value:Number):void
		{
		}
		
		public function get rotationZ():Number
		{
			return 0
		}
		
		public function set scaleX(value:Number):void
		{
			sprite.scale_x=value
		}
		
		public function get scaleX():Number
		{
			return sprite.scale_x;
		}
		
		public function set scaleY(value:Number):void
		{
			sprite.scale_y=value
		}
		
		public function get scaleY():Number
		{
			return sprite.scale_y;
		}
		
		public function set scaleZ(value:Number):void
		{
			sprite.scale_z=value
		}
		
		public function get scaleZ():Number
		{
			return sprite.scale_z;
		}
		
		public function get readObject():Object
		{
			return null;
		}
		
		public function dele():void
		{
		}
		
		public function set prefab($prefab:Prefab):void
		{
		}
		
		public function set select(value:Boolean):void
		{
		}
		
		public function get select():Boolean
		{
			return false;
		}
		
		public function set visible(value:Boolean):void
		{
			sprite.visible=value
		}
		
		public function get visible():Boolean
		{
			return sprite.visible;
		}
		
		public function addStage():void
		{
		}
		
		public function removeStage():void
		{
		}
		
		public function reset():void
		{
			var $pos:Vector3D=new Vector3D(sprite.x,sprite.y,sprite.z)
			var $rect:Rectangle=new Rectangle(0,0,_captureMesh.textureSize,_captureMesh.textureSize);
			_captureMesh.cubeTextureBmp=SceneContext.scanCaptureLookAtBmp($pos,$rect,_captureMesh.textureSize)
			sprite.cubeTextureBmp=_captureMesh.cubeTextureBmp
				
				
			
		}
	}
}