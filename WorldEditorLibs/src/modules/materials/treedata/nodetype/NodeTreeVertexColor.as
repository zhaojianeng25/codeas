package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;

	public class NodeTreeVertexColor extends NodeTreeVec3
	{
		public function NodeTreeVertexColor()
		{
			super();
		}
		
		override public function getComponentID($id:int):String{
			if($id == 0){
				return  CompileOne.VI + "2.xyz";
			}else if($id == 1){
				return CompileOne.VI + "2.w";
			}else if($id == 2){
				return CompileOne.VI + "2";
			}else if($id == 3){
				return CompileOne.VI + "2.x";
			}else if($id == 4){
				return CompileOne.VI + "2.y";
			}else if($id == 4){
				return CompileOne.VI + "2.z";
			}
			return null;
		}
		
		
	}
}