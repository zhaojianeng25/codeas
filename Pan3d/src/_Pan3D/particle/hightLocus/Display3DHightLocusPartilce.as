package _Pan3D.particle.hightLocus
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Object3D;
	import _Pan3D.core.BezierClass;
	import _Pan3D.core.MathClass;
	import _Pan3D.particle.locus.Display3DLocusPartilce;
	
	import _me.Scene_data;
	
	public class Display3DHightLocusPartilce extends Display3DLocusPartilce
	{
		public function Display3DHightLocusPartilce(context:Context3D)
		{
			super(context);
			this._particleType = 16;
		}
		override protected function setVc() : void {
			this.updateMatrix();

			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,4,getResultMatrix() , true);
			var d:Number=MathClass.math_distance3D(beginVector3D.x,beginVector3D.y,beginVector3D.z,endVector3D.x,endVector3D.y,endVector3D.z)
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,8,Vector.<Number>( [Scene_data.stageWidth/Scene_data.stageHeight,1,0,d]));  
			
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,5, getResultUV()); 
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,6, getColor());

			
		}
		override protected function setVa() : void {

			_context3D.setVertexBufferAt(4, gpuLocusData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.setVertexBufferAt(5, gpuLocusData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			
			_context3D.setVertexBufferAt(0, gpuLocusData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, gpuLocusData.vaDataBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(2, gpuLocusData.lightUvsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(3, gpuLocusData.locusVa0Buffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			
			_context3D.setTextureAt(1,particleData.texture);
			_context3D.setTextureAt(0,_textureColor);
			_context3D.drawTriangles(gpuLocusData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(gpuLocusData.indexs.length/3);
		}
		override protected function setVaBatch() : void {
			_context3D.setVertexBufferAt(4, gpuLocusData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.setVertexBufferAt(5, gpuLocusData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			
			_context3D.setVertexBufferAt(0, gpuLocusData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, gpuLocusData.vaDataBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(2, gpuLocusData.lightUvsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(3, gpuLocusData.locusVa0Buffer, 0, Context3DVertexBufferFormat.FLOAT_3);

			_context3D.setTextureAt(0,_textureColor);
			_context3D.drawTriangles(gpuLocusData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			if(gpuLocusData.indexs){
				Scene_data.drawTriangle += int(gpuLocusData.indexs.length/3);
			}else{
				trace("&&&&&&&&&&error&&&&&&&&&&")
			}
		}
		
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setVertexBufferAt(3, null);
			_context3D.setVertexBufferAt(4, null);
			_context3D.setVertexBufferAt(5, null);
			_context3D.setTextureAt(0,null);
			_context3D.setTextureAt(1,null);
		}

		override protected function makeModeData(_guijiLizhiVO:Display3DLocusPartilce):void
		{
			
			gpuLocusData.vertices=new Vector.<Number>
			gpuLocusData.uvs=new Vector.<Number>
			gpuLocusData.indexs=new Vector.<uint>
			gpuLocusData.normals=new Vector.<Number>
			gpuLocusData.lightUvs=new Vector.<Number>  
			gpuLocusData.vaData=new Vector.<Number>
			gpuLocusData.locusVa0=new Vector.<Number>
				
				

			
			var i:int,j:int,k:int,l:int;
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
			//$posArr.push($dataArr[$dataArr.length-1]);
			for( i=0;i<$posArr.length;i++)
			{
				//一次推两组数据进入
				var c:Object3D=Object3D($posArr[i]);
				gpuLocusData.vertices.push(c.x,c.y,c.z)
				gpuLocusData.vertices.push(c.x,c.y,c.z)
				
				gpuLocusData.vaData.push(-1,+1,0)
				gpuLocusData.vaData.push(+1,-1,0)
				
				
				var t0:Object3D=new Object3D
				var t1:Object3D=new Object3D
				var tempT:Object3D;
				if(i>=($posArr.length-1)){
					t1.x=Object3D($posArr[i]).x
					t1.y=Object3D($posArr[i]).y
					t1.z=Object3D($posArr[i]).z
					tempT=Object3D($posArr[i-1])
					t1.x=t1.x+(t1.x-tempT.x)
					t1.y=t1.y+(t1.y-tempT.y)
					t1.z=t1.z+(t1.z-tempT.z)
				}else{
					t1=Object3D($posArr[i+1])
				}
				
				gpuLocusData.lightUvs.push(t1.x,t1.y,t1.z)
				gpuLocusData.lightUvs.push(t1.x,t1.y,t1.z)
					
				if(i==0){
					t0.x=Object3D($posArr[i]).x
					t0.y=Object3D($posArr[i]).y
					t0.z=Object3D($posArr[i]).z
					tempT=Object3D($posArr[i+1])
					t0.x=t0.x-(tempT.x-t0.x)
					t0.y=t0.y-(tempT.y-t0.y)
					t0.z=t0.z-(tempT.z-t0.z)
				}else{
					t0=Object3D($posArr[i-1])
				}
				gpuLocusData.locusVa0.push(t0.x,t0.y,t0.z)
				gpuLocusData.locusVa0.push(t0.x,t0.y,t0.z)

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
		override public function pushToGpu():void
		{
			
			gpuLocusData.vertexBuffer = this._context3D.createVertexBuffer(gpuLocusData.vertices.length / 3, 3);
			gpuLocusData.vertexBuffer.uploadFromVector(Vector.<Number>(gpuLocusData.vertices), 0, gpuLocusData.vertices.length / 3);
			gpuLocusData.uvBuffer = this._context3D.createVertexBuffer(gpuLocusData.uvs.length / 4, 4);
			gpuLocusData.uvBuffer.uploadFromVector(Vector.<Number>(gpuLocusData.uvs), 0, gpuLocusData.uvs.length / 4);
			gpuLocusData.normalsBuffer = this._context3D.createVertexBuffer(gpuLocusData.normals.length / 4, 4);
			gpuLocusData.normalsBuffer.uploadFromVector(Vector.<Number>(gpuLocusData.normals), 0, gpuLocusData.normals.length / 4);
			gpuLocusData.indexBuffer = this._context3D.createIndexBuffer(gpuLocusData.indexs.length);
			gpuLocusData.indexBuffer.uploadFromVector(Vector.<uint>(gpuLocusData.indexs), 0, gpuLocusData.indexs.length);
			
			gpuLocusData.lightUvsBuffer = this._context3D.createVertexBuffer(gpuLocusData.lightUvs.length / 3, 3);
			gpuLocusData.lightUvsBuffer.uploadFromVector(Vector.<Number>(gpuLocusData.lightUvs), 0, gpuLocusData.lightUvs.length / 3);
			gpuLocusData.vaDataBuffer = this._context3D.createVertexBuffer(gpuLocusData.vaData.length / 3, 3);
			gpuLocusData.vaDataBuffer.uploadFromVector(Vector.<Number>(gpuLocusData.vaData), 0, gpuLocusData.vaData.length / 3);
			gpuLocusData.locusVa0Buffer = this._context3D.createVertexBuffer(gpuLocusData.locusVa0.length / 3, 3);
			gpuLocusData.locusVa0Buffer.uploadFromVector(Vector.<Number>(gpuLocusData.locusVa0), 0, gpuLocusData.locusVa0.length / 3);

			
		}
	}
}