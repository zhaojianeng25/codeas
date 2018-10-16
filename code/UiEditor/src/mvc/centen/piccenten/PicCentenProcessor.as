package mvc.centen.piccenten
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import spark.components.RichEditableText;
	import spark.skins.spark.WindowedApplicationSkin;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import _me.Scene_data;
	
	import common.msg.event.engineConfig.MEventStageResize;
	
	import manager.LayerManager;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.centen.panelcenten.PanelCentenEvent;
	import mvc.left.panelleft.vo.PanelRectInfoNode;
	import mvc.project.ProjectEvent;
	import mvc.scene.UiSceneEvent;
	
	import vo.FileInfoType;
	import vo.H5UIFileNode;
	import vo.HistoryModel;
	import vo.InfoDataSprite;
	
	public class PicCentenProcessor extends Processor
	{
		private var _centenPanel:PicCentenPanel;
		private var _menuFile:NativeMenu;
		public function PicCentenProcessor($module:Module)
		{
			super($module);
			initData()
			
	
		}
		
		private function initData():void
		{
			Scene_data.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,onMiddleUp)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUP)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			
			Scene_data.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,onMiddleDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			Scene_data.stage.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			Scene_data.stage.addEventListener(MouseEvent.CLICK,onStageClik);
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onStageKeyDown)	;
			
			initMenuFile()
			readyReceiveThing()
			
		}
		private function readyReceiveThing():void
		{
			Scene_data.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,dragEnterHandler);
			Scene_data.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,dragDropHandler);
			Scene_data.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT,dragExitHandler);
			
		}
		private function dragExitHandler(e:NativeDragEvent):void
		{
			
		}
		
		private function dragEnterHandler(e:NativeDragEvent):void
		{
			if(!isCanDo){
				return ;
			}
			var clipBoard:Clipboard = e.clipboard;
			if(clipBoard.hasFormat(ClipboardFormats.BITMAP_FORMAT) ||
				clipBoard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)
			)
			{
				NativeDragManager.acceptDragDrop(Scene_data.stage);
			}
		
		}
		
		private function dragDropHandler(event:NativeDragEvent):void
		{
			if(!isCanDo){
				return ;
			}
			
			var _reBitmapdata:BitmapData = event.clipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
			var arr:Array=event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array
			for each(var $file:File in arr){
				if($file.isDirectory){
				}else{
					sendFile($file)
				}
			}
			
		}
		
		private function sendFile($file:File):void
		{
			if($file.extension=="jpg"||$file.extension=="png"){
				pushBaseBmpurl($file.url)
			}
	
		}
		
		public function pushBaseBmpurl(url:String):void
		{
			
			var loaderinfo:LoadInfo = new LoadInfo(url,LoadInfo.BITMAP,function onImgLoad($bitmap:Bitmap):void
			{

				UiData.picFileDataVo.url=url;
				UiData.picFileDataVo.bmp=$bitmap.bitmapData;
				UiData.picFileDataVo.rect=new Rectangle(0,0,UiData.picFileDataVo.bmp.width,UiData.picFileDataVo.bmp.height);
				refreshSceneData()
				
			},0);
			
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		
		public function initMenuFile():void{
			
			
			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			
			
			item = new NativeMenuItem("添加对象")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,addNewInfoNode);
			//H5UIFrameMesh
			
			
			
		}
		
		protected function addNewInfoNode(event:Event):void
		{
			var $H5UIFileNode:H5UIFileNode=new H5UIFileNode
			$H5UIFileNode.name="NewName";
			$H5UIFileNode.type=FileInfoType.baseUi
			$H5UIFileNode.modelType=2
			$H5UIFileNode.rect=new Rectangle((_centenPanel.mouseX-_centenPanel.bmpLevel.x)*(1/_centenPanel.scaleNum)-10,(_centenPanel.mouseY-_centenPanel.bmpLevel.y)*(1/_centenPanel.scaleNum)-10,100,80)
			UiData.picItem.addItem($H5UIFileNode)
				
			var $UiSceneEvent:UiSceneEvent=new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA)
			$UiSceneEvent.modelType=2
			ModuleEventManager.dispatchEvent($UiSceneEvent);
			
		
			
		}
		private function get isCanDo():Boolean
		{
			if(UiData.editMode==2){
				
				return true
			}else{
				return false
			}
		}
		private function selectAll():void
		{
			var $selectNodeArr:Vector.<H5UIFileNode>=new Vector.<H5UIFileNode>
			for(var i:uint=0;i<UiData.picItem.length;i++){
				var $h5UIFileNode:H5UIFileNode=UiData.picItem[i];
				$selectNodeArr.push($h5UIFileNode);
			}
			UiData.selectArr=$selectNodeArr;
			var $UiSceneEvent:UiSceneEvent=new UiSceneEvent(UiSceneEvent.SELECT_INFO_NODE)
			$UiSceneEvent.modelType=2
			ModuleEventManager.dispatchEvent($UiSceneEvent);
			
		}
		protected function onStageKeyDown(event:KeyboardEvent):void
		{
			if(!isCanDo){
				return 
			}
			if(!Boolean(event.target is RichEditableText))
			{
				if(event.ctrlKey&&event.keyCode==Keyboard.S){
					
		
				}
				
				if(event.keyCode==Keyboard.DELETE){
					delSeLect()
				}
				
				if(event.ctrlKey){
					
					if(event.keyCode==Keyboard.C){
						UiData.makeCopy();
					}
					if(event.keyCode==Keyboard.V){
						UiData.paste();
					}
					
					if(event.keyCode==Keyboard.A){
						selectAll()
					}
					
					if(event.keyCode==Keyboard.Z){
						HistoryModel.getInstance().cancelScene()
					}
					if(event.keyCode==Keyboard.Y){
						HistoryModel.getInstance().nextScene()
					}
					
					
				}else{
					
					if(event.keyCode==Keyboard.UP){
						tureSelecMove(0,-1)
					}
					if(event.keyCode==Keyboard.DOWN){
						tureSelecMove(0,+1)
					}
					if(event.keyCode==Keyboard.LEFT){
						tureSelecMove(-1,0)
					}
					if(event.keyCode==Keyboard.RIGHT){
						tureSelecMove(+1,0)
					}
				}
			}
			
			
			
			
			
			
			
			
		}
		private var willDeleItem:Vector.<H5UIFileNode>
		private function delSeLect():void
		{
			if(UiData.selectArr&&UiData.selectArr.length){
				
				willDeleItem=new Vector.<H5UIFileNode>
				for(var i:uint=0;i<UiData.selectArr.length;i++)
				{
					willDeleItem.push(UiData.selectArr[i])
				}
				
				
				Alert.show("是否确定删除？","删除",3,_centenPanel,deleteCallBack);
			}
		}
		private function deleteCallBack(event:CloseEvent):void
		{
			
			if(event.detail == Alert.YES)
			{
				for(var i:uint=0;i<willDeleItem.length;i++)
				{
					deleH5UIFileNode(willDeleItem[i])
				}
				UiData.selectArr=new Vector.<H5UIFileNode>
			}
			
		}
		private function tureSelecMove($tx:Number,$ty:Number):void
		{
			for(var i:uint=0;UiData.selectArr&&i<UiData.selectArr.length;i++)
			{
				UiData.selectArr[i].rect.x+=$tx
				UiData.selectArr[i].rect.y+=$ty
				UiData.selectArr[i].sprite.updata()
			}
			ModuleEventManager.dispatchEvent(new DisCentenEvent(DisCentenEvent.REFRESH_SELECT_FILENODE));
			
		}
		
		protected function onStageClik(event:MouseEvent):void
		{
			if(!isCanDo){
				return ;
			}
			if(Boolean(event.target as WindowedApplicationSkin)){
				
	
				ModuleEventManager.dispatchEvent(new PicCentenEvent(PicCentenEvent.SHOW_PIC_MESH));
			}
			
		}
		protected function onRightClick(event:MouseEvent):void
		{
			if(!isCanDo){
				return 
			}
			
			if(testInCentenPanel){
				_menuFile.display(Scene_data.stage,Scene_data.stage.mouseX,Scene_data.stage.mouseY);
			}
			
			
		}
		protected function onMouseWheel(event:MouseEvent):void
		{
			
			
			if(!isCanDo){
				return 
			}
			if(testInCentenPanel){
				if(event.delta>0){
					_centenPanel.KeyAdd()
				}else{
					_centenPanel.KeySub()
				}
			}
			
			
			
		}
		protected function onMouseDown(event:MouseEvent):void
		{
			if(!isCanDo){
				return ;
			}
			if(event.target as Sprite){
				if(Sprite(event.target).parent as InfoDataSprite ){
					return ;
				}
			}
			if(testInCentenPanel){
				_centenPanel.beginDrawLine()	
			}
			
			
			
		}
		protected function onStageMouseUP(event:MouseEvent):void
		{
			
			if(!isCanDo){
				return 
			}
			
			if(_startSelectNodeInfo){
				for(var i:uint=0;i<UiData.selectArr.length;i++){
					var $h5UIFileNode:H5UIFileNode=UiData.selectArr[i];
					$h5UIFileNode.sprite.x=int($h5UIFileNode.sprite.x)
					$h5UIFileNode.sprite.y=int($h5UIFileNode.sprite.y)
					$h5UIFileNode.rect.x=$h5UIFileNode.sprite.x
					$h5UIFileNode.rect.y=$h5UIFileNode.sprite.y
				}
				_startSelectNodeInfo=false;
				ModuleEventManager.dispatchEvent(new DisCentenEvent(DisCentenEvent.REFRESH_SELECT_FILENODE));
				HistoryModel.getInstance().saveSeep()
			}else{
				findSelectNode(event)
			}
			_centenPanel.endDrawLine()
			
		}
		private function findSelectNode(event:MouseEvent):void
		{

			if(_centenPanel.beginLinePoin){  //说明是框选
				var $selectNodeArr:Vector.<H5UIFileNode>=new Vector.<H5UIFileNode>
				var a:Point=_centenPanel.beginLinePoin
				var b:Point=new Point(_centenPanel.mouseX,_centenPanel.mouseY)
				var $selectRec:Rectangle=new Rectangle();
				var cavanPos:Point=_centenPanel.getBmpPostion()
				var anum:Number=1/_centenPanel.scaleNum
				$selectRec.x=(Math.min(a.x,b.x)-cavanPos.x)*anum
				$selectRec.y=(Math.min(a.y,b.y)-cavanPos.y)*anum
				$selectRec.width=Math.abs(a.x-b.x)*anum
				$selectRec.height=Math.abs(a.y-b.y)*anum
				for(var i:uint=0;i<UiData.picItem.length;i++){
					var $h5UIFileNode:H5UIFileNode=UiData.picItem[i];
					if($selectRec.intersects($h5UIFileNode.rect)||(event.shiftKey&&$h5UIFileNode.select)){
						$selectNodeArr.push($h5UIFileNode)
					}
				}
				UiData.selectArr=$selectNodeArr;
				var $UiSceneEvent:UiSceneEvent=new UiSceneEvent(UiSceneEvent.SELECT_INFO_NODE)
				$UiSceneEvent.modelType=2
				ModuleEventManager.dispatchEvent($UiSceneEvent);
				
			}
		}
		private function get testInCentenPanel():Boolean
		{
			
			if(!isCanDo){
				return false
			}
			var pos:Point	=_centenPanel.localToGlobal(new Point);
			var rect:Rectangle=new Rectangle();
			rect.x=pos.x
			rect.y=pos.y
			rect.width=_centenPanel.width;
			rect.height=_centenPanel.height;
			
			var mousePos:Point=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			
			if(mousePos.x>rect.x&&mousePos.y>rect.y&&mousePos.x<(rect.x+rect.width)&&mousePos.y<(rect.y+rect.height)){
				return true
			}else{
				return false
			}
			
			
		}
		
		protected function onMiddleDown(event:MouseEvent):void
		{
			if(testInCentenPanel){
				_centenPanel.middleDown=true
			}
			
			
		}
		
		protected function onMiddleUp(event:MouseEvent):void
		{	if(!isCanDo){
			return 
		}
			_centenPanel.middleDown=false
			
		}
		private var _startSelectNodeInfo:Boolean=false //移动选取的;
		private var _selcetNodeLastMouse:Point;
		protected function onMouseMove(event:MouseEvent):void
		{
			if(!isCanDo){
				return 
			}
			
			_centenPanel.mouseMove()
			if(_startSelectNodeInfo){
				//_selcetNodeLastMouse=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
				var addPos:Point=new Point;
				addPos.x=Scene_data.stage.mouseX-_selcetNodeLastMouse.x
				addPos.y=Scene_data.stage.mouseY-_selcetNodeLastMouse.y
				for(var i:uint=0;i<UiData.selectArr.length;i++){
					var $h5UIFileNode:H5UIFileNode=UiData.selectArr[i];
					$h5UIFileNode.sprite.x=$h5UIFileNode.rect.x+addPos.x/_centenPanel.scaleNum
					$h5UIFileNode.sprite.y=$h5UIFileNode.rect.y+addPos.y/_centenPanel.scaleNum
				}
				
			}else{
				_centenPanel.drawSelectLine()
				
			}
			
		}
		
		override protected function listenModuleEvents():Array 
		{
			return [
				PicCentenEvent,
				MEventStageResize,
				DisCentenEvent,
				ProjectEvent,
				UiSceneEvent,
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case PicCentenEvent:
					if($me.action==PicCentenEvent.SHOW_CENTEN){
						showHide();
					}
					break;
				case DisCentenEvent:
		
					if($me.action==DisCentenEvent.DELE_NODE_INFO_VO){
						deleNodeInof(DisCentenEvent($me))
					}
				case UiSceneEvent:
					if(_centenPanel){
						if($me.action==UiSceneEvent.REFRESH_SCENE_DATA){
							refreshSceneData()
						}
						if($me.action==UiSceneEvent.SELECT_INFO_NODE){
							selectInfoNode(UiSceneEvent($me) )
						}
						if($me.action==UiSceneEvent.START_MOVE_NODE_INFO){
							startMoveNodeInfo()
						}
						if($me.action==UiSceneEvent.REFRESH_SCENE_BITMAPDATA){
							refreshSceneBitmapData(UiSceneEvent($me) )
						}
						
					}			
					break;
			}
		}
		
		private function refreshSceneBitmapData(param0:UiSceneEvent):void
		{
			if(!isCanDo){
				return 
			}
		
			if(UiData.picFileDataVo.url&&new File(UiData.picFileDataVo.url).exists){
				this.pushBaseBmpurl(UiData.picFileDataVo.url)
			}else{
				Alert.show("先拖入编辑图片")
			}

	
			
		}
		private function deleNodeInof($centenEvent:DisCentenEvent):void
		{
			deleH5UIFileNode($centenEvent.h5UIFileNode)
			
		}
		private function deleH5UIFileNode($delNode:H5UIFileNode):void
		{
			
			for(var i:uint=0;i<UiData.picItem.length;i++){
				if(UiData.picItem[i]==$delNode){
					UiData.picItem.removeItemAt(i)
				}
			}
			ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA));
			
		}
		
		
		private function startMoveNodeInfo():void
		{
			
			_selcetNodeLastMouse=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			_startSelectNodeInfo=true
			
		}
		private function selectInfoNode($centenEvent:UiSceneEvent):void
		{
			for(var i:uint=0;i<UiData.picItem.length;i++){
				var has:Boolean=false;
				for(var j:uint=0;j<UiData.selectArr.length;j++){
					if(H5UIFileNode(UiData.picItem[i])==UiData.selectArr[j]){
						has=true;
					}
				}
				H5UIFileNode(UiData.picItem[i]).select=has;
				H5UIFileNode(UiData.picItem[i]).sprite.updata();
			}
			
			
		}
		private function refreshSceneData():void
		{
			if(_centenPanel){
			_centenPanel.resetInfoArr()
			}
		}	
		public function showHide():void
		{
			if(!_centenPanel){
				_centenPanel = new PicCentenPanel;
			
			}
			_centenPanel.init(this,"中",1);
			LayerManager.getInstance().addPanel(_centenPanel);
	
		}
	}
}