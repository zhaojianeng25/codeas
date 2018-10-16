package modules.roles
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import common.AppData;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	import roles.RoleStaticMesh;

	public class RoleManager
	{
		private static var instance:RoleManager;
		public function RoleManager()
		{
		}
		public static function getInstance():RoleManager{
			if(!instance){
				instance = new RoleManager();
			}
			return instance;
		}
		public function objToMesh($obj:Object):RoleStaticMesh
		{
			var $roleStaticMesh:RoleStaticMesh=new RoleStaticMesh
			$roleStaticMesh.url=$obj.url
			return $roleStaticMesh
		}
		public var listArr:ArrayCollection
		public function addRoleModel($id:uint,$url:String):HierarchyFileNode
		{
			var $file:File=new File($url)
			if($file.exists){
				var $roleStaticMesh:RoleStaticMesh=new RoleStaticMesh;
				$roleStaticMesh.url=$url.replace(AppData.workSpaceUrl,"")
				var $imode:IModel=Render.creatRole($roleStaticMesh)
					
				var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
				$hierarchyFileNode.id=$id
				$hierarchyFileNode.name=$file.name.replace(("."+$file.extension),"")
				$hierarchyFileNode.iModel=$imode;
				$hierarchyFileNode.type=HierarchyNodeType.Role
				$hierarchyFileNode.data=$roleStaticMesh;
				listArr.addItem($hierarchyFileNode)
				
				return $hierarchyFileNode
			}
			return null
		}
	}
}


