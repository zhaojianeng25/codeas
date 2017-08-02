package _Pan3D.program
{
	import com.adobe.AGALMiniAssembler;
	
	import flash.utils.ByteArray;

	public interface IShader3D
	{
		function get vertexShaderByte():ByteArray;
		function get fragmentShaderByte():ByteArray;
		function encode(agal:AGALMiniAssembler):void;
	}
}