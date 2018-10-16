package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;

	public class NodeTreePaticleColor extends NodeTreeVec3
	{
		public function NodeTreePaticleColor()
		{
			super();
		}
		
		override public function getComponentID($id:int):String{
			if($id == 0){
				return  CompileOne.FT + this.regResultTemp.id + ".xyz";
			}else if($id == 1){
				return CompileOne.FT + this.regResultTemp.id + ".w";
			}else if($id == 2){
				return CompileOne.FT + this.regResultTemp.id;
			}
			return null;
		}
		
	}
}