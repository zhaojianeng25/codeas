package out
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import _me.Scene_data;
	
	import modules.brower.BrowerInputDaeFile;
	
	import tempest.data.map.MapConfig;

	//通过文件生成OBJS
	public class OutToOurObjsModel
	{
		private static var instance:OutToOurObjsModel;
		public function OutToOurObjsModel()
		{
		}
		public static function getInstance():OutToOurObjsModel{
			if(!instance){
				instance = new OutToOurObjsModel();
			}
			return instance;
		}
		
		public  function run():void
		{
			var $file:File=new File;
			//var txtFilter:FileFilter = new FileFilter("Text", ".xml;*.xml;");
			var txtFilter:FileFilter = new FileFilter("Text",".xml;*.xml;");
			$file.browseForOpen("打开导入的文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				reandRoot($file.parent)
				
			}
		}


		private function reandRoot($rootfile:File):void
		{
			var objdata:Object=new Object;
			objdata.normals= this.getNmr($rootfile.url+"/"+"normals.xml")
			objdata.vertices= this.getFloatItem($rootfile.url+"/"+"vertices.xml");
			objdata.uvs= this.getFloatItem($rootfile.url+"/"+"uvs.xml");
			objdata.lightUvs=objdata.uvs;
			objdata.indexs= this.getUintItem($rootfile.url+"/"+"indexs.xml");
			
			trace(objdata.vertices.length/3);
			trace(objdata.uvs.length/2);
			trace(objdata.normals.length/3);
		
			var _editPreUrl:String=$rootfile.url+"/out.objs"
			var obj:Object=objdata
			obj.version=Scene_data.version;
			var fs:FileStream = new FileStream;
			fs.open(new File(_editPreUrl),FileMode.WRITE);
			fs.writeObject(obj);
			fs.close();
		}
		
		/*
		bool ie = (id.y > (32767.1 / 65535.0));
		id.y = ie ? (id.y - (32768.0 / 65535.0)) :id.y; 
		vec3 r;
		r.xy = (2.0 * 65535.0 / 32767.0) * id - vec2(1.0);
		r.z = sqrt(clamp(1.0 - dot(r.xy, r.xy), 0.0, 1.0));
		r.z = ie ? -r.z : r.z;
		*/
		private function getNmr($url:String):Vector.<Number>{
			var dd:Vector.<Number>=this.getFloatItem($url);
			var $outNmr:Vector.<Number>=new Vector.<Number>
			for(var i:Number=0;i<Math.floor(dd.length/2);i++){
				var id:Vector3D=new Vector3D()
				id.x=dd[i*2+0]/65535;
				id.y=dd[i*2+1]/65535;
				var  ie:Boolean = (id.y > (32767.1 / 65535.0));
				id.y = ie ? (id.y - (32768.0 / 65535.0)) :id.y; 
				var r:Vector3D=new Vector3D()
				r.x = (2.0 * 65535.0 / 32767.0) * id.x - 1;
				r.y = (2.0 * 65535.0 / 32767.0) * id.y - 1;
				r.z =Math.sqrt(r.x*r.x+r.y*r.y);
				r.z = ie ? -r.z : r.z;;

				$outNmr.push(r.x,r.y,r.z)
			}

			return $outNmr
		}
		private function getFloatItem($url:String):Vector.<Number> 
		{
			var fs:FileStream = new FileStream();   
			var $indexsFile:File=new File($url);
			fs.open($indexsFile,FileMode.READ);    
			var $str:String=fs.readUTFBytes(fs.bytesAvailable)
		
			return this.getArrayFloatByStr($str);
		}
		private function getUintItem($url:String):Vector.<uint> 
		{
			var fs:FileStream = new FileStream();   
			var $indexsFile:File=new File($url);
			fs.open($indexsFile,FileMode.READ);    
			var $str:String=fs.readUTFBytes(fs.bytesAvailable);
			return this.getArrayUintByStr($str);
		}
		private function  getArrayUintByStr($str: String):Vector.<uint>  {
			
			var $aa: Array= $str.split(",")
			var $data: Vector.<uint> = new Vector.<uint> 
			for (var i: Number = 0; i < $aa.length; i++) {
				$data.push(Number($aa[i]))
			}
			return $data
		}
			
		private function  getArrayFloatByStr($str: String):Vector.<Number>  {
			
			var $aa: Array= $str.split(",")
			var $data: Vector.<Number> = new Vector.<Number> 
			for (var i: Number = 0; i < $aa.length; i++) {
				$data.push(Number($aa[i]))
			}
			return $data
		}
			
	}
}