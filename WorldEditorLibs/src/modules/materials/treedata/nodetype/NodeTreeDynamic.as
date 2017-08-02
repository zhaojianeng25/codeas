package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.NodeTreeItem;
	import modules.materials.view.MaterialItemType;
	
	public class NodeTreeDynamic extends NodeTree
	{
		public function NodeTreeDynamic()
		{
			super();
		}
		override public function getComponentID($id:int):String{
			var output:NodeTreeItem = outputVec[0];
			if($id == 0){
				if(output.type == MaterialItemType.VEC4){
					return  CompileOne.FT + this.regResultTemp.id;
				}else if(output.type == MaterialItemType.VEC3){
					return  CompileOne.FT + this.regResultTemp.id + ".xyz";
				}else if(output.type == MaterialItemType.VEC2){
					return  CompileOne.FT + this.regResultTemp.id + ".xy";
				}else if(output.type == MaterialItemType.FLOAT){
					return  CompileOne.FT + this.regResultTemp.id + ".x";
				}
			}else if($id == 1){
				return CompileOne.FT + this.regResultTemp.id + ".x";
			}else if($id == 2){
				return CompileOne.FT + this.regResultTemp.id + ".y";
			}else if($id == 3){
				return CompileOne.FT + this.regResultTemp.id + ".z";
			}else if($id == 4){
				return CompileOne.FT + this.regResultTemp.id + ".xy";
			}else if($id == 5){
				return CompileOne.FT + this.regResultTemp.id + ".xyz";
			}else if($id == 6){
				return CompileOne.FT + this.regResultTemp.id + ".w";
			}
			
			return null;
		}
	}
}