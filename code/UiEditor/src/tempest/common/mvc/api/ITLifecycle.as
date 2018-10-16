package tempest.common.mvc.api {
	import org.osflash.signals.ISignal;

	public interface ITLifecycle {
		function get onBeforeInitializing():ISignal;
		function get onAfterInitializing():ISignal;
		function get onBeforeDestroying():ISignal;
		function get onAfterDestroying():ISignal;
		function beforeInitializing(handler:Function):ITLifecycle;
		function afterInitializing(handler:Function):ITLifecycle;
		function beforeDestroying(handler:Function):ITLifecycle;
		function afterDestroying(handler:Function):ITLifecycle;
		function destroy():void;
	}
}
