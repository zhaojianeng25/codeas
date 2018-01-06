package tempest.common.mvc.api {
	

	public interface IMediatorMap {
		function get facade():ITFacade;
		function unmapAll():void;
		function mediate(item:Object):void;
		function unmediate(item:Object):void;
		function map_(obj:Object):IMediatorMapper;
		function unmap_(obj:Object):void;
		function proccess(obj:Object, destroy:Boolean = false):void
	}
}
