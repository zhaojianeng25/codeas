package tempest.common.logging.logger
{
	import tempest.common.logging.ILogger;
	import tempest.common.logging.TLog;

	public class TraceLogger extends TLog implements ILogger
	{
		private var _logLevel:int;

		public function TraceLogger(name:String, logLevel:int)
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
					_log("LOG", message, params);
			}
		}

		public function debug(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_DEBUG && _logLevel >= LEVEL_DEBUG)
					_log("DEBUG", message, params);
			}
		}

		public function info(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_INFO && _logLevel >= LEVEL_INFO)
					_log("INFO", message, params);
			}
		}

		public function warn(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_WARN && _logLevel >= LEVEL_WARN)
					_log("WARN", message, params);
			}
		}

		public function error(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_ERROR && _logLevel >= LEVEL_ERROR)
					_log("ERROR", message, params);
			}
		}

		public function fatal(message:String, ... params):void
		{
			CONFIG::LOGGING
			{
				if (LogLevel >= LEVEL_FATAL && _logLevel >= LEVEL_FATAL)
					_log("FATAL", message, params);
			}
		}

		protected function _log(level:String, message:String, params:Array):void
		{
			var msg:String = "";
			// add datetime
			msg += ((showDate) ? new Date().toLocaleString() + " " : "") + "[" + level + "] ";
			// add name and params
			msg += ((showClass) ? "[" + name + "] " : "") + applyParams(message, params);
			// trace the message
			trace(msg);
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
		private var name:String;
	}
}
