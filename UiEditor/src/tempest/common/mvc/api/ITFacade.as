package tempest.common.mvc.api {
	import flash.display.DisplayObject;
	
	import org.as3commons.logging.api.ILogger;
	import org.osflash.signals.IPrioritySignal;
	
	import tempest.common.mvc.base.MediatorMap;

	public interface ITFacade {
		function get injector():IInjector;
		function get logger():ILogger;
		function get shutdownSignal():IPrioritySignal;
		function get startupSignal():IPrioritySignal;
		function configure(... configs):ITFacade;
		function install(... extensions):ITFacade;
		function get commandMap():ICommandMap;
		function get mediatorMap():MediatorMap;
		function get lifecycle():ITLifecycle;
		function afterDestroying(handler:Function):ITFacade;
		function afterInitializing(handler:Function):ITFacade;
		function beforeDestroying(handler:Function):ITFacade;
		function beforeInitializing(handler:Function):ITFacade;
		function destroy():void;
		function initialize(target:DisplayObject = null):ITFacade;
		function addChild(child:ITFacade):ITFacade;
		function removeChild(child:ITFacade):ITFacade;
	}
}
