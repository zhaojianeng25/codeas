package _Pan3D.particle.followLocus
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.enum.EnumParticleType;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.ParticleData;
	import _Pan3D.particle.locus.Display3DLocusShader;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	

	public class Display3DFollowLocusPartilce extends Display3DParticle
	{
		protected var _fenduanshu:uint;//分段数
		protected var _isLoop:Boolean;
		
		private var _bindPosAry:Vector.<Vector.<Number>>;
		//private var _bindNormalAry:Vector.<Vector.<Number>>;
		
		public function Display3DFollowLocusPartilce(context:Context3D)
		{
			super(context);
			particleData = new ParticleData;
			this._particleType = EnumParticleType.FOLLOW_LOCUS;
			useTextureColor = false;
		}

		override protected function uplodToGpu():void
		{
			//particleData = new ParticleData;
			particleData.vertices=new Vector.<Number>;
			particleData.uvs=new Vector.<Number>;
			particleData.indexs=new Vector.<uint>;

			for(var i:uint=0;i<=_fenduanshu;i++)
			{
				//var randomz:int = 30*Math.random()
				//var backA:Vector3D = new Vector3D(0,-_originWidthScale*_width,0);
				//var backB:Vector3D = new Vector3D(0,(1-_originWidthScale)*_width,0);
				
				
				var pA:Point = new Point(i/_fenduanshu,0);
				var pB:Point = new Point(i/_fenduanshu,1);
				
				if(_isU){
					pA.x = -pA.x;
					pB.x = -pB.x;
				}
				
				if(_isV){
					pA.y = -pA.y;
					pB.y = -pB.y;
				}
				
				var vcIndex:int = 16 + i*2;
				particleData.vertices.push(vcIndex,vcIndex + 1,-_originWidthScale*_width/100);
				particleData.vertices.push(vcIndex,vcIndex + 1,(1-_originWidthScale)*_width/100);
				
				if(_isUV){
					particleData.uvs.push(pA.y,pA.x);
					particleData.uvs.push(pB.y,pB.x);
				}else{
					particleData.uvs.push(pA.x,pA.y);
					particleData.uvs.push(pB.x,pB.y);
				}
				
			}
			
			for(i = 0;i<_fenduanshu;i++){
				particleData.indexs.push(0+2*i,1+2*i,2+2*i,1+2*i,3+2*i,2+2*i);
			}
			
			pushToGpu();
			
		}
		
		override public function pushToGpu():void{
			particleData.vertexBuffer = this._context3D.createVertexBuffer(particleData.vertices.length / 3, 3);
			particleData.vertexBuffer.uploadFromVector(Vector.<Number>(particleData.vertices), 0, particleData.vertices.length / 3);
			particleData.uvBuffer = this._context3D.createVertexBuffer(particleData.uvs.length / 2, 2);
			particleData.uvBuffer.uploadFromVector(Vector.<Number>(particleData.uvs), 0, particleData.uvs.length / 2);
			particleData.indexBuffer = this._context3D.createIndexBuffer(particleData.indexs.length);
			particleData.indexBuffer.uploadFromVector(Vector.<uint>(particleData.indexs), 0, particleData.indexs.length);
		}
		
		private function initBindMatrixAry():void{
			_bindPosAry = new Vector.<Vector.<Number>>;
			//_bindNormalAry = new Vector.<Vector.<Number>>;
			for(var i:int;i<=_fenduanshu;i++){
				_bindPosAry.push(Vector.<Number>([0,0,5 * i,1]));
				_bindPosAry.push(Vector.<Number>([0,0,1,1]));
			}
		}
		
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			setMaterialTexture();
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(particleData.indexs.length/3);
		}
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);

			resetMaterialTexture();
		}
		
		override protected function setVaBatch() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setTextureAt(1, particleData.texture);
//			_context3D.setTextureAt(2,_textureColor);
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
		}
		
		override protected function resetVaBatch() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setTextureAt(2,null);
		}
		
		override protected function setVc() : void {
			//return;
			this.updateMatrix();
			
			var tempv3d:Vector3D = new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z);;
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,12, Vector.<Number>([tempv3d.x,tempv3d.y,tempv3d.z,0]));
			
			//_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, Scene_data.cam3D.cameraMatrix, true);
			
			
			for(var i:int;i<_bindPosAry.length;i++){
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16 + i,_bindPosAry[i]);
			}
			
			setMaterialVc();
			
		}
		
		
		private var flag:int;
		private var add:int;
		private var lastFrame:int;
		
		
		override public function setBind($bindVecter3d:Vector3D, $bindMatrix:Matrix3D,_bindAlpha:Number=1):void{
			super.setBind($bindVecter3d,$bindMatrix,_bindAlpha);
			if(!$bindMatrix){
				return;
			}
			flag++;
			if(flag == 2){
				var normal:Vector.<Number> = _bindPosAry.pop();
				var pos:Vector.<Number> = _bindPosAry.pop();
				pos[0] = $bindVecter3d.x;
				pos[1] = $bindVecter3d.y;
				pos[2] = $bindVecter3d.z;
				
				var pos0:Vector.<Number> = _bindPosAry[0];
				var normal0:Vector.<Number> = _bindPosAry[1];
				
				var v3d:Vector3D = new Vector3D(pos[0] - pos0[0],pos[1] - pos0[1],pos[2] - pos0[2]);
				v3d.normalize();
				normal[0] = normal0[0] = v3d.x;
				normal[1] = normal0[1] = v3d.y;
				normal[1] = normal0[2] = v3d.z;
				
				_bindPosAry.unshift(normal);
				_bindPosAry.unshift(pos);
				

//				var ma:UseMatrix3D = _bindMatrixAry.pop();
//				ma.identity();
//				ma.append($bindMatrix);
//				ma.appendTranslation($bindVecter3d.x,$bindVecter3d.y,$bindVecter3d.z);
//				_bindMatrixAry.unshift(ma);
//				ma.inUse = true;
//				
//				for(var i:int;i<_bindMatrixAry.length;i++){
//					ma = _bindMatrixAry[i];
//					if(!ma.inUse){
//						ma.identity();
//						ma.append($bindMatrix);
//						ma.appendTranslation($bindVecter3d.x,$bindVecter3d.y,$bindVecter3d.z);
//						ma.inUse = true;
//					}
//				}
				
				flag = 0;
			}
			
		}
		
		override public function updateMatrix():void{
			modelMatrix.identity();
			//modelMatrix.prepend(Scene_data.cam3D.cameraMatrix);
			//modelMatrix.prependTranslation(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
			//modelMatrix.prepend(bindMatrix);
			modelMatrix.prepend(posMatrix);
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			obj.tileMode = _tileMode;
			obj.isLoop = _isLoop;
			obj.fenduanshu = _fenduanshu;
			return obj;
		}
		
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			this._tileMode = obj.tileMode;
			this._isLoop = obj.isLoop;
			this._fenduanshu = obj.fenduanshu;
			super.setAllInfo(obj,isClone);
			
			
			initBindMatrixAry();
			try
			{
				uplodToGpu();
			} 
			catch(error:Error) 
			{
				if(!Scene_data.disposed){
					throw error;
				}
			}
			
			regShader();
		}
		
		override public function resetPos($xpos:int,$ypos:int,$zpos:int):void{
			super.resetPos($xpos,$ypos,$zpos);
//			for(var i:int;i<_bindPosAry.length;i++){
//				_bindPosAry[i].identity();
//				_bindPosAry[i].appendTranslation($xpos,$ypos,$zpos);
//				_bindPosAry[i].inUse = false;
//			}
			
			for(var i:int=0;i<_bindPosAry.length;i+=2){
				_bindPosAry[i][0] = $xpos;
				_bindPosAry[i][1] = $ypos;
				_bindPosAry[i][2] = $zpos;
			} 
			
		}
		

		
		override public function clone():Display3DParticle{
			var display:Display3DFollowLocusPartilce = new Display3DFollowLocusPartilce(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			display._textureColor = _textureColor;
			display._textureColorAry = _textureColorAry;
			return display;
		}
		
		override public function clear():void{
			super.clear();
			
			_bindPosAry = null;

		}
		
		override public function reload():void{
			super.reload();
			_program = Program3DManager.getInstance().getProgram(Display3DFollowLocusShader.DISPLAY3DFOLLOWLOCUSSHADER);
			pushToGpu();
		}
		
		override public function getBufferNum():int{
			return particleData.hasUnload ? 0 : 2;
		}
		
		override public function regShader():void{
			if(!materialParam){
				return;
			}
			var shaderParameAry:Array;
			var isWatchEye:int = _watchEye ? 1 : 0;
			var changeUv:int=0
			
			if(_isU||_isV||_isUV){
				changeUv=1
			}
			shaderParameAry = [isWatchEye,changeUv];
			materialParam.program = Program3DManager.getInstance().getMaterialProgram(Display3DFollowLocusShader.DISPLAY3DFOLLOWLOCUSSHADER,Display3DFollowLocusShader,materialParam.material,shaderParameAry);
		}
		
		
	}
}