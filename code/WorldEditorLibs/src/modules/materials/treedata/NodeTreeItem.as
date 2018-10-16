package modules.materials.treedata
{
	public class NodeTreeItem
	{
		public static var IN:String = "in";
		public static var OUT:String = "out"
		public var node:NodeTree;
		public var inoutType:String;
		public var id:int;
		public var type:String;
		public function NodeTreeItem()
		{
			
		}
		
		public function getObj():Object{
			var obj:Object = new Object;
			obj.inoutType = inoutType;
			obj.id = id;
			obj.type = type;
			return obj;
		}
		
		public function otherNeedObj():Object{
			var obj:Object = new Object;
			obj.id = id;
			obj.inoutType = inoutType;
			obj.pid = node.id;
			return obj;
		}
		
	}
}