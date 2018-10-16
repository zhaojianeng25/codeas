package modules.materials.treedata
{
	public class RegisterItem
	{
		public var id:int;
		public var inUse:Boolean;
		public var url:String;
		public var xUse:Boolean;
		public var yUse:Boolean;
		public var zUse:Boolean;
		public var wUse:Boolean;
		public var hasInit:Boolean;
		
		public function RegisterItem($id:int)
		{
			id = $id;
		}
		
		public function getUse($nodeTree:NodeTree):Boolean{
			var $type:String = $nodeTree.type;
			if($type == NodeTree.VEC3){
				if(!xUse){
					xUse = true;
					yUse = true;
					zUse = true;
					$nodeTree.regResultConst = this;
					$nodeTree.regConstIndex = 0;
					return true;
				}
			}else if($type == NodeTree.VEC2){
				if(!xUse){
					xUse = true;
					yUse = true;
					$nodeTree.regResultConst = this;
					$nodeTree.regConstIndex = 0;
					return true;
				}else if(!yUse){
					yUse = true;
					zUse = true;
					$nodeTree.regResultConst = this;
					$nodeTree.regConstIndex = 1;
					return true;
				}else if(!zUse){
					zUse = true;
					wUse = true;
					$nodeTree.regResultConst = this;
					$nodeTree.regConstIndex = 2;
					return true;
				}
			}else if($type == NodeTree.FLOAT){
				if(!xUse){
					xUse = true;
					$nodeTree.regResultConst = this;
					$nodeTree.regConstIndex = 0;
					return true;
				}else if(!yUse){
					yUse = true;
					$nodeTree.regResultConst = this;
					$nodeTree.regConstIndex = 1;
					return true;
				}else if(!zUse){
					zUse = true;
					$nodeTree.regResultConst = this;
					$nodeTree.regConstIndex = 2;
					return true;
				}else if(!wUse){
					wUse = true;
					$nodeTree.regResultConst = this;
					$nodeTree.regConstIndex = 3;
					return true;
				}
			}
			
			return false;
			
		}
	}
}