package proxy.pan3d.model
{
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import spark.components.Alert;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;
	
	import pack.Prefab;
	import pack.PrefabStaticMesh;
	
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	import textures.TextureBaseVo;

	public class ProxyPan3dModel implements IModel
	{
		public var sprite:Display3DMaterialSprite;
		private var _prefab:PrefabStaticMesh;
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void
		{
			sprite.setEnvCubeMap($textVo)
			
		}
		public function getMainTexUrl():String
		{
			
			if(!sprite.material){
			    var tipstr:String="没有材质"+decodeURI(_prefab.url)
				Alert.show(tipstr)
			}

			var $fileUrl:String=sprite.material.getMainTexUrl();
			
			if(_prefab.materialInfoArr){
				for(var i:Number=0;i<_prefab.materialInfoArr.length;i++){
					var a:Object=_prefab.materialInfoArr[i]
					if(a.type==0){
						$fileUrl=a.url;
						i=_prefab.materialInfoArr.length
					}
				}
			}
			
			return $fileUrl
		}

		public function set uid(value:String):void
		{
			sprite.uid=value
			var $url:String=Render.lightUvRoot+value+".jpg"
			BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
				sprite.lightMapTexture=TextureManager.getInstance().bitmapToTexture($bitmap.bitmapData)
			},{})	
			
		}
		
		public function get uid():String
		{
			// TODO Auto Generated method stub
			return sprite.uid;
		}
		

		
		
		public function ProxyPan3dModel()
		{
		}
		

		
		public function addStage():void
		{
			
		}
		
		public function set prefab($prefab:Prefab):void
		{
			_prefab=PrefabStaticMesh($prefab)
			_prefab.addEventListener(Event.CHANGE,onChange);
			if(_prefab.material){
				Program3DManager.getInstance().regMaterial(_prefab.material as MaterialTree);
			}
			onChange();
		}
		
		protected function onChange(event:Event=null):void
		{
			sprite.url=Scene_data.fileRoot+_prefab.axoFileName;
			if(_prefab.material){
				Program3DManager.getInstance().regMaterial(_prefab.material as MaterialTree);
				Display3DMaterialSprite(sprite).material  = _prefab.material as MaterialTree;
				
				Display3DMaterialSprite(sprite).setMaterialParam(_prefab.materialInfoArr)
			}
		}
		
		public function removeStage():void 
		{
			
			
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
			sprite.scale_y=value
			
		}
		
		public function get scaleY():Number
		{
			// TODO Auto Generated method stub
			return sprite.scale_y
		}
		
		public function set scaleZ(value:Number):void
		{
			sprite.scale_z=value
			
		}
		
		public function get scaleZ():Number
		{
			// TODO Auto Generated method stub
			return sprite.scale_z;
		}
		
		public function set select(value:Boolean):void
		{
			sprite.showTriLine(value);
			
		}
		
		public function get select():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function get readObject():Object
		{
			
			if(sprite&&sprite.objData){
				//return sprite.objData
				var $obj:Object=new Object
				$obj.vertices=sprite.objData.vertices
				$obj.uvs=sprite.objData.uvs
				$obj.lightUvs=sprite.objData.lightUvs
				$obj.normals=sprite.objData.normals
				$obj.indexs=sprite.objData.indexs
				return $obj
			}
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
		
		public function set visible(value:Boolean):void
		{
			sprite.visible=value
			
		}
		
		public function get visible():Boolean
		{
			// TODO Auto Generated method stub
			return sprite.visible;
		}
		
	}
}