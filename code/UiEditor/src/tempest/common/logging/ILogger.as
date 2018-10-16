package tempest.common.logging
{

	public interface ILogger
	{
		/**
		 * 获取/设置日志等级
		 * @return
		 */
		function get logLevel():int;
		function set logLevel(value:int):void;
		/**
		 * 普通日志
		 * @param message 日志类容 支持"abc{0}"格式字符串 使用params中的参数
		 * @param params 格式参数
		 */
		function log(message:String, ... params):void;
		/**
		 * 调试日志
		 * @param message 日志类容 支持"abc{0}"格式字符串 使用params中的参数
		 * @param params 格式参数
		 */
		function debug(message:String, ... params):void;
		/**
		 * 消息日志
		 * @param message 日志类容 支持"abc{0}"格式字符串 使用params中的参数
		 * @param params 格式参数
		 */
		function info(message:String, ... params):void;
		/**
		 * 警告日志
		 * @param message 日志类容 支持"abc{0}"格式字符串 使用params中的参数
		 * @param params 格式参数
		 */
		function warn(message:String, ... params):void;
		/**
		 * 错误日志
		 * @param message 日志类容 支持"abc{0}"格式字符串 使用params中的参数
		 * @param params 格式参数
		 */
		function error(message:String, ... params):void;
		/**
		 * 致命错误日志
		 * @param message 日志类容 支持"abc{0}"格式字符串 使用params中的参数
		 * @param params 格式参数
		 */
		function fatal(message:String, ... params):void;
	}
}
