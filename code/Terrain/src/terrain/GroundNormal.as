package terrain
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class GroundNormal
	{
		
		public function GroundNormal()
		{
		}
		
		public function getHightMapToNrm(hightMap:BitmapData):BitmapData
		{
			var $bmp:BitmapData=new BitmapData(hightMap.width,hightMap.height,false,0xff0000)
			for(var i:uint=0;i<hightMap.width;i++)
			{
				for(var j:uint=0;j<hightMap.height;j++)
				{
					var $colorInt:uint=getVectorNormal(hightMap,i,j)
					$bmp.setPixel(i,j,$colorInt)
				}
			}
			miaobian($bmp)
			var bf:BlurFilter = new BlurFilter(2,2,1);
			$bmp.applyFilter($bmp,$bmp.rect,new Point(0,0),bf);
			$bmp.applyFilter($bmp,$bmp.rect,new Point(0,0),bf);
			return $bmp
		}
		private function miaobian($bmp:BitmapData):void
		{
			for(var i:uint=0;i<$bmp.width;i++)
			{
				$bmp.setPixel(i,0,$bmp.getPixel(i,1))
				$bmp.setPixel(i,$bmp.height-1,$bmp.getPixel(i,$bmp.height-2))
			}
			for(var j:uint=0;j<$bmp.height;j++)
			{
				$bmp.setPixel(0,j,$bmp.getPixel(1,j))
				$bmp.setPixel($bmp.width-1,j,$bmp.getPixel($bmp.width-2,j))
			}
		}

		private function getVectorNormal(_hightInfoBitmapData:BitmapData,i:int,j:int):uint
		{
			
			
			
			
			var cellNum10:Number=GroundMath.getInstance().Area_Size/GroundMath.getInstance().Area_Cell_Num;
	
			var $o:Vector3D=new Vector3D(i*cellNum10,GroundMath.getInstance().getBitmapDataHight(_hightInfoBitmapData,i, j),j*cellNum10);
			var $ii:int;
			var $jj:int;
			
			$ii=i+1
			$jj=j+0
			var $a:Vector3D=new Vector3D($ii*cellNum10,GroundMath.getInstance().getBitmapDataHight(_hightInfoBitmapData,$ii, $jj),$jj*cellNum10);
			$ii=i-1
			$jj=j+0
			var $b:Vector3D=new Vector3D($ii*cellNum10,GroundMath.getInstance().getBitmapDataHight(_hightInfoBitmapData,$ii, $jj),$jj*cellNum10);
			
			$ii=i+0
			$jj=j+1
			var $c:Vector3D=new Vector3D($ii*cellNum10,GroundMath.getInstance().getBitmapDataHight(_hightInfoBitmapData,$ii, $jj),$jj*cellNum10);
			$ii=i+0
			$jj=j-1
			var $d:Vector3D=new Vector3D($ii*cellNum10,GroundMath.getInstance().getBitmapDataHight(_hightInfoBitmapData,$ii, $jj),$jj*cellNum10);
			
			
			
			var norm0:Vector3D=new Vector3D
			var norm1:Vector3D=new Vector3D
			var norm2:Vector3D=new Vector3D
			var norm3:Vector3D=new Vector3D
			
			
			normal($a, $o, $c, norm0);
			normal($c, $o, $b, norm1);
			normal($b, $o, $d, norm2);
			normal($d, $o, $a, norm3);
			var endNorm:Vector3D = new Vector3D;
			endNorm.x = (norm0.x+norm1.x+norm2.x+norm3.x)/4;
			endNorm.y = (norm0.y+norm1.y+norm2.y+norm3.y)/4;
			endNorm.z = (norm0.z+norm1.z+norm2.z+norm3.z)/4;
			
			endNorm.normalize()
			endNorm.scaleBy(0xff/2)
			return argbToHex16(endNorm.x+0xff/2,endNorm.y+0xff/2,endNorm.z+0xff/2)
			
		}
		
		public function normal(p1:Vector3D,p2:Vector3D,p3:Vector3D,norm:Vector3D):void
		{
			var d1:Vector3D= p1.subtract(p2);//subVector3D(p1,p2)
			var d2:Vector3D= p2.subtract(p3);
			normcrossprod(d1,d2,norm);
			
		}
			
		private function normcrossprod(v1:Vector3D, v2:Vector3D, out:Vector3D):void
		{
			// TODO Auto Generated method stub
			out.x=v1.y*v2.z-v1.z*v2.y;
			out.y=v1.z*v2.x-v1.x*v2.z;
			out.z=v1.x*v2.y-v1.y*v2.x;
			out.normalize();
		}
		
		private function argbToHex16( r:uint, g:uint, b:uint):uint
		{
			// 转换颜色
			var color:uint= r << 16 | g << 8 | b;
			return color;
		}
		
	}
}


