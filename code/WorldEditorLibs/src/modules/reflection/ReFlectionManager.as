package modules.reflection
{
	import flash.display.BitmapData;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import PanV2.TextureCreate;
	
	import _me.Scene_data;
	
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import light.ReflectionStaticMesh;
	import light.ReflectionTextureVo;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import proxy.top.model.IModel;
	import proxy.top.model.IReflection;
	import proxy.top.render.Render;

	public class ReFlectionManager
	{
		public function ReFlectionManager()
		{
		}
		public static function getInstance():ReFlectionManager{
			if(!instance){
				instance = new ReFlectionManager();
			}
			return instance;
		}
		
		public var captureDis:Dictionary=new Dictionary
		
		public function getReFlectionVoById($id:uint):ReflectionTextureVo
		{
			if(!captureDis[$id]){
				
				captureDis[$id]= new ReflectionTextureVo;
			}
			return captureDis[$id]
		}

		
		
		public var listArr:ArrayCollection
		private static var instance:ReFlectionManager;
		public function addCaptureModel($id:uint):void
		{
			var $reflectionMesh:ReflectionStaticMesh=new ReflectionStaticMesh
			$reflectionMesh.url="assets/obj/box_0.objs";
			$reflectionMesh.reFlectionMapSize=256
	
			var $imode:IModel=Render.creatReFlectionModel($reflectionMesh,$id)
			$imode.x=Scene_data.focus3D.x
			$imode.y=Scene_data.focus3D.y
			$imode.z=Scene_data.focus3D.z
				
			IReflection($imode).reflectionTextureVo=ReFlectionManager.getInstance().getReFlectionVoById($id)
				
			var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
			$hierarchyFileNode.id=$id
			$hierarchyFileNode.name="反射捕捉器"
			$hierarchyFileNode.iModel=$imode;
			$hierarchyFileNode.type=HierarchyNodeType.Reflection
			$hierarchyFileNode.data=$reflectionMesh;
			
			listArr.addItem($hierarchyFileNode)
			
			$reflectionMesh.addEventListener(Event.CHANGE,onMeshChange)
		}
		public function changeReflectionTextureVoSize($reflectionMesh:ReflectionStaticMesh):void
		{

			var $arr:Vector.<FileNode>=FileNodeManage.getListAllFileNode(listArr)
			for(var i:uint=0;i<$arr.length;i++)
			{
				if(HierarchyFileNode($arr[i]).data==$reflectionMesh){
					var $reflectionTextureVo:ReflectionTextureVo=IReflection(HierarchyFileNode($arr[i]).iModel).reflectionTextureVo
					if($reflectionTextureVo.ZeTexture){
						$reflectionTextureVo.ZeTexture.dispose()
					}
					if($reflectionTextureVo.texture){
						$reflectionTextureVo.texture.dispose()
					}
					$reflectionTextureVo.ZeTexture=TextureCreate.getInstance().bitmapToRectangleTexture(new BitmapData($reflectionMesh.reFlectionMapSize,$reflectionMesh.reFlectionMapSize,false,0x000000))
					$reflectionTextureVo.texture=TextureCreate.getInstance().bitmapToRectangleTexture(new BitmapData($reflectionMesh.reFlectionMapSize,$reflectionMesh.reFlectionMapSize,false,0x000000))
			
				}
			}
			
		}
		protected function onMeshChange(event:Event):void
		{
			changeReflectionTextureVoSize(ReflectionStaticMesh(event.target))
		}
		public function objToReflectionMesh($obj:Object):ReflectionStaticMesh
		{
			var $reflectionMesh:ReflectionStaticMesh = new ReflectionStaticMesh();
			for(var i:String in $obj) {
				$reflectionMesh[i]=$obj[i]
			}
			$reflectionMesh.addEventListener(Event.CHANGE,onMeshChange)
			return $reflectionMesh
		}
		
	
		
	}
}