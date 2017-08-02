package modules.materials.treedata
{
	public class NodeTreeOutoutItem extends NodeTreeItem
	{
		public var sunNodeItems:Vector.<NodeTreeInputItem>;
		public function NodeTreeOutoutItem()
		{
			super();
			sunNodeItems = new Vector.<NodeTreeInputItem>;
			inoutType = OUT;
		}
		
		public function pushSunNode(nodeitem:NodeTreeInputItem):void{
			sunNodeItems.push(nodeitem);
		}
		
		public function removeSunNode(nodeitem:NodeTreeInputItem):void{
			for(var i:int;i<sunNodeItems.length;i++){
				if(sunNodeItems[i] == nodeitem){
					sunNodeItems.splice(i,1);
					break;
				}
			}
		}
		
		override public function getObj():Object{
			var obj:Object = super.getObj();
			var ary:Array = new Array;
			for(var i:int;i<sunNodeItems.length;i++){
				ary.push(sunNodeItems[i].otherNeedObj());
			}
			obj.sunObj = ary;
			return obj;
		}
		
	}
}