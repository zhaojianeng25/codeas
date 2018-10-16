package modules.hierarchy.h5
{
	import _Pan3D.base.ObjData;

	public class HitObjAnaly
	{
		private const LINE_FEED:String = String.fromCharCode(10);
		private const SPACE:String = String.fromCharCode(32);
		private const SLASH:String = "/";
		private const VERTEX:String = "v";
		private const NORMAL:String = "vn";
		private const UV:String = "vt";
		private const INDEX_DATA:String = "f";
		private const USEMTL:String = "usemtl";
		
		private var _faceIndex:uint;
		private var _vertices:Vector.<Number>;
		protected var _Indexs:Vector.<uint>;
		private var _mtl:String;
		//private var _cachedRawNormalsBuffer:Vector.<Number>;
		
		// the raw data that is used to create Molehill buffers

		
		public function HitObjAnaly()
		{
			
		}
		public function analysis(definition:String):ObjData{
			_Indexs = new Vector.<uint>();
			_vertices = new Vector.<Number>();
			
			
			_faceIndex = 0;
			
			// Split data in to lines and parse all lines.
			var lines:Array = definition.split(LINE_FEED);
			var loop:uint = lines.length;
			for(var i:uint = 0; i < loop; ++i){
				parseLine(lines[i]);
			}
			var objdata:ObjData = new ObjData();
		

			objdata.indexs=_Indexs
			objdata.vertices=_vertices
			return objdata;
		}
		private function parseLine(line:String):void
		{
			// Split line into words.
			var words:Array = line.split(SPACE);
			// Prepare the data of the line.
			if (words.length > 0){
				var data:Array = words.slice(1);
			}
			else{
				return;
			}
			// Check first word and delegate remainder to proper parser.
			var firstWord:String = words[0];
			if (firstWord == VERTEX){
				parseVertex(data);
			}

			else if (firstWord == INDEX_DATA){
				parseIndex(data);
			}
		
		}
		
		private function parseVertex(data:Array):void
		{
			if ((data[0] == '') || (data[0] == ' ')){
				data = data.slice(1); // delete blanks
			}
	
			var loop:uint = data.length;
			if (loop > 3) loop = 3;
			for (var i:uint = 0; i < loop; ++i)
			{
				var element:String = data[i];
				_vertices.push(Number(element));
			}
		

			//			}
		}
		


		private function parseIndex(data:Array):void
		{
			//if (!_Indexs.length) trace('parseIndex:' + data);
			var triplet:String;
			var subdata:Array;
			var vertexIndex:int;
			var uvIndex:int;
			var normalIndex:int;
			var index:uint;
			// Process elements.
			var i:uint;
			var loop:uint = data.length;
			var starthere:uint = 0;
			while ((data[starthere] == '') || (data[starthere] == ' ')) {
				starthere++; // ignore blanks
			}
			
			loop = starthere + 3;
			
	
			for(i = starthere; i < loop; ++i)
			{
				triplet = data[i];
				subdata = triplet.split(SLASH);
				vertexIndex = Math.abs(subdata[0]) - 1;
				uvIndex = Math.abs(subdata[1]) - 1;
				normalIndex = Math.abs(subdata[2]) - 1;
				// sanity check
				_Indexs.push(vertexIndex);
			}


		}
		public static var xpos:Boolean=true;

		
	}
}


