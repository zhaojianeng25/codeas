package modules.materials.view
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import spark.components.TextInput;
	
	import _me.Scene_data;
	
	import modules.materials.treedata.NodeTree;

	public class MaterialCtrl
	{
		public var nodeList:Vector.<NodeTree>;
		private var uiList:Vector.<BaseMaterialNodeUI>;
		public function MaterialCtrl()
		{
			init();
		}
		
		private function init():void{
			nodeList = new Vector.<NodeTree>;
			uiList = new Vector.<BaseMaterialNodeUI>;
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKey);
		}
		
		protected function onKey(event:KeyboardEvent):void
		{
			
			var selUI:BaseMaterialNodeUI = getSelUI();
			if(event.keyCode == 46){
				if(selUI){
					delUI(selUI);
				}
			}else if(event.keyCode == Keyboard.C){
				if(selUI&&!selUI.textInputTxt.visible){  //不是修改变量状态
					if(selUI.nodeTree.canDynamic && !selUI.nodeTree.paramName){
						selUI.nodeTree.paramName = getParamName();
					}
					selUI.changeDynamic();
				}
			}else if(event.keyCode == 77){
				
				if(selUI is TextureSampleNodeUI){
					for(var i:int;i<uiList.length;i++){
						if(uiList[i] is TextureSampleNodeUI){
							if(uiList[i].select){
								TextureSampleNodeUI(uiList[i]).isMain = true;
							}else{
								TextureSampleNodeUI(uiList[i]).isMain = false;
							}
						}
					}
				}
				
			}
		}

		public function getParamName():String{
			var str:String = "param"
			for(var i:int;i<100;i++){
				for(var j:int=0;j<uiList.length;j++){
					if(uiList[j].nodeTree.paramName == (str + i)){
						break;
					}
				}
				if(j == uiList.length){
					return str + i;
				}
			}
			return null;
		}
		
		private function getSelUI():BaseMaterialNodeUI{
			for(var i:int;i<uiList.length;i++){
				if(uiList[i].select){
					return uiList[i];
				}
			}
			return null;
		}
			
		private function delUI(ui:BaseMaterialNodeUI):void{
			ui.removeAllNodeLine();
			removeUI(ui);
		}
		
		public function addNodeUI(ui:BaseMaterialNodeUI):void{
			var node:NodeTree = ui.nodeTree;
			if(node.id == -1){
				if(nodeList.length){
					node.id = nodeList[nodeList.length-1].id + 1;
				}else{
					node.id = 0;
				}
			}
			nodeList.push(node);
			uiList.push(ui);
			ui.addEventListener(Event.SELECT,onSel);
		}
		
		public function getNodeByCls($cls:Class):BaseMaterialNodeUI{
			for(var i:int;i<uiList.length;i++){
				if(uiList[i] is $cls){
					return uiList[i];
				}
			}
			return null;
		}
		
		protected function onSel(event:Event):void
		{
			var ui:BaseMaterialNodeUI = event.target as BaseMaterialNodeUI;
			for(var i:int;i<uiList.length;i++){
				if(uiList[i] == ui){
					uiList[i].select = true;
				}else{
					uiList[i].select = false;
				}
			}
		}
		
		public function removeAllUI():void{
			for(var i:int;i<uiList.length;i++){
				if(uiList[i].parent){
					uiList[i].parent.removeChild(uiList[i]);
				}
			}
		}
		
		public function removeUI(ui:BaseMaterialNodeUI):void{
			if(ui.parent){
				ui.parent.removeChild(ui);
			}
			for(var i:int;i<uiList.length;i++){
				if(uiList[i] == ui){
					uiList.splice(i,1);
					break;
				}
			}
			
			for(i = 0;i<nodeList.length;i++){
				if(nodeList[i] == ui.nodeTree){
					nodeList.splice(i,1);
					break;
				}
			}
		}
		
		public function getObj():Object{
			var ary:Array = new Array;
			
			for(var i:int;i<nodeList.length;i++){
				var obj:Object = nodeList[i].getObj();
				ary.push(obj);
			}
			
			return ary;
		}
		
		
	}
}