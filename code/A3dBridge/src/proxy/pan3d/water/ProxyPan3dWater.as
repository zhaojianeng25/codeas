package proxy.pan3d.water
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.water.Display3DWaterSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.scene.SceneContext;
	
	import light.ReflectionTextureVo;
	
	import materials.MaterialTree;
	
	import pack.Prefab;
	
	import proxy.top.model.IWater;
	
	import textures.TextureBaseVo;
	
	import water.WaterStaticMesh;
	
	public class ProxyPan3dWater implements IWater
	{
		
		public var sprite:Display3DWaterSprite
		private var _waterMesh:WaterStaticMesh
		public function ProxyPan3dWater()
		{
		}
		
		public function get waterMesh():WaterStaticMesh
		{
			return _waterMesh;
		}

		public function set waterMesh(value:WaterStaticMesh):void
		{
			_waterMesh = value;
			_waterMesh.addEventListener(Event.CHANGE,onChange);
			if(_waterMesh.material){
				Program3DManager.getInstance().regMaterial(_waterMesh.material as MaterialTree);
			}
			
			onChange();
		}
		
		protected function onChange(event:Event=null):void
		{
			if(_waterMesh.material){
				Program3DManager.getInstance().regMaterial(_waterMesh.material as MaterialTree);
				sprite.material  = _waterMesh.material as MaterialTree;
			}
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
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set rotationZ(value:Number):void
		{
			
			
		}
		
		public function get rotationZ():Number
		{
			return 0;
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
			// TODO Auto Generated method stub
			return sprite.y;
		}
		
		public function set z(value:Number):void
		{
			sprite.z=value

			
		}
		
		public function get z():Number
		{
			// TODO Auto Generated method stub
			return sprite.z;
		}
		
		public function set scaleX(value:Number):void
		{
			sprite.scale_x=value

			
		}
		
		public function get scaleX():Number
		{
			// TODO Auto Generated method stub
			return sprite.scale_x;
		}
		
		public function set scaleY(value:Number):void
		{

			
		}
		
		public function get scaleY():Number
		{
			// TODO Auto Generated method stub
			return 1
		}
		
		public function set scaleZ(value:Number):void
		{
	
			sprite.scale_z=value

			
		}
		
		public function get scaleZ():Number
		{
			// TODO Auto Generated method stub
			return sprite.scale_z
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
		
		public function addStage():void
		{
		}
		
		public function removeStage():void
		{
		}
		
		public function reset():void
		{

			var $pos:Vector3D=new Vector3D(sprite.x,sprite.y,sprite.z)
			$pos.w=_waterMesh.depht//扫描深度
			var $rect:Rectangle=new Rectangle(0,0,200,200);
			$rect.width=sprite.scale_x*100
			$rect.height=sprite.scale_z*100
			

			var $w:uint=Math.pow(2,Math.ceil(Math.log(_waterMesh.textureSize)/Math.log(2)))
			_waterMesh.dephtBmp=SceneContext.scanGroundAndBuildHightMap($pos,$rect,Math.max($w,64))
			sprite.dephtBmp=_waterMesh.dephtBmp
			
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
		
		public function set visible(value:Boolean):void
		{
			sprite.visible=value
			
		}
		
		public function get visible():Boolean
		{
			// TODO Auto Generated method stub
			return sprite.visible;
		}
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void
		{
			sprite.setEnvCubeMap($textVo)
				
			
		}
		public function set reflectionTextureVo(value:ReflectionTextureVo):void
		{
			sprite.reflectionTextureVo=value
			
		}
		
		
		public function get reflectionTextureVo():ReflectionTextureVo
		{
			// TODO Auto Generated method stub
			return sprite.reflectionTextureVo;
		}
		
	}
}