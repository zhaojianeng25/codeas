package proxy.pan3d.light
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.light.Display3DLightSprite;
	
	import light.LightStaticMesh;
	
	import pack.Prefab;
	
	import proxy.top.model.ILight;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3dLight implements ILight
	{
		
		public var sprite:Display3DLightSprite;
		private var _lightMesh:LightStaticMesh
		public function ProxyPan3dLight()
		{
		}
		
		public function set visible(value:Boolean):void
		{
			sprite.visible=value
			
		}
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void
		{
			// TODO Auto Generated method stub
			
		}
		
		
		public function get visible():Boolean
		{
			// TODO Auto Generated method stub
			return sprite.visible;
		}
		
		
		public function get lightMesh():LightStaticMesh
		{
			return _lightMesh;
		}

		public function set lightMesh(value:LightStaticMesh):void
		{
			_lightMesh = value;
			sprite.distance=_lightMesh.distance
			sprite.colorVec=MathCore.hexToArgbNum(_lightMesh.color)
			lightMesh.addEventListener(Event.CHANGE,onMeshChange)
		}
		
		protected function onMeshChange(event:Event):void
		{
			sprite.distance=_lightMesh.distance
			sprite.colorVec=MathCore.hexToArgbNum(_lightMesh.color)
		
		}
		
		public function set distance(value:Number):void
		{
			sprite.distance=value
			_lightMesh.distance=value
				
		}
		
		public function get distance():Number
		{
			return _lightMesh.distance;
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
			return 0;
		}
		
		public function set scaleX(value:Number):void
		{
			sprite.scale_x=value
		}
		
		public function get scaleX():Number
		{
			return  sprite.scale_x;
		}
		
		public function set scaleY(value:Number):void
		{
			sprite.scale_y=value
		}
		
		public function get scaleY():Number
		{
			return  sprite.scale_y;
		}
		
		public function set scaleZ(value:Number):void
		{
			sprite.scale_z=value
		}
		
		public function get scaleZ():Number
		{
			return sprite.scale_z;
		}
		
		public function set prefab($prefab:Prefab):void
		{
		}
		
		public function set select(value:Boolean):void
		{
			sprite.select=value;
			
	
		}
		
		public function get select():Boolean
		{
			return sprite.select;
		}
		
		public function addStage():void
		{
		}
		
		public function removeStage():void
		{
		}
		
		public function get readObject():Object
		{
			
			return _lightMesh.readObject()

			return null;
		}
		
		public function dele():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function reset():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function set uid(value:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get uid():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
	}
}