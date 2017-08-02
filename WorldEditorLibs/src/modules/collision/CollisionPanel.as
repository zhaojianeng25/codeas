package modules.collision
{
	import flash.events.Event;
	
	import common.utils.frame.BasePanel;
	import common.vo.editmode.EditModeEnum;
	
	import modules.scene.SceneEditModeManager;
	
	public class CollisionPanel extends BasePanel
	{

		
		public function CollisionPanel()
		{
			super();
			drawBack()
			

			//this.horizontalScrollPolicy = "off";
			//this.verticalScrollPolicy = "off";


			addEvents();
			
		}
		
		private function addEvents():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage)
			
		}
		
		protected function onAddToStage(event:Event):void
		{
			SceneEditModeManager.changeMode(EditModeEnum.EDIT_COLLISION)
			
		}
		override public function onSize(event:Event= null):void
		{
			drawBack();

			
		}

		private function drawBack():void{
			this.graphics.clear();
			this.graphics.lineStyle(1,0x505050);
			this.graphics.moveTo(0,30);
			this.graphics.lineTo(this.width,30);
			
			
			this.graphics.beginFill(0x404040,0.0);
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();
			
		}


	

		
		
	}
}


