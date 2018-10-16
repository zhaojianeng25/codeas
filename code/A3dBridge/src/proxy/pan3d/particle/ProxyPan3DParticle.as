package proxy.pan3d.particle
{
	import flash.events.Event;
	
	import _Pan3D.display3D.particle.ParticleHitBoxSprite;
	import _Pan3D.particle.ctrl.CombineParticle;
	
	import pack.Prefab;
	
	import particle.ParticleStaticMesh;
	
	import proxy.top.model.IParticle;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3DParticle implements IParticle
	{
		public var particleSprite:CombineParticle
		public var sprite:ParticleHitBoxSprite;
		private var _particleStaticMesh:ParticleStaticMesh
		
		public function ProxyPan3DParticle()
		{
		}
		


		public function get particleStaticMesh():ParticleStaticMesh
		{
			return _particleStaticMesh;
		}

		public function set particleStaticMesh(value:ParticleStaticMesh):void
		{
			_particleStaticMesh = value;
			
			_particleStaticMesh.addEventListener(Event.CHANGE,onMeshChange)
		}
		
		protected function onMeshChange(event:Event):void
		{

			
			particleSprite.reset()
			
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
			particleSprite.x=value
		}
		
		public function get x():Number
		{
			return sprite.x;
		}
		
		public function set y(value:Number):void
		{
			sprite.y=value
			particleSprite.y=value
		}
		
		public function get y():Number
		{
			return sprite.y;
		}
		
		public function set z(value:Number):void
		{
			sprite.z=value
			particleSprite.z=value
		}
		
		public function get z():Number
		{
			return sprite.z;
		}
		
		public function set rotationX(value:Number):void
		{
			sprite.rotationX=value
			particleSprite.rotationX=value
		}
		
		public function get rotationX():Number
		{
			return sprite.rotationX;
		}
		
		public function set rotationY(value:Number):void
		{
			sprite.rotationY=value
			particleSprite.rotationY=value
		}
		
		public function get rotationY():Number
		{
			return sprite.rotationY;
		}
		
		public function set rotationZ(value:Number):void
		{
			sprite.rotationZ=value
			particleSprite.rotationZ=value
		}
		
		public function get rotationZ():Number
		{
			return sprite.rotationZ;
		}
		
		public function set scaleX(value:Number):void
		{
			if(value&&value!=0){
				sprite.scale_x=value	
				particleSprite.scaleX=value	
			}
			
		}
		
		public function get scaleX():Number
		{

			return sprite.scale_x;
		}
		
		public function set scaleY(value:Number):void
		{
			if(value&&value!=0){
				sprite.scale_y=value	
				particleSprite.scaleY=value	
			}
		}
		
		public function get scaleY():Number
		{
			return sprite.scale_z;
		}
		
		public function set scaleZ(value:Number):void
		{
			if(value&&value!=0){
				sprite.scale_z=value	
				particleSprite.scaleZ=value	
			}
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
		}
		
		public function get visible():Boolean
		{
			return false;
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