package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeHeightInfo extends NodeTree
	{
		public function NodeTreeHeightInfo(){
			super();
		}
		
		override public function getComponentID($id:int):String{
			var str:String;
			if($id == 0){
				str = CompileOne.FT + this.regResultTemp.id + ".xyz";
			}else if($id == 1){
				str = CompileOne.FT + this.regResultTemp.id + ".x";
			}else if($id == 2){
				str = CompileOne.FT + this.regResultTemp.id + ".y";
			}else if($id == 3){
				str = CompileOne.FT + this.regResultTemp.id + ".z";
			}else if($id == 4){
				str = CompileOne.FT + this.regResultTemp.id + ".w";
			}
			return str;
		}
		
		override public function checkInput():Boolean{
			return true;
		}
	}
}