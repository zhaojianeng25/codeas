package common.utils.ui.prefab
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import common.AppData;
	import common.msg.event.brower.MEvent_BrowerShowFile;
	import common.utils.ui.txt.TextCtrlInput;

	public class MotionModelPic extends PreFabModelPic
	{
		public function MotionModelPic()
		{
			super();
			this.height=150
			this.isDefault=false
			addLevelNum();
			addFrameSpeed()
		}
		
		private function addFrameSpeed():void
		{
			_frameSpeedextInput = new TextCtrlInput;
			_frameSpeedextInput.center = true;
			_frameSpeedextInput.height = 18;
			_frameSpeedextInput.label ="FrameSpeed"
			_frameSpeedextInput.changFun=changeFrameSpeed
			_frameSpeedextInput.maxNum = 100
			_frameSpeedextInput.minNum = 0
			_frameSpeedextInput.step = 1
			_frameSpeedextInput.target=this
			this.addChild(_frameSpeedextInput)
			_frameSpeedextInput.x=10
			_frameSpeedextInput.y=120
			
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
		private var _frameSpeedextInput:TextCtrlInput
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
			_motionIDTextInput.y=100

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
					if($obj.axmFileName==str){
						return 
					}else
					{
						$obj.axmFileName=str
						changeData()
					}
				}
			}
		}
		private function changeData():void
		{
			
			if(target&&FunKey){
				target[FunKey]=target[FunKey]
			}
		}
		override protected function _searchButClik(event:MouseEvent):void
		{
			if(target&&FunKey){
				var $obj:Object=target[FunKey]
				if($obj){
					var file:File=new File(AppData.workSpaceUrl+String($obj.axmFileName));
					var evt:MEvent_BrowerShowFile=new MEvent_BrowerShowFile(MEvent_BrowerShowFile.BROWER_SHOW_SAMPE_FILE)
					evt.data=String($obj.axmFileName)
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
				_frameSpeedextInput.text=String($obj.frameSpeed)
				labelName(String($obj.axmFileName))
			}

		}
	}
}