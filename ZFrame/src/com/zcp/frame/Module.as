package com.zcp.frame
{
	import flash.utils.Dictionary;

	/**
	 * Module基类
	 * Module为单一模块总入口，可注册多个Processor
	 * 注意:
	 * 1.不能注册相同的类型的Module两次
	 * 2.同一Module不能注册相同的类型的Processor两次
	 * 重写方法举例
	 * 1.重写listProcessors方法
	 * 例如：
	 * override protected function listProcessors():Array
	 * {
	 * 		return [
	 * 			new Processor1(this),
	 * 			new Processor2(this)
	 * 		];
	 * }
	 * @author zcp
	 * 
	 */	
	public class Module
	{
		public function Module()
		{
			//模块初始化
			onInit();
		}
		/**
		 * 获取实例的类型类 
		 * @return 
		 * 
		 */		
		public function getClass():Class
		{
			return this["constructor"];//getDefinitionByName(getQualifiedClassName(this));
		}
		
		//--------------------------------------------------------
		// 注册 、查询、移除 Module（静态管理,全局唯一）
		//--------------------------------------------------------
		/**
		 * module字典 
		 */		
		private static const moduleMap:Dictionary = new Dictionary(); 
		/**
		 * 注册Module
		 * @param $module
		 */		
		public static function registerModule( $module:Module ) : void
		{
			//单例
			if (moduleMap[$module.getClass()] != null) throw Error("不能注册两个相同的Module");
			moduleMap[ $module.getClass() ] = $module;
			$module.registerProcessors();
			$module.onRegister();
		}
		/**
		 * 指定module是否存在
		 * @param $moduleClass
		 * @return 
		 * 
		 */		
		public static function hasModule( $moduleClass:Class) : Boolean
		{
			return ( moduleMap[ $moduleClass ] != null );
		}
		/**
		 * 查找module
		 * @param $moduleClass
		 */		
		public static function getModule( $moduleClass:Class):Module
		{
			return moduleMap[$moduleClass];
		}
		/**
		 * 移除module
		 * @param $moduleClass
		 * return 返回被移除的Module
		 */		
		public static function removeModule( $moduleClass:Class) : Module
		{
			var module:Module = moduleMap [ $moduleClass ] as Module;
			if ( module ) 
			{
				moduleMap[ $moduleClass ] = null;
				delete moduleMap[ $moduleClass ] ;
				module.removeProcessors();
				module.onRemove();
			}
			return module;
		}
		
		//--------------------------------------------------------
		// 注册 、查询、移除 Processor（实例管理，每一个Module互补干涉）
		//--------------------------------------------------------
		/**
		 * processor字典 
		 */	
		private const processorMap:Dictionary = new Dictionary();
		/**
		 * 注册Processor
		 * @param $processor
		 */		
		private function registerProcessor( $processor:Processor ) : void
		{
			//单例
			if (processorMap[ $processor.getClass() ] != null) throw Error("同一Module不能注册两个相同的Processor");
			processorMap[ $processor.getClass() ] = $processor;
			$processor.registerEvents();
			$processor.onRegister();
		}
		/**
		 * 检查是否存在
		 * @param $processorClass
		 */		
		private function hasProcessor( $processorClass:Class):Boolean
		{
			return processorMap[$processorClass] != null;
		}
		/**
		 * 查找Processor
		 * @param $processorClass
		 */		
		public function getProcessor( $processorClass:Class) : Processor
		{
			return processorMap[$processorClass];
		}
		/**
		 * 移除Processor
		 * @param $processorClass
		 * return 返回被移除的Processor
		 */		
		private function removeProcessor( $processorClass:Class) : Processor
		{
			var processor:Processor = processorMap [ $processorClass ] as Processor;
			if ( processor ) 
			{
				processorMap[ $processorClass ] = null;
				delete processorMap[ $processorClass ] ;
				processor.removeEvents();
				processor.onRemove();
			}
			return processor;
		}
		
		
		
		//--------------------------------------------------------
		// private API
		//--------------------------------------------------------
		/**
		 * 注册所有的Processor
		 */ 
		private function registerProcessors():void {
			//注册Processor
			var processorArr:Array = listProcessors();
			if(processorArr!=null && processorArr.length>0)
			{
				for each(var processor:Processor in processorArr)
				{
					registerProcessor(processor);
				}
			}
		}
		
		/**
		 * 移除所有的Processor
		 */ 
		private function removeProcessors():void {
			//移除Processor
			var processorArr:Array = listProcessors();
			if(processorArr!=null && processorArr.length>0)
			{
				for each(var processor:Processor in processorArr)
				{
					removeProcessor(processor.getClass());
				}
			}
		}
		
		
		
		//--------------------------------------------------------
		// 以下为需要覆写的函数
		//--------------------------------------------------------
		/**
		 * 初始化
		 */		
		protected function onInit():void {}
		
		/**
		 * 当被注册时
		 * 小技巧：可在此函数内注册所有processor
		 */ 
		protected function onRegister():void {}
		
		/**
		 * 当被移除时
		 * 小技巧：可在此函数内移除所有processor
		 */ 
		protected function onRemove():void {}
		
		/**
		 * 注册的Processor的集合
		 * 请注意：返回为Processor的实例数组
		 * @return 
		 * 
		 */		
		protected function listProcessors():Array
		{
			return null;
		}
	}
}