package modules.hierarchy
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import pack.BuildMesh;
	
	import proxy.top.model.IModel;

	public class GroupMaterialMath
	{
		private static var instance:GroupMaterialMath;
		public function GroupMaterialMath()
		{
		}
		public static function getInstance():GroupMaterialMath{
			if(!instance){
				instance = new GroupMaterialMath();
			}
			return instance;
		}

	    public function conutMaterialArr($childItem:ArrayCollection,item:Object):void
		{
			var $materialItem:Dictionary=new Dictionary
			var $hierarchyFileNode:HierarchyFileNode;
			var $BuildMesh:BuildMesh;
			for(var i:uint=0;i<	item.length;i++){
				 $hierarchyFileNode=findfileNodeFromListByImodel($childItem,item[i])
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
					$BuildMesh=BuildMesh($hierarchyFileNode.data);
					if(!Boolean($BuildMesh.prefabStaticMesh.material)){
						Alert.show("没有材质"+$hierarchyFileNode.name)
					}
					if($materialItem.hasOwnProperty($BuildMesh.prefabStaticMesh.materialUrl)){
						$materialItem[$BuildMesh.prefabStaticMesh.materialUrl]=Math.min(Number($materialItem[$BuildMesh.prefabStaticMesh.materialUrl]),$hierarchyFileNode.id);
					}else{
						$materialItem[$BuildMesh.prefabStaticMesh.materialUrl]=$hierarchyFileNode.id;
					}
				}
			}

			
			for(var j:uint=0;j<	item.length;j++){
				$hierarchyFileNode=findfileNodeFromListByImodel($childItem,item[j])
				if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
					$BuildMesh=BuildMesh($hierarchyFileNode.data);
					$BuildMesh.groupMaterialId=$materialItem[$BuildMesh.prefabStaticMesh.materialUrl];
					
					
				}
			}
			
	

		
		}
		public function cancelMerge($childItem:ArrayCollection):void
		{	
			if($childItem&&$childItem.length){
				for(var i:uint=0;$childItem&&i<$childItem.length;i++){
					var $hierarchyFileNode:HierarchyFileNode=$childItem[i] as HierarchyFileNode
					if($hierarchyFileNode.type==HierarchyNodeType.Prefab){
						var $BuildMesh:BuildMesh=BuildMesh($hierarchyFileNode.data);
						$BuildMesh.groupMaterialId=$hierarchyFileNode.id
							
						trace($hierarchyFileNode.name,$BuildMesh.groupMaterialId)
					}
					cancelMerge($hierarchyFileNode.children)
				}
			
			}
		
			
		
		}
		
		
		
		private function findfileNodeFromListByImodel($childItem:ArrayCollection,$iModel:IModel):HierarchyFileNode{
			for(var i:uint=0;$childItem&&i<$childItem.length;i++){
				var $hierarchyFileNode:HierarchyFileNode=$childItem[i] as HierarchyFileNode
				if($hierarchyFileNode.iModel==$iModel){
					return $hierarchyFileNode
				}
				var $childFileNode:HierarchyFileNode=findfileNodeFromListByImodel($hierarchyFileNode.children,$iModel)
				if($childFileNode){
					return $childFileNode
				}
			}
			return null
		}
	}
}