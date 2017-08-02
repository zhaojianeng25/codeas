package modules.materials.treedata.nodetype
{
	import flash.geom.Point;
	
	import modules.materials.treedata.CompileOne;
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreePanner extends NodeTree
	{
		public var coordinateValue:Point = new Point(1,1);
		public var speedValue:Point = new Point(0,0);
		public function NodeTreePanner(){
			super();
		}
		
		override public function getComponentID($id:int):String{
			var str:String;
			if($id == 0){
				str = CompileOne.FT + this.regResultTemp.id + ".xy";
			}
			return str;
		}
		
		override public function checkInput():Boolean{
			return true;
		}
		
	}
}