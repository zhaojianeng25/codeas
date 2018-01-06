package tempest.common.logging.logger
{
	import com.junkbyte.console.Cc;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import tempest.common.logging.ILogger;
	import tempest.common.logging.ILoggerFactory;

	/**
	 * 具有调试功能面板的日志处理器
	 * @author wushangkun
	 */
	public class CcLoggerFatory implements ILoggerFactory
	{
		private var loggers:Dictionary;

		public function CcLoggerFatory(container:DisplayObjectContainer)
		{
			loggers = new Dictionary();
			CONFIG::LOGGING
			{
				if (container.stage)
					container = container.stage;
				Cc.start(container, "*");
				Cc.commandLine = true;
				Cc.config.commandLineAllowed = true;
				Cc.config.tracing = true;
				Cc.width = 400;
				Cc.height = 300;
				Cc.x = (((container is Stage) ? Stage(container).stageWidth : container.width) - Cc.width) / 2;
				Cc.y = (((container is Stage) ? Stage(container).stageHeight : container.height) - Cc.height) / 2;
			}
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
				logger = new CcLogger(name, logLevel);
				loggers[name] = logger;
			}
			return logger;
		}
	}
}
