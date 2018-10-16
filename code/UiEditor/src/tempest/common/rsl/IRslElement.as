package tempest.common.rsl
{
	import flash.system.ApplicationDomain;
	
	public interface IRslElement
	{
		function set applicationDomain(value:ApplicationDomain):void;
		function get applicationDomain():ApplicationDomain;
	}
}