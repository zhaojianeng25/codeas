package tempest.common.mvc.base {
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import tempest.common.mvc.api.ITFacade;
	import tempest.common.mvc.api.ITLifecycle;

	public class TLifecycle implements ITLifecycle {
		private var _signals:Object = {};

		public function TLifecycle() {
		}

		public function destroy():void {
			for each (var signal:ISignal in _signals) {
				signal.removeAll();
			}
			_signals = {};
		}

		private function getSignal(name:String):ISignal {
			return _signals[name] ||= new Signal(ITFacade);
		}

		public function get onAfterDestroying():ISignal {
			return getSignal("onAfterDestroying");
		}

		public function get onAfterInitializing():ISignal {
			return getSignal("onAfterInitializing");
		}

		public function get onBeforeDestroying():ISignal {
			return getSignal("onBeforeDestroying");
		}

		public function get onBeforeInitializing():ISignal {
			return getSignal("onBeforeInitializing");
		}

		public function afterDestroying(handler:Function):ITLifecycle {
			onAfterDestroying.add(handler);
			return this;
		}

		public function afterInitializing(handler:Function):ITLifecycle {
			onAfterInitializing.add(handler);
			return this;
		}

		public function beforeDestroying(handler:Function):ITLifecycle {
			onBeforeDestroying.add(handler);
			return this;
		}

		public function beforeInitializing(handler:Function):ITLifecycle {
			onBeforeInitializing.add(handler);
			return this;
		}
	}
}
