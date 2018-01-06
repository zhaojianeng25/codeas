package tempest.common.logging.logger
{
	import com.junkbyte.console.Cc;
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class CcLogger extends TLog implements ILogger
	{
		private var name:String;
		private var _logLevel:int;

		public function CcLogger(name:String, logLevel:int)
		{
			this.name = name;
			this._logLevel = logLevel;
		}

		public function get logLevel():int
		{
			return _logLevel;
		}

		public function set logLevel(value:int):void
		{
			_logLevel = value;
		}

		public function log(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_LOG && _logLevel >= LEVEL_LOG)
					Cc.log(((showDate) ? new Date().toLocaleString() + " " : "") + "[LOG]" + ((showClass) ? "[" + name + "] " : "") + applyParams(message, params));
			}
		}

		public function debug(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_DEBUG && _logLevel >= LEVEL_DEBUG)
					Cc.debug(((showDate) ? new Date().toLocaleString() + " " : "") + "[DEBUG]" + ((showClass) ? "[" + name + "] " : "") + applyParams(message, params));
			}
		}

		public function error(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_ERROR && _logLevel >= LEVEL_ERROR)
					Cc.error(((showDate) ? new Date().toLocaleString() + " " : "") + "[ERROR]" + ((showClass) ? "[" + name + "] " : "") + applyParams(message, params));
			}
		}

		public function fatal(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_FATAL && _logLevel >= LEVEL_FATAL)
					Cc.fatal(((showDate) ? new Date().toLocaleString() + " " : "") + "[FATAL]" + ((showClass) ? "[" + name + "] " : "") + applyParams(message, params));
			}
		}

		public function info(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_INFO && _logLevel >= LEVEL_INFO)
					Cc.info(((showDate) ? new Date().toLocaleString() + " " : "") + "[INFO]" + ((showClass) ? "[" + name + "] " : "") + applyParams(message, params));
			}
		}

		public function warn(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_WARN && _logLevel >= LEVEL_WARN)
					Cc.warn(((showDate) ? new Date().toLocaleString() + " " : "") + "[WARN]" + ((showClass) ? "[" + name + "] " : "") + applyParams(message, params));
			}
		}

		protected function applyParams(message:String, params:Array):String
		{
			var result:String = message;
			var numParams:int = params.length;
			for (var i:int = 0; i < numParams; i++)
			{
				result = result.replace(new RegExp("\\{" + i + "\\}", "g"), params[i]);
			}
			return result;
		}
	}
}
