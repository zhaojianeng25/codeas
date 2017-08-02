package _Pan3D.role
{
	import flash.display3D.Context3D;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjectTri;
	import _Pan3D.base.ObjectUv;
	import _Pan3D.base.ObjectWeight;
	import _Pan3D.display3D.analysis.AnalysisQueue;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.program.shaders.Md5MatrialShader;
	import _Pan3D.skill.SkillManager;
	import _Pan3D.utils.Log;
	import _Pan3D.utils.TickTime;
	import _Pan3D.vo.analysis.AnalysisQueueVo;
	
	import _me.Scene_data;

	public class MeshDataManager
	{
		private var _meshDic:Object = new Object;//key:url,value:countobject
		private var _loadFunDic:Object = new Object;
		private var _context:Context3D;
		
		public var beginKey:int = 20;
		public var bindWidth:int  = 4;
		
		/**
		 * 解析队列       
		 */		
		//private var _analysisQueue:Vector.<AnalysisQueueVo> = new Vector.<AnalysisQueueVo>;
		private static var instance:MeshDataManager;
		public function MeshDataManager()
		{
			TickTime.addCallback(dispose);
		}
		public static function getInstance():MeshDataManager{
			if(!instance){
				instance = new MeshDataManager;
			}
			return instance;
		}
		public function init(context:Context3D):void{
			this._context = context;
		}
		/**
		 * 解析一个mesh数据 
		 * @param url 路径
		 * @param fun 回调函数
		 * @param info 附加的信息
		 * @param $priority 加载优先级
		 * @param byteMode 强制使用二进制解析模式
		 * 
		 */		
		public function addMesh(url:String,fun:Function,info:Object,$priority:int=0,byteMode:Boolean=false):void{
			if(_meshDic.hasOwnProperty(url) && !Scene_data.isDevelop){
				var useMesh:MeshData = _meshDic[url];
				if(!useMesh){
					trace("mesh为空" + url);
					return;
				}
				if(!useMesh.hasBuffer){
					useMesh.loadBuffer();
				}
				fun(useMesh,info);
				//_meshDic[url].num++;
			}else{
				if(!_loadFunDic.hasOwnProperty(url)){
					_loadFunDic[url] = new Array;
					var loaderinfo:LoadInfo;
					
					var obj:Object = new Object;
					obj.url = url;
					obj.priority = $priority;
					
					_loadFunDic[url].push({"fun":fun,"info":info});
					
					if(Scene_data.fileByteMode || byteMode){
						loaderinfo = new LoadInfo(url,LoadInfo.BYTE,onQueue,$priority,obj,onErrorQueue);
					}else{
						loaderinfo = new LoadInfo(url,LoadInfo.XML,onQueue,$priority,obj,onErrorQueue);
					}
					LoadManager.getInstance().addSingleLoad(loaderinfo);
				}else{
					_loadFunDic[url].push({"fun":fun,"info":info});
				}
				
			}
		}
		
		private function onErrorQueue(obj:Object):void{
			delete _loadFunDic[obj.url];
		}
		
		private function onQueue(str:*,obj:Object):void{
			
			var queueVo:AnalysisQueueVo = new AnalysisQueueVo;
			queueVo.data = str;
			queueVo.url = obj.url;
			queueVo.priority = obj.priority;
			queueVo.fun = onMeshLoad;
			
			AnalysisQueue.addQueue(queueVo);
			
		}
		
		public function onMeshLoad(str:*,url:String):void{
			var meshData:MeshData;
			if(str is String){
				meshData = AnalysisServer.getInstance().analysisMesh(str);//new Md5Analysis().addMesh(str,1);
			}else{
				meshData = AnalysisServer.getInstance().analysisByteMesh(str);//new Md5Analysis().addMesh(str,1);
			}
			meshData.key = url;
			processForAgal(meshData);
			
//			var countobj:CountObject = new CountObject;
//			countobj.obj = meshData;
			
			var ary:Array = _loadFunDic[url];
			for each(var obj:Object in ary){
				obj.fun(meshData,obj.info)
//				countobj.num++;
			}
			delete _loadFunDic[url];
			
			_meshDic[url] = meshData;
			
			//_meshDic[place] = meshData;
		}
		
		public function processForAgal(meshData:MeshData):void{
			
			var uvItem:Vector.<ObjectUv> = meshData.uvItem;
			var weightItem:Vector.<ObjectWeight> = meshData.weightItem;
			var triItem:Vector.<ObjectTri> = meshData.triItem;
			
			var uvArray:Array=new Array();
			var ary:Array = [[],[],[],[]];
			var boneWeightAry:Array = new Array;
			var bonetIDAry:Array = new Array;
			var indexAry:Array = new Array;
			
			var skipNum:int;
			var beginIndex:int;
			var allNum:int;
			
			var boneUseAry:Array = new Array;
			
			for(var i:int = 0;i<uvItem.length;i++){
				beginIndex = uvItem[i].a;
				allNum = uvItem[i].b;
				for(skipNum = 0;skipNum<4;skipNum++){
					if(skipNum<allNum){
						boneUseAry.push((weightItem[beginIndex+skipNum].boneId));
					}else{
						boneUseAry.push(boneUseAry[0]);
					}
				}
			}
			
			boneUseAry = getboneNum(boneUseAry);
			
			for(i = 0;i<uvItem.length;i++){
				beginIndex = uvItem[i].a;
				allNum = uvItem[i].b;
				for(skipNum = 0;skipNum<4;skipNum++){
					if(skipNum<allNum){
						ary[skipNum].push(weightItem[beginIndex+skipNum].x,weightItem[beginIndex+skipNum].y,weightItem[beginIndex+skipNum].z);
						bonetIDAry.push(beginKey + boneUseAry.indexOf((weightItem[beginIndex+skipNum].boneId))*bindWidth);
						boneWeightAry.push(weightItem[beginIndex+skipNum].w);
					}else{
						ary[skipNum].push(0,0,0);
						bonetIDAry.push(beginKey);
						boneWeightAry.push(0);
					}
				}
				uvArray.push(uvItem[i].x);
				uvArray.push(uvItem[i].y);
			}
			
			meshData.boneNewIDAry = boneUseAry;
			
			for(i=0;i<triItem.length;i++){
				indexAry.push(triItem[i].t0,triItem[i].t1,triItem[i].t2);
			}
			meshData.faceNum = indexAry.length/3;
			

			
			if(!Scene_data.compressBuffer){
				meshData.dataAry = ary;
				meshData.uvArray = uvArray;
				meshData.boneWeightAry = boneWeightAry;
				meshData.bonetIDAry = bonetIDAry;
				meshData.indexAry = indexAry;
			}
			
			
			meshData.hasBuffer = true;
			
			try{
				
				if(Scene_data.compressBuffer){
					uplodToGpuByOne(meshData,uvArray,ary,boneWeightAry,bonetIDAry,indexAry);
				}else{
					uplodToGpu(meshData,uvArray,ary,boneWeightAry,bonetIDAry,indexAry);
				}
				
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
		}
		private function getboneNum(ary:Array):Array{
			var numAry:Array = new Array;
			for(var i:int;i<ary.length;i++){
				if(numAry.indexOf(ary[i]) == -1){
					numAry.push(ary[i]);
				}
			}
			//trace(numAry.length);
			return numAry;
		}
		public function uplodToGpu(meshData:MeshData,uvArray:Array,ary:Array,
									boneWeightAry:Array,bonetIDAry:Array,indexAry:Array):void{
			meshData.uvBuffer = this._context.createVertexBuffer(uvArray.length/2,2);
			meshData.uvBuffer.uploadFromVector(Vector.<Number>(uvArray),0,uvArray.length/2);
			
			meshData.vertexBuffer1 = this._context.createVertexBuffer(ary[0].length/3,3);
			meshData.vertexBuffer1.uploadFromVector(Vector.<Number>(ary[0]),0,ary[0].length/3);
			
			meshData.vertexBuffer2 = this._context.createVertexBuffer(ary[1].length/3,3);
			meshData.vertexBuffer2.uploadFromVector(Vector.<Number>(ary[1]),0,ary[1].length/3);
			
			meshData.vertexBuffer3 = this._context.createVertexBuffer(ary[2].length/3,3);
			meshData.vertexBuffer3.uploadFromVector(Vector.<Number>(ary[2]),0,ary[2].length/3);
			
			meshData.vertexBuffer4 = this._context.createVertexBuffer(ary[3].length/3,3);
			meshData.vertexBuffer4.uploadFromVector(Vector.<Number>(ary[3]),0,ary[3].length/3);
			 
			meshData.boneWeightBuffer = this._context.createVertexBuffer(boneWeightAry.length/4,4);
			meshData.boneWeightBuffer.uploadFromVector(Vector.<Number>(boneWeightAry),0,boneWeightAry.length/4);
			
	
			var arr:Vector.<uint>=new Vector.<uint>
			for(var i:uint=0;i<bonetIDAry.length;i++)
			{
					arr.push((bonetIDAry[i]-20)/2+20)
			}
	

			meshData.boneIdBuffer = this._context.createVertexBuffer(arr.length/4,4);
			meshData.boneIdBuffer.uploadFromVector(Vector.<Number>(arr),0,arr.length/4);
			
			meshData.indexBuffer = this._context.createIndexBuffer(indexAry.length);
			meshData.indexBuffer.uploadFromVector(Vector.<uint>(indexAry),0,indexAry.length);
			
			
		}
		
		public function uplodToGpuByOne(meshData:MeshData,uvArray:Array,ary:Array,
								boneWeightAry:Array,bonetIDAry:Array,indexAry:Array):void{
			var vec:Vector.<Number> = new Vector.<Number>;
			
			var length:int = uvArray.length/2;
			
			for(var i:int=0;i<length;i++){
				vec.push(ary[0][i*3],ary[0][i*3 + 1],ary[0][i*3 + 2]);
				vec.push(ary[1][i*3],ary[1][i*3 + 1],ary[1][i*3 + 2]);
				vec.push(ary[2][i*3],ary[2][i*3 + 1],ary[2][i*3 + 2]);
				vec.push(ary[3][i*3],ary[3][i*3 + 1],ary[3][i*3 + 2]);
				
				vec.push(uvArray[i*2],uvArray[i*2+1]);
				
				vec.push(boneWeightAry[i*4],boneWeightAry[i*4+1],boneWeightAry[i*4+2],boneWeightAry[i*4+3]);
				
				vec.push(bonetIDAry[i*4],bonetIDAry[i*4+1],bonetIDAry[i*4+2],bonetIDAry[i*4+3]);
			}
			
			meshData.vertexBuffer1 = this._context.createVertexBuffer(vec.length/22,22);
			meshData.vertexBuffer1.uploadFromVector(vec,0,vec.length/22);
			meshData.vec = vec;
			
			
			meshData.indexBuffer = this._context.createIndexBuffer(indexAry.length);
			meshData.indexBuffer.uploadFromVector(Vector.<uint>(indexAry),0,indexAry.length);
		}
		
		public function reload(context:Context3D):void{
			this._context = context;
			for each(var data:MeshData in _meshDic){
				processForAgal(data);
			}
			
		}
		private var flag:int;
		public var allBufferNum:int;
		public function dispose():void{
			if(Scene_data.isDevelop){
				return;
			}
			var num:int;
			for each(var meshdata:MeshData in _meshDic){
				//Log.add(meshdata.key + " mesh使用次数：" +meshdata.useNum);
				if(meshdata.useNum <= 0){
					meshdata.idleTime++;
					if(meshdata.idleTime >= Scene_data.cacheTime){
						//trace("***************清理******************")
						delete _meshDic[meshdata.key];
						meshdata.dispose();
					}
				}else{
					meshdata.idleTime = 0;
					num++;
				}
			}
			flag++;
			if(flag == Log.logTime){
				allBufferNum = 0;
				for each(meshdata in _meshDic){
					Log.add(meshdata.key + " mesh使用次数：" +meshdata.useNum,5);
					if(meshdata.hasBuffer){
						if(Scene_data.compressBuffer){
							allBufferNum += 1;
						}else{
							allBufferNum += 7;
						}
					}
				}
				Log.add("———————————————————————Mesh分割线——————————————————————————— " + num + " 总meshBUff数" + allBufferNum,5);
				flag = 0;
				
				disposeBuffer();
			}
			
			MeshUtils.staticDispose();
			
		}
		
		private function disposeBuffer():void{
			var allGameNum:int = ParticleManager.getInstance().allBuffNum + allBufferNum;
			
			Scene_data.allBuffNum = allGameNum;
			
			Log.add("***********************allGameNum************************* "  + allGameNum);
			
			if(allGameNum < 3000){
				return;
			}
			
			for each(var meshdata:MeshData in _meshDic){
				if(meshdata.useNum <= 0){
					meshdata.unloadBuffer();
				}
			}
			
			if(allGameNum > 3500){
				SkillManager.getInstance().unloadAllIdleParticle();
				
				ParticleManager.getInstance().applyBufferNum();
				
				allGameNum = ParticleManager.getInstance().allBuffNum + allBufferNum;
				
				Scene_data.allBuffNum = allGameNum;
				
				Log.add("***********************allGameNum************************* "  + allGameNum);
				
			}
			
		}
		
		
	}
}