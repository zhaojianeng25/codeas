package modules.materials.treedata.nodetype
{
	import flash.geom.Vector3D;
	
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeVec3 extends NodeTree
	{
		public var constVec3:Vector3D = new Vector3D;
		public function NodeTreeVec3()
		{
			super();
			this.canDynamic = true;
		}
		
		override public function getComponentID($id:int):String{
			if($id == 0){
				return  CompileOne.FC + NodeTree.getID(this.regResultConst.id) + ".xyz";
			}else if($id == 1){
				return  CompileOne.FC + NodeTree.getID(this.regResultConst.id) + ".w";
			}else if($id == 2){
				return  CompileOne.FC + NodeTree.getID(this.regResultConst.id);
			}
			return null;
		}
		
//		private function getID():String{
//			return "[" + this.regResultConst.id + "]"
//		}
	}
}