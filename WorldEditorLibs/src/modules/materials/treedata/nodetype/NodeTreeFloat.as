package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeFloat extends NodeTree
	{
		public var constValue:Number;
		public function NodeTreeFloat()
		{
			super();
			this.canDynamic = true;
		}
		
		override public function getComponentID($id:int):String{
			if($id == 0){
				var str:String = CompileOne.FC + NodeTree.getID(this.regResultConst.id);
				if(regConstIndex == 0){
					str += ".x";
				}else if(regConstIndex == 1){
					str += ".y";
				}else if(regConstIndex == 2){
					str += ".z";
				}else if(regConstIndex == 3){
					str += ".w";
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