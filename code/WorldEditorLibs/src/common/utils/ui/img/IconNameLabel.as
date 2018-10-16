package common.utils.ui.img
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import spark.components.Label;
	
	import capture.CaptureStaticMesh;
	
	import common.msg.event.brower.MEvent_BrowerShowFile;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Group_Model_hide;
	import common.msg.event.hierarchy.MEvent_Hierarchy_Reset;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	import common.utils.ui.prefab.PicBut;
	
	import grass.GrassStaticMesh;
	
	import light.LightStaticMesh;
	import light.ReflectionStaticMesh;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.hierarchy.HierarchyFileNode;
	
	import pack.HierarchyGroupMesh;
	import pack.ModePropertyMesh;
	
	import water.WaterStaticMesh;
	
	public class IconNameLabel extends UIComponent
	{
		private var _iconBitmap:Bitmap;

		private var _txtLabel:Label;
		private var _searchBut:PicBut;
		private var _target:Object
		private var _isSelectBmp:Bitmap
		public function IconNameLabel()
		{
			super();
			
			_iconBitmap = new Bitmap;
			_iconBitmap.smoothing = true;
			_iconBitmap.x = 10;
			this.addChild(_iconBitmap);
			

			
			_txtLabel = new Label;
			_txtLabel.setStyle("color",0x9f9f9f);
			_txtLabel.setStyle("paddingTop",4);
			_txtLabel.width = 200;
			_txtLabel.height = 20;
			_txtLabel.x = 80;
			_txtLabel.text = "123456";
			this.addChild(_txtLabel);
	        addSearchBut()
			addSeeTure();
		}


		public function set target(value:Object):void
		{
		
			if(value as LightStaticMesh){
				_target=LightStaticMesh(value).fileNode
				icon = BrowerManage.getIcon("light_16");
				label=HierarchyFileNode(_target).name
			}else
			if(value as CaptureStaticMesh){
				_target=CaptureStaticMesh(value).fileNode
				icon = BrowerManage.getIcon("icon_cube01");
				label=HierarchyFileNode(_target).name
			}else
			if(value as ReflectionStaticMesh){
				_target=ReflectionStaticMesh(value).fileNode
				icon = BrowerManage.getIcon("icon_cube01");
				label=HierarchyFileNode(_target).name
			}else
			if(value as WaterStaticMesh){
				_target=WaterStaticMesh(value).fileNode
				icon = BrowerManage.getIcon("water_16");
				label=HierarchyFileNode(_target).name
			}else
			if(value as GrassStaticMesh){
				_target=GrassStaticMesh(value).fileNode
				icon = BrowerManage.getIcon("water_16");
				label=HierarchyFileNode(_target).name
			}else
			if(value as HierarchyGroupMesh){
				_target=HierarchyGroupMesh(value).fileNode
				_target=HierarchyGroupMesh(value)
				icon = BrowerManage.getIcon("water_16");
				label="组合"
			}else
			if(value as ModePropertyMesh){
				_target=ModePropertyMesh(value).fileNode
				label="Group"	
			}else
			{
				_target = value;
			}
			if(_target as HierarchyFileNode){
				_canSee.visible=true
				_searchBut.visible=false
				_isSelectBmp.visible=HierarchyFileNode(_target).isHide
				icon=BrowerManage.getIcon("icon_cube01")
					
			}else if(_target as HierarchyGroupMesh){
				_canSee.visible=true
				_searchBut.visible=false
				_isSelectBmp.visible=HierarchyGroupMesh(_target).isHide
				icon=BrowerManage.getIcon("icon_cube01")
			}else
			{
				_searchBut.visible=true
				_canSee.visible=false
			}
			resetSize();
		}
		private function addSearchBut():void
		{
			_searchBut=new PicBut
			_searchBut.setBitmapdata(BrowerManage.getIcon("search"))
			_searchBut.x=155
			_searchBut.addEventListener(MouseEvent.CLICK,_searchButClik)
			_searchBut.buttonMode=true
			this.addChild(_searchBut)
		}
		private function addSeeTure():void
		{
			_canSee=new PicBut
			_canSee.setBitmapdata(BrowerManage.getIcon("icon_box_back"))
			_canSee.x=60
			_canSee.y=3
			_canSee.buttonMode=true
			_canSee.visible=false
			_canSee.addEventListener(MouseEvent.CLICK,_canSeeButClik)
			this.addChild(_canSee)
				
			_isSelectBmp=new Bitmap
			_isSelectBmp.bitmapData=BrowerManage.getIcon("icon_box_change")
			_isSelectBmp.x=3
			_isSelectBmp.y=1
			_canSee.addChild(_isSelectBmp)
	
			
		}
		
		protected function _canSeeButClik(event:MouseEvent):void
		{
			var $isHide:Boolean
			if(_target as HierarchyFileNode ){
			
				if(HierarchyFileNode(_target)){
					 $isHide=HierarchyFileNode(_target).isHide
					var $itemArr:Vector.<FileNode>=FileNodeManage.getChildeFileNode(HierarchyFileNode(_target))
					for(var i:uint=0;i<$itemArr.length;i++){
						if(HierarchyFileNode($itemArr[i])){
							HierarchyFileNode($itemArr[i]).isHide=!$isHide
							HierarchyFileNode($itemArr[i]).showOrHide();
							
							
							var $evt:MEvent_Hierarchy_Reset=new MEvent_Hierarchy_Reset(MEvent_Hierarchy_Reset.MEVENT_HIERARCHY_RESET)
							$evt.fileNode=HierarchyFileNode($itemArr[i])
							ModuleEventManager.dispatchEvent($evt);
						}
					}
					target=_target
				}
			}
			if(_target as HierarchyGroupMesh ){
				HierarchyGroupMesh(_target).isHide=!HierarchyGroupMesh(_target).isHide
				 $isHide=HierarchyGroupMesh(_target).isHide
				
				 var $MEvent_Hierarchy_Group_Model_hide:MEvent_Hierarchy_Group_Model_hide=new MEvent_Hierarchy_Group_Model_hide(MEvent_Hierarchy_Group_Model_hide.MEVENT_HIERARCHY_GROUP_MODEL_HIDE)
				 $MEvent_Hierarchy_Group_Model_hide.hierarchyGroupMesh=HierarchyGroupMesh(_target)
				 ModuleEventManager.dispatchEvent($MEvent_Hierarchy_Group_Model_hide);
					 
				 target=_target

			}
			
			
		}
		
		private var _listOnly:Boolean=false
		private var _canSee:PicBut;
		protected function _searchButClik(event:MouseEvent):void
		{

			var evt:MEvent_BrowerShowFile=new MEvent_BrowerShowFile(MEvent_BrowerShowFile.BROWER_SHOW_SAMPE_FILE)
			evt.data=_target

			evt.listOnly=_listOnly;
			ModuleEventManager.dispatchEvent(evt);
			_listOnly=!_listOnly
		}		
		public function set icon(bmp:BitmapData):void{
			_iconBitmap.bitmapData = bmp;
			_iconBitmap.scaleX = 36/bmp.width;
			_iconBitmap.scaleY = 36/bmp.height;
		}
		public function set label(value:String):void{
			
			_txtLabel.text = value;
			_txtLabel.width=_txtLabel.measureText(value).width+5
			resetSize()
		}
		public function resetSize():void
		{
			_searchBut.x=Math.max(120,_txtLabel.x+_txtLabel.width+10)
			
		}
		
		
	}
}