package mvc.centen.panelcenten
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import spark.components.RichEditableText;
	import spark.skins.spark.WindowedApplicationSkin;
	
	import _me.Scene_data;
	
	import manager.LayerManager;
	
	import mesh.H5UIMetaDataView;
	import mesh.PanelRectGroupMesh;
	import mesh.PanelRectInfoButtonMesh;
	import mesh.PanelRectInfoPictureMesh;
	import mesh.PanelSceneMesh;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.left.panelleft.PanelLeftEvent;
	import mvc.left.panelleft.PanelModel;
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.left.panelleft.vo.PanelRectInfoNode;
	import mvc.left.panelleft.vo.PanelRectInfoSprite;
	import mvc.left.panelleft.vo.PanelRectInfoType;
	import mvc.scene.UiSceneEvent;
	
	import vo.H5UIFileNode;
	import vo.InfoDataSprite;
	
	public class PanelCentenProcessor extends Processor
	{
		private var _panelCentenView:PanelCentenView;
		public function PanelCentenProcessor($module:Module)
		{
			super($module);
			initData()
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				
				
				case UiSceneEvent:
					if($me.action==UiSceneEvent.SHOW_HIDE_LINE){
			
						if(_panelCentenView.panelCentenInfoLevel){
							_panelCentenView.panelCentenInfoLevel.showHideLine()
						}
							
						//
					}
					break;
				
				case PanelLeftEvent:
					if($me.action==PanelLeftEvent.SHOW_LEFT){
						
					}
					if($me.action==PanelLeftEvent.SELECT_PANEL_NODEVO){
						showUiPanel();
						setPanelNodeVo(PanelLeftEvent($me).panelNodeVo)
					}
					if($me.action==PanelLeftEvent.DELE_PANEL_RECT_NODE_INFO_VO){
						delePanelRectInfoNode(PanelLeftEvent($me).panelRectInfoNode)
					}
					break;
				case PanelCentenEvent:
					
					if($me.action==PanelCentenEvent.SELECT_PANEL_INFO_NODE){
						selectInfoNode(PanelCentenEvent($me))
					}
					if($me.action==PanelCentenEvent.PANEL_RECT_INFO_START_MOVE){
						startMoveNodeInfo()
					}
					if($me.action==PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SIZE_VIEW){
						refreshPanelInofView()
					}
					break;
				
			}
		}
		private function initData():void
		{
			Scene_data.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,onMiddleUp)
			Scene_data.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,onMiddleDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
				
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUP)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onStageKeyDown)	;
			Scene_data.stage.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			Scene_data.stage.addEventListener(MouseEvent.CLICK,onStageClik);

			initMenuFile()
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(!isCanDo){
				return ;
			}
			if(event.target as Sprite){
				if(Sprite(event.target).parent as PanelRectInfoSprite ){
					if(event.ctrlKey){
						this.getCtrlCopyItem(Sprite(event.target).parent as PanelRectInfoSprite)
					}
					
					return ;
				}
			}
			if(testInCentenPanel){
				_panelCentenView.beginDrawLine()
			}
			
			
		}
		private var  ctrlSelectNode:PanelRectInfoNode;
		private var lastCtrlMousePos:Point;
		private function getCtrlCopyItem($dis:PanelRectInfoSprite):void
		{
			
			this.ctrlSelectNode=null
			this.lastCtrlMousePos=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			for(var i:uint=0;i<_panelCentenView.selectArr.length;i++){
				var $panelRectInfoNode:PanelRectInfoNode=_panelCentenView.selectArr[i];
				if($panelRectInfoNode.sprite==$dis){
					trace("准备复制",$panelRectInfoNode.name)
					this.ctrlSelectNode=$panelRectInfoNode
				}
				
			}
		}
		protected function onStageClik(event:MouseEvent):void
		{
			if(!isCanDo){
				return ;
			}
			if(Boolean(event.target as WindowedApplicationSkin)){
				
				var $PanelLeftEvent:PanelLeftEvent=new PanelLeftEvent(PanelLeftEvent.SELECT_PANEL_NODEVO)
				$PanelLeftEvent.panelNodeVo=_panelCentenView.panelNodeVo;
				ModuleEventManager.dispatchEvent($PanelLeftEvent);
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
		public function initMenuFile():void{
			
			
			
			_menuFile = new NativeMenu;
			var newtypefile:NativeMenu = new NativeMenu;
			var item:NativeMenuItem;
			
			
			
			item = new NativeMenuItem("添加图片")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,addNewRectPic);
			
			item = new NativeMenuItem("添加按钮")
			_menuFile.addItem(item);
			item.addEventListener(Event.SELECT,addNewRectBut);
			
	
			
		}
		
		protected function addNewRectBut(event:Event):void
		{
			var pos:Point=new Point(_panelCentenView.mouseX,_panelCentenView.mouseY)
			pos.x=pos.x-_panelCentenView.PexilX
			pos.y=pos.y-_panelCentenView.PexilY
			pos.x=pos.x/_panelCentenView.scaleNum
			pos.y=pos.y/_panelCentenView.scaleNum
				
				
			PanelModel.getInstance().panelNodeVoAddInfoNode(_panelCentenView.panelNodeVo,pos,PanelRectInfoType.BUTTON)
			var $PanelLeftEvent:PanelLeftEvent=new PanelLeftEvent(PanelLeftEvent.SELECT_PANEL_NODEVO)
			$PanelLeftEvent.panelNodeVo=_panelCentenView.panelNodeVo;
			ModuleEventManager.dispatchEvent($PanelLeftEvent);
		}
		
		protected function addNewRectPic(event:Event):void
		{
			var pos:Point=new Point(_panelCentenView.mouseX,_panelCentenView.mouseY)
			pos.x=pos.x-_panelCentenView.PexilX
			pos.y=pos.y-_panelCentenView.PexilY
			pos.x=pos.x/_panelCentenView.scaleNum
			pos.y=pos.y/_panelCentenView.scaleNum
			
			
			
		
		
			PanelModel.getInstance().panelNodeVoAddInfoNode(_panelCentenView.panelNodeVo,pos,PanelRectInfoType.PICTURE)
			var $PanelLeftEvent:PanelLeftEvent=new PanelLeftEvent(PanelLeftEvent.SELECT_PANEL_NODEVO)
			$PanelLeftEvent.panelNodeVo=_panelCentenView.panelNodeVo;
			ModuleEventManager.dispatchEvent($PanelLeftEvent);
			
		}
		private function selectAll():void
		{
			var $selectNodeArr:Vector.<PanelRectInfoNode>=new Vector.<PanelRectInfoNode>
			for(var i:uint=0;i<_panelCentenView.nodeItem.length;i++){
				var $PanelRectInfoNode:PanelRectInfoNode=_panelCentenView.nodeItem[i];
				$selectNodeArr.push($PanelRectInfoNode)
			}
			_panelCentenView.selectArr=$selectNodeArr
			ModuleEventManager.dispatchEvent(new PanelCentenEvent(PanelCentenEvent.SELECT_PANEL_INFO_NODE));
			
		}
		protected function onStageKeyDown(event:KeyboardEvent):void
		{
			if(!isCanDo){
				return 
			}

	
		
			if(!Boolean(event.target is RichEditableText))
			{
				if(event.ctrlKey){
					if(event.keyCode==Keyboard.UP){
						changeLevelUp();
					}
					if(event.keyCode==Keyboard.DOWN){
						changeLevelDown();
					}
					if(event.keyCode==Keyboard.C){
						_panelCentenView.makeCopy();
					}
					if(event.keyCode==Keyboard.A){
						selectAll()
					}
					if(event.keyCode==Keyboard.V){
						if(_panelCentenView.paste()){
							var $CentenEvent:PanelCentenEvent=new PanelCentenEvent(PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SELECT_ITEM)
							$CentenEvent.selectItem=_panelCentenView.selectArr
							ModuleEventManager.dispatchEvent($CentenEvent);
						}
						
						
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
					if(event.keyCode==Keyboard.DELETE){
						deleSelectPanelInfoNode()
					}
				}
				
			}
			

			
			
		}
		private var willDeleItem:Vector.<PanelRectInfoNode>
		private function deleSelectPanelInfoNode():void
		{
			if(_panelCentenView.selectArr&&_panelCentenView.selectArr.length){
				willDeleItem=new Vector.<PanelRectInfoNode>
				for(var i:uint=0;i<_panelCentenView.selectArr.length;i++)
				{
					willDeleItem.push(_panelCentenView.selectArr[i])
				}
				
				Alert.show("是否确定删除？","删除",3,_panelCentenView,function deleteCallBack(event:CloseEvent):void
				{
					if(event.detail == Alert.YES)
					{
						deleRectInfoNode(willDeleItem)
						_panelCentenView.selectArr=new Vector.<PanelRectInfoNode>
					}
					
				});
			}
		}

		private function deleRectInfoNode(arr:Vector.<PanelRectInfoNode>):void
		{
			for(var j:uint=0;arr&&j<arr.length;j++)
			{
				var panelRectInfoNode:PanelRectInfoNode=arr[j]
				
				for(var i:uint=0;i<_panelCentenView.panelNodeVo.item.length;i++){
					if(_panelCentenView.panelNodeVo.item[i]==panelRectInfoNode){
						_panelCentenView.panelNodeVo.item.removeItemAt(i)
					}
				}
			}
			var $PanelLeftEvent:PanelLeftEvent=new PanelLeftEvent(PanelLeftEvent.SELECT_PANEL_NODEVO)
			$PanelLeftEvent.panelNodeVo=_panelCentenView.panelNodeVo;
			ModuleEventManager.dispatchEvent($PanelLeftEvent);
			arr=new Vector.<PanelRectInfoNode>
		
		}
			

		
		private function tureSelecMove($tx:int, $ty:int):void
		{
			for(var i:uint=0;_panelCentenView.selectArr&&i<_panelCentenView.selectArr.length;i++)
			{
				_panelCentenView.selectArr[i].rect.x+=$tx
				_panelCentenView.selectArr[i].rect.y+=$ty
				_panelCentenView.selectArr[i].sprite.changeSize();
			}
			
		}
		
		private function changeLevelDown():void
		{
			for(var i:uint=0;_panelCentenView.selectArr&&i<_panelCentenView.selectArr.length;i++)
			{
				var $parent:DisplayObjectContainer=_panelCentenView.selectArr[i].sprite.parent;
				if($parent){
					var num:int=$parent.getChildIndex(_panelCentenView.selectArr[i].sprite)
					if(num>0){
						$parent.setChildIndex(_panelCentenView.selectArr[i].sprite,num-1)
					}
				}
			}
			_panelCentenView.changePanelInfoLevel()
		}
		
		private function changeLevelUp():void
		{
			for(var i:uint=0;_panelCentenView.selectArr&&i<_panelCentenView.selectArr.length;i++)
			{
				var $parent:DisplayObjectContainer=_panelCentenView.selectArr[i].sprite.parent;
				if($parent){
					var num:int=$parent.getChildIndex(_panelCentenView.selectArr[i].sprite)
					if(num<($parent.numChildren-1)){
						$parent.setChildIndex(_panelCentenView.selectArr[i].sprite,num+1)
					}						
				}
			}

			_panelCentenView.changePanelInfoLevel()
		}
		

		
		protected function onMouseWheel(event:MouseEvent):void
		{
			if(!isCanDo){
				return 
			}
			if(testInCentenPanel){
				if(event.delta>0){
					_panelCentenView.KeyAdd()
				}else{
					_panelCentenView.KeySub()
				}
			}
			
			
		}
		protected function onMiddleUp(event:MouseEvent):void
		{
			if(!isCanDo){
			   return 
			}
			
			_panelCentenView.middleDown=false
			
		}
		protected function onMiddleDown(event:MouseEvent):void
		{
			if(!isCanDo){
			   return ;
			}
			if(testInCentenPanel){
				_panelCentenView.middleDown=true
			}
			
		}
		private function get testInCentenPanel():Boolean
		{
			
			var pos:Point	=_panelCentenView.localToGlobal(new Point);
			var rect:Rectangle=new Rectangle();
			rect.x=pos.x
			rect.y=pos.y
			rect.width=_panelCentenView.width;
			rect.height=_panelCentenView.height;
			
			var mousePos:Point=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			
			if(mousePos.x>rect.x&&mousePos.y>rect.y&&mousePos.x<(rect.x+rect.width)&&mousePos.y<(rect.y+rect.height)){
				return true
			}else{
				return false
			}
			
			
		}
		
		protected function onStageMouseUP(event:MouseEvent):void
		{
			if(!isCanDo){
				return 
			}
			if(event.ctrlKey&&this.ctrlSelectNode){   //复制
				
				var $mopos:Point=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
				_panelCentenView.ctrlCopy(new Point(($mopos.x-this.lastCtrlMousePos.x)/_panelCentenView.scaleNum,($mopos.y-this.lastCtrlMousePos.y)/_panelCentenView.scaleNum));
				
				return 
			}
			if(_startSelectNodeInfo){
				for(var i:uint=0;i<_panelCentenView.selectArr.length;i++){
					var $h5UIFileNode:PanelRectInfoNode=_panelCentenView.selectArr[i];
					$h5UIFileNode.sprite.x=int($h5UIFileNode.sprite.x)
					$h5UIFileNode.sprite.y=int($h5UIFileNode.sprite.y)
					$h5UIFileNode.rect.x=$h5UIFileNode.sprite.x
					$h5UIFileNode.rect.y=$h5UIFileNode.sprite.y
				}
				_startSelectNodeInfo=false;
				
				refreshPanelInofView()
			}else{
			
				findSelectNode(event)
			}
			_panelCentenView.endDrawLine()
			
		}
		
		private function findSelectNode(event:MouseEvent):void
		{
			if(_panelCentenView.beginLinePoin){  //说明是框选
				var $selectNodeArr:Vector.<PanelRectInfoNode>=new Vector.<PanelRectInfoNode>
				var a:Point=_panelCentenView.beginLinePoin
				var b:Point=new Point(_panelCentenView.mouseX,_panelCentenView.mouseY)
				var $selectRec:Rectangle=new Rectangle();
				var cavanPos:Point=_panelCentenView.getBmpPostion()
				var anum:Number=1/_panelCentenView.scaleNum
				$selectRec.x=(Math.min(a.x,b.x)-cavanPos.x)*anum
				$selectRec.y=(Math.min(a.y,b.y)-cavanPos.y)*anum
				$selectRec.width=Math.abs(a.x-b.x)*anum
				$selectRec.height=Math.abs(a.y-b.y)*anum
					
					
				for(var i:uint=0;i<_panelCentenView.nodeItem.length;i++){
					var $PanelRectInfoNode:PanelRectInfoNode=_panelCentenView.nodeItem[i];
					if($selectRec.intersects($PanelRectInfoNode.rect)||(event.shiftKey&&$PanelRectInfoNode.select)){
						$selectNodeArr.push($PanelRectInfoNode)
					}
				}
				_panelCentenView.selectArr=$selectNodeArr

					
		
				ModuleEventManager.dispatchEvent(new PanelCentenEvent(PanelCentenEvent.SELECT_PANEL_INFO_NODE));
			
				
			}
			
		}
		
		private function get isCanDo():Boolean
		{
			if(UiData.editMode==1){
				
				return true
			}else{
				return false
			}
		}
		protected function onMouseMove(event:MouseEvent):void
		{
			if(!isCanDo){
				return 
			}
			_panelCentenView.mouseMove()
			if(_startSelectNodeInfo){
				//_selcetNodeLastMouse=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
				var addPos:Point=new Point;
				addPos.x=Scene_data.stage.mouseX-_selcetNodeLastMouse.x
				addPos.y=Scene_data.stage.mouseY-_selcetNodeLastMouse.y
				for(var i:uint=0;i<_panelCentenView.selectArr.length;i++){
					var $h5UIFileNode:PanelRectInfoNode=_panelCentenView.selectArr[i];
					$h5UIFileNode.sprite.x=$h5UIFileNode.rect.x+addPos.x/_panelCentenView.scaleNum
					$h5UIFileNode.sprite.y=$h5UIFileNode.rect.y+addPos.y/_panelCentenView.scaleNum
				}

			}else{
				_panelCentenView.drawSelectLine()
			}
			
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				PanelCentenEvent,
				DisCentenEvent,
				PanelLeftEvent,
				UiSceneEvent,
				
				
			]
		}
		
		private function delePanelRectInfoNode(panelRectInfoNode:PanelRectInfoNode):void
		{
			var arr:Vector.<PanelRectInfoNode>=new Vector.<PanelRectInfoNode>
			arr.push(panelRectInfoNode)
			deleRectInfoNode(arr)
			

		}
		
		private function showPanelSceneMesh(panelNodeVo:PanelNodeVo):void
		{

			if(!_panelSceneMeshView){
				_panelSceneMeshView = new H5UIMetaDataView();
				_panelSceneMeshView.init(this,"属性",2);
				_panelSceneMeshView.creatByClass(PanelSceneMesh);
				
			}
			var $PanelSceneMesh:PanelSceneMesh=new PanelSceneMesh
			$PanelSceneMesh.panelNodeVo=panelNodeVo
			_panelSceneMeshView.setTarget($PanelSceneMesh);
			LayerManager.getInstance().addPanel(_panelSceneMeshView);
			$PanelSceneMesh.addEventListener(Event.CHANGE,panelSceneMeshChange)
			
		}
		
		protected function panelSceneMeshChange(event:Event):void
		{
			_panelCentenView.changeData()
		}
		
		private function refreshPanelInofView():void
		{
			if(_panelRectInfoPicMeshView){
				_panelRectInfoPicMeshView.refreshView()
			}
			if(_panelRectInfoButtonMeshView){
				_panelRectInfoButtonMeshView.refreshView()
			}
		
			
		}
		private var _startSelectNodeInfo:Boolean=false //移动选取的;
		private var _selcetNodeLastMouse:Point;
		private var _panelRectInfoPicMeshView:H5UIMetaDataView;
		private var _panelSceneMeshView:H5UIMetaDataView;
		private var _menuFile:NativeMenu;
		private var _panelRectInfoGroupMeshView:H5UIMetaDataView;
		private var _panelRectInfoButtonMeshView:H5UIMetaDataView;

		private function startMoveNodeInfo():void
		{
			
			_selcetNodeLastMouse=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			_startSelectNodeInfo=true
			
		}
		private function selectInfoNode($centenEvent:PanelCentenEvent):void
		{
		
			if(!_panelCentenView.selectArr){
				_panelCentenView.selectArr=new Vector.<PanelRectInfoNode>;
			}
			if($centenEvent.panelRectInfoNode){
				if($centenEvent.ctrlKey){
					_panelCentenView.selectArr=new Vector.<PanelRectInfoNode>;
					_panelCentenView.selectArr.push($centenEvent.panelRectInfoNode)
					
				}else if($centenEvent.shiftKey){
					clearSelectNode($centenEvent.panelRectInfoNode)
					if(!$centenEvent.panelRectInfoNode.select){
						_panelCentenView.selectArr.push($centenEvent.panelRectInfoNode)
					}
					
				}else{
					_panelCentenView.selectArr=new Vector.<PanelRectInfoNode>;
					_panelCentenView.selectArr.push($centenEvent.panelRectInfoNode)
				}
				
			}
	
			
			
			
			for(var i:uint=0;i<_panelCentenView.nodeItem.length;i++){
				var has:Boolean=false;
				for(var j:uint=0;j<_panelCentenView.selectArr.length;j++){
					if(PanelRectInfoNode(_panelCentenView.nodeItem[i])==_panelCentenView.selectArr[j]){
						has=true;
					}
				}
				PanelRectInfoNode(_panelCentenView.nodeItem[i]).select=has;
				PanelRectInfoNode(_panelCentenView.nodeItem[i]).sprite.updata();
			}
			
			
			if(_panelCentenView.selectArr&&_panelCentenView.selectArr.length==1){
				if(_panelCentenView.selectArr[0].type==PanelRectInfoType.PICTURE){
					showPanelRectInfoNode(_panelCentenView.selectArr[0])
				}
				if(_panelCentenView.selectArr[0].type==PanelRectInfoType.BUTTON){
					showPanelRectInfoNodeButton(_panelCentenView.selectArr[0])
				}
				
			}
			if(_panelCentenView.selectArr&&_panelCentenView.selectArr.length>1){
				showPanelRectInfoNodeGroup(_panelCentenView.selectArr)
			}
			
			
			var $CentenEvent:PanelCentenEvent=new PanelCentenEvent(PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SELECT_ITEM)
			$CentenEvent.selectItem=_panelCentenView.selectArr
			ModuleEventManager.dispatchEvent($CentenEvent);
		}
		
		private function showPanelRectInfoNodeButton($PanelRectInfoNode:PanelRectInfoNode):void
		{
			if($PanelRectInfoNode.type==PanelRectInfoType.BUTTON){
				if(!_panelRectInfoButtonMeshView){
					_panelRectInfoButtonMeshView = new H5UIMetaDataView();
					_panelRectInfoButtonMeshView.init(this,"属性",2);
					_panelRectInfoButtonMeshView.creatByClass(PanelRectInfoButtonMesh);
					
				}
				var $PanelRectInfoButtonMesh:PanelRectInfoButtonMesh=new PanelRectInfoButtonMesh
				$PanelRectInfoButtonMesh.panelRectInfoNode=$PanelRectInfoNode
				_panelRectInfoButtonMeshView.setTarget($PanelRectInfoButtonMesh);
				LayerManager.getInstance().addPanel(_panelRectInfoButtonMeshView);
				$PanelRectInfoButtonMesh.addEventListener(Event.CHANGE,panelRectInfoButtonMeshChange)
			}
			
		}
		
		protected function panelRectInfoButtonMeshChange(event:Event):void
		{
			var $PanelRectInfoButtonMesh:PanelRectInfoButtonMesh=PanelRectInfoButtonMesh(event.target);
			$PanelRectInfoButtonMesh.panelRectInfoNode.sprite.updata();
			
		}
		
		private function showPanelRectInfoNodeGroup(selectArr:Vector.<PanelRectInfoNode>):void
		{
			if(!_panelRectInfoGroupMeshView){
				_panelRectInfoGroupMeshView = new H5UIMetaDataView();
				_panelRectInfoGroupMeshView.init(this,"属性",2);
				_panelRectInfoGroupMeshView.creatByClass(PanelRectGroupMesh);
				
			}
			var $PanelRectGroupMesh:PanelRectGroupMesh=new PanelRectGroupMesh
			$PanelRectGroupMesh.selectItem=selectArr
			_panelRectInfoGroupMeshView.setTarget($PanelRectGroupMesh);
			LayerManager.getInstance().addPanel(_panelRectInfoGroupMeshView);

		}		
	
		
//		PanelRectGroupMesh
		
		private function showPanelRectInfoNode($PanelRectInfoNode:PanelRectInfoNode):void
		{
			if($PanelRectInfoNode.type==PanelRectInfoType.PICTURE){
				if(!_panelRectInfoPicMeshView){
					_panelRectInfoPicMeshView = new H5UIMetaDataView();
					_panelRectInfoPicMeshView.init(this,"属性",2);
					_panelRectInfoPicMeshView.creatByClass(PanelRectInfoPictureMesh);
					
				}
				var $PanelRectInfoMesh:PanelRectInfoPictureMesh=new PanelRectInfoPictureMesh
				$PanelRectInfoMesh.panelRectInfoNode=$PanelRectInfoNode
				_panelRectInfoPicMeshView.setTarget($PanelRectInfoMesh);
				LayerManager.getInstance().addPanel(_panelRectInfoPicMeshView);
				$PanelRectInfoMesh.addEventListener(Event.CHANGE,panelRectInfoMeshChange)
			}
			
		}
		
		protected function panelRectInfoMeshChange(event:Event):void
		{
			var $PanelRectInfoMesh:PanelRectInfoPictureMesh=PanelRectInfoPictureMesh(event.target);
			$PanelRectInfoMesh.panelRectInfoNode.sprite.updata();
			
			
		}
		private function clearSelectNode($node:PanelRectInfoNode):void
		{ 
			for(var i:uint=0;i<_panelCentenView.selectArr.length;i++){
				
				if($node==_panelCentenView.selectArr[i]){
					_panelCentenView.selectArr.splice(i,1)
					break;
				}
			}
		}
		
		private function setPanelNodeVo(panelNodeVo:PanelNodeVo):void
		{
	
			_panelCentenView.panelNodeVo=panelNodeVo;
			showPanelSceneMesh(panelNodeVo)
			
			
		
		}
		
		private function showUiPanel():void
		{
			if(!_panelCentenView){
				_panelCentenView = new PanelCentenView;
				
			}
			//_centenPanel.init(this,"面板(E)",1);
			_panelCentenView.init(this,"中",1);
			LayerManager.getInstance().addPanel(_panelCentenView);
			
		}
	}
}