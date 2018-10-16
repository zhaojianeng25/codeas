package tempest.common.mvc.base
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.as3commons.logging.api.ILogger;
	import org.osflash.signals.IPrioritySignal;
	import org.osflash.signals.ISignal;

	import tempest.common.mvc.api.ICommand;
	import tempest.common.mvc.api.ICommandMap;
	import tempest.common.mvc.api.ICommandMapper;
	import tempest.common.mvc.api.ITFacade;
	import tempest.common.obj.ISyncEventRecorder;
	import tempest.common.staticdata.SyncEventIndexValueType;

	public class CommandMap implements ICommandMap
	{
		private var _facade:ITFacade;
		private var _logger:ILogger;
		private var _commands:Dictionary=new Dictionary(true);
		private var _commandList:Dictionary=new Dictionary();
		private var _eventDispatcher:IEventDispatcher;

		public function CommandMap(facade:ITFacade, eventDispatcher:IEventDispatcher)
		{
			_facade=facade;
			_logger=_facade.logger;
			_eventDispatcher=eventDispatcher;
		}

		public function get facade():ITFacade
		{
			return _facade;
		}

		[Deprecated]
		public function map(signals:Array, commandCls:Class, once:Boolean=false, priority:int=0):void
		{
			if (signals && commandCls)
			{
				var command:*=new commandCls();
				if (command == null)
				{
					throw new Error(commandCls + " is not ICommand Class");
				}
				var callBack:Function;
				if (command is ICommand)
				{
					callBack=command["execute"];
				}
				else
				{
					callBack=command["getHandle"]();
				}
				if (callBack == null)
				{
					throw new Error(commandCls + " handle is null");
				}
				if (signals.length < 1)
				{
					throw new Error("must has more than one args");
				}
				signals.forEach(function(signal:*, index:int, arr:Array):void
				{
					if (signal is Class)
					{
						signal=_facade.injector.getInstance(signal);
					}
					if (signal == null)
					{
						throw new Error("this is not ISignal");
					}
					unmap(signal);
					_commands[signal]=command;
					if (command is Command)
					{
						command.setFacade(_facade);
						command.setInject(_facade.injector);
					}
					_facade.injector.injectInto(command);
					if (priority != 0 && signal is IPrioritySignal)
					{
						if (once)
						{
							IPrioritySignal(signal).addOnceWithPriority(callBack, priority);
							IPrioritySignal(signal).addOnceWithPriority(function(... args):void
							{
								unmap(signal);
							}, priority);
						}
						else
						{
							IPrioritySignal(signal).addWithPriority(callBack, priority);
						}
					}
					else
					{
						if (once)
						{
							signal.addOnce(callBack);
							signal.addOnce(function(... args):void
							{
								unmap(signal);
							});
						}
						else
						{
							signal.add(callBack);
						}
					}
				});
			}
		}

		public function mapSignal(signalClass:Class, name:String=""):ICommandMapper
		{
			return _commandList[getKey(signalClass, name)]||=new SignalCommandMapper(signalClass, name, _facade.injector);
		}

		public function unmap_(cls:Class, name:String=""):void
		{
			var key:String=getKey(cls, name);
			var scm:ICommandMapper=_commandList[key];
			if (scm)
			{
				scm["destroy"] && scm["destroy"]();
				_commandList[key]=null;
				delete _commandList[key];
			}
		}

		public function unmapSyncEvent_(guid:String, valueIndex:int):void
		{
			unmap_(ISyncEventRecorder, guid + valueIndex);
		}

		private function getKey(signalClass:Class, name:String):String
		{
			return signalClass + name;
		}

//		[Deprecated]
		public function unmap(signal:ISignal):void
		{
			if (signal)
			{
				var _command:*=_commands[signal];
				if (_command)
				{
					if (_command is ICommand)
					{
						signal.remove(_command.execute);
					}
					else
					{
						_command.setFacade(null);
						_command.setInject(null);
						signal.remove(_command.getHandle());
					}
					_facade.injector.destroyInstance(_command);
					_commands[signal]=null;
					delete _commands[signal];
				}
			}
		}

		//////////////////////////////////////////////
		public function mapEvent(type:String, eventCls:Class, eventDispatcher:IEventDispatcher=null):ICommandMapper
		{
			return _commandList[getKey(eventCls, type)]||=new EventCommandMapper(eventCls, type, _facade.injector, eventDispatcher || _eventDispatcher);
		}

		public function mapSyncEventListen(valueIndex:int, dispatcher:ISyncEventRecorder):ICommandMapper
		{
			return _commandList[getKey(ISyncEventRecorder, dispatcher.guid + valueIndex.toString())]||=new SyncEventCommandMapper(SyncEventIndexValueType.VALUE_TYPE_NUMBER, valueIndex, _facade.injector, dispatcher);
		}

		public function mapSyncEventListenString(valueIndex:int, dispatcher:ISyncEventRecorder):ICommandMapper
		{
			return _commandList[getKey(ISyncEventRecorder, dispatcher.guid + valueIndex.toString())]||=new SyncEventCommandMapper(SyncEventIndexValueType.VALUE_TYPE_STRING, valueIndex, _facade.injector, dispatcher);
		}

		public function unmapAll():void
		{
			var scm:ICommandMapper;
			for each (scm in _commandList)
			{
				scm["destroy"] && scm["destroy"]();
			}
			_commandList=new Dictionary();
			var _signal:Object;
			for (_signal in _commands)
			{
				unmap(ISignal(_signal));
			}
		}
	}
}
