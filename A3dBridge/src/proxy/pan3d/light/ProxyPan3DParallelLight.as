package proxy.pan3d.light
{
	import flash.events.Event;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.parallel.Dispaly3DParallelLightSpreit;
	
	import light.ParallelLightStaticMesh;
	
	import pack.Prefab;
	
	import proxy.top.model.IParallelLight;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3DParallelLight implements IParallelLight
	{
		
		public var sprite:Dispaly3DParallelLightSpreit
		private var _parallelLightStaticMesh:ParallelLightStaticMesh
		public function ProxyPan3DParallelLight()
		{
		}
		
		public function get parallelLightStaticMesh():ParallelLightStaticMesh
		{
			return _parallelLightStaticMesh;
		}

		public function set parallelLightStaticMesh(value:ParallelLightStaticMesh):void
		{
			_parallelLightStaticMesh = value;
			_parallelLightStaticMesh.addEventListener(Event.CHANGE,onMeshChange)
	
		}
		
		protected function onMeshChange(event:Event):void
		{
			sprite.colorVec=MathCore.hexToArgbNum(_parallelLightStaticMesh.color)
			
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
			
			sprite.rotationX=value
		}
		
		public function get rotationX():Number
		{
			return sprite.rotationX;
		}
		
		public function set rotationY(value:Number):void
		{
			sprite.rotationY=value
			
		}
		
		public function get rotationY():Number
		{
			// TODO Auto Generated method stub
			return sprite.rotationY;
		}
		
		public function set rotationZ(value:Number):void
		{
			sprite.rotationZ=value
			
		}
		
		public function get rotationZ():Number
		{
			return sprite.rotationZ;
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
			sprite.select=value
		}
		
		public function get select():Boolean
		{
			return sprite.select;
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
		}
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void
		{
		}
	}
}