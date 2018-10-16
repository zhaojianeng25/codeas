package tempest.common.mvc.base {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import org.osflash.signals.ISignal;
	import tempest.common.mvc.api.ICommand;
	import tempest.common.mvc.api.ICommandExector;
	import tempest.common.mvc.api.ICommandMapper;
	import tempest.common.mvc.api.IInjector;

	public class EventCommandMapper implements ICommandMapper {
		private var _type:String;
		private var _eventCls:Class;
		private var commandList:Vector.<CommandExector> = new Vector.<CommandExector>();
		private var _injector:IInjector;
		private var _eventDispatcher:IEventDispatcher;

		public function EventCommandMapper(eventClass:Class, type:String, injector:IInjector, eventDispatcher:IEventDispatcher):void {
			_injector = injector.createChild();
			_eventDispatcher = eventDispatcher;
			_type = type;
			_eventCls = eventClass;
			_eventDispatcher.addEventListener(type, listener);
		}

		private function listener(e:Event):void {
			if (commandList && commandList.length > 0) {
				_injector.map(_eventCls).toValue(e);
				var i:int = commandList.length;
				var exector:CommandExector;
				while (i--) {
					exector = commandList[i];
					exector.execute(_injector);
					if (exector.once) {
						commandList.splice(i, 1);
					}
				}
				_injector.unmap(_eventCls);
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
			_eventDispatcher.removeEventListener(_type, listener);
			commandList.length = 0;
			_eventDispatcher = null;
			_eventCls = null;
			_injector.parent = null;
			_injector = null;
		}
	}
}
import flash.events.Event;
import tempest.common.mvc.api.ICommand;
import tempest.common.mvc.api.ICommandExector;
import tempest.common.mvc.api.IInjector;

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
