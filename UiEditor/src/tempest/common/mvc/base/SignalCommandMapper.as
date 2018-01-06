package tempest.common.mvc.base {
	import org.osflash.signals.ISignal;
	import tempest.common.mvc.api.ICommand;
	import tempest.common.mvc.api.ICommandExector;
	import tempest.common.mvc.api.IInjector;
	import tempest.common.mvc.api.ICommandMapper;

	public class SignalCommandMapper implements ICommandMapper {
		private var signal:ISignal;
		private var commandList:Vector.<CommandExector> = new Vector.<CommandExector>();
		private var _injector:IInjector;

		public function SignalCommandMapper(signalClass:Class, name:String, injector:IInjector):void {
			_injector = injector.createChild();
			if (!injector.hasMapping(signalClass, name))
				injector.map(signalClass, name).asSingleton();
			signal = injector.getInstance(signalClass);
			signal.add(execute);
		}

		private function execute(... args):void {
			if (commandList && commandList.length > 0) {
				var injectProxy:InjectProxy = new InjectProxy(signal.valueClasses, args, _injector);
				var i:int = commandList.length;
				var exector:CommandExector;
				while (i--) {
					exector = commandList[i];
					exector.execute(_injector);
					if (exector.once) {
						commandList.splice(i, 1);
					}
				}
				injectProxy.destory(_injector);
			}
		}

		public function toCommand(commandCls:Class, once:Boolean = false):ICommandExector {
			var commandExector:ICommandExector = getCommand(commandCls);
			if (!commandExector) {
				commandExector = new CommandExector(commandCls, once);
				commandList.push(commandExector);
			}
			return commandExector;
		}

		private function hasCommand(commandCls:Class):Boolean {
			var i:int = commandList.length;
			while (i--) {
				if (commandList[i].commandCls == commandCls)
					return true;
			}
			return false;
		}

		private function getCommand(commandCls:Class):ICommandExector {
			var i:int = commandList.length;
			while (i--) {
				if (commandList[i].commandCls == commandCls)
					return commandList[i];
			}
			return null;
		}

		public function destroy():void {
			signal.remove(execute);
			commandList.length = 0;
			_injector.parent = null;
			_injector = null;
		}
	}
}
import tempest.common.mvc.api.ICommand;
import tempest.common.mvc.api.ICommandExector;
import tempest.common.mvc.api.IInjector;

class InjectProxy {
	private var _classList:Array;

	public function InjectProxy(classList:Array, valueList:Array, injector:IInjector) {
		if (classList.length > 0) {
			_classList = classList;
			var i:int = classList.length;
			while (i--) {
				injector.map(classList[i]).toValue(valueList[i]);
			}
		}
	}

	public function destory(injector:IInjector):void {
		if (_classList) {
			var i:int = _classList.length;
			while (i--) {
				injector.unmap(_classList[i]);
			}
		}
	}
}

class CommandExector implements ICommandExector {
	public var once:Boolean = false;
	public var commandCls:Class;
	public var command:ICommand;

	public function CommandExector(commandCls:Class, once:Boolean = false):void {
		this.commandCls = commandCls;
		once = once;
	}

	public function execute(injector:IInjector):void {
		command ||= new commandCls();
		injector.injectInto(command);
		command.execute();
		injector.destroyInstance(command);
		if (once) {
			commandCls = null;
			command = null;
		}
//		var command:ICommand = injector.getOrCreateNewInstance(commandCls);
//		command.execute();
	}
}
