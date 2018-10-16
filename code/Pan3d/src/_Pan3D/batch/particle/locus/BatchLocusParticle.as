package _Pan3D.batch.particle.locus
{
	import _Pan3D.batch.particle.BatchParticle;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.locus.GpuLocusData;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.utils.Tick;
	
	import _me.Scene_data;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	
	public class BatchLocusParticle extends BatchParticle
	{
		private var _particleList:Vector.<ILocusBatch>;
		private var _gpuLocusData:GpuLocusData;
		
		public function BatchLocusParticle()
		{
			super();
			_particleList = new Vector.<ILocusBatch>;
			_idleNum = 10;
			_gpuLocusData=new GpuLocusData;
			Tick.addCallback(tickUpload);
		}
		private var hasNew:Boolean;
	
		override public function add(particle:Display3DParticle):void{
			Program3DManager.getInstance().registe(BatchLocusShader.BATCH_LOCUS_SHADER,BatchLocusShader)
			_program = Program3DManager.getInstance().getProgram(BatchLocusShader.BATCH_LOCUS_SHADER);
			var facet:ILocusBatch = particle as ILocusBatch;
			_particleList.push(facet);
			_idleNum--;
			hasNew = true;
		}
		override public function remove(particle:Display3DParticle):int{
			var index:int = _particleList.indexOf(particle);
			if(index != -1){
				_particleList.splice(index,1);
				_idleNum++;
				hasNew = true;
				if(_idleNum == 10){
					return 0;
				}else{
					return 1;
				}
			}
			return -1;
		}
		private function tickUpload():void{
			if(!hasNew){
				return;
			}
			if(particleData.vertexBuffer){
				particleData.vertexBuffer.dispose();
				particleData.uvBuffer.dispose();
				particleData.vaDataBuffer.dispose();
				particleData.indexBuffer.dispose();
			}
			if(_particleList.length)
				uplodToGpu();
			hasNew = false;
		}
		
		protected function uplodToGpu() : void {
			_gpuLocusData.vertices=new Vector.<Number>
			_gpuLocusData.uvs=new Vector.<Number>
			_gpuLocusData.indexs=new Vector.<uint>

			_gpuLocusData.normals=new Vector.<Number>
				
			var $indexNum:uint=0
			for(var i:int;i<_particleList.length;i++){
				var $gpuTuoQiuData:GpuLocusData = _particleList[i].particleData as GpuLocusData;
				_gpuLocusData.vertices = _gpuLocusData.vertices.concat($gpuTuoQiuData.vertices);
				_gpuLocusData.uvs = _gpuLocusData.uvs.concat($gpuTuoQiuData.uvs);
				_gpuLocusData.normals = _gpuLocusData.normals.concat($gpuTuoQiuData.normals);
				for(var j:int=0;j<($gpuTuoQiuData.indexs.length);j++){
					_gpuLocusData.indexs.push($gpuTuoQiuData.indexs[j]+$indexNum)
				}
				for(var k:int=0;k<$gpuTuoQiuData.vertices.length / 3;k++){

				}
				$indexNum=$indexNum+$gpuTuoQiuData.indexs.length/3+2
					
				var $m:Matrix=new Matrix()
				$m.ty=i*2
				_colorTextureBmp.draw(_particleList[i].getBmpJbColor(),$m);
			}

			_gpuLocusData.vertexBuffer = this._context3D.createVertexBuffer(_gpuLocusData.vertices.length / 3, 3);
			_gpuLocusData.vertexBuffer.uploadFromVector(Vector.<Number>(_gpuLocusData.vertices), 0, _gpuLocusData.vertices.length / 3);
			_gpuLocusData.uvBuffer = this._context3D.createVertexBuffer(_gpuLocusData.uvs.length / 4, 4);
			_gpuLocusData.uvBuffer.uploadFromVector(Vector.<Number>(_gpuLocusData.uvs), 0, _gpuLocusData.uvs.length / 4);
			_gpuLocusData.normalsBuffer = this._context3D.createVertexBuffer(_gpuLocusData.normals.length / 4, 4);
			_gpuLocusData.normalsBuffer.uploadFromVector(Vector.<Number>(_gpuLocusData.normals), 0, _gpuLocusData.normals.length / 4);

			_gpuLocusData.indexBuffer = this._context3D.createIndexBuffer(_gpuLocusData.indexs.length);
			_gpuLocusData.indexBuffer.uploadFromVector(Vector.<uint>(_gpuLocusData.indexs), 0, _gpuLocusData.indexs.length);

			upColorBmpToTexture();
				
		}
		override protected function setVa() : void {
			if(!_gpuLocusData.indexBuffer){
				return;
			}
			_context3D.setVertexBufferAt(0, _gpuLocusData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, _gpuLocusData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.setVertexBufferAt(2, _gpuLocusData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);

			_context3D.setTextureAt(0,_colorJBTexture);
			_context3D.drawTriangles(_gpuLocusData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_gpuLocusData.indexs.length/3);
		}
		private var _colorTextureBmp:BitmapData=new BitmapData(128,32,true,0)
		private var _colorJBTexture:Texture;
		private function upColorBmpToTexture():void
		{
			if(!_colorJBTexture){
				_colorJBTexture=TextureManager.getInstance().bitmapToTexture(_colorTextureBmp)
			}else{
				_colorJBTexture.uploadFromBitmapData(_colorTextureBmp);
			}
		}
		override protected function setVc() : void {
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,Vector.<Number>([1,2,4,24])); 
			for(var i:int;i<_particleList.length;i++){
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5+i*2,_particleList[i].getResultUV()); 
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,6+i*2, _particleList[i].getColor());
				_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,24+i*4,_particleList[i].getResultMatrix() , true);
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>( [1/16,0/32,1,1]));
			}
		}
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setVertexBufferAt(3, null);
			_context3D.setTextureAt(0,null);
		}
		
	}
	
}