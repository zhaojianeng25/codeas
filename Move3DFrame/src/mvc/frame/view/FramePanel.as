package mvc.frame.view
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.collections.ArrayCollection;
	import mx.controls.List;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	import mx.events.ScrollEvent;
	
	import _me.Scene_data;
	
	import common.msg.event.hierarchy.MEvent_Hierarchy_Property_Show;
	import common.utils.frame.BaseComponent;
	import common.utils.frame.BasePanel;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	
	import mvc.frame.FrameModel;
	import mvc.frame.line.FrameLinePointVo;
	
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.pan3d.particle.ProxyPan3DParticle;
	import proxy.pan3d.roles.ProxyPan3DRole;
	import proxy.top.model.IModel;
	import proxy.top.render.Render;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.draw.TooXyzMoveData;
	
	public class FramePanel extends BasePanel
	{
		

		private var _sequenceUiPanel:SequenceUiPanel
		public function FramePanel()
		{
			super();
			this.setStyle("top",22);
			addList();
			this.addButs();
			_sequenceUiPanel=new SequenceUiPanel()
			this.addChild(_sequenceUiPanel)
			this._sequenceUiPanel.resetView();
			
			this._sequenceUiPanel.addEventListener(MouseEvent.MOUSE_WHEEL,onPanelListMouseWheel);

			this.playFrameTo(0);
			FrameModel.getInstance().framePanel=this;
			this.addMoveWeithMc();
			
		}
		private function addMoveWeithMc():void
		{
			this._moveWeithMc=new BaseComponent
			this._moveWeithMc.x=200;
			this.addChild(this._moveWeithMc)
				
			this._moveWeithMc.addEventListener(MouseEvent.MOUSE_OVER,onMoveWeithMcOver)
			this._moveWeithMc.addEventListener(MouseEvent.MOUSE_OUT,onMoveWeithMcOut)
			this._moveWeithMc.addEventListener(MouseEvent.MOUSE_DOWN,onMoveWeithMcDown)
				
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove)
				
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp)
		}		
		
		protected function onStageMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(this._moveWeight){
				var tw:Number=this.mouseX-this._mouseDownBaseX
				this._moveWeithMc.x=this._lastMoveMcX+tw;
				this._sequenceUiPanel.left=	this._moveWeithMc.x+12
				this._sequenceUiPanel.onSize(event);
			}
			
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this._moveWeight=false
		}
		
		protected function onMoveWeithMcDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this._moveWeight=true
			this._mouseDownBaseX=this.mouseX;
			this._lastMoveMcX=this._moveWeithMc.x
			
		}
		private var _mouseDownBaseX:Number;
		private var _lastMoveMcX:Number;
		private var _moveWeight:Boolean=false
		protected function onMoveWeithMcOut(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
		}
		protected function onMoveWeithMcOver(event:MouseEvent):void
		{
			Mouse.cursor = "doubelArrow";
		}
		protected function onKeyUp(event:KeyboardEvent):void
		{
			_ctrlKeyDown=false;
			_shiftKeyDown=false;
		}
		protected function onKeyDown(event:KeyboardEvent):void
		{
			_ctrlKeyDown=event.ctrlKey;
			_shiftKeyDown=event.shiftKey;
		}
		
		
		[Embed(source="assets/icon/icon_FolderClosed_dark.png")]
		private static var icon_FolderClosed_dark:Class;
		
		[Embed(source="assets/icon/LockButton_a.png")]
		private static var LockButton_a:Class;
		
		[Embed(source="assets/icon/eyeopen.png")]
		private static var eyeopen:Class;
		
		
		
		private function addButs():void
		{
			var _addFolderBut:PicBut=new PicBut
			_addFolderBut.x=100;
			_addFolderBut.y=6;
			this.addChild(_addFolderBut)
			_addFolderBut.setBitmapdata( Bitmap(new icon_FolderClosed_dark).bitmapData,18,16);
			
			_addFolderBut.addEventListener(MouseEvent.CLICK,_addFloadClik)
				
			_allLockBut=new PicBut;
			_allLockBut.x=155;
			_allLockBut.y=7;
			this.addChild(_allLockBut)
			_allLockBut.setBitmapdata(Bitmap(new LockButton_a).bitmapData,15,15);
			_allLockBut.addEventListener(MouseEvent.CLICK,_allLockButClik)
				
			_allHideBut=new PicBut;
			_allHideBut.x=175;
			_allHideBut.y=6;
			this.addChild(_allHideBut)
			_allHideBut.setBitmapdata(Bitmap(new eyeopen).bitmapData,16,16);
			_allHideBut.addEventListener(MouseEvent.CLICK,_allHideButClik)
		}
		private var allHidestatic:Boolean=true
		protected function _allHideButClik(event:MouseEvent):void
		{
			var $arr:Vector.<FrameFileNode>=FrameModel.getInstance().getAllFrameFileNode();
			for(var i:Number=0;i<$arr.length;i++){
				$arr[i].hide=this.allHidestatic
			}
			this.allHidestatic=!this.allHidestatic;
			this.refrishFrameList()
			FrameModel.getInstance().tree.selectedItems=[];
			
			this.playFrameTo(AppDataFrame.frameNum,true)
		}
		private var allLockstatic:Boolean=false
		protected function _allLockButClik(event:MouseEvent):void
		{
			var $arr:Vector.<FrameFileNode>=FrameModel.getInstance().getAllFrameFileNode();
			for(var i:Number=0;i<$arr.length;i++){
				$arr[i].lock=this.allLockstatic
				
			}
			this.allLockstatic=!this.allLockstatic
				
			this.refrishFrameList()

			
			FrameModel.getInstance().tree.selectedItems=[];
			
			FrameModel.getInstance().tree.validateNow()
		}
		
		protected function _addFloadClik(event:MouseEvent):void
		{
			var $type:FrameFileNode = new FrameFileNode;
			$type.type=FrameFileNode.Folder0
			$type.children=new ArrayCollection;
			$type.name = "newflod";
			if(FrameModel.getInstance().tree.selectedItems&&FrameModel.getInstance().tree.selectedItems.length==1){
				var $node:FrameFileNode=FrameModel.getInstance().tree.selectedItems[0] as FrameFileNode;
				if($node.type==FrameFileNode.Folder0){
					$type.parentNode=$node
					$node.children.addItem($type);
				}else{
					if($node.parentNode){
						$node.parentNode.children.addItem($type);
					
					}else{
						FrameModel.getInstance().ary.addItem($type);
					}
				}
			}else{
				FrameModel.getInstance().ary.addItem($type);
			}
			
		}
		


		public function addFrameKeyByModelChange($imode:IModel):void
		{
			var $arr:Vector.<FileNode>=	FileNodeManage.getListAllFileNode(FrameModel.getInstance().ary);
			for(var i:Number=0;i<$arr.length;i++){
				var $node:FrameFileNode=$arr[i] as FrameFileNode;
				if($node.iModel==$imode&&$node.isVisible(AppDataFrame.frameNum)){
					var $next:FrameLinePointVo=	$node.getNextFrameLinePointVoByTime(AppDataFrame.frameNum);
					var $pre:FrameLinePointVo=$node.getPreFrameLinePointVoByTime(AppDataFrame.frameNum);
					 if($next.iskeyFrame&&$pre.isAnimation){//是关键帧保持插入
						 $node.insetKey(AppDataFrame.frameNum);
					 }else{
						 if($pre.iskeyFrame){//是关键帧保持插入
							 $pre.x=$node.iModel.x
							 $pre.y=$node.iModel.y
							 $pre.z=$node.iModel.z
							 $pre.scale_x=$node.iModel.scaleX
							 $pre.scale_y=$node.iModel.scaleY
							 $pre.scale_z=$node.iModel.scaleZ
							 $pre.rotationX=$node.iModel.rotationX
							 $pre.rotationY=$node.iModel.rotationY
							 $pre.rotationZ=$node.iModel.rotationZ
						 }
					 }
					 $node.frameLineMc.refrish()
				}
			}
		}


		protected function onPanelListMouseWheel(event:MouseEvent):void
		{
			FrameModel.getInstance().getMaxLength();
			if(event.delta < 0){
				if((FrameModel.getInstance().maxLength-(FrameModel.getInstance().tree.rowCount-1)) <= FrameModel.getInstance().tree.verticalScrollPosition){
					return;
				}
				FrameModel.getInstance().tree.verticalScrollPosition ++;
			}else{
				if(FrameModel.getInstance().tree.verticalScrollPosition <= 0){
					return;
				}
				FrameModel.getInstance().tree.verticalScrollPosition --;
			}
			
			this.refrishFrameList();
			

			
		
		}
		
		private function addList():void
		{
			var _tree:Tree = new Tree;
			_tree.setStyle("top",30);
			_tree.setStyle("bottom",15);
			_tree.setStyle("left",5);
			_tree.setStyle("right",5);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.setStyle("borderVisible",false);
//			_tree.horizontalScrollPolicy = "off";
			_tree.verticalScrollPolicy = "on";
			
			this.addChild(_tree);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(FrameItemRenderer);
		//	_tree.buttonMode=false
	
		
			_tree.iconFunction = tree_iconFunc;

			_tree.addEventListener(MouseEvent.MOUSE_WHEEL,onChuange);
			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
			

			_tree.addEventListener("itemOpen",ItemEvent);
			_tree.addEventListener("itemClose",ItemEvent);
				

			FrameModel.getInstance().tree=_tree;
			FrameModel.getInstance().ary=new ArrayCollection;
			FrameModel.getInstance().tree.width=220
			FrameModel.getInstance().tree.dataProvider = FrameModel.getInstance().ary;
			FrameModel.getInstance().tree.height=FrameModel.getInstance().ary.length*20;

			FrameModel.getInstance().tree.addEventListener(ScrollEvent.SCROLL,onTreeScroll)
		}
		
		protected function onTreeScroll(event:ScrollEvent):void
		{
		
			this.refrishFrameList();
			
		}		


		public function playFrameTo($num:Number,must:Boolean=false):void
		{

			if(	AppDataFrame.frameNum!=$num||must){
				AppDataFrame.frameNum=$num;
				trace("AppDataFrame.frameNum=>",AppDataFrame.frameNum)
				this._sequenceUiPanel.playFrameTo($num);
				this.setNodeList(FrameModel.getInstance().ary,$num)
				this.refrishModel();
				MoveScaleRotationLevel.getInstance().xyzMoveData=null
			}
		}
		private function refrishModel():void
		{
		
			var $arr:Vector.<FileNode>=	FileNodeManage.getListAllFileNode(FrameModel.getInstance().ary);
			for(var i:Number=0;i<$arr.length;i++){
				var $node:FrameFileNode=	 $arr[i] as FrameFileNode;
				$node.upData()
				
			}
		}
		
			
		private function setNodeList($arr:ArrayCollection,$num:Number):void
		{
			var startId:Number=FrameModel.getInstance().tree.verticalScrollPosition;
			for(var i :Number=0;i<$arr.length;i++)
			{
				var $node:FrameFileNode=$arr[i] as FrameFileNode;
				if($node.children&&$node.children.length){
					this.setNodeList($node.children,$num);
				}else{
					if($node.type==FrameFileNode.build1){
			
						if($node.iModel as ProxyPan3dModel){
							ProxyPan3dModel($node.iModel).sprite.visible=$node.isVisible($num)
						}
						if($node.iModel as ProxyPan3DParticle){
							ProxyPan3DParticle($node.iModel).particleSprite.visible=$node.isVisible($num)
						}
						if($node.iModel as ProxyPan3DRole){
							ProxyPan3DRole($node.iModel).sprite.visible=$node.isVisible($num)
						}
					}
				}
				
			}
			
		}
		protected function ItemEvent(event:Object):void
		{
		
			this.refrishFrameList();
		}
		private function isFileNodeInArr($arr:Array,$fileNode:FileNode):Boolean
		{
			for(var i:uint=0;i<$arr.length;i++){
				if($arr[i]==$fileNode){
					return true
				}
			}
			
			return false
		}
		private var _ctrlKeyDown:Boolean=false
		private var _ctrlSelectArr:Array=new Array
		private var _shiftKeyDown:Boolean=false
		private var _shiftSelectArr:Array=new Array
		private var _sceleFrameFileNode:FrameFileNode;
		protected function onItemClik(event:ListEvent):void
		{
			FrameModel.getInstance().slectImodelTriClear();

			if(event.itemRenderer){
				_sceleFrameFileNode= event.itemRenderer.data as FrameFileNode	
				
				if(_ctrlKeyDown){  //单选添加
					
					if(isFileNodeInArr(_ctrlSelectArr,_sceleFrameFileNode))
					{
						for(var j:uint=0;j<_ctrlSelectArr.length;j++){
							if(_ctrlSelectArr[j]==_sceleFrameFileNode){
								_ctrlSelectArr.splice(j,1)
							}
						}
					}else{
						_ctrlSelectArr.push(_sceleFrameFileNode)
					}
					xuanQuFileNode(_ctrlSelectArr)
					
				}else if(_shiftKeyDown){  //复选
					if(!isFileNodeInArr(_shiftSelectArr,_sceleFrameFileNode))
					{
						if(_shiftSelectArr.length>1){
							_shiftSelectArr[1]=_sceleFrameFileNode
						}else{
							_shiftSelectArr.push(_sceleFrameFileNode)
						}
					}
					if(_shiftSelectArr.length==2){
						_ctrlSelectArr=getShiftArr(_shiftSelectArr)
						xuanQuFileNode(_ctrlSelectArr)
					}
				}else{
					_ctrlSelectArr=new Array
					_ctrlSelectArr.push(_sceleFrameFileNode)
					_shiftSelectArr=new Array
					_shiftSelectArr.push(_sceleFrameFileNode)
					
					var $itemArr:Vector.<FileNode>=FileNodeManage.getChildeFileNode(_sceleFrameFileNode)
					var $earr:Array=new Array
					for(var i:uint=0;i<$itemArr.length;i++){
						$earr.push($itemArr[i])
					}
					
					xuanQuFileNode($earr,false,false,_sceleFrameFileNode.type)
					singleSelect=true
				}
	  
				if(!_sceleFrameFileNode.rename){
					Scene_data.stage.focus=this.stage
				}
			}
		


		}
		
		public var singleSelect:Boolean=false  //是否为单选
		private var _allHideBut:PicBut;
		private var _allLockBut:PicBut;
		private var _moveWeithMc:BaseComponent;
		private function getShiftArr($arr:Array):Array
		{
			
			var $selectItem:Array=new Array
			
			if($arr.length==1){
				$selectItem=$arr;
			}
			var $isTure:Boolean=false
			if($arr.length==2){
				var $fileNodeArr:Vector.<FrameFileNode>=getListAllFileNode(FrameModel.getInstance().ary)
				for(var i:uint=0;i<$fileNodeArr.length;i++){
					
					for(var j:uint=0;j<$arr.length;j++){
						if($fileNodeArr[i]==$arr[j]){
							$isTure=!$isTure
							if(!$isTure){  //结束的最后一个也要添加
								$selectItem.push($fileNodeArr[i])
							}
						}
					}
					if($isTure){//在范围内的也要添加
						$selectItem.push($fileNodeArr[i])
					}
					
					
				}
			}
			
			return $selectItem
			
		}
		private function getListAllFileNode($childItem:ArrayCollection):Vector.<FrameFileNode>
		{
			var $arr:Vector.<FrameFileNode>=new Vector.<FrameFileNode>
			for(var i:uint=0;$childItem&&i<$childItem.length;i++){
				var $FrameFileNode:FrameFileNode=$childItem[i] as FrameFileNode
				$arr.push($FrameFileNode)
				$arr=$arr.concat(getListAllFileNode($FrameFileNode.children))
				
			}
			return $arr
		}
		
		public function xuanQuFileNode($arr:Array,$shiftKey:Boolean=false,slect:Boolean=true,$selectType:uint=0):void
		{
			singleSelect=false
			var $itemArr:Array=new Array
			if($shiftKey){
				$itemArr=FrameModel.getInstance().tree.selectedItems
				for(var j:uint=0;j<$arr.length;j++){
					var $needAdd:Boolean=true
					for(var k:uint=0;k<$itemArr.length;k++){
						if($itemArr[k]==$arr[j]){//已有
							$needAdd=false
						}
					}
					if($needAdd){
						$itemArr.push($arr[j])
					}
				}
			}else{
				$itemArr=$arr
			}
	
			$itemArr=FrameModel.getInstance().getNoLockItem($itemArr)
			
			var $iModelArr:Vector.<IModel>=new Vector.<IModel>
			for(var i:uint=0;i<$itemArr.length;i++){
				if(FrameFileNode($itemArr[i]).iModel){
					$iModelArr.push(FrameFileNode($itemArr[i]).iModel)
				}
			}
			if($iModelArr.length){
				xyzPosMoveItem($iModelArr,$selectType)
			}
			if(slect){
				FrameModel.getInstance().tree.selectedItems=$itemArr
			}
			_ctrlSelectArr=FrameModel.getInstance().tree.selectedItems
				
			this.drawSelectBack()
	
			
		}
		private function drawSelectBack():void
		{
		
			var $arr:Vector.<FrameFileNode>=	FrameModel.getInstance().getAllFrameFileNode();
			for(var i:Number=0;i<$arr.length;i++){
				$arr[i].select=false
				for(var j:Number=0;j<FrameModel.getInstance().tree.selectedItems.length;j++){
					if($arr[i]==FrameModel.getInstance().tree.selectedItems[j]){
					  $arr[i].select=true;
					}
				}
				$arr[i].frameLineMc.refrish()
			}
			
		}
		public function xyzPosMoveItem($iModelArr:Vector.<IModel>,$selectType:uint=0):void
		{
			
			
			FrameModel.getInstance().slectImodelTriClear();
			
			for(var i:uint=0;i<$iModelArr.length;i++){
				$iModelArr[i].select=true
			}


			var $tooXyzMoveData:TooXyzMoveData=Render.xyzPosMoveItem($iModelArr);
			var $evt:MEvent_Hierarchy_Property_Show=new MEvent_Hierarchy_Property_Show(MEvent_Hierarchy_Property_Show.MEVENT_HIERARCHY_PROPERTY_SHOW)
			$evt.modeItem=$iModelArr;
			$evt.selectType=$selectType
			$evt.tooXyzMoveData=$tooXyzMoveData;
			ModuleEventManager.dispatchEvent($evt);
			
		}


		protected function onChuange(event:MouseEvent):void
		{
			this.refrishFrameList();	
				
		}
	    public function refrishFrameList():void
		{
			this._sequenceUiPanel.resetView();
			this.refrishModel();
		}
		private function tree_iconFunc(item:FrameFileNode):Class {  
	
			if(item.children){
				return BrowerManage.getIconClassByName("icon_FolderOpen_dark");
			}else{
				if(item.type==FrameFileNode.build1){
					if(item.hide){
						return BrowerManage.getIconClassByName("hideIcon20");
					}
					if(item.lock){
						return BrowerManage.getIconClassByName("iconlock");
					}else{
						return BrowerManage.getIconClassByName("table_16");
					}
		
				
				}
				return BrowerManage.getIconClassByName("table_16");
			}
		}  
		override public function onSize(event:Event= null):void
		{
			this.height=Math.min(event.target.height,800);
	
			this.refrishFrameList();
	
			this._moveWeithMc.graphics.clear();
			this._moveWeithMc.graphics.beginFill(0xff0000,0.0);
			this._moveWeithMc.graphics.drawRect(0,0,12,this.height);
			this._moveWeithMc.graphics.endFill();

			this._sequenceUiPanel.left=	this._moveWeithMc.x+12
			this._sequenceUiPanel.onSize(event);
		}

		
	
		

		public function downKeyBoardF():void
		{
			// TODO Auto Generated method stub
			this._sequenceUiPanel.downKeyBoardF()
		}
	}
}


