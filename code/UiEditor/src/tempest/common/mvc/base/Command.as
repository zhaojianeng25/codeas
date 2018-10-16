package tempest.common.mvc.base {
	import flash.display.InteractiveObject;
	import tempest.common.mvc.api.ICommandMap;
	import tempest.common.mvc.api.IInjector;
	import tempest.common.mvc.api.ITFacade;

	//[Deprecated]
	public class Command {
		private var _facade:ITFacade;
		private var _inject:IInjector;

		public function get commandMap():ICommandMap {
			return _facade.commandMap;
		}

		public function get inject():IInjector {
			return _inject;
		}

		internal function setInject(value:IInjector):void {
			_inject = value;
		}

		public function get facade():ITFacade {
			return _facade;
		}

		internal function setFacade(facade:ITFacade):void {
			_facade = facade;
		}

		public function get mediatorMap():MediatorMap {
			return _facade.mediatorMap;
		}

		public function execute():void {
		}

		public function getHandle():Function {
			return execute;
		}
	}
}
