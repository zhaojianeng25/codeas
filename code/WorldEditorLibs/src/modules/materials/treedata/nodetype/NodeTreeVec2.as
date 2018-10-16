package modules.materials.treedata.nodetype
{
	import flash.geom.Point;
	
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeVec2 extends NodeTree
	{
		public var constValue:Point = new Point;
		public function NodeTreeVec2()
		{
			super();
			this.canDynamic = true;
		}
		
		override public function getComponentID($id:int):String{
			if($id == 0){
				var str:String = CompileOne.FC + NodeTree.getID(this.regResultConst.id);
				if(regConstIndex == 0){
					str += ".xy";
				}else if(regConstIndex == 1){
					str += ".yz";
				}else if(regConstIndex == 2){
					str += ".zw";
				}
				return str ;
			}
			return null;
		}
		
//		private function getID():String{
//			return "[" + this.regResultConst.id + "]"
//		}
		
	}
}