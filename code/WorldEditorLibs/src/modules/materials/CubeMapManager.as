package modules.materials
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.core.MathCore;
	
	import common.AppData;
	
	import materials.MaterialCubeMap;
	
	import modules.hierarchy.FileSaveModel;

	public class CubeMapManager
	{
		public function CubeMapManager()
		{
		}
		public static function getInstance():CubeMapManager{
			if(!instance){
				instance = new CubeMapManager();
			}
			return instance;
		}
		private var _keyObj:Object=new Object
		private static var instance:CubeMapManager;
		public function getCubeMapByUrl($url:String):MaterialCubeMap
		{
			var file:File = new File($url);
			if(!file.exists){
				return null
			}
			if(file.extension!="cube"){
				return null
			}
			if(_keyObj[$url]){
				return _keyObj[$url]
			}else{
				var $fs:FileStream = new FileStream;
				$fs.open(new File($url),FileMode.READ);
				var $obj:Object = $fs.readObject();
				$fs.close();
				var $editCubeMap:MaterialCubeMap =objToCubeMap($obj)
				$editCubeMap.addEventListener(Event.CHANGE,onCubeMapChange)
				$editCubeMap.cubeName=new File($url).name
				$editCubeMap.url=$url.replace(AppData.workSpaceUrl,"");
				_keyObj[$url]=$editCubeMap
				return _keyObj[$url]
			}
		}
		protected function onCubeMapChange(event:Event):void
		{
			var _editCubeMap:MaterialCubeMap=MaterialCubeMap(event.target)
			if(AppData.type==1){
				if(_editCubeMap){
					var obj:Object = new Object;
					var fs:FileStream = new FileStream;
					fs.open(new File(AppData.workSpaceUrl+_editCubeMap.url),FileMode.WRITE);
					fs.writeObject(_editCubeMap.readObject());
					fs.close();
					drawCubeMapIcon(_editCubeMap)
					
				}
			}
			
		}
		private function  drawCubeMapIcon(_editCubeMap:MaterialCubeMap):void
		{
			
			var $sprite:Sprite=new Sprite
			var tempBmp:BitmapData=new BitmapData(128,128,false,	MathCore.argbToHex16(64,64,64))	
				
			var $v:Vector.<Number>=new Vector.<Number>;
			var $u:Vector.<Number>=new Vector.<Number>;
			var $index:Vector.<int>=new Vector.<int>
				


				
			var a0:Point=new Point(5,25)
			var a1:Point=new Point(86,41)
			var a2:Point=new Point(119,15)
			var a3:Point=new Point(48,1)
				
			var b0:Point=new Point(5,25+84)
			var b1:Point=new Point(86,41+84)
			var b2:Point=new Point(119,15+84)
			var b3:Point=new Point(48,1+84)
			
			BmpLoad.getInstance().addSingleLoad(AppData.workSpaceUrl+_editCubeMap.textureName0,function ($bitmap:Bitmap,$obj:Object):void{
				$sprite.graphics.clear()
				$sprite.graphics.beginBitmapFill($bitmap.bitmapData)
				
				$v=new Vector.<Number>

				$v.push(a0.x,a0.y)
				$v.push(a1.x,a1.y)
				$v.push(a2.x,a2.y)
				$v.push(a3.x,a3.y)

			
				$u.push(100/100,25/100,1)
				$u.push(65/100,25/100,1)
				$u.push(65/100,50/100,1)
				$u.push(100/100,50/100,1)
				
				$index.push(0,1,2);
				$index.push(0,2,3);
				
				
				//-------------------//
				$v.push(a0.x,a0.y)
				$v.push(b0.x,b0.y)
				$v.push(b1.x,b1.y)
				$v.push(a1.x,a1.y)
				
				
				$u.push(65/100,0/100,1)
				$u.push(33/100,0/100,1)
				$u.push(33/100,25/100,1)
				$u.push(65/100,25/100,1)
				
				$index.push(4,5,6);
				$index.push(4,6,7);
				//-------------------//
				$v.push(a1.x,a1.y)
				$v.push(b1.x,b1.y)
				$v.push(b2.x,b2.y)
				$v.push(a2.x,a2.y)
				
				
				$u.push(65/100,25/100,1)
				$u.push(33/100,25/100,1)
				$u.push(33/100,50/100,1)
				$u.push(65/100,50/100,1)
				
				$index.push(8,9,10);
				$index.push(8,10,11);
				
				
				$sprite.graphics.drawTriangles($v,$index,$u)
				tempBmp.draw($sprite)
				
				var $bmpFileName:String=_editCubeMap.url.replace(".cube",".jpg")
				var $tourl:String=File.desktopDirectory.url+"/world/"+$bmpFileName;
				FileSaveModel.getInstance().saveBitmapdataToJpg(tempBmp,$tourl)
				
			
			
			
				
				
			},new Object)
				
	
			
			
			
		}
			
		public function getUrlByCubeMap($temp:MaterialCubeMap):String
		{
			for (var $url:String in _keyObj){
				if(_keyObj[$url]==$temp)
				{
					return $url
				}
			}
			return "";
		}
		private function objToCubeMap($obj:Object):MaterialCubeMap
		{
			var $temp:MaterialCubeMap = new MaterialCubeMap();
			for(var i:String in $obj) {
				$temp[i]=$obj[i]
			}
			return $temp
		}
	}
}


