package _Pan3D.display3D
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import _Pan3D.display3D.analysis.TBNUtils;
	import _Pan3D.display3D.interfaces.IBind;
	import _Pan3D.display3D.lightProbe.LightProbeManager;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.display3D.modelLine.ModelLineSprite;
	import _Pan3D.texture.TextureCubeMapVo;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.utils.MaterialBaseParam;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import light.ReflectionTextureVo;
	
	import materials.ConstItem;
	import materials.MaterialTree;
	import materials.TexItem;
	
	import textures.TextureBaseVo;
	
	public class Display3DMaterialSprite extends Display3DModelSprite
	{
		private var _material:MaterialTree;
		private var _lightMapTexture:Texture;
		private var time:int;
		public var cameraPosV3d:Vector3D;
		protected var _rotationMatrix:Matrix3D;
		private var _envCubeMap:TextureCubeMapVo;
		private var _envDynamicTexture:TextureBase;
		protected var _reflectionTextureVo:ReflectionTextureVo;
		
		private var _baseSH:Vector.<Number>;
		public var resultSHVec:Vector.<Vector3D>;
		private var _lightProbe:Boolean;
		
		public var bindTarget:IBind;
		public var bindSocket:String;
		
		public var bindMatrix:Matrix3D = new Matrix3D;
		
		public var onlyshowTri:Boolean=false;
		
		public var materialParam:MaterialBaseParam = new MaterialBaseParam;

		
		public function Display3DMaterialSprite(context:Context3D)
		{
			super(context);
			time = getTimer();
			_lightMapTexture = TextureManager.getInstance().defaultLightTextVo.texture;
			cameraPosV3d = Scene_data.cam3D;
			_rotationMatrix = new Matrix3D;

		}

		 
		public function get lightProbe():Boolean
		{
			return _lightProbe;
		}
		
		public  function showOnlyModelLine(value:Boolean):void
		{
			if(value){
				if(!_modelLineSprite){
					_modelLineSprite=new ModelLineSprite(_context3D)
				}
		
				_modelLineSprite.setModelObjData(_objData,true)
				_modelLineSprite.visible=true
			}else{
				_modelLineSprite.visible=false
			}
		
			onlyshowTri=value
	
		
		}

		public function set lightProbe(value:Boolean):void
		{
			_lightProbe = value;
			if(_lightProbe){
				if(!_baseSH){
					initSH();
				}
				
				if(!resultSHVec){
					resultSHVec = new Vector.<Vector3D>;
					var ary:Array = [0.4444730390920146,-0.3834955622240026,-0.33124467509627725,0.09365654209093091,
						-0.05673310882817577,0.2120523322966496,0.02945768486978205,-0.04965996229802928,-0.1136529129285836]
					for(var i:int;i<9;i++){
						resultSHVec.push(new Vector3D(ary[i],ary[i],ary[i]));
					}
				}
			}
		}

		public function get reflectionTextureVo():ReflectionTextureVo
		{
			return _reflectionTextureVo;
		}

		public function set reflectionTextureVo(value:ReflectionTextureVo):void
		{
			_reflectionTextureVo = value;
		}

		public function get lightMapTexture():Texture
		{
			return _lightMapTexture;
		}

		public function set lightMapTexture(value:Texture):void
		{
			_lightMapTexture = value;
		}
		
		public function setEnvCubeMap($textVo:TextureBaseVo):void{
			_envCubeMap = $textVo as TextureCubeMapVo;
		}

		public function get material():MaterialTree
		{
			return _material;
		}

		public function set material(value:MaterialTree):void
		{
			_material = value;
			
			if(_material.useNormal){
				processTBN();
			}
			
			var texVec:Vector.<TexItem> = value.texList;
			for(var i:int;i<texVec.length;i++){
				if(texVec[i].isParticleColor || texVec[i].type != 0 || !texVec[i].url ){
					continue;
				}
				texVec[i].url=texVec[i].url.replace(Scene_data.fileRoot,"");
				var isMipmap:Boolean = texVec[i].mipmap == 0 ? false : true;
				trace(Scene_data.fileRoot + texVec[i].url)
				TextureManager.getInstance().addTexture(Scene_data.fileRoot + texVec[i].url,onTextureLoad,texVec[i],0,isMipmap);
			}
			
			this.lightProbe = _material.lightProbe;
			
			this.materialParam.setMaterial(_material);
		}
		
		public function setMaterialParam($ary:Array):void{
			if(!$ary){
				return;
			}
			this.materialParam.setData($ary);
		}
		
		override public function processTBN():void{
			if(_objData && _material){
				if(!_objData.hasTBN){
					TBNUtils.processTBN(_objData);
					
					_objData.tangentsBuffer = this._context.createVertexBuffer(_objData.tangents.length / 3, 3);
					_objData.tangentsBuffer.uploadFromVector(Vector.<Number>(_objData.tangents), 0, _objData.tangents.length / 3);
					
					_objData.bitangentsBuffer = this._context.createVertexBuffer(_objData.bitangents.length / 3, 3);
					_objData.bitangentsBuffer.uploadFromVector(Vector.<Number>(_objData.bitangents), 0, _objData.bitangents.length / 3);
				}
			}
		}
		
		override protected function onObjLoad(str : String) : void {
			super.onObjLoad(str);
			processTBN();
		}
		
		private function onTextureLoad($textureVo:TextureVo ,$texItem:TexItem):void{
			$texItem.texture = $textureVo.texture;
			$texItem.textureVo = $textureVo;
		}
		
		override public function update() : void {
			if(!_visible){
				return 
			}
		

			
			if (_objData && _objData.indexBuffer && _material) {
//				_context.setProgram(_material.program);
//				setBlendFactors(_material.blendMode);
//				if(_material.backCull){
//					_context.setCulling(Context3DTriangleFace.BACK);
//				}else{
//					_context.setCulling(Context3DTriangleFace.NONE);
//				}
//				if(!_material.writeZbuffer){
//					_context.setDepthTest(false,Context3DCompareMode.LESS);
//				}
				
				setMaterialConfig(_material);
				
				setVc();
				setVa();
				resetVa();
				
//				if(!_material.writeZbuffer){
//					_context.setDepthTest(true,Context3DCompareMode.LESS);
//				}
				
				reSetMaterialConfig(_material);
			}
			if(_modelLineSprite){
				_modelLineSprite.posMatrix=this.posMatrix
				_context.setCulling(Context3DTriangleFace.NONE);
				_modelLineSprite.update()
			}
			if(_objData&&_objData.indexs){
				Scene_data.drawTriangle+=_objData.indexs.length/3
			}
		
		}

		protected function setMaterialConfig($material:MaterialTree):void{
			_context.setProgram($material.program);
			setBlendFactors($material.blendMode);
			if($material.backCull){
				_context.setCulling(Context3DTriangleFace.BACK);
			}else{
				_context.setCulling(Context3DTriangleFace.NONE);
			}
			
			if(!$material.writeZbuffer){
				_context.setDepthTest(false,Context3DCompareMode.LESS);
			}
		}
		
		protected function reSetMaterialConfig($material:MaterialTree):void{
			if(!_material.writeZbuffer){
				_context.setDepthTest(true,Context3DCompareMode.LESS);
			}
		}
		
		protected function setBlendFactors(type:int):void{
			switch(type){
				case 0:
					_context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
					break;
				case 1:
					_context.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE);
					break;
				case 2:                    
					_context.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR,Context3DBlendFactor.ZERO);
					break;
				case 3:
					_context.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
					break;
				case 4:
					_context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE);
					break;
			}
		}
		
		override  protected function setVc() : void {
			this.updatePosMatrix();
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
//			
//			if(_material.useDynamicIBL && _reflectionTextureVo){
//				if( _reflectionTextureVo.camMatrix3D){
//					_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12, _reflectionTextureVo.camMatrix3D, true);
//				}
//			}else if(_material.lightProbe){
//				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>( [_baseSH[0],_baseSH[1],_baseSH[2],_baseSH[3]]));
//				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13, Vector.<Number>( [_baseSH[4],_baseSH[5],_baseSH[6],_baseSH[7]]));
//				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 14, Vector.<Number>( [_baseSH[8],3,1,0]));
//			}
//			
//			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 16, _rotationMatrix, true);
//			
//			if(_material.lightProbe){
//				for(var i:int=0;i<9;i++){
//					_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 20 + i, Vector.<Number>( [resultSHVec[i].x,resultSHVec[i].y,resultSHVec[i].z,0]));
//				}
//			}
//			
//			var t:Number;
//			if(material.hasTime){
//				t = (getTimer() - time) * material.timeSpeed;
//			}else{
//				t = 0;
//			}
//			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1,2,material.killNum,t]));//lerpuse,lightuse,use,use;
//			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0.08,0.5,Scene_data.light.Envscale,material.normalScale]));//pbr 0.08,default pbr 0.5,Envscale,normalscale;
//			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([cameraPosV3d.x,cameraPosV3d.y,cameraPosV3d.z,material.roughness]));
//			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([5,0,0,0]));
//			if(_material.useDynamicIBL){
//				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([1,-1,2,-2]));
//			}
			
			setBaseMaterialVc(_material);
			setMaterialVc(_material,this.materialParam);
		}
		
		protected function setBaseMaterialVc($material:MaterialTree):void{
			
			if($material.useDynamicIBL && _reflectionTextureVo){
				if( _reflectionTextureVo.camMatrix3D){
					_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12, _reflectionTextureVo.camMatrix3D, true);
				}
			}else if($material.lightProbe){
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>( [_baseSH[0],_baseSH[1],_baseSH[2],_baseSH[3]]));
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13, Vector.<Number>( [_baseSH[4],_baseSH[5],_baseSH[6],_baseSH[7]]));
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 14, Vector.<Number>( [_baseSH[8],3,1,0]));
			}else if($material.directLight && Scene_data.light.SunLigth.dircet){
				//sundirect
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>( [Scene_data.light.SunLigth.dircet.x,Scene_data.light.SunLigth.dircet.y,Scene_data.light.SunLigth.dircet.z,0]));
				
				var sc:Vector3D = Scene_data.light.getSun();
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13, Vector.<Number>( [sc.x,sc.y,sc.z,0]));

				sc = Scene_data.light.getAmbient();
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 14, Vector.<Number>( [sc.x,sc.y,sc.z,0]));
			}

			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 16, _rotationMatrix, true);
			
			if($material.lightProbe){
				for(var i:int=0;i<9;i++){
					_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 20 + i, Vector.<Number>( [resultSHVec[i].x,resultSHVec[i].y,resultSHVec[i].z,0]));
				}
				//trace(resultSHVec);
			}
			
			var t:Number;
			if($material.hasTime){
				t = (getTimer() - time) * $material.timeSpeed;
			}else{
				t = 0;
			}
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1,2,$material.killNum,t]));//lerpuse,lightuse,use,use;
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0.08,0.5,Scene_data.light.Envscale,$material.normalScale]));//pbr 0.08,default pbr 0.5,Envscale,normalscale;
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([cameraPosV3d.x,cameraPosV3d.y,cameraPosV3d.z,$material.roughness]));
	
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([2,Scene_data.fogAttenuation,Scene_data.fogDistance,0])); 
			//trace(Scene_data.fogAttenuation)
			var d:Number=800;
			var s:Number=0.8;
			d=Scene_data.fogDistance;
		    s=Scene_data.fogAttenuation;
	
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([2,1/((1-s)*d),d*s,0])); 
			if($material.useDynamicIBL){
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([1,-1,2,-2]));
			}else if($material.fogMode != 0){
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([Scene_data.fogColor.x/255,Scene_data.fogColor.y/255,Scene_data.fogColor.z/255,1]));
			}else if($material.hdr){
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([255.0,128.0,2.0,1.0/2.2]));
			}
		}
		
		override public function updatePosMatrix():void{
			
			if(bindTarget){
				
				posMatrix.identity();
				
				if(isInGroup){
					posMatrix.prependTranslation(groupPos.x,groupPos.y,groupPos.z);
					posMatrix.prependRotation(groupRotation.z , Vector3D.Z_AXIS);
					posMatrix.prependRotation(groupRotation.y , Vector3D.Y_AXIS);
					posMatrix.prependRotation(groupRotation.x , Vector3D.X_AXIS);
					posMatrix.prependScale(groupScale.x,groupScale.y,groupScale.z);
				}
				
				bindTarget.getSocket(bindSocket,bindMatrix);
				
				posMatrix.append(bindMatrix);
				
				bindMatrix.copyToMatrix3D(_rotationMatrix);
				
				_rotationMatrix.appendTranslation(-_rotationMatrix.position.x,-_rotationMatrix.position.y,-_rotationMatrix.position.z);
				
				if(isInGroup){
					_rotationMatrix.prependRotation(groupRotation.z , Vector3D.Z_AXIS);
					_rotationMatrix.prependRotation(groupRotation.y , Vector3D.Y_AXIS);
					_rotationMatrix.prependRotation(groupRotation.x , Vector3D.X_AXIS);
				}
				
			}else{
				super.updatePosMatrix();
				
				_rotationMatrix.identity();
				_rotationMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
				_rotationMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
				_rotationMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
			}
			
			
			if(_material && _material.lightProbe){
				resultSHVec = LightProbeManager.getInstance().getData(new Vector3D(this._absoluteX,this._absoluteY,this._absoluteZ));
			}
			
		}
		
		public function setMaterialVc($material:MaterialTree,$mParam:MaterialBaseParam):void{
			if($mParam){
				$mParam.update();
			}
			var constVec:Vector.<ConstItem> = $material.constList;
			for(var i:int=0;i<constVec.length;i++){
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, constVec[i].id, constVec[i].vecNum);
				//_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, constVec[i].id, Vector.<Number>([constVec[i].value.x,constVec[i].value.y,constVec[i].value.z,constVec[i].value.w]));
			}
			
		}
		
		
		public function setMaterialTexture($material:MaterialTree,$mParam:MaterialBaseParam):void{
			if($material.url.indexOf("terrain.material")!=-1){
				var kkk:Number=000
			}
			var texVec:Vector.<TexItem> = $material.texList;
			for(var i:int;i<texVec.length;i++){
				if(texVec[i].type == TexItem.LIGHTMAP){
					if(Scene_data.showLightmap){
						_context.setTextureAt(texVec[i].id, lightMapTexture);
	
					}else{
						_context.setTextureAt(texVec[i].id, TextureManager.getInstance().defaultLightTextVo.texture);
					}
					
				}else if(texVec[i].type == TexItem.LTUMAP && Scene_data.prbLutTexture){
					_context.setTextureAt(texVec[i].id, Scene_data.prbLutTexture.texture);
				}else if(texVec[i].type == TexItem.CUBEMAP){
					
					if($material.useDynamicIBL && _reflectionTextureVo){
						_context.setTextureAt(texVec[i].id, _reflectionTextureVo.texture);
					}else{
						var _cubeTexture:CubeTexture;
						
						var index:int = Math.floor($material.roughness * 5);
						
						if(_envCubeMap){
							_cubeTexture = _envCubeMap.texturelist[index];
						}else if(Scene_data.skyCubeMap){
							_cubeTexture = Scene_data.skyCubeMap.texturelist[index];
						}
						
						
						_context.setTextureAt(texVec[i].id, _cubeTexture);
					}
					
					
				}else if(texVec[i].type == TexItem.HEIGHTMAP){
					//_context.setTextureAt(texVec[i].id, _cubeTexture);
					setHeightTexture(texVec[i].id);
				}else if(texVec[i].type == TexItem.REFRACTIONMAP){
					if(_reflectionTextureVo){
						_context.setTextureAt(texVec[i].id, _reflectionTextureVo.ZeTexture);
					}
				}else{
					if(Scene_data.showTexture){
						_context.setTextureAt(texVec[i].id, texVec[i].texture);
					}else{
						_context.setTextureAt(texVec[i].id, TextureManager.getInstance().defaultLightTextVo.texture);
					}
					
				}
			}
			
			if($mParam && $mParam.hasData){
				for(i=0;i<$mParam.dynamicTexList.length;i++){
					if($mParam.dynamicTexList[i].target){
						if(Scene_data.showTexture){
							_context.setTextureAt($mParam.dynamicTexList[i].target.id,$mParam.dynamicTexList[i].texture);
						}else{
							_context.setTextureAt($mParam.dynamicTexList[i].target.id, TextureManager.getInstance().defaultLightTextVo.texture);
						}
					}
				
					
				}
			}
			
		}
		private var _heightTexture:Texture;
		protected function setHeightTexture($id:int):void{
			if(!_heightTexture){
				var bmp:BitmapData = new BitmapData(32,32,true,0xff666666);
				_heightTexture= TextureManager.getInstance().bitmapToTexture(bmp);
			}
			_context.setTextureAt($id, _heightTexture);
		}
		
		public function reSetMaterialTexture($material:MaterialTree):void{
			var texVec:Vector.<TexItem> = $material.texList;
			for(var i:int;i<texVec.length;i++){
				_context.setTextureAt(texVec[i].id, null);
			}
		}
		
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			if(!(material.lightProbe || material.directLight || material.noLight)){
				_context.setVertexBufferAt(2, _objData.lightUvsBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			}
			if(material.usePbr){
				_context.setVertexBufferAt(3, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				if(material.useNormal){
					_context.setVertexBufferAt(4, _objData.tangentsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
					_context.setVertexBufferAt(5, _objData.bitangentsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				}
			}else if(material.hasFresnel || material.lightProbe || material.directLight){
				_context.setVertexBufferAt(3, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			}
			setMaterialTexture(material,this.materialParam);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
		}
		
		override  protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setVertexBufferAt(2, null);
			
			if(material.usePbr){
				_context.setVertexBufferAt(3,null);
				if(material.useNormal){
					_context.setVertexBufferAt(4,null);
					_context.setVertexBufferAt(5,null);
				}
			}else if(material.hasFresnel || material.lightProbe||material.directLight){
				_context.setVertexBufferAt(3,null);
			}
			
			reSetMaterialTexture(material);
			
		}
		
		private function initSH():void{
			var sh0:Number = 0.5 * Math.sqrt(1/Math.PI);
			var sh1:Number = -0.5 * Math.sqrt(3/Math.PI);
			var sh2:Number = 0.5 * Math.sqrt(3/Math.PI);
			var sh3:Number = -0.5 * Math.sqrt(3/Math.PI);
			var sh4:Number = 0.5 * Math.sqrt(15/Math.PI);
			var sh5:Number = -0.5 * Math.sqrt(15/Math.PI);
			var sh6:Number = 0.25 * Math.sqrt(5/Math.PI);
			var sh7:Number = -0.5 * Math.sqrt(15/Math.PI);
			var sh8:Number = 0.25 * Math.sqrt(15/Math.PI);
			_baseSH = Vector.<Number>([sh0,sh1,sh2,sh3,sh4,sh5,sh6,sh7,sh8]);
			trace(_baseSH)
		}
		
		

	}
}