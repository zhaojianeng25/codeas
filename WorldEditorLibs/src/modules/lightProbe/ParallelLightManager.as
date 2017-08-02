package modules.lightProbe
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import _Pan3D.core.MathCore;
	
	import _me.Scene_data;
	
	import light.ParallelLightStaticMesh;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import proxy.top.render.Render;

	public class ParallelLightManager
	{
		private static var instance:ParallelLightManager;
		public function ParallelLightManager()
		{
		}
		public static function getInstance():ParallelLightManager{
			if(!instance){
				instance = new ParallelLightManager();
			}
			return instance;
		}
		public function objToMesh($obj:Object):ParallelLightStaticMesh
		{
			var $parallelLightStaticMesh:ParallelLightStaticMesh=new ParallelLightStaticMesh
			$parallelLightStaticMesh.color=$obj.color
			$parallelLightStaticMesh.strong=$obj.strong
			$parallelLightStaticMesh.modelUrl="assets/obj/box_0.objs"


			return $parallelLightStaticMesh
	
		}
		
		public var listArr:ArrayCollection
		public function addParallelLight($id:uint):void
		{
			var $lightProbeMesh:ParallelLightStaticMesh=new ParallelLightStaticMesh
				

			$lightProbeMesh.modelUrl="assets/obj/box_0.objs";
			$lightProbeMesh.color= MathCore.argbToHex(255,255,0,1);
			$lightProbeMesh.strong=5;
			
		
			
			$lightProbeMesh.postion=Scene_data.focus3D.clone()


			var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
			$hierarchyFileNode.id=$id
			$hierarchyFileNode.name="平行光"
				
			
			$hierarchyFileNode.iModel=Render.creatParallelLight($lightProbeMesh)
			$hierarchyFileNode.type=HierarchyNodeType.ParallelLight
			$hierarchyFileNode.data=$lightProbeMesh;
			
			listArr.addItem($hierarchyFileNode)
			$lightProbeMesh.addEventListener(Event.CHANGE,onMeshChange)
		}
		
		protected function onMeshChange(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}		
		
	}
}