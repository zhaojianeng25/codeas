package modules.materials.view
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import common.msg.event.materials.MEvent_Material_Connect;
	
	public class MaterialLineContainer extends UIComponent
	{
		private var _currentLine:MaterialNodeLineUI;
		private var _lineList:Vector.<MaterialNodeLineUI> = new Vector.<MaterialNodeLineUI>;
		public function MaterialLineContainer()
		{
			super();
		}
		
		public function startLine($item:ItemMaterialUI):void{
			_currentLine = new MaterialNodeLineUI;
			this.addChild(_currentLine);
			_currentLine.setFromNode($item);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			var ary:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX,stage.mouseY));
			var evt:MEvent_Material_Connect = new MEvent_Material_Connect(MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_STOPDRAG);
			for(var i:int;i<ary.length;i++){
				if(ary[i] is CircleSprite){
					var sp:ItemMaterialUI = CircleSprite(ary[i]).parent as ItemMaterialUI;
					evt.itemNode = sp;
					break;
				}
			}
			ModuleEventManager.dispatchEvent(evt);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		public function stopLine($item:ItemMaterialUI):void{
			if($item){
				if(_currentLine.needNodeType == $item.inOut //进出验证
					&& $item.parent != _currentLine.currentHasNode.parent//同一个节点
					&& ($item.type == MaterialItemType.UNDEFINE || $item.type == _currentLine.currentHasNode.type))
				{
					if($item.type == MaterialItemType.UNDEFINE){
						$item.changeType(_currentLine.currentHasNode.type);
					}
					_currentLine.setEndNode($item);
					_lineList.push(_currentLine);
				}else{
					_currentLine.removeStage();
				}
			}else{
				_currentLine.removeStage();
			}
		}
		
		public function addConnentLine($startItem:ItemMaterialUI,$endItem:ItemMaterialUI):void{
			_currentLine = new MaterialNodeLineUI;
			this.addChild(_currentLine);
			_currentLine.setFromNode($startItem);
			_currentLine.setEndNode($endItem);
			_lineList.push(_currentLine);
		}
		
		public function removeLine($line:MaterialNodeLineUI):void{
			for(var i:int;i<_lineList.length;i++){
				if(_lineList[i] == $line){
					_lineList.splice(i,1);
					break;
				}
			}
			$line.remove();
		}
		
		public function removeAll():void{
			for(var i:int;i<_lineList.length;i++){
				_lineList[i].remove();
			}
			_lineList.length = 0;
		}
		
	}
}