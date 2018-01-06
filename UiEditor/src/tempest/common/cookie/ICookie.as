package tempest.common.cookie
{

	public interface ICookie
	{
		function getValue(name:String):Object;
		function unlock():void;
		function deleteValue(value:String):void;
		function lock():void;
		function clear():void;
		function setValue(key:String, value:Object):void;
	}
}
