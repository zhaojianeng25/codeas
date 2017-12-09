package mvc.libray
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	
	import PanV2.loadV2.BmpLoad;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.utils.frame.BasePanel;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	import common.utils.ui.prefab.PicBut;
	
	import flashx.textLayout.tlf_internal;
	
	import modules.brower.fileWin.BrowerManage;
	
	import proxy.top.model.IModel;
	
	public class LibraryPanel extends BasePanel
	{
		private var _bg:UIComponent;
	


		private var _iconBmp:Bitmap;
		public function LibraryPanel()
		{
			super();
			var $iconbg:UIComponent=new UIComponent();

			this.addChild($iconbg)
				
			this._iconBmp=new Bitmap()
			$iconbg.addChild(this._iconBmp);
			this.addList()	;

			LibrayModel.getInstance().librayTree.dataProvider =LibrayModel.getInstance().librayArr
				
			this.addButs();
				
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp)
		}
	
		private function addButs():void
		{
			var _addFload:PicBut=new PicBut
			_addFload.x=10;
			_addFload.y=5;
			this.addChild(_addFload)
			_addFload.setBitmapdata(BrowerManage.getIcon("cylinder001"),20,20);
			
			_addFload.addEventListener(MouseEvent.CLICK,_addFloadClik)
			
			var _addFrameNodeBut:PicBut=new PicBut
			_addFrameNodeBut.x=40;
			_addFrameNodeBut.y=5;
			this.addChild(_addFrameNodeBut)
			_addFrameNodeBut.setBitmapdata(BrowerManage.getIcon("Plane001"),20,20);
			_addFrameNodeBut.addEventListener(MouseEvent.CLICK,_addFrameNodeButClik)
				
			_addFrameNodeBut.bottom=50-5
			_addFload.bottom=50-5
		}
		protected function _addFloadClik(event:MouseEvent):void
		{
			LibrayModel.getInstance().addfolder()
			
		}
		protected function _addFrameNodeButClik(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			LibrayModel.getInstance().addFiles();
			
		}
		private var _ctrlKeyDown:Boolean=false
		private var _ctrlSelectArr:Array=new Array
		private var _shiftKeyDown:Boolean=false
		private var _shiftSelectArr:Array=new Array
			
			
		protected function onKeyUp(event:KeyboardEvent):void
		{
			_ctrlKeyDown=false
			_shiftKeyDown=false
		}
		protected function onKeyDown(event:KeyboardEvent):void
		{
			
			_ctrlKeyDown=event.ctrlKey
			_shiftKeyDown=event.shiftKey
			
			
			if(event.keyCode==27 ||event.keyCode==Keyboard.Q){
				LibrayModel.getInstance().librayTree.selectedItems=[];

			}
			
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
		private var _sceleLibrayFildNode:LibrayFildNode;
		
		private function setIconBmp($node:LibrayFildNode):void
		{
			_iconBmp.bitmapData=new BitmapData(128,128,true,0x00000000);
			var $urlItem:Vector.<String>=new Vector.<String>
			if($node.type==LibrayFildNode.Pefrab_TYPE1){
				$urlItem.push($node.url)
			}else{
				for(var i:Number=0;i<$node.children.length;i++)
				{
					var $ce:LibrayFildNode=$node.children[i]
					if($ce.type==LibrayFildNode.Pefrab_TYPE1){
						$urlItem.push($ce.url)
					}
				}
			}
			if($urlItem.length){
				this.drawIconToBmp($urlItem)
			}
		}
		private function drawIconToBmp($urlItem:Vector.<String>):void
		{
		
			var $num:Number=Math.ceil(Math.sqrt($urlItem.length));
			for(var i:Number=0;i<$urlItem.length;i++){
				var $file:File=new File($urlItem[i])
				if($file.exists){
					var $diskRendUrl:String=$file.url.replace(AppData.workSpaceUrl,"")
					$diskRendUrl=$diskRendUrl.replace("."+$file.extension,$file.extension+".jpg")
					var $bmpUrl:String=File.desktopDirectory.url+"/world/"+$diskRendUrl;
				
					BmpLoad.getInstance().addSingleLoad($bmpUrl,function ($bitmap:Bitmap,$obj:Object):void{
						//_iconBmp.bitmapData=$bitmap.bitmapData
						var $backId:Number=Number($obj)
						var $m:Matrix=new Matrix()
						$m.scale((_iconBmp.bitmapData.width/$num)/$bitmap.bitmapData.width,(_iconBmp.bitmapData.height/$num)/$bitmap.bitmapData.height)
						$m.tx=($backId%$num)*(_iconBmp.bitmapData.width/$num)
						$m.ty=Math.floor($backId/$num)*(_iconBmp.bitmapData.height/$num)

						_iconBmp.bitmapData.draw($bitmap.bitmapData,$m)
					},i)
				}
			
			}

		
		}
		protected function onItemClik(event:ListEvent):void
		{

			if(event.itemRenderer){
				_sceleLibrayFildNode= event.itemRenderer.data as LibrayFildNode	
			
				this.setIconBmp(_sceleLibrayFildNode)
		
				if(_ctrlKeyDown){  //单选添加
					
					if(isFileNodeInArr(_ctrlSelectArr,_sceleLibrayFildNode))
					{
						for(var j:uint=0;j<_ctrlSelectArr.length;j++){
							if(_ctrlSelectArr[j]==_sceleLibrayFildNode){
								_ctrlSelectArr.splice(j,1)
							}
						}
					}else{
						_ctrlSelectArr.push(_sceleLibrayFildNode)
					}
					xuanQuFileNode(_ctrlSelectArr)
					
				}else if(_shiftKeyDown){  //复选
					if(!isFileNodeInArr(_shiftSelectArr,_sceleLibrayFildNode))
					{
						if(_shiftSelectArr.length>1){
							_shiftSelectArr[1]=_sceleLibrayFildNode
						}else{
							_shiftSelectArr.push(_sceleLibrayFildNode)
						}
					}
					if(_shiftSelectArr.length==2){
						_ctrlSelectArr=getShiftArr(_shiftSelectArr)
						xuanQuFileNode(_ctrlSelectArr)
					}
				}else{
					_ctrlSelectArr=new Array
					_ctrlSelectArr.push(_sceleLibrayFildNode)
					_shiftSelectArr=new Array
					_shiftSelectArr.push(_sceleLibrayFildNode)
					
					var $itemArr:Vector.<FileNode>=FileNodeManage.getChildeFileNode(_sceleLibrayFildNode)
					var $earr:Array=new Array
					for(var i:uint=0;i<$itemArr.length;i++){
						$earr.push($itemArr[i])
					}
					xuanQuFileNode($earr,false,false,_sceleLibrayFildNode.type)
					singleSelect=true
				}
				if(!_sceleLibrayFildNode.rename){
					Scene_data.stage.focus=this.stage
				}
			}
		
			this.onSize()
		}
		public var singleSelect:Boolean=false  //是否为单选
		private function getShiftArr($arr:Array):Array
		{
			
			var $selectItem:Array=new Array
			
			if($arr.length==1){
				$selectItem=$arr;
			}
			var $isTure:Boolean=false
			if($arr.length==2){
				var $fileNodeArr:Vector.<LibrayFildNode>=getListAllFileNode(LibrayModel.getInstance().librayArr)
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
		private function getListAllFileNode($childItem:ArrayCollection):Vector.<LibrayFildNode>
		{
			var $arr:Vector.<LibrayFildNode>=new Vector.<LibrayFildNode>
			for(var i:uint=0;$childItem&&i<$childItem.length;i++){
				var $LibrayFildNode:LibrayFildNode=$childItem[i] as LibrayFildNode
				$arr.push($LibrayFildNode)
				$arr=$arr.concat(getListAllFileNode($LibrayFildNode.children))
				
			}
			return $arr
		}
		public function xuanQuFileNode($arr:Array,$shiftKey:Boolean=false,slect:Boolean=true,$selectType:uint=0):void
		{
			singleSelect=false
			var $itemArr:Array=new Array
			if($shiftKey){
				$itemArr=LibrayModel.getInstance().librayTree.selectedItems
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
			if(slect){
				LibrayModel.getInstance().librayTree.selectedItems=$itemArr
			}
			_ctrlSelectArr=LibrayModel.getInstance().librayTree.selectedItems
				

			
		}
	

		private function addList():void
		{
			var _tree:Tree = new Tree;
			_tree.setStyle("top",150);
			_tree.setStyle("bottom",50);
			_tree.setStyle("left",5);
			_tree.setStyle("right",5);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.setStyle("borderVisible",false);
			
			//_tree.horizontalScrollPolicy = "off";
			//_tree.verticalScrollPolicy = "on";
			trace(_tree.horizontalScrollPolicy)
			trace(_tree.verticalScrollPolicy)
			this.addChild(_tree);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(LibrayItemRender);
			_tree.iconFunction = tree_iconFunc;
			LibrayModel.getInstance().librayTree=_tree
				
			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
			
		}
		private function tree_iconFunc(item:LibrayFildNode):Class {  
			
			if(item.type==LibrayFildNode.Folder_TYPE0){
				return BrowerManage.getIconClassByName("icon_FolderOpen_dark");
			}else{
				return BrowerManage.getIconClassByName("table_16");
			}
		}  

		override public function onSize(event:Event= null):void
		{
		
			this._iconBmp.x=(this.width-this._iconBmp.width)/2

		}

		
		protected function addToStage(event:Event):void
		{

			
		}



	}
}