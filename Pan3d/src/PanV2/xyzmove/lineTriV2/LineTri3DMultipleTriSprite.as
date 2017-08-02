package PanV2.xyzmove.lineTriV2
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import _Pan3D.base.ObjData;
	
	public class LineTri3DMultipleTriSprite extends LineTri3DSprite
	{
		public function LineTri3DMultipleTriSprite($context3D:Context3D)
		{
			super($context3D);
		}
		private var _objDataItem:Vector.<ObjData>;
		private function clearData():void
		{
			if(_objDataItem){
				for each(var $tempObjData:ObjData in _objDataItem){
					$tempObjData.dispose();
				}
			}
			_objDataItem=new Vector.<ObjData>;
		}

		override public function clear():void
		{
			super.clear()
			clearData();
		}
		override protected function uplodToGpu() : void {
			clearData();
			if(!Boolean(_objData.indexs)){
				return ;
			}
			var $begin:uint
			var $end:uint
			var $maxNum10:uint=5000
			var $tempObjData:ObjData
			var $triNum:uint=_objData.indexs.length/3
			var $intNum:uint=uint($triNum/$maxNum10)
			if($intNum>0){
				for(var i:uint=0;i<$intNum;i++){
					var $haveTriNum:uint=$maxNum10
					 $tempObjData=new ObjData;
					 $begin=  9*(i*$maxNum10)  // 9*前面的三角形数量，
					$end=  9*(i*$maxNum10)  +$maxNum10*9     //前面的加上剩余的得到最后的
						
					$tempObjData.vertices=_objData.vertices.slice($begin,$end)
					$tempObjData.uvs=_objData.uvs.slice($begin,$end)
						
					 $begin=  12*(i*$maxNum10)  // 9*前面的三角形数量，
					 $end=  12*(i*$maxNum10)  +$maxNum10*12     //前面的加上剩余的得到最后的
						 
					 $tempObjData.normals=_objData.normals.slice($begin,$end)
					 $tempObjData.indexs=_objData.indexs.slice(0,$maxNum10*3)
					 upToGpuMul($tempObjData)
					 _objDataItem.push($tempObjData)
				}
				
			}
			var lastTriNum:uint=$triNum-($intNum*$maxNum10)   //最后剩余的三角形
			if(lastTriNum){
				$tempObjData=new ObjData;
				 $begin=  9*($intNum*$maxNum10)  // 9*前面的三角形数量，
				 $end=  9*($intNum*$maxNum10)  +lastTriNum*9     //前面的加上剩余的得到最后的
			   
				$tempObjData.vertices=_objData.vertices.slice($begin,$end)
				$tempObjData.uvs=_objData.uvs.slice($begin,$end)
					
				 $begin=  12*($intNum*$maxNum10)  // 9*前面的三角形数量，
				 $end=  12*($intNum*$maxNum10)  +lastTriNum*12     //前面的加上剩余的得到最后的
				 $tempObjData.normals=_objData.normals.slice($begin,$end)
					 
				 $tempObjData.indexs=_objData.indexs.slice(0,lastTriNum*3)
				 upToGpuMul($tempObjData)
				_objDataItem.push($tempObjData)
				
			}
		
		}
		private function upToGpuMul($tempObjData:ObjData):void
		{
			$tempObjData.vertexBuffer = _context3D.createVertexBuffer($tempObjData.vertices.length / 3, 3);
			$tempObjData.vertexBuffer.uploadFromVector(Vector.<Number>($tempObjData.vertices), 0, $tempObjData.vertices.length / 3);
			
			$tempObjData.uvBuffer =_context3D.createVertexBuffer($tempObjData.uvs.length / 3, 3);
			$tempObjData.uvBuffer.uploadFromVector(Vector.<Number>($tempObjData.uvs), 0, $tempObjData.uvs.length / 3);
			
			$tempObjData.normalsBuffer = _context3D.createVertexBuffer($tempObjData.normals.length / 4, 4);
			$tempObjData.normalsBuffer.uploadFromVector(Vector.<Number>($tempObjData.normals), 0, $tempObjData.normals.length /4);
			
			$tempObjData.indexBuffer = _context3D.createIndexBuffer($tempObjData.indexs.length);
			$tempObjData.indexBuffer.uploadFromVector(Vector.<uint>($tempObjData.indexs), 0, $tempObjData.indexs.length);
		}
		
		override public function update() : void {
			if (_objData) {
				_context3D.setProgram(this._program);
				setVc();
				if(_objDataItem){
					for (var i:uint=0;i<_objDataItem.length;i++){
						setVaMul(_objDataItem[i]);
					}
				}
				resetVa();
			}
		}
		

		protected function setVaMul($temp:ObjData) : void {
			_context3D.setVertexBufferAt(0, $temp.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, $temp.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(2, $temp.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.drawTriangles($temp.indexBuffer, 0, -1);
		}
	}
}