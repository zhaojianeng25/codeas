package view.scene
{
	import mx.controls.Alert;
	
	import common.utils.frame.BaseReflectionView;
	import common.utils.frame.ReflectionData;
	
	public class ParticleItemPropView extends BaseReflectionView
	{
		public function ParticleItemPropView()
		{
			super();
			
			this.creat(viewMenu());
			this.refreshView();
		}
		
		private static var _instance:ParticleItemPropView;
		public static function getInstance():ParticleItemPropView{
			if(!_instance){
				_instance = new ParticleItemPropView;
			}
			return _instance;
		}
		
		public function setItem():void{
			
		}
		
		private function viewMenu():Array
		{
			var ary:Array =
				[
					{Type:ReflectionData.Input,Label:"名称:",GetFun:getName,SetFun:setName,Category:"属性"},
					
				]
			
			return ary;
		}
		
		public function setName(value:String):void{
			
		}
		
		public function getName():String{
			return "1111";
		}
	}
}