package mvc.centen.discenten
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
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
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
	
	import mvc.left.panelleft.PanelModel;
	import mvc.project.ProjectEvent;
	import mvc.scene.UiSceneEvent;
	import mvc.top.SavePngZipModel;
	
	import vo.FileDataVo;
	import vo.FileInfoType;
	import vo.H5UIFileNode;
	import vo.HistoryModel;
	import vo.InfoDataSprite;
	
	public class DisCentenProcessor extends Processor
	{
		private var _centenPanel:DisCentenPanel;
		public function DisCentenProcessor($module:Module)
		{
			super($module);
			initData()
			
	
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				DisCentenEvent,
				MEventStageResize,
				ProjectEvent,
				UiSceneEvent,
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case DisCentenEvent:
					if($me.action==DisCentenEvent.SHOW_CENTEN){
						showHide()
					}
					if($me.action==DisCentenEvent.DELE_NODE_INFO_VO){
						deleNodeInof(DisCentenEvent($me))
					}
					if($me.action==DisCentenEvent.DELE_SELECT_NODE){
						delSeLect()
					}
				
					if($me.action==DisCentenEvent.SAVE_H5UI_PROJECT_FILE){
						saveFile(DisCentenEvent($me).saveH5UIchangeFile)
					}
					break;
				case UiSceneEvent:
					if($me.action==UiSceneEvent.REFRESH_SCENE_DATA){
						refreshSceneData()
					}
					if($me.action==UiSceneEvent.START_MOVE_NODE_INFO){
						startMoveNodeInfo()
					}
					
					if($me.action==UiSceneEvent.CHANGE_SCENE_COLOR){
						changeSceneColor()
					}
					if($me.action==UiSceneEvent.SELECT_INFO_NODE){
						selectInfoNode(UiSceneEvent($me) )
					}
					if($me.action==UiSceneEvent.REFRESH_SCENE_BITMAPDATA){
						refreshSceneBitmapData(UiSceneEvent($me) )
					}
				
					break;
			
				case MEventStageResize:
					resize($me as MEventStageResize)
					break;

			}
		}
		
		private function refreshSceneBitmapData($UiSceneEvent:UiSceneEvent):void
		{
			if(UiData.bigBitmapUrl&&new File(UiData.bigBitmapUrl).exists){
				pushBaseBmpurl(UiData.bigBitmapUrl)
			}else{
				Alert.show("先拖入编辑图片")
			}
			
		}
		
		private function selectInfoNode($UiSceneEvent:UiSceneEvent):void
		{
			if($UiSceneEvent.modelType==0){
				if(UiData.editMode!=0){
					showHide()
				}
			}
			
		}
		private function get isCanDo():Boolean
		{
			if(UiData.editMode==0){
			
				return true
			}else{
			    return false
			}
		}
		
		private function deleNodeInof($centenEvent:DisCentenEvent):void
		{
			deleH5UIFileNode($centenEvent.h5UIFileNode)
			
		}
		private function deleH5UIFileNode($delNode:H5UIFileNode):void
		{

			for(var i:uint=0;i<UiData.nodeItem.length;i++){
				if(UiData.nodeItem[i]==$delNode){
					UiData.nodeItem.removeItemAt(i)
				}
			}
			ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA));
			
		}
			
	
		
		
		
		private function changeSceneColor():void
		{
			_centenPanel.changeSceneColor()
			
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
        
		protected function onMouseDown(event:MouseEvent):void
		{
			if(!isCanDo){
				return ;
			}

			if(event.target as Sprite){
				if(Sprite(event.target).parent as InfoDataSprite ){
					
				   if(event.ctrlKey){
			
					  this.getCtrlCopyItem(Sprite(event.target).parent as InfoDataSprite)
				   }
					
				   return ;
				}
			}
			if(testInCentenPanel){
				_centenPanel.beginDrawLine()	
			}
		}
		private var  ctrlSelectNode:H5UIFileNode;
		private var lastCtrlMousePos:Point;
		private function getCtrlCopyItem($dis:InfoDataSprite):void
		{
		
			this.ctrlSelectNode=null
			this.lastCtrlMousePos=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			for(var i:uint=0;i<UiData.selectArr.length;i++){
				var $h5UIFileNode:H5UIFileNode=UiData.selectArr[i];
				if($h5UIFileNode.sprite==$dis){
		
					trace("准备复制",$h5UIFileNode.name)
					this.ctrlSelectNode=$h5UIFileNode
				}

			}
		}
		
		protected function onStageClik(event:MouseEvent):void
		{
			if(!isCanDo){
				return ;
			}
			if(Boolean(event.target as WindowedApplicationSkin)){
			
				ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.SHOW_UI_SCENE));
			}
			
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
			if($file.extension=="h5ui"){
				//readScene($file);
				
				var $CentenEvent:ProjectEvent=new ProjectEvent(ProjectEvent.OPEN_PROJECT_FILE)
				$CentenEvent.url=$file.url
				ModuleEventManager.dispatchEvent( $CentenEvent);
				
				
			}
		}
		public function pushBaseBmpurl(url:String):void
		{

			var loaderinfo:LoadInfo = new LoadInfo(url,LoadInfo.BITMAP,function onImgLoad($bitmap:Bitmap):void
			{
				UiData.bigBitmapUrl=url
				var $FileDataVo:FileDataVo=new FileDataVo;
				$FileDataVo.url=url;
				$FileDataVo.bmp=$bitmap.bitmapData;
				UiData.bmpitem.length=0
				$FileDataVo.rect=new Rectangle(0,0,$FileDataVo.bmp.width,$FileDataVo.bmp.height);
				UiData.bmpitem.push($FileDataVo)
				
				UiData.sceneBmpRec=$FileDataVo.rect.clone();
				ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA));
				
			},0);
			
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
	
		protected function onStageKeyDown(event:KeyboardEvent):void
		{
			if(!isCanDo){
			   return 
			}
			if(!Boolean(event.target is RichEditableText))
			{
				if(event.ctrlKey&&event.keyCode==Keyboard.S){
					
					return ;
					Alert.show("是否确定要保存","保存",3,_centenPanel,function (event:CloseEvent):void
					{
						if(event.detail == Alert.YES)
						{
							saveFile(false)
						}
						
					});
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
						selectAll();
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
		
		private function selectAll():void
		{
			var $selectNodeArr:Vector.<H5UIFileNode>=new Vector.<H5UIFileNode>
			for(var i:uint=0;i<UiData.nodeItem.length;i++){
				var $h5UIFileNode:H5UIFileNode=UiData.nodeItem[i];
				$selectNodeArr.push($h5UIFileNode)
			}
			UiData.selectArr=$selectNodeArr;
			ModuleEventManager.dispatchEvent(new UiSceneEvent(UiSceneEvent.SELECT_INFO_NODE));
			
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
		private var _so:SharedObject
		private function saveFile($changeUrl:Boolean):void
		{
			if(UiData.isNewH5UI){
				//如果是新场景将只能另存为
				$changeUrl=true;
			}
			
			if($changeUrl){
				var file:File=new File;
				file.browseForSave("保存文件");
				file.addEventListener(Event.SELECT,onSelect);
				function onSelect(e:Event):void
				{
					var saveFiled:File = e.target as File;
					var fileName:String=saveFiled.name.replace("."+saveFiled.extension,"")
					saveWorkScene(saveFiled.parent.nativePath,fileName)
				}
				
			}else{
				
				_so = UiData.getSharedObject()
				if(_so.data.url){
					var $fristFile:File=new File(_so.data.url)
					var $fristNmae:String=$fristFile.name.replace("."+$fristFile.extension,"")
					saveWorkScene($fristFile.parent.nativePath,$fristNmae)
				}
			}
			
		}
		private function saveWorkScene(dicurl:String,filename:String):void
		{

			var $file:File=new File(dicurl+"/"+filename+".h5ui")//objs文件地址

			_so = UiData.getSharedObject()
			_so.data.url=$file.url;
			
			var $fs:FileStream = new FileStream;
			$fs.open($file,FileMode.WRITE);
			var a:Object=new Object;
			a.FileBmpItem=UiData.getFileBmpItem()
		    a.picinfoRectItem=UiData.getPicRectItem()
			a.picSceneData=UiData.getPicSceneData()
	
			a.InfoRectItem=UiData.getInfoRectItem()
			a.sceneBmpRec=UiData.sceneBmpRec;
			a.sceneColor=UiData.sceneColor;
			a.panelItem=PanelModel.getInstance().getPanelNodeItemToSave()
			
			$fs.writeObject(a);
			$fs.close();
			
			UiData.saveToH5xml($file.parent.nativePath,$file.name.replace("."+$file.extension,""))
			
			Alert.show($file.name,"保存完毕")
			UiData.isNewH5UI=false
				
			//SavePngZipModel.getInstance().saveJpngBy()
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
		public function initMenuFile():void{
			
			
			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			
			
			item = new NativeMenuItem("添加对象")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,addNewInfoNode);
			
			item = new NativeMenuItem("添加9宫格")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,add9InfoNode);
			
			item = new NativeMenuItem("添加序列帧")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,addFrameInfoNode);
			

			
		    //H5UIFrameMesh
			
			
			
		}
		
		protected function addFrameInfoNode(event:Event):void
		{
			var $H5UIFileNode:H5UIFileNode=new H5UIFileNode
			$H5UIFileNode.type=FileInfoType.frame
			$H5UIFileNode.name="NewName";
			$H5UIFileNode.rect=new Rectangle((_centenPanel.mouseX-_centenPanel.bmpLevel.x)*(1/_centenPanel.scaleNum)-10,(_centenPanel.mouseY-_centenPanel.bmpLevel.y)*(1/_centenPanel.scaleNum)-10,100,80)
			$H5UIFileNode.rowColumn=new Point(1,1)
			UiData.nodeItem.addItem($H5UIFileNode)
			ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA));
			
		}
		
		protected function add9InfoNode(event:Event):void
		{
			var $H5UIFileNode:H5UIFileNode=new H5UIFileNode
			$H5UIFileNode.type=FileInfoType.ui9
			$H5UIFileNode.name="NewName";
			$H5UIFileNode.rect=new Rectangle((_centenPanel.mouseX-_centenPanel.bmpLevel.x)*(1/_centenPanel.scaleNum)-10,(_centenPanel.mouseY-_centenPanel.bmpLevel.y)*(1/_centenPanel.scaleNum)-10,100,80)
			$H5UIFileNode.rect9=new Rectangle(0,0,10,10)
			UiData.nodeItem.addItem($H5UIFileNode)
			ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA));
			
		}
		

		
		protected function addNewInfoNode(event:Event):void
		{
			var $H5UIFileNode:H5UIFileNode=new H5UIFileNode
			$H5UIFileNode.name="NewName";
			$H5UIFileNode.type=FileInfoType.baseUi
			$H5UIFileNode.rect=new Rectangle((_centenPanel.mouseX-_centenPanel.bmpLevel.x)*(1/_centenPanel.scaleNum)-10,(_centenPanel.mouseY-_centenPanel.bmpLevel.y)*(1/_centenPanel.scaleNum)-10,100,80)
			UiData.nodeItem.addItem($H5UIFileNode)
			ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA));
			
		}
		private var _startSelectNodeInfo:Boolean=false //移动选取的;
		private var _selcetNodeLastMouse:Point;
		private var _menuFile:NativeMenu;
		private function startMoveNodeInfo():void
		{
		
			_selcetNodeLastMouse=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			_startSelectNodeInfo=true
			
		}
		
		protected function onStageMouseUP(event:MouseEvent):void
		{
		
			if(!isCanDo){
				return 
			}
			if(event.ctrlKey&&this.ctrlSelectNode){   //复制
			
				var $mopos:Point=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
				UiData.ctrlCopy(new Point(($mopos.x-this.lastCtrlMousePos.x)/_centenPanel.scaleNum,($mopos.y-this.lastCtrlMousePos.y)/_centenPanel.scaleNum));
				
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
				for(var i:uint=0;i<UiData.nodeItem.length;i++){
					var $h5UIFileNode:H5UIFileNode=UiData.nodeItem[i];
					if($selectRec.intersects($h5UIFileNode.rect)||(event.shiftKey&&$h5UIFileNode.select)){
						$selectNodeArr.push($h5UIFileNode)
					}
				}
				UiData.selectArr=$selectNodeArr;
				ModuleEventManager.dispatchEvent(new UiSceneEvent(UiSceneEvent.SELECT_INFO_NODE));
			
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
		private function get testInCentenPanel():Boolean
		{

		
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
		{
			_centenPanel.middleDown=false
			
		}
		
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
		
		
	
		private function resize(evt:MEventStageResize):void
		{
			if(_centenPanel){
				_centenPanel.onSize()
			}
		}		

	
		private function refreshSceneData():void
		{
			_centenPanel.resetInfoArr()
		}		
		
		public function showHide():void
		{
			if(!_centenPanel){
				_centenPanel = new DisCentenPanel;
			
			}
			//_centenPanel.init(this,"分割(E)",1);
			_centenPanel.init(this,"中",1);
			LayerManager.getInstance().addPanel(_centenPanel);
	
		}
	}
}