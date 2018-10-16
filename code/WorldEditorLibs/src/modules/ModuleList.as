package modules
{
	import com.zcp.frame.Module;
	
	import modules.brower.BrowerModule;
	import modules.collision.CollisionModule;
	import modules.cradiosity.CradiosityModule;
	import modules.enginConfig.EngineConfigModule;
	import modules.hierarchy.HierarchyModule;
	import modules.lightProbe.LightProbeModule;
	import modules.materials.MaterialModule;
	import modules.menu.MenuModule;
	import modules.navMesh.NavMeshModule;
	import modules.prefabs.PrefabModule;
	import modules.projectSave.ProjectSaveModule;
	import modules.roles.RoleModule;
	import modules.scene.SceneModule;
	import modules.sceneConfig.SceneConfigModule;
	import modules.terrain.TerrainModule;
	

	/**
	 * 游戏启动时,所有需要初始化的模块列表
	 * @author nick
	 * Email : 7105647@QQ.com
	 */	
	public class ModuleList
	{
		public function ModuleList()
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
					MenuModule,
					SceneModule,
					EngineConfigModule,
					TerrainModule,
					BrowerModule,
					ProjectSaveModule,
					PrefabModule,
					HierarchyModule,
					CollisionModule,
					LightProbeModule,
					RoleModule,
					SceneConfigModule,
					CradiosityModule,
					NavMeshModule,
					MaterialModule
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



