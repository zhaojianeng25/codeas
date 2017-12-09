package exph5
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.FileFilter;
	
	import PanV2.loadV2.BmpLoad;
	import PanV2.loadV2.ObjsLoad;
	
	import _Pan3D.base.ObjData;
	
	import modules.hierarchy.FileSaveModel;
	import modules.scene.sceneSave.FilePathManager;

	public class OjbsExpOnlyUsePicModel
	{
		private static var instance:OjbsExpOnlyUsePicModel;
		public function OjbsExpOnlyUsePicModel()
		{
		}
		public static function getInstance():OjbsExpOnlyUsePicModel{
			if(!instance){
				instance = new OjbsExpOnlyUsePicModel();
			}
			return instance;
		}
		
		public function expObjs():void
		{
			var $file:File=new File(FilePathManager.getInstance().getPathByUid("Move3DFrame"))
			var txtFilter:FileFilter = new FileFilter("Text", ".objs;*.objs;");
			
			$file.browseForOpen("打开转换文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				_selectUrl=$file.url
				ObjsLoad.getInstance().addSingleLoad($file.url,objsFun)
			} 
		
			

		}
		private var _selectUrl:String;
		private var _selectObjData:ObjData
		
		protected function objsFun($objData:ObjData):void
		{
			_selectObjData=$objData;
			
			
			
			
			var $file:File=new File(FilePathManager.getInstance().getPathByUid("Move3DFramepic"))
			var txtFilter:FileFilter = new FileFilter("Text", "*.jpg;*.png;");
			
			$file.browseForOpen("打开转换文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				BmpLoad.getInstance().addSingleLoad($file.url,selectBmpBackFun,{})
			} 
			
				
//			var _editPreUrl:String=_selectUrl.replace(".objs","_only.objs")
//			var wirteObjData:Object=new Object
//			wirteObjData.vertices=$objData.vertices
//			wirteObjData.normals=$objData.normals
//			wirteObjData.uvs=$objData.uvs
//			wirteObjData.lightUvs=$objData.lightUvs
//			wirteObjData.indexs=$objData.indexs
//				
//			var fs:FileStream = new FileStream;
//			fs.open(new File(_editPreUrl),FileMode.WRITE);
//			fs.writeObject(wirteObjData);
//			fs.close();
		
			
		}
		private function selectBmpBackFun($bitmap:Bitmap,$obj:Object):void
		{
			var $min:Point=new Point(_selectObjData.uvs[0],_selectObjData.uvs[1])
			var $max:Point=new Point(_selectObjData.uvs[0],_selectObjData.uvs[1])
			for(var i:Number=0;i<_selectObjData.uvs.length/2;i++){
				var $p:Point=new Point(_selectObjData.uvs[i*2+0],_selectObjData.uvs[i*2+1])
		
				if($min.x>$p.x){
					$min.x=$p.x
				}
				if($min.y>$p.y){
					$min.y=$p.y
				}
	
				if($max.x<$p.x){
					$max.x=$p.x
				}
				if($max.y<$p.y){
					$max.y=$p.y
				}
			}
		
			trace($min);
			trace($max);
			trace($bitmap.width,$bitmap.height);

		
			var $w:Number=$max.x-$min.x;
			var $h:Number=$max.y-$min.y;
			var $tempFull:BitmapData=new BitmapData(Math.ceil($bitmap.width*$w),Math.ceil($bitmap.height*$h),true,0x000000);
			
			var $m:Matrix=new Matrix();
			$m.tx=-Math.floor($min.x*$bitmap.width);
			$m.ty=-Math.floor($min.y*$bitmap.height);
			$tempFull.draw($bitmap,$m);
			
			var kw:uint=Math.pow(2,Math.ceil(Math.LOG2E *Math.log($tempFull.width)));
			var kh:uint=Math.pow(2,Math.ceil(Math.LOG2E *Math.log($tempFull.height)));
			
	
			var $endBmp:BitmapData=new BitmapData(kw,kh)
			$endBmp.draw($tempFull)
			
		
		
		
		//	FileSaveModel.getInstance().saveBitmapdataToPng($tempFull,_selectUrl.replace(".objs","_full.png"))
			FileSaveModel.getInstance().saveBitmapdataToPng($endBmp,_selectUrl.replace(".objs","_end.png"))
				
	
			var $sw:Number=($tempFull.width/$endBmp.width)
			var $sh:Number=($tempFull.height/$endBmp.height)
			this.writeNewObjs($min,$max,$sw,$sh)
		}
		private function writeNewObjs($min:Point,$max:Point,$sw:Number,$sh:Number):void
		{
			var $w:Number=$max.x-$min.x;
			var $h:Number=$max.y-$min.y;
			
			
			var $objData:ObjData=_selectObjData
			var _editPreUrl:String=_selectUrl.replace(".objs","_only.objs")
			var wirteObjData:Object=new Object
			wirteObjData.vertices=$objData.vertices
			wirteObjData.normals=$objData.normals
			wirteObjData.uvs=new Vector.<Number>
			for(var i:Number=0;i<$objData.uvs.length/2;i++){
				var p:Point=new Point($objData.uvs[i*2+0],$objData.uvs[i*2+1]);
				p.x=(p.x-$min.x)/$w*$sw
				p.y=(p.y-$min.y)/$h*$sh
				wirteObjData.uvs.push(p.x,p.y)
			}	
			wirteObjData.lightUvs=$objData.lightUvs
			wirteObjData.indexs=$objData.indexs
				
			var fs:FileStream = new FileStream;
			fs.open(new File(_editPreUrl),FileMode.WRITE);
			fs.writeObject(wirteObjData);
			fs.close();
		
		}
		
		

	}
}