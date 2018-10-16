package tempest.common.mvc.base
{
	import flash.utils.Dictionary;

	import tempest.common.mvc.api.IMediatorMap;
	import tempest.common.mvc.api.IMediatorMapper;
	import tempest.common.mvc.api.ITFacade;

	public class MediatorMap implements IMediatorMap
	{
		private var _facade:ITFacade;
		private var mediatorList:Dictionary=new Dictionary();

		public function MediatorMap(facade:ITFacade)
		{
			_facade=facade;
		}

		public function get facade():ITFacade
		{
			return _facade;
		}

		public function destroy():void
		{
			unmapAll();
			_facade=null;
		}

		public function unmapAll():void
		{
			var mediatorMapper:IMediatorMapper;
			for each (mediatorMapper in mediatorList)
			{
				mediatorMapper["destroy"]();
			}
			mediatorList=new Dictionary();
		}

		///////////////////////////////////////////////////////////////////////////////////
		public function mediate(obj:Object):void
		{
			if (!obj)
			{
				return;
			}
			var type:Class=obj["constructor"];
			if (mediatorList[type])
			{
				MediatorMapper(mediatorList[type]["createMediator"](obj)).onShow();
			}
		}

		public function unmediate(obj:Object):void
		{
			if (!obj)
			{
				return;
			}
			var type:Class=obj["constructor"];
			mediatorList[type] && MediatorMapper(mediatorList[type]).onHide();
		}

		public function map_(obj:Object):IMediatorMapper
		{
			if (!obj)
			{
				return null;
			}
			var type:Class=obj as Class || obj["constructor"];
			return mediatorList[type]||=new MediatorMapper(type, _facade.injector, _facade.logger, _facade);
		}

		public function unmap_(obj:Object):void
		{
			if (!obj)
			{
				return;
			}
			var type:Class=obj as Class || obj["constructor"];
			var mediatorMapper:IMediatorMapper=mediatorList[type];
			if (mediatorMapper)
			{
				mediatorMapper["destroy"]();
				mediatorList[type]=null;
				delete mediatorList[type];
			}
		}

		public function proccess(obj:Object, create:Boolean=true):void
		{
			if (!obj)
			{
				return;
			}
			var type:Class=obj["constructor"];
			mediatorList[type] && (create ? mediatorList[type]["createMediator"](obj) : mediatorList[type]["destroyMediator"]())
		}
	}
}
