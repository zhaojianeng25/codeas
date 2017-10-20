package proxy.pan3d.roles
{
	import flash.utils.ByteArray;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.utils.editorutils.Display3DEditorMovie;
	import _Pan3D.utils.editorutils.RoleLoadUtils;
	
	import _me.Scene_data;
	
	import pack.Prefab;
	
	import proxy.top.model.IModel;
	
	import roles.RoleStaticMesh;
	
	import textures.TextureBaseVo;
	
	public class ProxyPan3DRole implements IModel
	{
		public var sprite:Display3DEditorMovie;
		
		private var _roleStaticMesh:RoleStaticMesh
		public function ProxyPan3DRole()
		{
		}
		
		public function get roleStaticMesh():RoleStaticMesh
		{
			return _roleStaticMesh;
		}

		public function set roleStaticMesh(value:RoleStaticMesh):void
		{
			_roleStaticMesh = value;
			
			var loaderinfo : LoadInfo = new LoadInfo(Scene_data.fileRoot+_roleStaticMesh.url, LoadInfo.BYTE, onObjByteLoad,10);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			function onObjByteLoad(byte:ByteArray):void{
				
				var roleData:Object = byte.readObject();
				var meshAry:Array = new Array;
				
				for(var i:int;i<roleData.mesh.length;i++){
					var children:Object = roleData.mesh[i].children;
					for(var j:int=0;j<children.length;j++){
						meshAry.push(children[j]);
					}
				}
				
				var obj:Object = new Object;
				obj.bone = roleData.bone;
				obj.mesh = meshAry;
				obj.socket = roleData.socket;
				
				new RoleLoadUtils(obj).setRoleData(sprite,obj)
				
				sprite.name ="ccav";

				if(sprite.fileScale==1.001){
					sprite.fileScale = roleData.scale;
				}
	
				sprite.play("stand");
				sprite.updatePosMatrix();
			
			}
			
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
			return 	sprite.x;
		}
		
		public function set y(value:Number):void
		{
			sprite.y=value
		}
		
		public function get y():Number
		{
			return 	sprite.y;
		}
		
		public function set z(value:Number):void
		{
			sprite.z=value
		}
		
		public function get z():Number
		{
			return 	sprite.z;
		}
		
		public function set rotationX(value:Number):void
		{
			sprite.rotationX=value
		}
		
		public function get rotationX():Number
		{
			return 	sprite.rotationX;
		}
		
		public function set rotationY(value:Number):void
		{
			sprite.rotationY=value
		}
		
		public function get rotationY():Number
		{
			return 	sprite.rotationY;
		}
		
		public function set rotationZ(value:Number):void
		{
			sprite.rotationZ=value
		}
		
		public function get rotationZ():Number
		{
			return 	sprite.rotationZ;
		}
		
		public function set scaleX(value:Number):void
		{
		
		}
		
		public function get scaleX():Number
		{
			return sprite.fileScale;
		}
		
		public function set scaleY(value:Number):void
		{

		}
		
		public function get scaleY():Number
		{
			return sprite.fileScale;
		}
		
		public function set scaleZ(value:Number):void
		{
	
		}
		
		public function get scaleZ():Number
		{
			return sprite.fileScale;
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