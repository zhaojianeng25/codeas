package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeTex extends NodeTree
	{
		public var url:String;
		public var isMain:Boolean;
		public var wrap:int;
		public var mipmap:int;// 0=disable、1=nearest、2=linear
		public var filter:int;// 1=nearest、0=linear
		public var permul:Boolean;
		public function NodeTreeTex()
		{
			super();
			this.canDynamic = true;
		}
		
//		override public function getComponentID($id:int):String{
//			if($id == 0){
//				return ".xyz";
//			}else if($id == 1){
//				return ".x";
//			}else if($id == 2){
//				return ".y";
//			}else if($id == 3){
//				return ".z";
//			}else if($id == 4){
//				return ".w";
//			}
//			return null;
//		}
		
		override public function getComponentID($id:int):String{
			if($id == 0){
				return  CompileOne.FT + this.regResultTemp.id + ".xyz";
			}else if($id == 1){
				return CompileOne.FT + this.regResultTemp.id + ".x";
			}else if($id == 2){
				return CompileOne.FT + this.regResultTemp.id + ".y";
			}else if($id == 3){
				return CompileOne.FT + this.regResultTemp.id + ".z";
			}else if($id == 4){
				return CompileOne.FT + this.regResultTemp.id + ".w";
			}else if($id == 5){
				return CompileOne.FT + this.regResultTemp.id;
			}
			return null;
		}
		
		override public function checkInput():Boolean{
			return true;
		}
		
		
		
	}
}