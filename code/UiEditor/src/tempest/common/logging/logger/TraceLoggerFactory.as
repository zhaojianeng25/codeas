package tempest.common.logging.logger
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.ILoggerFactory;
	import tempest.common.logging.TLog;

	/**
	 * 使用trace输出的调试器
	 * @author wushangkun
	 */
	public class TraceLoggerFactory implements ILoggerFactory
	{
		public function TraceLoggerFactory()
		{
			loggers = new Dictionary();
		}

		public function getLogger(logTarget:Object, logLevel:int):ILogger
		{
			if (logTarget == null)
			{
				throw new ArgumentError("logTarget must not be null")
			}
			var name:String
			if (logTarget is String)
			{
				name = String(logTarget)
			}
			else
			{
				name = getQualifiedClassName(logTarget);
				name = name.replace(/::/g, ".");
			}
			var logger:ILogger = loggers[name];
			if (logger == null)
			{
				logger = new TraceLogger(name, logLevel);
				loggers[name] = logger;
			}
			return logger;
		}
		private var loggers:Dictionary;
	}
}
