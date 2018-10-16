package _Pan3D.display3D
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.vo.anim.BoneSocketData;
	
	import _me.Scene_data;

	/**
	 * 角色绑定类
	 * 1.绑定
	 * 2.被绑定
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DBindMovie extends Display3DMovie implements IBind
	{
		public var bindParticleAry:Vector.<CombineParticle> = new Vector.<CombineParticle>;
		public var isInUI:Boolean;
		public var is3D:Boolean;
		public var uiParticleContaniner:Display3DContainer;
		/**
		 * 绑定的对象的位置编号
		 */		
		protected var posIndex:int;
		public function Display3DBindMovie(context:Context3D)
		{
			super(context);
		}
		
		public function getSocket(socketName:String,resultMatrix:Matrix3D):void{
			
			var boneSocketData:BoneSocketData = _socketDic[socketName];
			
			resultMatrix.identity();
			
			if(!boneSocketData){
				//resultMatrix.append(this.posMatrix);
				resultMatrix.appendTranslation(this._absoluteX,this._absoluteY,this._absoluteZ);
				return;
			}
			
			var testmatix:Matrix3D;
			var index:int = boneSocketData.index;
			
			testmatix = getFrameMatrix(index);
			
			resultMatrix.appendScale(1/_scale,1/_scale,1/_scale);
			
			resultMatrix.appendRotation(boneSocketData.rotationX,Vector3D.X_AXIS);
			resultMatrix.appendRotation(boneSocketData.rotationY,Vector3D.Y_AXIS);
			resultMatrix.appendRotation(boneSocketData.rotationZ,Vector3D.Z_AXIS);
			resultMatrix.appendTranslation(boneSocketData.x,boneSocketData.y,boneSocketData.z);
			
			if(testmatix){
				resultMatrix.append(testmatix);
				//resultMatrix.appendScale(-1,1,1);
			}
			
			resultMatrix.append(this.posMatrix);
			
		}
		
		protected function getFrameMatrix(index:int):Matrix3D{
			if(_animDic){
				if(_animDic[_curentAction] && _animDic[_curentAction][_curentFrame] && _animDic[_curentAction][_curentFrame][index]){
					return _animDic[_curentAction][_curentFrame][index];
				}else if(_animDic[_defaultAction] && _animDic[_defaultAction][_curentFrame] && _animDic[_defaultAction][_curentFrame][index]){
					return _animDic[_defaultAction][_curentFrame][index];
				}
			}
			return null;
		}
		
		protected var _particleList:Object = new Object;
		public function addMeshParticle(meshKey:String,ary:Array):void{
			
			
			for(var i:int;i<ary.length;i++){
				var particles:CombineParticle = ParticleManager.getInstance().getParticle(Scene_data.fileRoot + ary[i].url);
				particles.bindTarget = this;
				particles.bindSocket = ary[i].name;
				particles.visible = ary[i].visible;
				ParticleManager.getInstance().addParticle(particles);
				
				if(!_particleList[meshKey]){
					_particleList[meshKey] = new Array;
				}
				
				_particleList[meshKey].push(particles);
				
			}
			
			
		}
		
		public function removeAllMeshParticle(meshKey:String):void{
			var ary:Array = _particleList[meshKey];
			if(!ary){
				return;
			}
			for(var i:int;i<ary.length;i++){
				var particles:CombineParticle = ary[i];
				ParticleManager.getInstance().removeParticle(particles);
			}
			ary.length = 0;
		}
		
		//private var _posVc3d:Vector3D = new Vector3D(0,0,0);
		private var _posVec:Vector.<Number> = Vector.<Number>( [0,0,0]);
		private var _posMatrix:Matrix3D = new Matrix3D;
		/**
		 * 获取骨骼挂点在世界中的绝对位置
		 * 被绑定接口
		 * @param index 骨骼号
		 * @return 位置
		 * 
		 */
		public function getPosV3d(index:int,resultV3d:Vector3D):void{
			if(hasDispose){
				return;
			}
			//var resultV3d:Vector3D;
			var testmatix:Matrix3D;
			if(index == -1){
				//_posVc3d.setTo(0,0,0);
				setTo(_posVec,0,0,0);
			}else{
				if(_animDic[_curentAction] && _animDic[_curentAction][_curentFrame] && _animDic[_curentAction][_curentFrame][index]){
					testmatix = _animDic[_curentAction][_curentFrame][index];
					setTo(_posVec,testmatix.position.x,testmatix.position.y,testmatix.position.z);
				}else if(_animDic[_defaultAction] && _animDic[_defaultAction][_curentFrame] && _animDic[_defaultAction][_curentFrame][index]){
					testmatix = _animDic[_defaultAction][_curentFrame][index];
					setTo(_posVec,testmatix.position.x,testmatix.position.y,testmatix.position.z);
				}else{
					setTo(_posVec,0,0,0);
				}
			}
			
			if(bindTarget){
				_posMatrix.identity();
				_posMatrix.prependScale(this.pureScale,this.pureScale,this.pureScale);
				_posMatrix.transformVectors(_posVec,_posVec);
				
				testmatix = bindMatrix;
				
				testmatix.transformVectors(_posVec,_posVec);
				_posVec[0] += this.bindVecter3d.x;
				_posVec[1] += this.bindVecter3d.y;
				_posVec[2] += this.bindVecter3d.z;
				
			}else{
				_posMatrix.identity();
				_posMatrix.appendScale(pureScale,pureScale,pureScale);
				_posMatrix.appendRotation(this.rotationY,Vector3D.Y_AXIS);
				
				_posMatrix.transformVectors(_posVec,_posVec);
				_posVec[0] += this._absoluteX
				_posVec[1] += this._absoluteY;
				_posVec[2] += this._absoluteZ;
			}
			//resultV3d = new Vector3D(_posVec[0],_posVec[1],_posVec[2]);
			//return _posVec;
			resultV3d.setTo(_posVec[0],_posVec[1],_posVec[2]);
		}
		public function setTo(ver:Vector.<Number>,$x:Number,$y:Number,$z:Number):void{
			ver[0] = $x;
			ver[1] = $y;
			ver[2] = $z;
		}
		/**
		 * 距离骨骼点指定偏移量 在世界中的绝对位置
		 * 被绑定接口
		 * @param v3d 指定偏移
		 * @param index 骨骼序列号
		 * @return 位置
		 * 
		 */
		public function getOffsetPos(v3d:Vector3D,index:int):Vector3D{
			var testmatix:Matrix3D;
			var result3D:Vector3D;
			if(index == -1){
				if(bindTarget){
					testmatix = bindMatrix;
					testmatix.prependScale(this.pureScale,this.pureScale,this.pureScale);
					result3D = testmatix.transformVector(v3d);
					result3D.x += this.bindVecter3d.x;
					result3D.y += this.bindVecter3d.y;
					result3D.z += this.bindVecter3d.z;
				}else{
					testmatix = new Matrix3D;
					testmatix.appendScale(pureScale,pureScale,pureScale);
					testmatix.appendRotation(this.rotationY,Vector3D.Y_AXIS);
					result3D = testmatix.transformVector(v3d);
					result3D.x += this._absoluteX;
					result3D.y += this._absoluteY;
					result3D.z += this._absoluteZ;
				}
			}else{
				if(_animDic){
					if(_animDic[_curentAction] && _animDic[_curentAction][_curentFrame] && _animDic[_curentAction][_curentFrame][index]){
						testmatix = _animDic[_curentAction][_curentFrame][index];
					}else if(_animDic[_defaultAction] && _animDic[_defaultAction][_curentFrame] && _animDic[_defaultAction][_curentFrame][index]){
						testmatix = _animDic[_defaultAction][_curentFrame][index];
					}else{
						testmatix = new Matrix3D;
					}
				}else{
					testmatix = new Matrix3D;
				}
				result3D = testmatix.transformVector(v3d);
				
				if(bindTarget){
					var selfMatrix:Matrix3D = new Matrix3D;
					selfMatrix.prependScale(this.scale,this.scale,this.scale);
					result3D = selfMatrix.transformVector(result3D);
					testmatix = bindMatrix;
					result3D = testmatix.transformVector(result3D);
					result3D.x += this.bindVecter3d.x;
					result3D.y += this.bindVecter3d.y;
					result3D.z += this.bindVecter3d.z;
				}else{
					testmatix = new Matrix3D;
					testmatix.appendScale(scale,scale,scale);
					testmatix.appendRotation(this.rotationY,Vector3D.Y_AXIS);
					result3D = testmatix.transformVector(result3D);
					
					result3D.x += this._absoluteX;
					result3D.y += this._absoluteY;
					result3D.z += this._absoluteZ;
				}
				
			}
			
			
			return result3D;
		}
		/**
		 * 骨骼点的旋转矩阵 
		 * 被绑定接口
		 * @param index 骨骼序列号
		 * @return 旋转矩阵（仅包含旋转）
		 * 
		 */
		public function getPosMatrix(index:int):Matrix3D{
			var testmatix:Matrix3D;
			var temp:Matrix3D;
			if(index == -1){
				if(bindTarget){
					temp = bindMatrix;
				}else{
					temp = new Matrix3D;
					temp.appendRotation(this.rotationY,Vector3D.Y_AXIS);
				}
			}else{
				if(_animDic[_curentAction] && _animDic[_curentAction][_curentFrame] && _animDic[_curentAction][_curentFrame][index]){
					testmatix = _animDic[_curentAction][_curentFrame][index];
				}else if(_animDic[_defaultAction] && _animDic[_defaultAction][_curentFrame] && _animDic[_defaultAction][_curentFrame][index]){
					testmatix = _animDic[_defaultAction][_curentFrame][index];
				}else{
					testmatix = new Matrix3D;
				}
				temp = testmatix.clone();
				temp.appendTranslation(-testmatix.position.x,-testmatix.position.y,-testmatix.position.z);
				if(bindTarget){
					temp.append(bindMatrix);
					//temp.prependScale(bindTarget.getScale(),bindTarget.getScale(),bindTarget.getScale());
				}else{
					temp.appendRotation(this.rotationY,Vector3D.Y_AXIS);
				}
			}
			return temp;
		}
		
		public function getRotation():Number{
			return rotationY;
		}
		/**
		 * 设定绑定对象的alpha值 
		 * @return 
		 * 
		 */		
		public function getBindAlpha():Number{
			return 1;
		}
		/**
		 * 绑定最终矩阵 
		 */	
		//public var bindMatrix:Matrix3D = new Matrix3D;
		/**
		 * 绑定最终位置
		 */
		public var bindVecter3d:Vector3D = new Vector3D;
		/**
		 * 绑定偏移 
		 */
		public var bindOffset:Vector3D;
		/**
		 * 绑定旋转 
		 */	
		public var bindRatation:Vector3D;
		/**
		 * 绑定点（骨骼序列号） 
		 */	
		public var bindIndex:int;
				
		public var isSoftBind:Boolean = false;
		
		public var bindVecterTarget3d:Vector3D = new Vector3D;
		
		
		override public function updateBind():void{
			
			if(bindTarget){
				
				bindTarget.getSocket(bindSocket,bindMatrix);
				
				bindVecter3d.setTo(bindMatrix.position.x,bindMatrix.position.y,bindMatrix.position.z);
				
				bindMatrix.appendTranslation(-bindMatrix.position.x,-bindMatrix.position.y,-bindMatrix.position.z); 
				
			}
			
		}
		
		/**
		 * 根据绑定目标更新自身位置 
		 * 
		 */
		public function updateBind_Bak():void{
			if(bindTarget){
				
				if(isSoftBind){
					updateSoftBind();
				}else{
					updateHardBind();
				}
				
				
				bindMatrix.identity();
				if(bindRatation){
					bindMatrix.appendRotation(bindRatation.x,Vector3D.X_AXIS);
					bindMatrix.appendRotation(bindRatation.y,Vector3D.Y_AXIS);
					bindMatrix.appendRotation(bindRatation.z,Vector3D.Z_AXIS);
					bindMatrix.append(bindTarget.getPosMatrix(bindIndex));
				}else{
					bindMatrix.prependRotation(bindTarget.getRotation(),Vector3D.Y_AXIS);
				}
				
			}else{
				//bindVecter3d.setTo(0,0,0);
				//bindMatrix.identity();
			}
		}
		
		public function updateHardBind():void{
			if(bindOffset){
				bindVecter3d = bindTarget.getOffsetPos(bindOffset,bindIndex);
			}else{
				bindTarget.getPosV3d(bindIndex,bindVecter3d);
			}
		}
		
		public function updateSoftBind():void{
			if(bindOffset){
				bindVecterTarget3d = bindTarget.getOffsetPos(bindOffset,bindIndex);
			}else{
				bindTarget.getPosV3d(bindIndex,bindVecterTarget3d);
			}
			
			var sc:int = 20;
			
			bindVecter3d.x += (bindVecterTarget3d.x - bindVecter3d.x)/sc;
			bindVecter3d.y += (bindVecterTarget3d.y - bindVecter3d.y)/sc;
			bindVecter3d.z += (bindVecterTarget3d.z - bindVecter3d.z)/sc;
			
		}
		
		/**
		 * 把绑定位置置于绝对位置 
		 * 
		 */		
		public function bindKeepPos():void{
			bindVecter3d.x = this._absoluteX;
			bindVecter3d.y = this._absoluteY;
			bindVecter3d.z = this._absoluteZ;
		}
		
		override public function updateMatrix():void{
			updateBind();
			modelMatrix.identity();
			modelMatrix.prepend(Scene_data.cam3D.cameraMatrix);
			if(bindTarget){
				modelMatrix.prependTranslation(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
				modelMatrix.prepend(bindMatrix);
			}
			modelMatrix.prepend(posMatrix);
		}
		
		public var modelShadowMatrix:Matrix3D = new Matrix3D;
		public function updateShadowMatrix():void{
			modelShadowMatrix.identity();
			if(bindTarget){
				modelShadowMatrix.prependTranslation(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
				modelShadowMatrix.prepend(bindMatrix);
			}
			modelShadowMatrix.prepend(posMatrix);
		}
		
		override public function updatePosMatrix():void{
			posMatrix.identity();
			if(!bindTarget){
				
				posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
				posMatrix.prependScale(this.scale,this.scale,this.scale);
				posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
				posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
				posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
				
				if(this.posDic[_curentAction]){
					var pos:Vector3D = this.posDic[_curentAction][_curentFrame];
					posMatrix.prependTranslation(pos.x, pos.y, pos.z);
					this.actionPos.setTo(pos.x * this.scale, pos.y * this.scale, pos.z * this.scale);
				}else{
					this.actionPos.setTo(0,0,0);
				}
				
				_rotationMatrix.identity();
				_rotationMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
				_rotationMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
				_rotationMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
				
			}else{
				posMatrix.prependTranslation(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
				posMatrix.prependScale(this.scale,this.scale,this.scale);
				posMatrix.prepend(bindMatrix);
				
				_rotationMatrix.copyToMatrix3D(bindMatrix);
			}
		}
		
		public function addToRender(container:Display3DContainer):void{
			container.addChild(this);
//			for(var i:int;i<bindParticleAry.length;i++){
//				ParticleManager.getInstance().addParticle(bindParticleAry[i]);
//			}
		}
		
		override public function removeRender():void{
			if(this.parent){
				this.parent.removeChild(this);
				for(var i:int;i<bindParticleAry.length;i++){
					//ParticleManager.getInstance().addParticle(bindParticleAry[i]);
					ParticleManager.getInstance().removeParticle(bindParticleAry[i]);
				}
				this.parent = null;
			}
		}
		
		public var _animInterpolaDic:Object = new Object;
		public function getInterpolaFrame(actionName:String):void{
			var frameAry:Array = _animDic[actionName];
			//BoneUtils.interpolaFrame(
		}
		
		public function getPosMultipleMatrix(index:int):Vector.<Matrix3D>{
			if(!_animInterpolaDic[_curentAction]){
				getInterpolaFrame(_curentAction);
			}
			return null;
		}
		
		public function get pureScale():Number{
			return 1;
		}
		
		
	}
}