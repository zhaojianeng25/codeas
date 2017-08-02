package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeFresnel extends NodeTree
	{
		public function NodeTreeFresnel()
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