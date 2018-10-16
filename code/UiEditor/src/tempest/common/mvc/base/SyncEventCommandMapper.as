package tempest.common.mvc.base
{
	import tempest.common.mvc.api.ICommandExector;
	import tempest.common.mvc.api.ICommandMapper;
	import tempest.common.mvc.api.IInjector;
	import tempest.common.obj.IBinLogStru;
	import tempest.common.obj.ISyncEventRecorder;
	import tempest.common.staticdata.SyncEventIndexValueType;

	public class SyncEventCommandMapper implements ICommandMapper
	{
		private var _valueType:String;
		private var _valueIndex:int;
		private var commandList:Vector.<CommandExector>=new Vector.<CommandExector>();
		private var _injector:IInjector;
		private var _syncEventRecorder:ISyncEventRecorder;
		private var _isExcute:Boolean=false;

		public function SyncEventCommandMapper(valueType:String, valueIndex:int, injector:IInjector, syncEventRecorder:ISyncEventRecorder, isExcute:Boolean=false)
		{
			_injector=injector.createChild();
			_syncEventRecorder=syncEventRecorder;
			_valueIndex=valueIndex;
			_valueType=valueType;
			_isExcute=isExcute;
			switch (valueType)
			{
				case SyncEventIndexValueType.VALUE_TYPE_NUMBER:
					_syncEventRecorder.AddListen(_valueIndex, listener);
					break;
				case SyncEventIndexValueType.VALUE_TYPE_STRING:
					_syncEventRecorder.AddListenString(_valueIndex, listener);
					break;
			}

		}

		private function listener(binlog:IBinLogStru):void
		{
			if (commandList && commandList.length > 0)
			{
				binlog && _injector.map(IBinLogStru).toValue(binlog);
				var i:int=commandList.length;
				var exector:CommandExector;
				while (i--)
				{
					exector=commandList[i];
					exector.execute(_injector);
					if (exector.once)
					{
						commandList.splice(i, 1);
					}
				}
				_injector.unmap(IBinLogStru);
			}
		}

		public function toCommand(commandCls:Class, once:Boolean=false):ICommandExector
		{
			var commandExector:ICommandExector=getCommand(commandCls);
			if (!commandExector)
			{
				commandExector=new CommandExector(commandCls, once);
				commandList.push(commandExector);
			}
			return commandExector;
		}

		private function getCommand(commandCls:Class):ICommandExector
		{
			var i:int=commandList.length;
			while (i--)
			{
				if (commandList[i].commandCls == commandCls)
				{
					return commandList[i];
				}

			}
			return null;
		}

		private function hasCommand(commandCls:Class):Boolean
		{
			var i:int=commandList.length;
			while (i--)
			{
				if (commandList[i].commandCls == commandCls)
					return true;
			}
			return false;
		}
	}
}
import tempest.common.mvc.api.ICommand;
import tempest.common.mvc.api.ICommandExector;
import tempest.common.mvc.api.IInjector;

class CommandExector implements ICommandExector
{
	public var once:Boolean=false;
	public var commandCls:Class;
	public var command:ICommand;

	public function CommandExector(commandCls:Class, once:Boolean=false):void
	{
		this.commandCls=commandCls;
		once=once;
	}

	public function execute(injector:IInjector):void
	{
		command||=new commandCls();
		injector.injectInto(command);
		command.execute();
		injector.destroyInstance(command);
		if (once)
		{
			commandCls=null;
			command=null;
		}
	}
}
