package  render.ground
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathClass;
	import _Pan3D.core.MathCore;
	
	import terrain.GroundMath;

	public class GroundNrmModel
	{
		//private var _hightInfoBitmapData:BitmapData
		private var _nrmBitmapData:BitmapData
		public function GroundNrmModel()
		{
		}

		public function set baseNrmBitmapData(value:BitmapData):void
		{
			_baseNrmBitmapData = value;
		}

		public function get nrmBitmapData():BitmapData
		{
			return _nrmBitmapData;
		}
		public static function getInstance():GroundNrmModel
		{
			if(!instance){
				instance=new GroundNrmModel()
			}
			return instance;
		}
		private static var instance:GroundNrmModel;
		/**
		 *传进来一张大两个像素的原始高度图，然后再算出法线图 
		 * @param $tempBmp
		 * 
		 */
		public function setBitmapdata($heighBmp:BitmapData,$rect:Rectangle=null):void
		{
			if(!Boolean(_baseNrmBitmapData)){
				_baseNrmBitmapData=$heighBmp.clone()
				$rect=new Rectangle(0,0,_baseNrmBitmapData.width,_baseNrmBitmapData.height)
			}
			if(!Boolean($rect)){
				_baseNrmBitmapData=new BitmapData($heighBmp.width,$heighBmp.height,false,0xffffff)
				$rect=new Rectangle(0,0,_baseNrmBitmapData.width,_baseNrmBitmapData.height)
			}
			if($rect.width==0||$rect.height==0){
				return ;
			}
			for(var i:uint=0;i<$rect.width;i++)
			{
				for(var j:uint=0;j<$rect.height;j++)
				{
					var $colorInt:uint=getVectorNormal($heighBmp,i+$rect.x,j+$rect.y)
					_baseNrmBitmapData.setPixel(i+$rect.x,j+$rect.y,$colorInt)
				}
			}
			miaobian(_baseNrmBitmapData)
			_nrmBitmapData=_baseNrmBitmapData.clone()
			var bf:BlurFilter = new BlurFilter(2,2,1);
			_nrmBitmapData.applyFilter(_nrmBitmapData,_nrmBitmapData.rect,new Point(0,0),bf);
			_nrmBitmapData.applyFilter(_nrmBitmapData,_nrmBitmapData.rect,new Point(0,0),bf);
		}
		
		private var _baseNrmBitmapData:BitmapData
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
			
			
			MathClass.normal($a, $o, $c, norm0);
			MathClass.normal($c, $o, $b, norm1);
			MathClass.normal($b, $o, $d, norm2);
			MathClass.normal($d, $o, $a, norm3);
			var endNorm:Vector3D = new Vector3D;
			endNorm.x = (norm0.x+norm1.x+norm2.x+norm3.x)/4;
			endNorm.y = (norm0.y+norm1.y+norm2.y+norm3.y)/4;
			endNorm.z = (norm0.z+norm1.z+norm2.z+norm3.z)/4;
			
			endNorm.normalize()
			endNorm.scaleBy(128)
			return MathCore.argbToHex16(endNorm.x+127,endNorm.y+127,endNorm.z+127)
			
		}
		
	}
}


