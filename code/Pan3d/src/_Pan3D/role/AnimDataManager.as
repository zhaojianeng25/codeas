package _Pan3D.role
{
	import _Pan3D.base.ObjectBone;
	import _Pan3D.core.CountObject;
	import _Pan3D.core.Quaternion;
	import _Pan3D.display3D.analysis.AnalysisQueue;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.utils.Log;
	import _Pan3D.utils.TickTime;
	import _Pan3D.vo.analysis.AnalysisQueueVo;
	import _Pan3D.vo.anim.AnimVo;
	
	import _me.Scene_data;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class AnimDataManager
	{
		private var _animDic:Object = new Object;//key:url,value:countobject
		private var _loadFunDic:Object = new Object;
		/**
		 * 解析队列 
		 */		
		//private var _analysisQueue:Vector.<AnalysisQueueVo> = new Vector.<AnalysisQueueVo>;
		private static var instance:AnimDataManager;
		public function AnimDataManager()
		{
			TickTime.addCallback(dispose);
		}
		public static function getInstance():AnimDataManager{
			if(!instance){
				instance = new AnimDataManager;
			}
			return instance;
		}
		public function addAnim(url:String,fun:Function,info:Object,$priority:int=0,$errorFun:Function=null,byteMode:Boolean=false):void{
			if(_animDic.hasOwnProperty(url) &&　!Scene_data.isDevelop){
				if(Scene_data.isDevelop){
					var resultObj:Object = _animDic[url].obj;
					
					if(resultObj.inLoop){
						info.inLoop = resultObj.inLoop;
					}
					if(resultObj.bounds){
						info.bounds = resultObj.bounds;
					}
					if(resultObj.nameHeight){
						info.nameHeight = resultObj.nameHeight;
					}
					
					fun(resultObj.frames,info);
				}else{
					var animVo:AnimVo = _animDic[url];
					if(!animVo){
						trace("animVo不存在" + url);
						return;
					}
					fun(animVo.frames,info,animVo);
				}
				//_animDic[url].num++;
			}else{
				if(!_loadFunDic.hasOwnProperty(url)){
					_loadFunDic[url] = new Array;
					var loaderinfo:LoadInfo;
					
					var obj:Object = new Object;
					obj.url = url;
					obj.priority = $priority;
					
					_loadFunDic[url].push({"fun":fun,"info":info,"errorFun":$errorFun});
					
					if(Scene_data.fileByteMode || byteMode){
						loaderinfo = new LoadInfo(url,LoadInfo.BYTE,onQueue,$priority,obj,onQueueError);
					}else{
						loaderinfo = new LoadInfo(url,LoadInfo.XML,onQueue,$priority,obj,onQueueError);
					}
					LoadManager.getInstance().addSingleLoad(loaderinfo);
				}else{
					_loadFunDic[url].push({"fun":fun,"info":info,"errorFun":$errorFun});
				}
			}
		}
		
		private function onQueueError(obj:Object):void{
			var url:String = obj.url;
			var ary:Array = _loadFunDic[url];
			for each(var obj:Object in ary){
				var errorFun:Function = obj.errorFun;
				if(Boolean(errorFun)){
					errorFun();
				}
			}
			delete _loadFunDic[url];
		}
		
		private function onQueue(str:*,obj:Object):void{
			
			var queueVo:AnalysisQueueVo = new AnalysisQueueVo;
			queueVo.data = str;
			queueVo.url = obj.url;
			queueVo.priority = obj.priority;
			queueVo.fun = onAnimLoad;
			
			AnalysisQueue.addQueue(queueVo);
			
		}
		public function onAnimLoad(str:*,url:String):void{
			var resultObj:Object;
			var byteMode:Boolean;
			if(str is String){
				resultObj = AnalysisServer.getInstance().analysisAnim(str);
			}else{
				resultObj = AnalysisServer.getInstance().analysisByteAnim(str);
				byteMode = true;
			}
			var animAry:Array = resultObj.frames;
//			var newAry:Array = new Array;
//			for(var i:int;i<animAry.length;i+=2){
//				newAry.push(animAry[i]);
//			}
//			
//			var interAry:Array = new Array
//			for(i=0;i<newAry.length;i++){
//				interAry.push(newAry[i]);
//				if(i != newAry.length-1){
//					interAry.push(interpolaFrame(newAry[i],newAry[i+1]));
//				}
//			}
			
			//animAry = interAry;
			//animAry = newAry;
			var sourceData:Array = cloneAction(animAry);
			setFrameToMatrix(animAry);
			
			var countobj:CountObject = new CountObject;
			countobj.obj = resultObj;
			
			var newAnimAry:Array = getPureMatrix(animAry);
			
			var animVo:AnimVo = new AnimVo;
			animVo.bounds = resultObj.bounds;
			animVo.inLoop = resultObj.inLoop;
			if(Scene_data.isDevelop && !byteMode){
				animVo.frames = animAry;
			}else{
				animVo.frames = newAnimAry;
			}
			animVo.nameHeight = resultObj.nameHeight;
			animVo.key = url;
			animVo.pos = resultObj.pos;
			animVo.scale = resultObj.scale;
			
			var ary:Array = _loadFunDic[url];
			for each(var obj:Object in ary){
				if(Scene_data.isDevelop && !byteMode){//用于剔除帧的计算，仅在开发模式下生效
					obj.info.source = sourceData;
					obj.info.strAry = AnalysisServer.getInstance().getMd5StrAry();
					obj.info.hierarchy = AnalysisServer.getInstance().getHierarchy();
					obj.info.str = str;
					
					if(resultObj.inLoop){//添加内循环字段
						obj.info.inLoop = resultObj.inLoop;
					}
					if(resultObj.bounds){
						obj.info.bounds = resultObj.bounds;
					}
					if(resultObj.nameHeight){
						obj.info.nameHeight = resultObj.nameHeight;
					}
					if(resultObj.pos){
						obj.info.pos = resultObj.pos;
					}
					
				}
				
				if(Scene_data.isDevelop && !byteMode){
					obj.fun(animAry,obj.info);
				}else{
					obj.fun(newAnimAry,obj.info,animVo);
				}
				
				//countobj.num++;
			}
			delete _loadFunDic[url];
			
			if(Scene_data.isDevelop && !byteMode){
				_animDic[url] = countobj;
			}else{
				_animDic[url] = animVo;
			}
			
			//_meshDic[place] = meshData;
		}
		private function cloneAction(sourceAry:Array):Array{
			var resultAry:Array = new Array;
			for(var i:int;i<sourceAry.length;i++){
				var sourceTwo:Array = sourceAry[i];
				resultAry.push(new Array);
				for(var j:int=0;j<sourceTwo.length;j++){
					resultAry[i].push(sourceTwo[j].clone());
				}
			}
			return resultAry;
		}
		private function interpolaFrame(ary1:Array,ary2:Array):Array{
			var ary:Array = new Array;
			for(var i:int;i<ary1.length;i++){
				ary.push(interpolaBone(ary1[i],ary2[i]));
			}
			return ary;
		}
		private function interpolaBone(one:ObjectBone,two:ObjectBone):ObjectBone{
			var q1:Quaternion = new Quaternion(one.qx,one.qy,one.qz);
			q1.w= getW(q1.x,q1.y,q1.z);
			var q2:Quaternion = new Quaternion(two.qx,two.qy,two.qz);
			q2.w= getW(q2.x,q2.y,q2.z);
			
			var resultQ:Quaternion = new Quaternion;
			resultQ.slerp(q1,q2,0.5);
			
			var newBone:ObjectBone = new ObjectBone();
			newBone.father = one.father;
			newBone.name = one.name;
			newBone.qx = resultQ.x;
			newBone.qy = resultQ.y;
			newBone.qz = resultQ.z;
			
			newBone.tx = (one.tx + two.tx)/2;
			newBone.ty = (one.ty + two.ty)/2;
			newBone.tz = (one.tz + two.tz)/2;
			
				
			return newBone;
		}
		public function setFrameToMatrix(frameAry:Array):void{
			for(var j:int=0;j<frameAry.length;j++){
				var boneAry:Array = frameAry[j];
				
				var Q0:Quaternion=new Quaternion();
				var Q1:Quaternion=new Quaternion();
				var OldQ:Quaternion=new Quaternion();
				var OldM:Matrix3D=new Matrix3D();
				var newM:Matrix3D=new Matrix3D();
				var tempM:Matrix3D=new Matrix3D;
				var tempObj:ObjectBone=new ObjectBone;
				
				for(var i:int=0;i<boneAry.length;i++){
					
					var _M1:Matrix3D=new Matrix3D;
					
					var sonBone:ObjectBone= boneAry[i];
					Q0=new Quaternion(sonBone.qx,sonBone.qy,sonBone.qz);
					Q0.w= getW(Q0.x,Q0.y,Q0.z);
				//	var sonBone:ObjectBone=xyzfarme0;
					
					if(sonBone.father==-1){
						OldQ=new Quaternion(sonBone.qx,sonBone.qy,sonBone.qz);
						OldQ.w= getW(OldQ.x,OldQ.y,OldQ.z);
						newM=OldQ.toMatrix3D();
						newM.appendTranslation(sonBone.tx,sonBone.ty,sonBone.tz);
						newM.appendRotation(-90,Vector3D.X_AXIS);
						var fatherQ:Quaternion = new Quaternion();
						fatherQ.fromMatrix(newM);
						
						sonBone.tx=newM.position.x;
						sonBone.ty=newM.position.y;
						sonBone.tz=newM.position.z;
						sonBone.tw=newM.position.w;
						
						sonBone.qx=fatherQ.x;
						sonBone.qy=fatherQ.y;
						sonBone.qz=fatherQ.z;
						sonBone.qw=fatherQ.w;
						newM.appendScale(-1,1,1);
						sonBone.matrix = newM;
						
					}else {
						var fatherBone:ObjectBone=boneAry[sonBone.father];
						OldQ=new Quaternion(fatherBone.qx,fatherBone.qy,fatherBone.qz,fatherBone.qw);
						OldM=OldQ.toMatrix3D();
						OldM.appendTranslation(fatherBone.tx,fatherBone.ty,fatherBone.tz);
						var  tempV:Vector3D=OldM.transformVector(new Vector3D(sonBone.tx,sonBone.ty,sonBone.tz));
						
						Q1.multiply(OldQ,Q0);
						newM=Q1.toMatrix3D();
						newM.appendTranslation(tempV.x,tempV.y,tempV.z);
						tempM=newM;
						
						sonBone.qx=Q1.x;
						sonBone.qy=Q1.y;
						sonBone.qz=Q1.z;
						sonBone.qw=Q1.w;
						
						sonBone.tx=tempV.x;
						sonBone.ty=tempV.y;
						sonBone.tz=tempV.z;
						sonBone.tw=tempV.w;
						
						tempM.appendScale(-1,1,1);
						sonBone.matrix = tempM;
						
					}
					//context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12+i*4,  tempM, true);
				}
			}
		}
		/*private function setFrameToMatrix(frameAry:Array):void{
			for(var j:int=0;j<frameAry.length;j++){
				var boneAry:Array = frameAry[j];
				
				var Q0:Quaternion=new Quaternion();
				var Q1:Quaternion=new Quaternion();
				var OldQ:Quaternion=new Quaternion();
				var OldM:Matrix3D=new Matrix3D();
				var newM:Matrix3D=new Matrix3D();
				var tempM:Matrix3D=new Matrix3D;
				var tempObj:ObjectBone=new ObjectBone;
				
				for(var i:int=0;i<boneAry.length;i++){
					
					var _M1:Matrix3D=new Matrix3D;
					
					var xyzfarme0:ObjectBone= boneAry[i];
					Q0=new Quaternion(xyzfarme0.qx,xyzfarme0.qy,xyzfarme0.qz);
					Q0.w= getW(Q0.x,Q0.y,Q0.z);
					var sonBone:ObjectBone=xyzfarme0;
					
					var utilsMatrix:Matrix3D = new Matrix3D;
					utilsMatrix.appendRotation(-90,Vector3D.X_AXIS);
					
					if(xyzfarme0.father==-1){
						OldQ=new Quaternion(xyzfarme0.qx,xyzfarme0.qy,xyzfarme0.qz);
						OldQ.w= getW(OldQ.x,OldQ.y,OldQ.z);
						
						OldQ = getQR(OldQ);
						var v3d:Vector3D = new Vector3D(xyzfarme0.tx,xyzfarme0.ty,xyzfarme0.tz);
						v3d = getTR(v3d);
						xyzfarme0.tx = v3d.x;
						xyzfarme0.ty = v3d.y;
						xyzfarme0.tz = v3d.z;
						
						newM=OldQ.toMatrix3D();
						newM.appendTranslation(xyzfarme0.tx,xyzfarme0.ty,xyzfarme0.tz);
						
						
						xyzfarme0.qx=OldQ.x;
						xyzfarme0.qy=OldQ.y;
						xyzfarme0.qz=OldQ.z;
						xyzfarme0.qw=OldQ.w;
						xyzfarme0.matrix = newM;
						
					}else {
						var fatherBone:ObjectBone=boneAry[xyzfarme0.father];
						OldQ=new Quaternion(fatherBone.qx,fatherBone.qy,fatherBone.qz,fatherBone.qw);
						OldM=OldQ.toMatrix3D();
						OldM.appendTranslation(fatherBone.tx,fatherBone.ty,fatherBone.tz);
						
						v3d = new Vector3D(sonBone.tx,sonBone.ty,sonBone.tz);
						v3d = getTR(v3d);
						sonBone.tx = v3d.x;
						sonBone.ty = v3d.y;
						sonBone.tz = v3d.z;
						
						var  tempV:Vector3D=OldM.transformVector(new Vector3D(sonBone.tx,sonBone.ty,sonBone.tz));
						_M1.appendTranslation(tempV.x,tempV.y,tempV.z);
						
						Q0 = getQR(Q0);
						
						Q1.multiply(OldQ,Q0);
						newM=Q1.toMatrix3D();
						newM.append(_M1);
						tempM=newM;
						
						xyzfarme0.qx=Q1.x;
						xyzfarme0.qy=Q1.y;
						xyzfarme0.qz=Q1.z;
						xyzfarme0.qw=Q1.w;
						
						xyzfarme0.tx=tempV.x;
						xyzfarme0.ty=tempV.y;
						xyzfarme0.tz=tempV.z;
						xyzfarme0.tw=tempV.w;
						
						//tempM.appendScale(-1,1,1);
						xyzfarme0.matrix = tempM;
						
					}
					//context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12+i*4,  tempM, true);
				}
			}
		}*/
		
		private function getQR(qua:Quaternion):Quaternion{
//			var utilsMatrix:Matrix3D = new Matrix3D;
//			utilsMatrix.appendRotation(-90,Vector3D.X_AXIS);
			qua.traceMathSense();
			var newMa:Matrix3D = qua.toMatrix3D();
			newMa.prependRotation(-90,Vector3D.Y_AXIS);
			var newQ:Quaternion = new Quaternion();
			newQ.fromMatrix(newMa);
			newQ.traceMathSense();
//			qua.rotationX();
			return qua;
		}
		private function getTR(newV3d:Vector3D):Vector3D{
			var utilsMatrix:Matrix3D = new Matrix3D;
			utilsMatrix.appendRotation(-90,Vector3D.X_AXIS);
			//trace(newV3d)
			//newV3d = utilsMatrix.transformVector(newV3d);
			//trace(newV3d)
			return newV3d;
		}
		
		private function getW(x:Number,y:Number,z:Number):Number{
			var t:Number = 1-(x*x + y*y + z*z);
			if(t<0){
				t=0
			}else{
				t = -Math.sqrt(t);
			}
			return t;
		}
		
		private function getPureMatrix(ary:Array):Array{
			var newAry:Array = new Array(ary.length)
			for(var i:int;i<ary.length;i++){
				newAry[i] = new Array(ary[i].length);
				for(var j:int=0;j<ary[i].length;j++){
					newAry[i][j] = ary[i][j].matrix;
				}
			}
			return newAry;
		}
		private var flag:int;
		private function dispose():void{
			//return;
			if(Scene_data.isDevelop){
				return;
			}
			var num:int;
			for each(var animVo:AnimVo in _animDic){
				//trace(animVo.key + " 使用次数：" + animVo.useNum)
				if(animVo.useNum <= 0){
					animVo.idleTime++;
					if(animVo.idleTime >= Scene_data.cacheTime){
						delete _animDic[animVo.key];
						destroy(animVo);
					}
				}else{
					animVo.idleTime = 0;
					num++;
				}
			}
			
			flag++;
			if(flag == Log.logTime){
				flag = 0;
				var allNum:int;
				
				for(var key:String in _animDic){
					animVo = _animDic[key];
					if(animVo.useNum > 0){
						Log.add(key + "*" + animVo.useNum,5)
					}
					allNum++;
				}
				
				Log.add("**************************************anim分割线***********************************************使用数量" +　num +　" 总数：" + allNum + "空闲个数：" + (allNum-num),5);
			}
			
			//trace("——————————————————————————————*****————————————Anim————————————————*****——————————————————————————————" + num)
		}
		
		private function destroy(animVo:AnimVo):void{
			if(animVo.bounds){
				animVo.bounds.length = 0;
				animVo.bounds = null;
			}
			
			if(animVo.frames){
				
				for(var i:int;i<animVo.frames.length;i++){
					animVo.frames[i].length = 0;
				}
				
				animVo.frames.length = 0;
				animVo.frames = null;
			}
			
			if(animVo.inter){
				animVo.inter.length = 0;
				animVo.inter = null;
			}
			
			animVo.key = null;
			
			if(animVo.pos){
				animVo.pos.length = 0;
				animVo.pos = null;
			}
			
		}
		
	}
}