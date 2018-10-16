package renderLevel
{
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	
	import PanV2.xyzmove.lineTriV2.LineTri3DSprite;
	
	import _Pan3D.display3D.model.Display3DModelSprite;
	
	import _me.Scene_data;
	
	public class BoneHitModelSprite extends Display3DModelSprite
	{
		private static var instance:BoneHitModelSprite;
		private var _lineTri3DSprite:LineTri3DSprite;
		public function BoneHitModelSprite(context:Context3D)
		{
			super(context);
		}
		override protected function init():void
		{
//			this.objData=MakeModelData.makeJuXinTampData(new Vector3D(-10,0,-10),new Vector3D(10,0,10))
//			uplodToGpu();
			
			
			url="assets/model/boneBox.objs"
			this.visible=false
			addLine()
			
		}
		
		private function addLine():void
		{
			LineTri3DSprite.agalLevel=1
			LineTri3DSprite.thickNessScale=0.3
			_lineTri3DSprite=new LineTri3DSprite(_context3D)
			_lineTri3DSprite.clear()
			_lineTri3DSprite.colorVector3d=new Vector3D(1,0,0,1);
			_lineTri3DSprite.makeLineMode(new Vector3D,new Vector3D(100,100,100),1)
			_lineTri3DSprite.reSetUplodToGpu()
		
			
		}
		public function setBonePos($pos:Vector3D):void
		{
			if(this.posMatrix&&$pos){
				var a:Vector3D=$pos
				var b:Vector3D=this.posMatrix.position
				_lineTri3DSprite.clear()
				_lineTri3DSprite.colorVector3d=new Vector3D(1,0,0,1);
				_lineTri3DSprite.makeLineMode(a,b,1)
				_lineTri3DSprite.reSetUplodToGpu()
			}
	
			
		}
		override public function update() : void {
			
			if(_visible==false){
				return
			}
			
			if (_objData && _objData.indexBuffer) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
			}
			if(_lineTri3DSprite){
				_lineTri3DSprite.update()
			}
		}
		public static function getInstance():BoneHitModelSprite{
			if(!instance){
				instance = new BoneHitModelSprite(Scene_data.context3D);
			}
			return instance;
		}
		
	}
}