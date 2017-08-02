package _Pan3D.lineTri
{
	import _Pan3D.base.BaseLevel;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3D;
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.interfaces.IDisplay3D;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.geom.Vector3D;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class ModelLine3DLevel   extends BaseLevel
	{

		public function ModelLine3DLevel()
		{
			super();
		}
		override protected function initData():void
		{
			addLine();
			upModeData();
		}
		override public function resetStage():void
		{
			this._context3D=Scene_data.context3D;
			addShaders();
			var tempLineTri3DSprite:LineTri3DSprite;
			for each (var iDisplay3D:IDisplay3D in _display3DContainer.childrenList){
				tempLineTri3DSprite=iDisplay3D as LineTri3DSprite;
				tempLineTri3DSprite.resetStage();
				tempLineTri3DSprite.program= Program3DManager.getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			}
		}
		override protected function addShaders():void
		{
			Program3DManager.getInstance().registe(LineTri3DShader.LINE_TRI3D_SHADER,LineTri3DShader);
		}
		public function upModeData(_objData:ObjData=null,pos:Vector3D=null):void
		{
			idNum=0;
			pos=pos?pos:new Vector3D;
			var tempLineTri3DSprite:LineTri3DSprite;
			for each (var iDisplay3D:IDisplay3D in _display3DContainer.childrenList){
				tempLineTri3DSprite=iDisplay3D as LineTri3DSprite;
				tempLineTri3DSprite.clear();
			}
			if(!_objData||!_objData.indexs||!_isShow){
				return;
			}
			var a:int;
			var b:int;
			var c:int;
			var P0:Vector3D;
			var P1:Vector3D;
			var P2:Vector3D;
		//	var num:uint=500;
		//	num=num>_objData.indexs.length/3?_objData.indexs.length/3-1:num;
			for(var i:uint=0;i<_objData.indexs.length/3;i++)
			{
				 a=_objData.indexs[i*3+0];
				 b=_objData.indexs[i*3+1];
				 c=_objData.indexs[i*3+2];
				 
				 P0=new Vector3D(_objData.vertices[a*3+0],_objData.vertices[a*3+1]+1,_objData.vertices[a*3+2]);
				 P1=new Vector3D(_objData.vertices[b*3+0],_objData.vertices[b*3+1]+1,_objData.vertices[b*3+2]);
				 P2=new Vector3D(_objData.vertices[c*3+0],_objData.vertices[c*3+1]+1,_objData.vertices[c*3+2]);
               
			     if(i%1000==999){
					 idNum++;
				     if(idNum>=_display3DContainer.childrenList.length)
					 {
						 addLine();
						// break;
					 }
				 }
				 var tempTri3DSprite:LineTri3DSprite= _display3DContainer.childrenList[idNum] as LineTri3DSprite;
				 if(tempTri3DSprite){
					 tempTri3DSprite.colorVector3d=new Vector3D(0.95,0.95,0.95);
					 tempTri3DSprite.makeLineMode(P0,P1,0.5);
					 tempTri3DSprite.makeLineMode(P1,P2,0.5);
					 tempTri3DSprite.makeLineMode(P2,P0,0.5);
				 }
			
			}
			for each (var endiDisplay3D:IDisplay3D in _display3DContainer.childrenList){
				tempLineTri3DSprite=endiDisplay3D as LineTri3DSprite;
				if(tempLineTri3DSprite.objData.indexs){
					tempLineTri3DSprite.refreshGpu();
					tempLineTri3DSprite.x=pos.x;
					tempLineTri3DSprite.y=pos.y;
					tempLineTri3DSprite.z=pos.z;
				}
			}
			
		}
		private var idNum:uint=0;
		private function addLine():void
		{
			var _lineTri3DSprite:LineTri3DSprite=new LineTri3DSprite(_context3D);
			_lineTri3DSprite.x=0;
			_lineTri3DSprite.y=0;
			_lineTri3DSprite.z=0;
			_lineTri3DSprite.scale=1;
			_lineTri3DSprite.clear();
			_display3DContainer.addChild(_lineTri3DSprite);
			var tmpeProgram3d:Program3D = Program3DManager.getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			_lineTri3DSprite.setProgram3D(tmpeProgram3d);
		}
		override public function upData():void
		{
		    if(_isShow){	
				_display3DContainer.update();
			}
		}
	}
}