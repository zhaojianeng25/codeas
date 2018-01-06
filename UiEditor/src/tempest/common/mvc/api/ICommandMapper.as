package tempest.common.mvc.api {

	public interface ICommandMapper {
		function toCommand(commandCls:Class, once:Boolean = false):ICommandExector;
	}
}
