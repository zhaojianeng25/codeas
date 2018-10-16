package _Pan3D.lineTri
{
	import _Pan3D.base.ObjData;
	import _Pan3D.program.Program3DManager;
	
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	
	public class ModelObjDataLineSprite extends LineTri3DSprite
	{
		private var idNum:int=0
		private var _lineSprite3DItem:Vector.<LineTri3DSprite>=new Vector.<LineTri3DSprite>
		public function ModelObjDataLineSprite(context:Context3D)
		{
			super(context);
			Program3DManager.getInstance().registe(LineTri3DShader.LINE_TRI3D_SHADER,LineTri3DShader);
			_program= Program3DManager.getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
		
		}
		override public function update() : void {
			if(this._visible){	
				for each (var $lineTri3DSprite:LineTri3DSprite in _lineSprite3DItem){
					$lineTri3DSprite.update()
				}
			}
		}
		private function addLine():void
		{
			var _lineTri3DSprite:LineTri3DSprite=new LineTri3DSprite(_context);
			_lineTri3DSprite.x=0;
			_lineTri3DSprite.y=0;
			_lineTri3DSprite.z=0;
			_lineTri3DSprite.scale=1;
			_lineTri3DSprite.clear();
			_lineSprite3DItem.push(_lineTri3DSprite);
			_lineTri3DSprite.program=Program3DManager.getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
		}
		public function setObjData(_objData:ObjData=null,pos:Vector3D=null):void
		{
			idNum=0;
			pos=pos?pos:new Vector3D;
			var tempLineTri3DSprite:LineTri3DSprite;
			for each (var $lineTri3DSprite:LineTri3DSprite in _lineSprite3DItem){
				$lineTri3DSprite.clear();
			}
			_lineSprite3DItem=new Vector.<LineTri3DSprite>
			addLine();
			if(!_objData||!_objData.indexs){
				return;
			}
			var a:int;
			var b:int;
			var c:int;
			var P0:Vector3D;
			var P1:Vector3D;
			var P2:Vector3D;
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
					if(idNum>=_lineSprite3DItem.length)
					{
						addLine();
					}
				}
				var tempTri3DSprite:LineTri3DSprite= _lineSprite3DItem[idNum]
				if(tempTri3DSprite){
					tempTri3DSprite.colorVector3d=new Vector3D(0.95,0.95,0.95);
					tempTri3DSprite.makeLineMode(P0,P1,0.5);
					tempTri3DSprite.makeLineMode(P1,P2,0.5);
					tempTri3DSprite.makeLineMode(P2,P0,0.5);
				}
				
			}
			for each (var endiDisplay3D:LineTri3DSprite in _lineSprite3DItem){
				tempLineTri3DSprite=endiDisplay3D as LineTri3DSprite;
				if(tempLineTri3DSprite.objData.indexs){
					tempLineTri3DSprite.refreshGpu();
					tempLineTri3DSprite.x=pos.x;
					tempLineTri3DSprite.y=pos.y;
					tempLineTri3DSprite.z=pos.z;
				}
			}
		}
		override public function dispose():void
		{
			super.dispose();
			_lineSprite3DItem.length = 0;
			_lineSprite3DItem = null;
		}
	}
}