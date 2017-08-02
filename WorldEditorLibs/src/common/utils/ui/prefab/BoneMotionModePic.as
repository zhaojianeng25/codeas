package common.utils.ui.prefab
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import common.AppData;
	import common.msg.event.brower.MEvent_BrowerShowFile;
	import common.utils.ui.txt.TextCtrlInput;

	public class BoneMotionModePic extends PreFabModelPic
	{
		public function BoneMotionModePic()
		{
			super();
			this.height=110
			this.isDefault=false
			addLevelNum();

		}
		

		private function  changeFrameSpeed($num:Number):void
		{
			var $obj:Object=target[FunKey]
			if($obj){
				$obj.frameSpeed=$num
				changeData()
			}
		}
		private var _motionIDTextInput:TextCtrlInput

		private function addLevelNum():void
		{
			_motionIDTextInput = new TextCtrlInput;
			_motionIDTextInput.center = true;
			_motionIDTextInput.height = 18;
			_motionIDTextInput.label ="MotionId"
			_motionIDTextInput.changFun=changeMotionId
			_motionIDTextInput.maxNum = 100
			_motionIDTextInput.minNum = 0
			_motionIDTextInput.step = 1
			_motionIDTextInput.target=this
			this.addChild(_motionIDTextInput)
			_motionIDTextInput.x=10
			_motionIDTextInput.y=85
			
		}
		
		private function  changeMotionId($num:Number):void
		{
			var $obj:Object=target[FunKey]
			if($obj){
				$obj.motionID=$num
				changeData()
			}
		}
		
		override public function refreshViewValue():void
		{
			if(target&&FunKey){
				var dde:Object=target[FunKey]
				setData(dde)
			}
			_listOnly=true
		}
		override public function seturl($url:String):void
		{
			var str:String=$url.replace(AppData.workSpaceUrl,"");
			if(target&&FunKey){
				var $obj:Object=target[FunKey]
				if($obj){
					if(axmFileName==str){
						return 
					}else
					{
						axmFileName=str
						chaifenName()
						//$obj.axmFileName=str
						changeData()
					}
				}
			}
		}
		private function chaifenName():void
		{

			var file:File=new File(AppData.workSpaceUrl+axmFileName);
			var fileName:String=file.name
			var filePath:String=	decodeURI(file.url).replace(fileName,"")
			filePath=filePath.replace(AppData.workSpaceUrl,"")
			var $obj:Object=target[FunKey]
			if($obj){
				$obj.fileName=fileName
				$obj.filePath=filePath
			}
			
		}
		private function changeData():void
		{
			
			if(target&&FunKey){
				target[FunKey]=target[FunKey]
			}
		}
		private var axmFileName:String
		override protected function _searchButClik(event:MouseEvent):void
		{
			if(target&&FunKey){
				var $obj:Object=target[FunKey]
				if($obj){
	
					var file:File=new File(AppData.workSpaceUrl+axmFileName);
					var evt:MEvent_BrowerShowFile=new MEvent_BrowerShowFile(MEvent_BrowerShowFile.BROWER_SHOW_SAMPE_FILE)
					evt.data=String(axmFileName)
					evt.listOnly=_listOnly;
					ModuleEventManager.dispatchEvent(evt);
					_listOnly=!_listOnly;
				}
				
			}
		}
		
		private function setData($obj:Object):void
		{
			if($obj){
				_motionIDTextInput.text=String($obj.motionID)
				axmFileName=String($obj.filePath)+String($obj.fileName)
				trace(axmFileName)
				labelName(axmFileName)
			}
			
		}
	}
}