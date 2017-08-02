package _Pan3D.batch.particle.cylinder
{
	import _Pan3D.batch.particle.BatchParticle;
	import _Pan3D.batch.particle.facet.BatchFacetShader;
	import _Pan3D.particle.Display3DFacetPartilce;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.cylinder.Display3DCylinderPartilce;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.utils.Tick;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	
	public class BatchCylinderParticle extends BatchParticle
	{
		private var _particleList:Vector.<Display3DCylinderPartilce>;
		
		public function BatchCylinderParticle()
		{
			super();
			_particleList = new Vector.<Display3DCylinderPartilce>;
			_idleNum = 20;
			Tick.addCallback(tickUpload);
		}
		override public function add(particle:Display3DParticle):void{
			_program = Program3DManager.getInstance().getProgram(BatchCylinderShader.BATCH_CYLINDER_SHADER);
			var cylinder:Display3DCylinderPartilce = particle as Display3DCylinderPartilce;
			_particleList.push(cylinder);
			//uplodToGpu();
			hasNew = true;
			_idleNum--;
		}
		override public function remove(particle:Display3DParticle):int{
			var index:int = _particleList.indexOf(particle);
			if(index != -1){
				_particleList.splice(index,1);
				_idleNum++;
				hasNew = true;
				if(_idleNum == 20){
					return 0;
				}else{
					return 1;
				}
			}
			return -1;
		}
		private var hasNew:Boolean;
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
			particleData.vertices = new Vector.<Number>;
			particleData.uvs = new Vector.<Number>;
			particleData.indexs = new Vector.<uint>;
			particleData.vaData = new Vector.<Number>;
			for(var i:int;i<_particleList.length;i++){
				particleData.vertices = particleData.vertices.concat(_particleList[i].particleData.vertices);
				particleData.uvs = particleData.uvs.concat(_particleList[i].particleData.uvs);	
				var indexs:Vector.<uint> = _particleList[i].particleData.indexs;
				for(var h:int=0;h<indexs.length;h++){
					particleData.indexs.push(indexs[h]+l);
				}
				var l:int = particleData.vertices.length/3;
//				particleData.indexs = particleData.indexs.concat(_particleList[i].particleData.indexs);
				var vertices:Vector.<Number> = _particleList[i].particleData.vertices;
				for(var j:int=0;j<vertices.length/3;j++){
					particleData.vaData.push(i*6+8,i*6+4+8,i*6+5+8);
				}
			}
			
			particleData.vertexBuffer = this._context3D.createVertexBuffer(particleData.vertices.length / 3, 3);
			particleData.vertexBuffer.uploadFromVector(Vector.<Number>(particleData.vertices), 0, particleData.vertices.length / 3);
			
			particleData.uvBuffer = this._context3D.createVertexBuffer(particleData.uvs.length / 3, 3);
			particleData.uvBuffer.uploadFromVector(Vector.<Number>(particleData.uvs), 0, particleData.uvs.length / 3);
			
			particleData.vaDataBuffer = this._context3D.createVertexBuffer(particleData.vaData.length / 3, 3);
			particleData.vaDataBuffer.uploadFromVector(Vector.<Number>(particleData.vaData), 0, particleData.vaData.length / 3);
			
			particleData.indexBuffer = this._context3D.createIndexBuffer(particleData.indexs.length);
			particleData.indexBuffer.uploadFromVector(Vector.<uint>(particleData.indexs), 0, particleData.indexs.length);
			
		}
		
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(2, particleData.vaDataBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
//			_context3D.setTextureAt(1, particleData.texture);
//			_context3D.setTextureAt(2,_textureColor);
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(particleData.indexs.length/3);
		}
		
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
//			_context3D.setTextureAt(1,null);
//			_context3D.setTextureAt(2,null);
		}
		
		override protected function setVc() : void {
			for(var i:int;i<_particleList.length;i++){
				_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8+i*6, _particleList[i].getResultMatrix(), true);
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8+i*6+4, _particleList[i].getResultUV());
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8+i*6+5, _particleList[i].getColor());
			}
//			this.updateMatrix();
//			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
//			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, modeRotationMatrix, true);
//			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 24, modeZiZhuanMatrix3D, true);// 传入整个粒子的旋转 
//			
//			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>( [_timer/(1000/60)/_life,_timer/(1000/60),0,1])); 
//			
//			if(_colorChange){
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1+_colorChange.rValue*_colorChange.num, 1+_colorChange.gValue*_colorChange.num, 1+_colorChange.bValue*_colorChange.num, 1+_colorChange.aValue*_colorChange.num]));
//			}else{
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1,1,1,1]));
//			}
//			
//			if(_scaleChange && _scaleNosie){
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,Vector.<Number>( [_widthFixed?1:(_scaleChange.num + _scaleNosie.num),_heightFixed?1:(_scaleChange.num + _scaleNosie.num),1,1])); 
//			}else if(_scaleChange){
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,Vector.<Number>( [_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,1,1])); 
//			}else if(_scaleNosie){
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,Vector.<Number>( [_widthFixed?1:(this._scale + _scaleNosie.num),_heightFixed?1:(this._scale + _scaleNosie.num),1,1])); 
//			}else{
//				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,Vector.<Number>( [1,1,1,1])); 
//			}
//			
//			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,Vector.<Number>( [ _animLine,_animRow,_uSpeed,_vSpeed ])); //UV移动
			
		}
	}
	
}