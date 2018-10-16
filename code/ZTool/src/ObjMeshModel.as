
package  
{
	
	import away3d.events.ParserEvent;
	import away3d.loaders.parsers.OBJParser;
	
	public class ObjMeshModel
	{
		private var _objParser:OBJParser;
		private var _bFun:Function
		private static var instance:ObjMeshModel;
		public function ObjMeshModel()
		{
		}
		public static function getInstance():ObjMeshModel{
			if(!instance){
				instance = new ObjMeshModel();
			}
			return instance;
		}
		public function setData($str:String,$fun:Function):void
		{
			_bFun=$fun
			_objParser=new OBJParser
			_objParser.parseAsync($str)
			_objParser.addEventListener(ParserEvent.PARSE_COMPLETE,onComeee)
			
			
		}
		
		protected function onComeee(event:ParserEvent):void
		{

			
			
			
			
		}

		
	}
}