package proxy.pan3d.grass
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.grass.GrassEditorDisplay3DSprite;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import grass.GrassStaticMesh;
	
	import materials.MaterialTree;
	
	import pack.Prefab;
	
	import proxy.top.grass.IGrass;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3dGrass implements IGrass
	{
		
		public var sprite:GrassEditorDisplay3DSprite;
		private var _grassMesh:GrassStaticMesh
		public function ProxyPan3dGrass()
		{
		}
		public function get grassMesh():GrassStaticMesh
		{
			return _grassMesh;
		}

		public function set grassMesh(value:GrassStaticMesh):void
		{
			_grassMesh = value;
			_grassMesh.addEventListener(Event.CHANGE,onChange);
			if(_grassMesh.material){
				Program3DManager.getInstance().regMaterial(_grassMesh.material as MaterialTree);
			}
		}
		
		protected function onChange(event:Event):void
		{

			GrassEditorDisplay3DSprite(sprite).faceAtlook=_grassMesh.faceAtlook
			if(_grassMesh.material){
				Program3DManager.getInstance().regMaterial(_grassMesh.material as MaterialTree);
				GrassEditorDisplay3DSprite(sprite).material  = _grassMesh.material as MaterialTree;
			}
			if(_grassMesh.modeUrl){
				GrassEditorDisplay3DSprite(sprite).url=Scene_data.fileRoot+_grassMesh.modeUrl
			}
			
			GrassEditorDisplay3DSprite(sprite).resetData();
			
		}
		

		public function get lastQuadPos():Vector3D
		{
			return sprite.lastQuadPos;
		}
	
		public function listGrassQuad($pos:Vector3D):void
		{
			sprite.listGrassQuad($pos)
			
		}
		public function setGrassInfoItem($arr:Array):void
		{
			sprite.setGrassInfoItem($arr)
			
		}
		public function addGrassArr($arr:Array):void
		{
			sprite.addGrassArr($arr)
			
		}
		
	
		
		public function addStage():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function dele():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function set prefab($prefab:Prefab):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get readObject():Object
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function removeStage():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function reset():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function set rotationX(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get rotationX():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set rotationY(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get rotationY():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set rotationZ(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get rotationZ():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set scaleX(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get scaleX():Number
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
		public function set scaleY(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get scaleY():Number
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
		public function set scaleZ(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get scaleZ():Number
		{
			// TODO Auto Generated method stub
			return 1;
		}
		
		public function set select(value:Boolean):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get select():Boolean
		{
			// TODO Auto Generated method stub
			return false;
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
			// TODO Auto Generated method stub
			
		}
		
		public function get visible():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function set x(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get x():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set y(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get y():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function set z(value:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get z():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}