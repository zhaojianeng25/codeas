package mvc.top
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.utils.ui.file.FileNodeManage;
	
	import exph5.MergeVideoModel;
	
	import modules.scene.EnvironmentVo;
	
	import mvc.frame.FrameModel;
	import mvc.frame.view.FrameFileNode;
	import mvc.libray.LibrayModel;
	
	public class TopProcessor extends Processor
	{

		private var _menu:TopMenuView;
		public function TopProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				TopEvent,
				MEvent_ProjectData,
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case TopEvent:
					if($me.action==TopEvent.SHOW_TOP){
						showTopMenu();
					}
					if($me.action==TopEvent.SAVE_FILE){
						saveFile();
					}
					break;
				case MEvent_ProjectData:
					if($me.action==MEvent_ProjectData.PROJECT_SAVE_CONFIG){
						AppDataFrame.saveConfigProject();
					}
					break;
			}
		}
		
		private function saveFile():void
		{

			var $obj:Object=new Object;
			this.testFrameNodeId()
			$obj.libarr=LibrayModel.getInstance().getLibObject()
			$obj.ary=this.wirteItem(FrameModel.getInstance().ary);
			$obj.light=	Scene_data.light.readObject();
			$obj.environment=EnvironmentVo.getInstance().readObject()
			$obj.frameSpeed=AppDataFrame.frameSpeed;
			$obj.videoLightUvData=MergeVideoModel.getInstance().videoLightUvData;
				
		

			var file:File = new File(AppData.workSpaceUrl +AppDataFrame.fileUrl);
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			fs.writeObject($obj);
			fs.close();

			
			
			var _so:SharedObject = AppDataFrame.getSharedObject()
			_so.data.url=AppDataFrame.fileUrl
			
			Alert.show("保存地址"+decodeURI(AppDataFrame.fileUrl),"保存完毕");

		}
		private function testFrameNodeId():void
		{
			var  $dic:Dictionary=new Dictionary
			var arr:Vector.<FrameFileNode>=	FrameModel.getInstance().getAllFrameFileNode();
			for(var i:Number=0;i<arr.length;i++){
		
				if($dic.hasOwnProperty(arr[i].id)||arr[i].id==0){
					arr[i].id=FileNodeManage.getFileNodeNextId(FrameModel.getInstance().ary)
				}
				$dic[arr[i].id]=true;
				trace(arr[i].name,"------>id",arr[i].id);
			}
		
		}
		private function wirteItem(childItem:ArrayCollection):Array
		{
			var $item:Array=new Array
			for(var i:uint=0;childItem&&i<childItem.length;i++){
				var $FrameFileNode:FrameFileNode=childItem[i] as FrameFileNode
				$item.push($FrameFileNode.getObject())
			}
			if($item.length){
				return $item
			}
			return null
		}

		public function showTopMenu():void
		{
			if(!_menu){
				_menu = new TopMenuView();
			}
			_menu.showMenu();
			
		}
	}
}