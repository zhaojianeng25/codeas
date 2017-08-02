package _Pan3D.display3D.ground
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;
	
	import _Pan3D.display3D.ground.quick.QuickModelMath;
	import _Pan3D.display3D.ground.quick.QuickModelMathShader;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import terrain.GroundData;
	import terrain.TerrainData;
	
	public class GroundEditorSprite extends GroundDisplaySprite
	{
		public var lastLodPos:Vector3D=new Vector3D;
	
		public function GroundEditorSprite(context:Context3D)
		{
			super(context);
		}
		override public function set terrainData($terrainData:TerrainData):void
		{
			super.terrainData=$terrainData
			setTimeout(function ():void{
				if(true){
					scanQuickTexture();
				}
			},1000)
		}
		public function scanQuickTexture():void
		{
			QuickModelMath.getInstance().scanQuickTexture(this)
		}
		public function quickScanToBmp():void
		{

			Program3DManager.getInstance().registe(QuickModelMathShader.QUICK_MODEL_MATH_SHADER,QuickModelMathShader)
			_context3D.setProgram(Program3DManager.getInstance().getProgram(QuickModelMathShader.QUICK_MODEL_MATH_SHADER))
			setVc()
				_context3D.setVertexBufferAt(0, baseGroundObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1, baseGroundObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setTextureAt(0,nrmMapText)
				_context3D.setTextureAt(1,idInfoText);    //id
				_context3D.setTextureAt(2,grassInfoText); //强度
				_context3D.setTextureAt(3,sixteenUvTexture);
				_context3D.setTextureAt(4,GroundData.uvMiduTexture);
				_context3D.drawTriangles(baseGroundObjData.indexBuffer, 0, -1);
			
			resetVa()
		}
		
		override public function update():void
		{
			//强行不优化渲染
		
			if(quickTexture&&GroundData.isQuickScan&&!GroundData.isEditNow){
				QuickModelMath.getInstance().upData(this)
				if(_modelLineSprite){
					_modelLineSprite.posMatrix=this.posMatrix
					_modelLineSprite.update()
				}
			}else{
				super.update()
			}
			if(baseGroundObjData.indexs){
				Scene_data.drawTriangle+=baseGroundObjData.indexs.length/3
			}
		
		}
	
	
	}
}