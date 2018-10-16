package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeMin extends NodeTree
	{
		public var value:Number = 0;
		public function NodeTreeMin()
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