package proxy.top.model
{
	import light.ReflectionTextureVo;
	

	public interface IWater extends IModel
	{
		function set reflectionTextureVo(value:ReflectionTextureVo):void
		function get reflectionTextureVo():ReflectionTextureVo;
	}
}