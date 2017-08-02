package _Pan3D.display3D.analysis
{
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjData;
	import _Pan3D.vo.analysis.AnalysisQueueVo;
	
	import flash.utils.ByteArray;

	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class AnalysisServer
	{
		private var _md5Analysis:Md5Analysis;
		private var _md5ByteAnalysis:Md5ByteAnalysis;
		private var _md5AnimAnlysis:Md5animAnalysis;
		private var _md5ByteAnimAnlysis:Md5ByteAnimAnalysis;
		private var _objAnalysis:ObjAnalysis;
		private var _objByteAnalysis:ObjByteAnalysis;
		//public static var analysisQueue:Vector.<AnalysisQueueVo> = new Vector.<AnalysisQueueVo>;
		private static var instance:AnalysisServer;
		public function AnalysisServer()
		{
			_md5Analysis = new Md5Analysis;
			_md5ByteAnalysis = new Md5ByteAnalysis;
			_md5AnimAnlysis = new Md5animAnalysis;
			_md5ByteAnimAnlysis = new Md5ByteAnimAnalysis;
			_objAnalysis = new ObjAnalysis;
			_objByteAnalysis = new ObjByteAnalysis;
		}
		
		public static function getInstance():AnalysisServer{
			if(!instance){
				instance = new AnalysisServer();
			}
			return instance;
		}
		
		public function analysisMesh(str:String):MeshData{
			trace("mesh解析")
			return _md5Analysis.addMesh(str,1);
		}
		
		public function analysisByteMesh(byte:ByteArray):MeshData{
			return _md5ByteAnalysis.addMesh(byte);;
		}
		
		public function analysisAnim(str:String):Object{
			_md5AnimAnlysis.addAnim(str);
			return _md5AnimAnlysis.resultInfo;
		}
		
		public function analysisByteAnim(byte:ByteArray):Object{
			_md5ByteAnimAnlysis.addAnim(byte);
			return _md5ByteAnimAnlysis.resultInfo;
		}
		
		public function getMd5StrAry():Array{
			return _md5AnimAnlysis.bigArr;
		}
		
		public function getHierarchy():*{
			return _md5AnimAnlysis.hierarchy;
		}
		
		public function analysisObj(str:*):ObjData{
			if(str is String){
				return _objAnalysis.analysis(str);
			}else{
				return _objByteAnalysis.analysis(str);
			}
		}
		
		public function dispose():void{
			_md5ByteAnalysis.dispose();
			_md5ByteAnimAnlysis.dispose();
		}
		
	}
}