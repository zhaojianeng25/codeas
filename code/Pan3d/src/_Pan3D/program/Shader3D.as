package _Pan3D.program
{
	import com.adobe.AGALMiniAssembler;
	
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;
	
	public class Shader3D implements IShader3D
	{
		protected var _vertex:String;
		protected var _fragment:String;
		private var vertexByte:ByteArray;
		private var fragmentByte:ByteArray;
		protected var version:int = 1;
		public var paramAry:Array;
		public var LN:String = "\n"
		public function Shader3D()
		{
		}
		
		public function get vertexShaderByte():ByteArray
		{
			return vertexByte;
		}
		
		public function get fragmentShaderByte():ByteArray
		{
			return fragmentByte;
		}
		
		public function encode(agal:AGALMiniAssembler):void
		{
			vertexByte = agal.assemble(Context3DProgramType.VERTEX,vertex,version);
			fragmentByte = agal.assemble(Context3DProgramType.FRAGMENT,fragment,version);
		}

		public function get vertex():String
		{
			return _vertex;
		}

		public function set vertex(value:String):void
		{
			_vertex = value;
		}

		public function get fragment():String
		{
			return _fragment;
		}

		public function set fragment(value:String):void
		{
			_fragment = value;
		}

		
	}
}