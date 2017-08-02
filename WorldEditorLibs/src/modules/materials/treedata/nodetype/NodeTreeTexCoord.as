package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeTexCoord extends NodeTree
	{
		public function NodeTreeTexCoord()
		{
			super();
		}
		
		override public function getComponentID($id:int):String{
			if($id == 0){
				return  CompileOne.VI + "0.xy";
			}
			return null;
		}
		
	}
}