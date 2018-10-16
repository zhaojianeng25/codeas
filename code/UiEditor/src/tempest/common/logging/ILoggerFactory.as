package tempest.common.logging
{

	public interface ILoggerFactory
	{
		function getLogger(logTarget:Object, logLevel:int):ILogger;
	}
}
