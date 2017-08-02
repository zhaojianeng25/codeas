package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeTime extends NodeTree
	{
		public var speed:Number = 1;
		public function NodeTreeTime()
		{
			super();
		}
		
		override public function getComponentID($id:int):String{
			if($id == 0){
				var str:String = CompileOne.FT + this.regResultTemp.id + ".x";
				return str ;
			}
			return null;
		}
	}
}