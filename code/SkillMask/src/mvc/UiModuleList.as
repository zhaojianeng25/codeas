package mvc
{
	import com.zcp.frame.Module;
	
	import mvc.centen.discenten.DisCentenModule;
	import mvc.centen.panelcenten.PanelCentenModule;
	import mvc.left.disleft.DisLeftModule;
	import mvc.left.panelleft.PanelLeftModule;
	import mvc.project.ProjectModule;
	import mvc.scene.UiSceneModule;
	import mvc.top.TopModule;

	public class UiModuleList
	{
		public function UiModuleList()
		{
			throw new Error("Modulist Class can not be created by new!");
		}
		
		/**
		 * 取得所有的模块列表 
		 */		
		private static function getModuleList():Array
		{
			//所有的需要注册的模块  都写在这里 直接用类名就可以
			return [
				UiSceneModule,
				DisCentenModule,
				PanelLeftModule,
				DisLeftModule,
				PanelCentenModule,
				TopModule,
				ProjectModule,
			
			
			];
		}
		
		/**
		 * 启动所有模块 
		 */		
		public static function startup():void
		{
			var allModules:Array = getModuleList();
			for( var i:int=0; i<allModules.length; i++)
			{
				var mClass:Class = allModules[i];
				statrupOneModule(mClass);
			}
		}
		
		
		/**
		 * 单独启动某模块 (注意,会有存在性判断, 不能重复启动统一模块)
		 */		
		public static function statrupOneModule($class:Class):void
		{
			if(Module.hasModule($class))
				return;
			var module:Module = (new $class()) as Module;
			Module.registerModule( module );
		}
	}
}



