package tempest.common.logging
{
	import tempest.common.logging.logger.TraceLoggerFactory;

	public class TLog
	{
		/**
		 * 获取/设置日志管理器
		 * @param factory
		 */
		public static var loggerFactory:ILoggerFactory;
		public static var LogLevel:int = 6;
		public static var showDate:Boolean = true;
		public static var showClass:Boolean = true;

		/**
		 * 初始化日志系统
		 * @param logLevel
		 * @param factory
		 */
		public static function init(logLevel:int = 6, factory:ILoggerFactory = null, showDate:Boolean = true, showClass:Boolean = true):void
		{
			if (factory != null)
				loggerFactory = factory;
			TLog.LogLevel = logLevel;
			TLog.showDate = showDate;
			TLog.showClass = showClass;
		}

		/**
		 * 获取日志处理器
		 * @param logTarget 日志处理器依赖对象 类名
		 * @param logLevel 日志等级  默认是输出全部日志
		 * @return
		 */
		public static function getLogger(logTarget:Object, logLevel:int = 6):ILogger
		{
//			CONFIG::LOGGING
//			{
			if (loggerFactory == null)
			{
				loggerFactory = new TraceLoggerFactory();
			}
//			}
			return (loggerFactory == null) ? null : loggerFactory.getLogger(logTarget, logLevel);
		}
		/**
		 * 日志级别
		 * 显示范围：所有日志信息
		 * @default 6
		 */
		public static const LEVEL_LOG:int = 6;
		/**
		 * 调试级别
		 * 显示范围：调试信息、警告信息、消息信息、错误信息、致命错误信息
		 * @default 5
		 */
		public static const LEVEL_DEBUG:int = 5;
		/**
		 * 警告级别
		 * 显示范围：警告信息、消息信息、错误信息、致命错误信息
		 * @default 4
		 */
		public static const LEVEL_WARN:int = 4;
		/**
		 * 消息级别
		 * 错误信息、致命错误信息
		 * @default 3
		 */
		public static const LEVEL_INFO:int = 3;
		/**
		 * 错误级别
		 * 显示范围：错误信息、致命错误信息
		 * @default 2
		 */
		public static const LEVEL_ERROR:int = 2;
		/**
		 * 致命错误级别
		 * 显示范围：致命错误信息
		 * @default 1
		 */
		public static const LEVEL_FATAL:int = 1;
		/**
		 * 不显示日志信息
		 * @default
		 */
		public static const NONE:int = 0;
	}
}
