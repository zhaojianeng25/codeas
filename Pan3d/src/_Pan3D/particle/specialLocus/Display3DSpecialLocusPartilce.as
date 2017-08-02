package _Pan3D.particle.specialLocus
{
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Object3D;
	import _Pan3D.core.BezierClass;
	import _Pan3D.core.MathClass;
	import _Pan3D.particle.locus.Display3DLocusPartilce;
	
	import _me.Scene_data;
	
	public class Display3DSpecialLocusPartilce extends Display3DLocusPartilce
	{
		public function Display3DSpecialLocusPartilce(context:Context3D)
		{
			super(context);
			this._particleType = 17;
		}
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			//this._closeGround = obj.closeGround;
			//this._gormalsGround = obj.gormalsGround;
			this._tileMode = obj.tileMode;
			this._isLoop = obj.isLoop;
			//this._scaleLocus = obj.scaleLocus;
			this._speed = obj.speed;
			this.density = obj.density;
			this.beginVector3D = getVector3DByObject(obj.beginVector3D);
			this.endVector3D = getVector3DByObject(obj.endVector3D);
			_colorVec = Vector.<Number>( [1,1,1,1]);
			super.setAllInfo(obj,isClone);
			if(obj.data&&obj.data.length>1){
			
				pointArr = getObject3DAry(obj.data);
				
			}else{
				pointArr=new Array;
				pointArr.push(new Object3D(0,0,0))
				pointArr.push(new Object3D(100,0,0))
				pointArr.push(new Object3D(200,0,0))
				pointArr.push(new Object3D(300,0,0))
			}


			changeFun=uplodToGpu;
			if(!isClone){
				uplodToGpu();
			}
		}
		override protected function makeModeData(_guijiLizhiVO:Display3DLocusPartilce):void
		{
			
			gpuLocusData.vertices=new Vector.<Number>
			gpuLocusData.uvs=new Vector.<Number>
			gpuLocusData.indexs=new Vector.<uint>
			gpuLocusData.normals=new Vector.<Number>
				
	
			
			var i:int,j:int,k:int,l:int;
			var scaleArr:Array=new Array
			
			
			
			for( i=0;i<pointArr.length;i++){
				var tempObj:Object3D=Object3D(pointArr[i])
				trace("更新到的比例",tempObj.scale)
				scaleArr.push(new Vector3D(tempObj.scale,tempObj.scale,tempObj.scale))
			}
			trace("------------")
			
			
			var $dataArr:Array=pointArr;
			var $angleArr:Array=new Array;
			var $posArr:Array=new Array();
			
			for( i=0;i<$dataArr.length;i++){
				$angleArr.push(new Vector3D($dataArr[i].angle_x,$dataArr[i].angle_y,$dataArr[i].angle_z)); //存放角度，等会可以转换为贝尔曲线用
			}
			for( i=0;i<($dataArr.length-1)/3;i++)
			{
				var isEnd:Boolean=(i==(($dataArr.length-1)/3-1))
				$posArr=$posArr.concat(BezierClass.getFourPointBezier($dataArr[i*3+0],$dataArr[i*3+1],$dataArr[i*3+2],$dataArr[i*3+3],Math.ceil(density/int($dataArr.length/3)),isEnd))
			}

			for( i=0;i<$posArr.length;i++)
			{
				var $scalaObj:Object=BezierClass.drawbezier(scaleArr,i/$posArr.length)
				//一次推两组数据进入
				var c:Object3D=Object3D($posArr[i]);
				var $pointA:Vector3D=new Vector3D(beginVector3D.x,beginVector3D.y,beginVector3D.z);
				var $pointB:Vector3D=new Vector3D(endVector3D.x,endVector3D.y,endVector3D.z);
				$pointA=MathClass.math_change_point(getSale($pointA,i/$posArr.length),c.angle_x,c.angle_y,c.angle_z);
				$pointB=MathClass.math_change_point(getSale($pointB,i/$posArr.length),c.angle_x,c.angle_y,c.angle_z);
				$pointA.scaleBy($scalaObj.x)
				$pointB.scaleBy($scalaObj.x)
				var s:Vector3D=new Vector3D($pointA.x+c.x,$pointA.y+c.y,$pointA.z+c.z)
				var e:Vector3D=new Vector3D($pointB.x+c.x,$pointB.y+c.y,$pointB.z+c.z)
				
				
				gpuLocusData.vertices.push(s.x,s.y,s.z);
				gpuLocusData.vertices.push(e.x,e.y,e.z);
				var uvNum:Number=i/($posArr.length-1)
				gpuLocusData.uvs.push(uvNum,0,_animLine,_animRow);
				gpuLocusData.uvs.push(uvNum,1,_animLine,_animRow);
				
				gpuLocusData.normals.push(_isU?-1:1,_isV?-1:1,_isUV?1:0,_isUV?0:1)//用来存UV互换数据
				gpuLocusData.normals.push(_isU?-1:1,_isV?-1:1,_isUV?1:0,_isUV?0:1)//用来存UV互换数据
				
				
				
			}
			for( j=0;j<(gpuLocusData.vertices.length/6-1);j++)
			{
				gpuLocusData.indexs.push(0+j*2+0,0+j*2+1,0+j*2+3)
				gpuLocusData.indexs.push(0+j*2+0,0+j*2+3,0+j*2+2)
			}	
			try{
				pushToGpu();
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
		}

	}
}