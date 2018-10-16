package  _Pan3D.display3D.ground
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import PanV2.TextureCreate;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import terrain.GroundData;
	import terrain.GroundMath;
	import terrain.TerrainData;
	
	public class GroundDisplaySprite extends ModelHasDepthSprite
	{
		private var _hightBitmapData:BitmapData;
		private var _nrmMapText:RectangleTexture;
		private var _idInfoText:RectangleTexture;
		private var _grassInfoText:RectangleTexture;
		private var _sixteenUvTexture:RectangleTexture;
		private var _quickBitmapData:BitmapData;
		private var _quickTexture:Texture;
		private var _lightMapTexture:Texture
		private var _baseGroundObjData:GroundObjData;
		private var _terrainData:TerrainData;
	

		
		
		private var _maxLodLevel:uint=2;

		public function GroundDisplaySprite(context:Context3D)
		{
			super(context);
			
		//	_lightMapTexture = TextureManager.getInstance().defaultLightTextVo.texture;
		}

		public function get lightMapTexture():Texture
		{
			return _lightMapTexture;
		}

		public function set lightMapTexture(value:Texture):void
		{
			_lightMapTexture = value;
		}

		public function get quickTexture():Texture
		{
			return _quickTexture;
		}
		public function set quickTexture(value:Texture):void
		{
			_quickTexture = value;
		}
		public function get quickBitmapData():BitmapData
		{
			return _quickBitmapData;
		}
		public function set quickBitmapData(value:BitmapData):void
		{
			_quickBitmapData = value;
		}
		public function get terrainData():TerrainData
		{
			return _terrainData;
		}
		public function get sixteenUvTexture():RectangleTexture
		{
			return _sixteenUvTexture;
		}
		public function set sixteenUvTexture(value:RectangleTexture):void
		{
			_sixteenUvTexture = value;
		}
		public function get grassInfoText():RectangleTexture
		{
			return _grassInfoText;
		}
		public function get baseGroundObjData():GroundObjData
		{
			return _baseGroundObjData;
		}
		public function get idInfoText():RectangleTexture
		{
			return _idInfoText;
		}
		public function get nrmMapText():RectangleTexture
		{
			return _nrmMapText;
		}
		override public function dispose():void
		{
			super.dispose()
		}
		public function set idInfoBitmapData($bmp:BitmapData):void
		{
			if(_idInfoText){
				_idInfoText.dispose()
			}
			_idInfoText=TextureCreate.getInstance().bitmapToRectangleTexture($bmp)
		}
		public function set grassInfoBitmapData($bmp:BitmapData):void
		{
			if(_grassInfoText){
				_grassInfoText.dispose()
			}
			_grassInfoText=TextureCreate.getInstance().bitmapToRectangleTexture($bmp)
		}
		public function resetNrmText():void
		{
			if(_nrmMapText){
				_nrmMapText.dispose()
			}
			_nrmMapText=TextureCreate.getInstance().bitmapToRectangleTexture(_terrainData.normalMap)
			if(false){
				mathNrmForBmp(_terrainData)
			}
				
		}
		private  function mathNrmForBmp($terrainData:TerrainData):void
		{
			for(var i:uint=0;i<$terrainData.vertices.length/3;i++){
				var p:Vector3D=new Vector3D($terrainData.vertices[i*3+0],0,$terrainData.vertices[i*3+2]);
				p.scaleBy(1/$terrainData.area_Size*$terrainData.area_Cell_Num)
				var c:Vector3D=MathCore.hexToArgbNum($terrainData.normalMap.getPixel(p.x,p.z))
				c=c.subtract(new Vector3D(0.5,0.5,0.5))	
				c.normalize()
				$terrainData.normals[i*3+0]=c.x
				$terrainData.normals[i*3+1]=c.y
				$terrainData.normals[i*3+2]=c.z
			}
			
			_baseGroundObjData.normalsBuffer = _context3D.createVertexBuffer($terrainData.normals.length / 3, 3);
			_baseGroundObjData.normalsBuffer.uploadFromVector(Vector.<Number>($terrainData.normals), 0, $terrainData.normals.length / 3);

		}
		public function set terrainData($terrainData:TerrainData):void
		{
			_terrainData=$terrainData
			_baseGroundObjData=new GroundObjData;
			_baseGroundObjData.getDataByTerrain(_terrainData);
			resetNrmText()
			upLodAndToIndex()
			
			x=_terrainData.positon.x
			y=_terrainData.positon.y
			z=_terrainData.positon.z
				

		}

		private var _lightProgram3d:Program3D
		override protected function init():void
		{
			Program3DManager.getInstance().registe(GroundDisplayShader.GROUND_DISPLAY_SHADER,GroundDisplayShader)
			_program=Program3DManager.getInstance().getProgram(GroundDisplayShader.GROUND_DISPLAY_SHADER)
			Program3DManager.getInstance().registe(GroundDisplayAndLightMapShader.GROUND_DISPLAY_AND_LIGHTMAP_SHADER,GroundDisplayAndLightMapShader)
			_lightProgram3d=Program3DManager.getInstance().getProgram(GroundDisplayAndLightMapShader.GROUND_DISPLAY_AND_LIGHTMAP_SHADER)
			super.init()
		}	
  
		
		
		
		public function upLodAndToIndex():void
		{
			if(_baseGroundObjData.vertices)
			{
				GroundMath.getInstance().getTerrainIndex(_terrainData,new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z),_maxLodLevel);
				_baseGroundObjData.getDataByTerrain(_terrainData);
				uplodToGpu();
				
			}
		}
		override public function showTriLine(value:Boolean):void
		{
			super.showTriLine(value);
			if(value){
				_modelLineSprite.setModelObjData(_baseGroundObjData);
			}
		}
		override protected function uplodToGpu() : void {
			if(_baseGroundObjData.vertexBuffer)
			{
				_baseGroundObjData.vertexBuffer.dispose();
			}

			_baseGroundObjData.vertexBuffer = _context3D.createVertexBuffer(_baseGroundObjData.vertices.length / 3, 3);
			_baseGroundObjData.vertexBuffer.uploadFromVector(Vector.<Number>(_baseGroundObjData.vertices), 0, _baseGroundObjData.vertices.length / 3);

			if(_baseGroundObjData.indexBuffer)
			{
				_baseGroundObjData.indexBuffer.dispose();
			}
			_baseGroundObjData.indexBuffer = _context3D.createIndexBuffer(_baseGroundObjData.indexs.length);
			_baseGroundObjData.indexBuffer.uploadFromVector(Vector.<uint>(_baseGroundObjData.indexs), 0, _baseGroundObjData.indexs.length);
			if(_baseGroundObjData.uvBuffer)
			{
				_baseGroundObjData.uvBuffer.dispose();
			}
			_baseGroundObjData.uvBuffer= _context3D.createVertexBuffer(_baseGroundObjData.uvs.length / 2, 2);
			_baseGroundObjData.uvBuffer.uploadFromVector(Vector.<Number>(_baseGroundObjData.uvs), 0, _baseGroundObjData.uvs.length / 2);
			
	
		}

		public function get triNum():uint
		{
			if(_baseGroundObjData&&_baseGroundObjData.indexs)
			{
				return _baseGroundObjData.indexs.length/3
			}else
			{
				return 0
			}
		}


		override public function update():void
		{
			if(true){ 
				upBase()
			}
			super.update()
			if(_baseGroundObjData.indexs){
				Scene_data.drawTriangle+=_baseGroundObjData.indexs.length/3
			}
		}
		protected function upBase():void
		{
			if(_baseGroundObjData&&_baseGroundObjData.indexBuffer){
				if(useLight){
					_context3D.setProgram(_lightProgram3d)
				}else{
					_context3D.setProgram(_program)
				}
				_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8,posMatrix, true);
				setVc()
				setVa()
				resetVa()
			}
		}
	
		public  var brushSize:int = 10;//笔刷大小
		public  var brushPow:Number = 0.2;//笔刷力度
		public  var brushBluer:Number = 0.5;//笔刷力度
		override protected function setVc() : void {
			
			var aerSize:uint=GroundData.terrainMidu*GroundData.cellScale*4

			var sunColorV:Vector3D=Scene_data.light.SunLigth.color.clone()
			sunColorV.scaleBy(1/255*Scene_data.light.SunLigth.intensity);
			sunColorV=new Vector3D(2,2,2,2)
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([sunColorV.x,sunColorV.y,sunColorV.z,sunColorV.w]));
			
			var $m:Matrix3D=new Matrix3D
			//$m.appendRotation(k++,Vector3D.Y_AXIS)
			var $nrm:Vector3D=Scene_data.light.SunLigth.dircet
			$nrm.normalize()
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([$nrm.x,$nrm.y,$nrm.z,1])); //法线
			var $groundHitPos:Vector3D=GroundData.groundHitPos
			
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([$groundHitPos.x,$groundHitPos.y,$groundHitPos.z,0])); //法线
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([aerSize,aerSize,0,0])); //法线
			
			
			var $outSize:Number=brushSize*5*((GroundData.terrainMidu*GroundData.cellScale*4)/400)*(10/GroundData.terrainMidu)
			var $inSize:Number=(1-brushBluer)*$outSize
	
			var $alpha:Number=brushPow
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([1/(brushBluer),$alpha,$inSize,$outSize]));

			
			var AmbientLightColorV:Vector3D=Scene_data.light.AmbientLight.color.clone()
			AmbientLightColorV.scaleBy(1/255*Scene_data.light.AmbientLight.intensity);
			AmbientLightColorV=new Vector3D(0.5,0.5,0.5,1)
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([AmbientLightColorV.x,AmbientLightColorV.y,AmbientLightColorV.z,AmbientLightColorV.w]));
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 6, Vector.<Number>([200/255,200/255,200/255,1]));
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 7, Vector.<Number>([0,0.5,1,2]));//强度w
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 8, Vector.<Number>([1,GroundData.showShaderHitPos?1:0,1,1]));
			
			//trace(GroundDisplaySprite.showShaderHitPos)
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 40, Vector.<Number>([255,0,0,GroundData.sixteenNum])); 
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 41, Vector.<Number>([0,1,2,255]));    //编号
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 42, Vector.<Number>([0.1,0.1,0.8,0]));   //
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 43, Vector.<Number>([0,0,0,15]));   //
			
		}
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, baseGroundObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, baseGroundObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setTextureAt(0,nrmMapText)
			_context3D.setTextureAt(1,idInfoText);    //id
			_context3D.setTextureAt(2,grassInfoText); //强度
			_context3D.setTextureAt(3,sixteenUvTexture);
			_context3D.setTextureAt(4,GroundData.uvMiduTexture);
			if(useLight){
				_context3D.setTextureAt(5,this.lightMapTexture);
			}
			
			_context3D.drawTriangles(baseGroundObjData.indexBuffer, 0, -1);
		}
		private function get useLight():Boolean
		{
			if(_lightMapTexture&&!GroundData.isEditNow&&!GroundData.showShaderHitPos){
				return true
			}else{
				return false
			}
		}
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setVertexBufferAt(3, null);
			_context3D.setTextureAt(0,null)
			_context3D.setTextureAt(1,null)
			_context3D.setTextureAt(2,null)
			_context3D.setTextureAt(3,null)
			_context3D.setTextureAt(4,null)
			_context3D.setTextureAt(5,null)
		}
		
	}
}