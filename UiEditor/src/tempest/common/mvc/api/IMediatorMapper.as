package tempest.common.mvc.api {
	import tempest.common.mvc.base.AutoType;
	import tempest.common.mvc.base.MediatorMapper;

	public interface IMediatorMapper {
		function toMediator(mediatorCls:Class, autoType:int = AutoType.ADD_REMOVE, over:Boolean = false):MediatorMapper;
		function withChild(obj:Class, mediatorCls:Class, autoType:int = AutoType.ADD_REMOVE, over:Boolean = false):MediatorMapper;
	}
}
