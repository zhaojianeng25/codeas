package common.utils.ui.layout
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import common.GameUIInstance;
	import common.utils.frame.BasePanel;
	import common.utils.ui.tab.TabPanel;
	
	import manager.LayerManager;

	public class LayoutNode
	{
		public var isRoot:Boolean;
		public var isEnd:Boolean;
		public var hasSun:Boolean;
		
		public var parentNode:LayoutNode;
		public var friendNode:LayoutNode;
		public var friendDirect:String;
		
		public var sun1Node:LayoutNode;
		public var sun2Node:LayoutNode;
		
		public var parentWidthScale:Number = 1;
		public var parentHeightScale:Number = 1;
		public var parentXScale:Number = 1;
		public var parentYScale:Number = 1;
		
		public var ctrlSprite:Sprite;
		public var responseSprite:ResponseSprite;
		
		public var panle:TabPanel;
		
		public var id:String;
		
		//0表示横  1表示纵
		public var direct:int;
		
		public static const Left:String = "left";
		public static const Right:String = "right";
		public static const Top:String = "top";
		public static const Bottom:String = "bottom";
		public static const Center:String = "center";
		
		public function LayoutNode()
		{
			
		}
		
		public function initRootNode($newPanle:TabPanel=null):void{
			responseSprite = new ResponseSprite;
			
			GameUIInstance.layoutBottom.addChild(responseSprite);
			responseSprite.spWidth = GameUIInstance.stage.stageWidth;
			responseSprite.spHeight = GameUIInstance.stage.stageHeight;
			this.panle = $newPanle;
			
			responseSprite.addEventListener(LayoutSunEvent.LAYOUTSUN_EVENT,onRespon);
			this.isRoot = true;
			this.id = "0";
		}
		
		public function initNode():void{
			responseSprite = new ResponseSprite;
			
			GameUIInstance.layoutBottom.addChild(responseSprite);
			responseSprite.spWidth = GameUIInstance.stage.stageWidth;
			responseSprite.spHeight = GameUIInstance.stage.stageHeight;
			
			responseSprite.addEventListener(LayoutSunEvent.LAYOUTSUN_EVENT,onRespon);
		}
		
		public function initCtrl():void{
			
			ctrlSprite = new Sprite;
			ctrlSprite.addEventListener(MouseEvent.MOUSE_DOWN,onCtrlMouseDown);
			ctrlSprite.addEventListener(MouseEvent.MOUSE_OVER,onCtrlOver);
			ctrlSprite.addEventListener(MouseEvent.MOUSE_OUT,onCtrlOut);
			if(!ctrlSprite.parent){
				GameUIInstance.layoutTop.addChild(ctrlSprite);
			}
			
		}
		
		public function getNodeByPanle($panle:TabPanel):LayoutNode{
			if(this.panle == $panle){
				return this;
			}else{
				var node:LayoutNode;
				if(sun1Node){
					node = this.sun1Node.getNodeByPanle($panle);
					if(node){
						return node;
					}
				}
				
				if(sun2Node){
					node = this.sun2Node.getNodeByPanle($panle);
					if(node){
						return node;
					}
				}
			}
			return null;
		}
		
		
		protected function onRespon(event:LayoutSunEvent):void
		{
			if(event.direct == Center){
				//this.parentNode.removeNode(this);
				this.panle.addItem(LayerManager.getInstance().dragPanel.name,LayerManager.getInstance().dragPanel);
			}else{
				addSunNode(event.direct,event.panel);
			}
		}
		
		public function draw():void{
			if(!responseSprite){
				responseSprite = new ResponseSprite;
			}
			
			if(sun1Node || sun2Node){
				if(responseSprite.parent){
					responseSprite.parent.removeChild(responseSprite);
				}
			}
			
			responseSprite.spWidth = getWidthScale() * GameUIInstance.stage.stageWidth;
			responseSprite.spHeight = getHeightScale() * (GameUIInstance.stage.stageHeight);
			
			responseSprite.x = getXScale() * GameUIInstance.stage.stageWidth;
			responseSprite.y = getYScale() * (GameUIInstance.stage.stageHeight);
			
			if(panle){
				panle.x = responseSprite.x;
				panle.y = responseSprite.y;
				panle.width = responseSprite.spWidth;
				panle.height = responseSprite.spHeight;
			}
			
			responseSprite.addEventListener(LayoutSunEvent.LAYOUTSUN_EVENT,onRespon);
			
			if(sun1Node){
				sun1Node.draw();
			}
			if(sun2Node){
				sun2Node.draw();
			}
			
			drawCtrl();
		}
		
		public function getIdle():LayoutNode{
			if(this.sun1Node==null && this.sun2Node == null){
				return this;
			}else{
				
				var node:LayoutNode;
				if(this.sun2Node){
					node = this.sun2Node.getIdle();
					if(node){
						return node;
					}
				}
				
				if(this.sun1Node){
					node = this.sun1Node.getIdle();
					if(node){
						return node;
					}
				}
				
			}
			return null;
		}
		
		public function addSunNode(direct:String,newPanle:TabPanel = null,$per:Number = 0.5):void{
			var sunNode1:LayoutNode = new LayoutNode;
			var sunNode2:LayoutNode = new LayoutNode;
			sunNode1.parentNode = this;
			sunNode2.parentNode = this;
			sunNode1.id = this.id + "1";
			sunNode2.id = this.id + "2";
			this.sun1Node = sunNode1;
			this.sun2Node = sunNode2;
			this.hasSun = true;
			
			
			if(responseSprite.parent){
				responseSprite.parent.removeChild(responseSprite);
			}
			
			if(direct == Left){
				sunNode2.panle = this.panle;
				this.panle = null;
				this.direct = 1;
				sunNode1.panle = newPanle;
				
				sunNode1.parentWidthScale = 1 - $per;
				sunNode1.parentHeightScale = 1;
				sunNode1.parentXScale = 0;
				sunNode1.parentYScale = 0;
				
				sunNode2.parentWidthScale = $per;
				sunNode2.parentHeightScale = 1;
				sunNode2.parentXScale = 1 - $per;
				sunNode2.parentYScale = 0;
			}else if(direct == Right){
				sunNode1.panle = this.panle;
				this.panle = null;
				this.direct = 1;
				sunNode2.panle = newPanle;
				
				sunNode1.parentWidthScale = 1 - $per;
				sunNode1.parentHeightScale = 1;
				sunNode1.parentXScale = 0;
				sunNode1.parentYScale = 0;
				
				sunNode2.parentWidthScale = $per;
				sunNode2.parentHeightScale = 1;
				sunNode2.parentXScale = 1 - $per;
				sunNode2.parentYScale = 0;
				
			}else if(direct == Top){
				sunNode2.panle = this.panle;
				this.panle = null;
				this.direct = 0;
				sunNode1.panle = newPanle;
				
				sunNode1.parentWidthScale = 1;
				sunNode1.parentHeightScale = 1-$per;
				sunNode1.parentXScale = 0;
				sunNode1.parentYScale = 0;
				
				sunNode2.parentWidthScale = 1;
				sunNode2.parentHeightScale = $per;
				sunNode2.parentXScale = 0;
				sunNode2.parentYScale = 1-$per;
				
			}else if(direct == Bottom){
				sunNode1.panle = this.panle;
				this.panle = null;
				this.direct = 0;
				sunNode2.panle = newPanle;
				
				sunNode1.parentWidthScale = 1;
				sunNode1.parentHeightScale = 1-$per;
				sunNode1.parentXScale = 0;
				sunNode1.parentYScale = 0;
				
				sunNode2.parentWidthScale = 1;
				sunNode2.parentHeightScale = $per;
				sunNode2.parentXScale = 0;
				sunNode2.parentYScale = 1-$per;
			}
			sunNode1.initNode();
			sunNode2.initNode();
			this.initCtrl();
			
			drawCtrl();
			sunNode1.draw();
			sunNode2.draw();
			
			LayerManager.getInstance().dispatchSizeEvent();
		}
		
		public function clear():void{
			if(responseSprite.parent){
				responseSprite.parent.removeChild(responseSprite);
			}
		}
		
		public function removeNode(rNode:LayoutNode):void{
			if(rNode.isRoot){
				return;
			}
			
			var needNode:LayoutNode;
			
			needNode = getNeedNode(rNode);
			
			if(sun1Node == rNode){
				sun1Node = null;
			}
			if(sun2Node == rNode){
				sun2Node = null;
			}
			
			rNode.clear();
			
			needNode.parentWidthScale = 1;
			needNode.parentHeightScale = 1;
			needNode.parentXScale = 0;
			needNode.parentYScale = 0;
			
			
			if(sun1Node == null && sun2Node == null){
				this.parentNode.removeNode(this);
			}
			
			parentDraw();
		}
		
		public function parentDraw():void{
			if(this.parentNode){
				this.parentNode.parentDraw();
			}else{
				draw();
			}
		}
		
		public function getNeedNode(rNode:LayoutNode):LayoutNode{
			var needNode:LayoutNode;
			if(rNode == this.sun1Node){
				needNode = this.sun2Node;
			}else{
				needNode = this.sun1Node;
			}
			if(needNode == null){
				return this.parentNode.getNeedNode(this);
			}else{
				return needNode;
			}
		}
		
		private function drawCtrl():void{
			if(!ctrlSprite){
				return;
			}
			
			if(sun1Node && sun2Node){
				
			}else{
				if(ctrlSprite.parent){
					ctrlSprite.parent.removeChild(ctrlSprite);
				}
			}
			
			if(!(sun1Node && sun2Node)){
				return;
			}
			
			var wNum:int = getWidthScale() * GameUIInstance.stage.stageWidth;
			var hNum:int = getHeightScale() * (GameUIInstance.stage.stageHeight);
			
			var xpos:int = sun2Node.getXScale() * GameUIInstance.stage.stageWidth;
			var ypso:int = sun2Node.getYScale() * (GameUIInstance.stage.stageHeight);
			
			var drawW:int;
			var drawH:int;
			if(direct == 1){
				drawW = 10;
				drawH = hNum;
				xpos -= 5;
			}else if(direct == 0){
				drawW = wNum;
				drawH = 10;
				ypso -= 5;
			}
			
			ctrlSprite.x = xpos;
			ctrlSprite.y = ypso;
			
			ctrlSprite.graphics.clear();
			ctrlSprite.graphics.beginFill(0xff0000,0);
			ctrlSprite.graphics.drawRect(0,0,drawW,drawH);
			ctrlSprite.graphics.endFill();
			
		}
		
		private var mousePos:Point;
		private function onCtrlOver(event:MouseEvent):void{
			if(direct == 1){
				Mouse.cursor = "doubelArrow";
			}else{
				Mouse.cursor = "doubelVerArrow";
			}
		}
		
		private function onCtrlOut(event:MouseEvent):void{
			Mouse.cursor = MouseCursor.AUTO;
		}
		protected function onCtrlMouseDown(event:MouseEvent):void
		{
			
			mousePos = new Point(GameUIInstance.stage.mouseX,GameUIInstance.stage.mouseY);
			GameUIInstance.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			GameUIInstance.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			GameUIInstance.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			GameUIInstance.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			var currentPos:Point = new Point(GameUIInstance.stage.mouseX,GameUIInstance.stage.mouseY);
			
			if(direct == 1){
				var num:Number = (currentPos.x - mousePos.x) * 0.0005;
				sun1Node.parentWidthScale += num;
				
				sun2Node.parentWidthScale -= num;
				sun2Node.parentXScale += num;
			}else{
				num = (currentPos.y - mousePos.y) * 0.0005;
				sun1Node.parentHeightScale += num;
				
				sun2Node.parentHeightScale -= num;
				sun2Node.parentYScale += num;
			}
			
			mousePos = currentPos;
			
			draw();
			
			LayerManager.getInstance().dispatchSizeEvent();
		}
		
		public function getWidthScale():Number{
			if(this.isRoot){
				return 1;
			}
			return parentWidthScale * this.parentNode.getWidthScale();
		}
		
		public function getHeightScale():Number{
			if(this.isRoot){
				return 1;
			}
			return parentHeightScale * this.parentNode.getHeightScale();
		}
		
		public function getXScale():Number{
			if(this.isRoot){
				return 0;
			}
			return parentXScale * this.parentNode.getWidthScale() + this.parentNode.getXScale();
		}
		
		public function getYScale():Number{
			if(this.isRoot){
				return 0;
			}
			return parentYScale * this.parentNode.getHeightScale() + this.parentNode.getYScale();
		}
		
	}
}