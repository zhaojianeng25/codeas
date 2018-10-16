package tempest.common.rsl.vo
{
	import flash.system.ApplicationDomain;

	public class TRslType
	{
		/**
		 * 共享库
		 * @default
		 */
		public static const LIB:String = "lib";
		/**
		 * 模块
		 * @default
		 */
		public static const MODULE:String = "module";
		/**
		 * 资源
		 * @default
		 */
		public static const RES:String = "res";

		/**
		 * 根据模块类型获取应用程序域
		 * @param moduleType 模块类型
		 * @return
		 */
		public static function getApplicationDomain(moduleType:String):ApplicationDomain
		{
			if (moduleType == LIB)
			{
				return ApplicationDomain.currentDomain;
			}
			else if (moduleType == RES)
			{
				return new ApplicationDomain();
			}
			else
			{
				return new ApplicationDomain(ApplicationDomain.currentDomain);
			}
		}
	}
}
