package modules.materials.treedata.nodetype
{
	import modules.materials.treedata.NodeTree;
	
	public class NodeTreeOP extends NodeTree
	{
		public var blendMode:int;
		public var killNum:Number;
		public var backCull:Boolean;
		public var writeZbuffer:Boolean = true;
		public var isUseLightMap:Boolean = true;
		public var useDynamicIBL:Boolean;
		public var normalScale:Number;
		public var lightProbe:Boolean;
		public var directLight:Boolean;
		public var noLight:Boolean;
		public var fogMode:int;
		public var scaleLightMap:Boolean;
		public function NodeTreeOP()
		{
			super();
			killNum = 0;
			normalScale = 1;
		}
		
		override public function checkInput():Boolean{
			return true;
		}
	}
}