package _Pan3D.particle.locusball
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Object3D;
	import _Pan3D.core.BezierClass;
	import _Pan3D.core.MathClass;
	import _Pan3D.particle.ball.Display3DBallPartilceNew;
	import _Pan3D.program.Program3DManager;
	
	
	public class Display3DLocusBallPartilce extends Display3DBallPartilceNew
	{
		public var pointArr:Array;
		public var fun:Function
		public var changeFun:Function
		public var density:uint=50
			
		public var beginVector3D:Vector3D;
		
		public var tangentSpeed:int;
		
		public function Display3DLocusBallPartilce(context:Context3D)
		{
			super(context);
			_particleType = 14;
			beginVector3D = new Vector3D(0,0,100);
		}
		
		override public function initBasePos():void{
			var basePos:Vector.<Number> = new Vector.<Number>;
			var posAry:Array = getPosList();
			for(var i:int=0;i<_totalNum;i++){
				var v3d:Vector3D;
				var ma:Matrix3D;
				if(_isRandom){
					var roundv3d:Vector3D = new Vector3D(_round.x*_round.w,_round.y*_round.w,_round.z*_round.w);
					v3d = new Vector3D(posAry[i].x + Math.random() * roundv3d.x,posAry[i].y + Math.random() * roundv3d.y,posAry[i].z + Math.random() * roundv3d.z);
				}else{
					v3d = new Vector3D(posAry[i].x,posAry[i].y,posAry[i].z);
				}
				
				v3d = v3d.add(_basePositon);
				
				for(var j:int=0;j<4;j++){
					basePos.push(v3d.x,v3d.y,v3d.z,i*_shootSpeed);
				}
			}
			
			gpuTuoQiuData.basePos = basePos;
		}
		private var tangentArr:Array;
		public function getPosList():Array{
			
			if(!pointArr){
				pointArr=new Array;
				pointArr.push(new Object3D(0,0,0))
				pointArr.push(new Object3D(100,0,0))
				pointArr.push(new Object3D(200,0,0))
				pointArr.push(new Object3D(300,0,0))
			}
			
			var i:int,j:int,k:int,l:int;
			var $dataArr:Array=pointArr;
			var $angleArr:Array=new Array;
			var $posArr:Array=new Array();
			tangentArr = new Array;
			
			
			
			for( i=0;i<$dataArr.length;i++){
				$angleArr.push(new Vector3D($dataArr[i].angle_x,$dataArr[i].angle_y,$dataArr[i].angle_z)); //存放角度，等会可以转换为贝尔曲线用
			}
			for( i=0;i<($dataArr.length-1)/3;i++)
			{
				var isEnd:Boolean=(i==(($dataArr.length-1)/3-1))
				$posArr=$posArr.concat(BezierClass.getFourPointBezier($dataArr[i*3+0],$dataArr[i*3+1],$dataArr[i*3+2],$dataArr[i*3+3],Math.ceil(_totalNum/int($dataArr.length/3))
					,isEnd,tangentArr,_isEven))
			}
			
			return $posArr;
		}
		
		public function getAngleList():Array{
			var $posArr:Array=getPosList();
			
			var ary:Array = new Array;
			for( var i:int=0;i<$posArr.length;i++)
			{
				var c:Object3D=Object3D($posArr[i]);
				
				var $pointA:Vector3D=new Vector3D(beginVector3D.x,beginVector3D.y,beginVector3D.z);
				$pointA=MathClass.math_change_point(getSale($pointA,i/$posArr.length),c.angle_x,c.angle_y,c.angle_z);
				var s:Vector3D=new Vector3D($pointA.x,$pointA.y,$pointA.z);
				s.normalize();
				ary.push(s);
			}
			return ary;
		}
		
		
		protected function getSale(vc3:Vector3D,num:Number):Vector3D{
			vc3 = vc3.clone();
			return vc3;
		}
		
		override protected function uplodToGpu():void{
			super.uplodToGpu();
			trace("upload");
		}
		
		override public function initSpeed():void{
			var beMove:Vector.<Number> = new Vector.<Number>;
			var angleAry:Array = getAngleList();
			//var tangentAry:Array = getPosList(true);
			for(var i:int=0;i<_totalNum;i++){
				
				var resultv3d:Vector3D = new Vector3D;
				
				if(tangentSpeed == 0){
					resultv3d = resultv3d.add(angleAry[i]);
				}else if(tangentSpeed == 2){
					resultv3d.setTo(Math.random() * 2 - 1,Math.random() * 2 - 1,Math.random() * 2 - 1);
				}else{
					var v3d:Vector3D = new Vector3D(tangentArr[i].x,tangentArr[i].y,tangentArr[i].z);
					v3d.scaleBy(tangentSpeed);
					resultv3d = resultv3d.add(v3d);
				}
				
				
				resultv3d.normalize();
				
				if(_isSendRandom){
					resultv3d.scaleBy(_speed * Math.random());
				}else{
					resultv3d.scaleBy(_speed);
				}
				
				var ranAngle:Number = _baseRandomAngle * Math.random() * Math.PI / 180;
				
				for(var j:int=0;j<4;j++){
					beMove.push(resultv3d.x,resultv3d.y,resultv3d.z,ranAngle);
				}
			}
			
			gpuTuoQiuData.beMove = beMove; 
		}
		
		override public function setAllInfo(obj:Object, isClone:Boolean=false):void{
			this.tangentSpeed = obj.tangentSpeed;
			if(obj.data&&obj.data.length>=4){
				pointArr = getObject3DAry(obj.data)
			}else{
				pointArr=new Array;
				pointArr.push(new Object3D(0,0,0))
				pointArr.push(new Object3D(100,0,0))
				pointArr.push(new Object3D(200,0,0))
				pointArr.push(new Object3D(300,0,0))
			}
			changeFun=uplodToGpu;
			super.setAllInfo(obj,isClone);
			
		}
		
		private function getObject3DAry(source:Array):Array{
			var ary:Array = new Array;
			for(var i:int;i<source.length;i++){
				var obj:Object3D;
				if(source[i] is Object3D){
					obj = source[i];
				}else{
					obj = new Object3D;
					obj.setData(source[i]);
				}
				ary.push(obj);
			}
			return ary;
		}
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			obj.data = pointArr;
			obj.tangentSpeed = this.tangentSpeed;
			obj.vecData = getVecData();
			return obj;
		}
		public function getVecData():Object{
			var obj:Object = new Object;
			var posNumAry:Array = new Array;
			var posAry:Array = getPosList();
			for(var i:int = 0;i<posAry.length;i++){
				posNumAry.push(posAry[i].x,posAry[i].y,posAry[i].z);
			}
			obj.pos = posNumAry;
			
			if(this.tangentSpeed == 0){
				var angleNumAry:Array = new Array;
				var angleAry:Array = getAngleList();
				
				for(i = 0;i<angleAry.length;i++){
					angleNumAry.push(angleAry[i].x,angleAry[i].y,angleAry[i].z);
				}
				obj.angle = angleNumAry;
			}else if(this.tangentSpeed == 1 || this.tangentSpeed == -1){
				var tangentNumAry:Array = new Array;
				var tangentAry:Array = this.tangentArr;
				
				for(i = 0;i<tangentAry.length;i++){
					tangentNumAry.push(tangentAry[i].x,tangentAry[i].y,tangentAry[i].z);
				}
				obj.tangent = tangentNumAry;
			}
			
			return obj;
		}
		
		override public function regShader():void{
			if(!materialParam){
				return;
			}
			var hasParticleColor:Boolean = materialParam.material.hasParticleColor();
			_needRandomColor = materialParam.material.hasVertexColor;
			
			var shaderParameAry:Array;
			
			var hasParticle:int;
			if(hasParticleColor){
				hasParticle = 1;
			}else{
				hasParticle = 0;
			}
			
			var hasRandomClolr:int = _needRandomColor ? 1 : 0;
			
			var isMul:int = _is3Dlizi ? 1 : 0;
			
			var needRotation:int = this._needSelfRotation ? 1 : 0;
			
			shaderParameAry = [hasParticle,hasRandomClolr,isMul,needRotation];
			
			materialParam.program = Program3DManager.getInstance().getMaterialProgram(Display3DLocusBallShader.DISPLAY3DLOCUSBALLSHADER,Display3DLocusBallShader,materialParam.material,shaderParameAry);
			
		}
		
		
	}
}