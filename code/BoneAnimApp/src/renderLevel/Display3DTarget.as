package renderLevel
{
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.texture.TextureManager;
	
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public class Display3DTarget extends Display3DSprite implements IBind
	{
		public function Display3DTarget(context:Context3D)
		{
			super(context);
			init();
		}
		public function init() : void {
			var loaderinfo : LoadInfo = new LoadInfo("assets/model/box512.obj", LoadInfo.XML, onObjLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		
		override protected function onObjLoad(str : String) : void {
			_objData = AnalysisServer.getInstance().analysisObj(str);
			TextureManager.getInstance().addTexture("assets/model/box512.jpg", addTexture, null,0);
		}
		
		public function getSocket(socketName:String,resultMatrix:Matrix3D):void{
			
		}
		
		public function getPosV3d(index:int,outVec:Vector3D):void{
			var vc3d:Vector3D = new Vector3D(this.x,0,this.z)
			outVec = vc3d;
		}
		
		public function getOffsetPos(v3d:Vector3D,index:int):Vector3D{
			return new Vector3D(this.x + v3d.x,v3d.y,this.z + v3d.z);
		}
		
		public function getPosMatrix(index:int):Matrix3D{
			return new Matrix3D;
		}
		
		public function getRotation():Number{
			return 0;
		}
		
		public function getScale():Number{
			return 1;
		}
		
		public function get hasDispose():Boolean{
			return true;
		}
		
		public function getBindAlpha():Number{
			return 1;
		}
		
	}
}