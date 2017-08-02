package modules.materials.view
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import common.msg.event.materials.MEvent_Material_Connect;
	
	import modules.materials.treedata.NodeTreeInputItem;
	import modules.materials.treedata.NodeTreeOutoutItem;
	
	public class MaterialNodeLineUI extends Sprite
	{
		public var fromNode:ItemMaterialUI;
		public var endNode:ItemMaterialUI;
		public var dragMode:Boolean;
		
		public var startPoint:Point;
		public var endPoint:Point;
		public var needNodeType:Boolean;
		public var currentHasNode:ItemMaterialUI;
		public function MaterialNodeLineUI()
		{
			super();
		}
		
		public function setFromNode($node:ItemMaterialUI):void{
			if($node.inOut){
				endNode = $node;
			}else{
				fromNode = $node;
			}
			currentHasNode = $node;
			needNodeType = !$node.inOut;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
		}
		
		protected function onMove(event:MouseEvent):void
		{
			draw();
		}
		
		public function setEndNode($node:ItemMaterialUI):void{
			if($node.inOut){
				endNode = $node;
			}else{
				fromNode = $node;
			}
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			draw();
			setNodeLine();
		}
		
		public function setNodeLine():void{
			if(endNode.inLine){
				var evt:MEvent_Material_Connect = new MEvent_Material_Connect(MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_REMOVELINE);
				evt.line = endNode.inLine;
				ModuleEventManager.dispatchEvent(evt);
			}
			if(endNode.type == MaterialItemType.UNDEFINE){
				endNode.changeType(fromNode.type);
			}
			fromNode.outLineList.push(this);
			endNode.inLine = this;
			fromNode.setConnect();
			endNode.setConnect();
			
			NodeTreeInputItem(endNode.nodeTreeItem).parentNodeItem = fromNode.nodeTreeItem as NodeTreeOutoutItem;
			NodeTreeOutoutItem(fromNode.nodeTreeItem).pushSunNode(endNode.nodeTreeItem as NodeTreeInputItem);
			
		}
		
		public function remove():void{
			removeStage();
			if(fromNode){
				fromNode.removeOut(this);
				NodeTreeOutoutItem(fromNode.nodeTreeItem).removeSunNode(endNode.nodeTreeItem as NodeTreeInputItem);
			}
			if(endNode){
				endNode.removeIn();
				NodeTreeInputItem(endNode.nodeTreeItem).parentNodeItem = null;
			}
		}
		
		public function removeStage():void{
			if(this.parent){
				if(stage){
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				}
				this.parent.removeChild(this);
			}
		}
		
		public function draw():void{
			if(fromNode){
				startPoint = this.parent.globalToLocal(fromNode.getStagePoint());
			}else{
				startPoint = new Point(this.parent.mouseX,this.parent.mouseY);
			}
			
			if(endNode){
				endPoint = this.parent.globalToLocal(endNode..getStagePoint());
			}else{
				endPoint = new Point(this.parent.mouseX,this.parent.mouseY);
			}
			this.graphics.clear();
			this.graphics.lineStyle(3,0xffffff);
			this.graphics.moveTo(startPoint.x,startPoint.y);
			this.graphics.cubicCurveTo(startPoint.x + 100,startPoint.y,endPoint.x-100,endPoint.y,endPoint.x,endPoint.y);
		}
		
	}
}