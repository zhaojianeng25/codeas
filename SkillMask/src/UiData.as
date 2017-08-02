package
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import mvc.left.panelleft.PanelModel;
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.scene.UiSceneEvent;
	
	import vo.FileDataVo;
	import vo.FileInfoType;
	import vo.H5UIFileNode;

	public class UiData
	{
		public function UiData()
		{
		}
		public static var editMode:uint=0 ///0是切割1为ui
		public static var nodeItem:ArrayCollection;
		private static var _selectArr: Vector.<H5UIFileNode>
		public static var bmpitem:Vector.<FileDataVo>;
		public static var bigBitmapUrl:String
		public static var sceneColor:uint;
		public static var sceneBmpRec:Rectangle;
		public static var url:String
		public static var isNewH5UI:Boolean
		public static var bitMapData:BitmapData
		public static var panelNodeVo:PanelNodeVo;
		private static var _copyItem:Vector.<H5UIFileNode>;
		
		public static function get selectArr():Vector.<H5UIFileNode>
		{
			return _selectArr;
		}

		public static function set selectArr(value:Vector.<H5UIFileNode>):void
		{
			_selectArr = value;
		}

		public static function getSharedObject():SharedObject
		{
			return SharedObject.getLocal("a4","/"); 
		
		}
		public static function makeNewUiFile():void
		{
			UiData.nodeItem=new ArrayCollection;
			UiData.selectArr=new Vector.<H5UIFileNode>;
			UiData.bmpitem=new Vector.<FileDataVo>
			UiData.sceneBmpRec=new Rectangle(0,0,512,512)
			UiData.isNewH5UI=true;
			
			PanelModel.getInstance().makeNewScene()
			ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA));
			
		}
		public static function getUiNodeByName($name:String):H5UIFileNode
		{
			for(var i:uint=0;UiData.nodeItem&&i<UiData.nodeItem.length;i++)
			{
				if(H5UIFileNode(UiData.nodeItem[i]).name==$name){
					return H5UIFileNode(UiData.nodeItem[i])
				}
			}
			return null
		}
		public static function getUIBitmapDataByName($name:String):BitmapData
		{
			var $H5UIFileNode:H5UIFileNode=getUiNodeByName($name)
			if($H5UIFileNode){
				var bmp:BitmapData=new BitmapData($H5UIFileNode.rect.width,$H5UIFileNode.rect.height,true,0x00000000);
				var m:Matrix=new Matrix;
				m.tx=-$H5UIFileNode.rect.x
				m.ty=-$H5UIFileNode.rect.y
				bmp.draw(bitMapData,m)
				return bmp;
			}else{
			   return null
			}
			
			
		}
		public static function getFileBmpItem():Array
		{
			var arr:Array=new Array
			for(var i:uint=0;i<bmpitem.length;i++)
			{
				if(!bmpitem[i].dele){
					var $obj:Object=new Object
					$obj.rect=bmpitem[i].rect
					$obj.url=bmpitem[i].url
					var rect:Rectangle = new Rectangle(0, 0, bmpitem[i].rect.width, bmpitem[i].rect.height);
					$obj.bmpByte = bmpitem[i].bmp.getPixels(rect)
					arr.push($obj)
				}
			}
			return arr;
		}
		public static function meshInfo($InfoRectItem:Array):void
		{
			UiData.nodeItem=new ArrayCollection
			for(var i:uint=0;i<$InfoRectItem.length;i++){
				var $H5UIFileNode:H5UIFileNode=new H5UIFileNode
				$H5UIFileNode.name=$InfoRectItem[i].name
				$H5UIFileNode.type=$InfoRectItem[i].type
				$H5UIFileNode.rect=new Rectangle;
				$H5UIFileNode.rect.x=int($InfoRectItem[i].rect.x)
				$H5UIFileNode.rect.y=int($InfoRectItem[i].rect.y)
				$H5UIFileNode.rect.width=int($InfoRectItem[i].rect.width)
				$H5UIFileNode.rect.height=int($InfoRectItem[i].rect.height)
				
				if($H5UIFileNode.type==FileInfoType.RECTANGLE){
					$H5UIFileNode.rect9=new Rectangle;
					if($InfoRectItem[i].rect9){
						$H5UIFileNode.rect9.x=int($InfoRectItem[i].rect9.x)
						$H5UIFileNode.rect9.y=int($InfoRectItem[i].rect9.y)
						$H5UIFileNode.rect9.width=int($InfoRectItem[i].rect9.width)
						$H5UIFileNode.rect9.height=int($InfoRectItem[i].rect9.height)
					}
				}
				if($H5UIFileNode.type==FileInfoType.SECTOR){
					$H5UIFileNode.rowColumn=new Point();
					if($InfoRectItem[i].rowColumn){
						$H5UIFileNode.rowColumn.x=int($InfoRectItem[i].rowColumn.x)
						$H5UIFileNode.rowColumn.y=int($InfoRectItem[i].rowColumn.y)
					}else{
						$H5UIFileNode.rowColumn.x=1;
						$H5UIFileNode.rowColumn.y=1;
					}
				}
				
				UiData.nodeItem.addItem($H5UIFileNode)
			}
			
			//_scenePanel.resetInfoArr(arr);
			//_centenPanel.resetInfoArr()
			
			
		}
		public static function meshBmp($FileBmpItem:Array):void
		{
			UiData.bmpitem=new Vector.<FileDataVo>
			for(var i:uint=0;i<$FileBmpItem.length;i++){
				var $FileDataVo:FileDataVo=new FileDataVo;
				$FileDataVo.url=$FileBmpItem[i].url;
				
				$FileDataVo.rect=new Rectangle;
				$FileDataVo.rect.x=	int($FileBmpItem[i].rect.x)
				$FileDataVo.rect.y=	int($FileBmpItem[i].rect.y)
				$FileDataVo.rect.width=$FileBmpItem[i].rect.width
				$FileDataVo.rect.height=$FileBmpItem[i].rect.height
				
				$FileDataVo.bmp=new BitmapData($FileDataVo.rect.width,$FileDataVo.rect.height)
				var $bmpByte:ByteArray=ByteArray($FileBmpItem[i].bmpByte);
				
				$FileDataVo.bmp.setPixels(new Rectangle(0,0,$FileDataVo.rect.width,$FileDataVo.rect.height), $bmpByte)
				UiData.bmpitem.push($FileDataVo);
				
				
			}
			//_centenPanel.resetSceneData($Bmpitem)
		}
		public static function getInfoRectItem():Array
		{
			var arr:Array=new Array
			for(var i:uint=0;i<nodeItem.length;i++)
			{
				
				var $obj:Object=new Object
				$obj.rect=nodeItem[i].rect;
				$obj.rect9=nodeItem[i].rect9;
				$obj.rowColumn=nodeItem[i].rowColumn;
				$obj.name=nodeItem[i].name;
				$obj.type=nodeItem[i].type;

				arr.push($obj)
			}
			return arr;
		}
		
		public static function makeCopy():void
		{
			_copyItem=new Vector.<H5UIFileNode>
			if(selectArr&&selectArr.length){
				for(var i:uint=0;i<selectArr.length;i++)
				{
					_copyItem.push(selectArr[i])
				}
			}
			
		}
		public static function paste():Boolean
		{
			if(_copyItem&&_copyItem.length){
				selectArr=new Vector.<H5UIFileNode>
				for(var i:uint=0;i<_copyItem.length;i++)
				{
					_copyItem[i].select=false;
					var $H5UIFileNode:H5UIFileNode=_copyItem[i].clone();
					$H5UIFileNode.name=_copyItem[i].name+"_copy";
					$H5UIFileNode.select=false
					nodeItem.addItem($H5UIFileNode)
					selectArr.push($H5UIFileNode)
				}
				
				ModuleEventManager.dispatchEvent( new UiSceneEvent(UiSceneEvent.REFRESH_SCENE_DATA));
				return true
				
				
			}
			return false
			
		}
		public static function saveToH5xml($url:String,$filename:String):void
		{
			var w:int=sceneBmpRec.width
			var h:int=sceneBmpRec.height
			var bmp:BitmapData=new BitmapData(w,h);
			isHaveRepeatName()
			if(nodeItem){
				var $infoArr:Array=new Array
				for(var j:uint=0;j<nodeItem.length;j++)
				{
					var $H5UIFileNode:H5UIFileNode=nodeItem[j] as H5UIFileNode
					var $infoObj:Object=new Object;
					$infoObj.name=$H5UIFileNode.name
					$infoObj.type=$H5UIFileNode.type
					$infoObj.x=$H5UIFileNode.rect.x/w
					$infoObj.y=$H5UIFileNode.rect.y/h
					$infoObj.width=$H5UIFileNode.rect.width/w
					$infoObj.height=$H5UIFileNode.rect.height/h
					$infoObj.ox=$H5UIFileNode.rect.x
					$infoObj.oy=$H5UIFileNode.rect.y
					$infoObj.ow=$H5UIFileNode.rect.width
					$infoObj.oh=$H5UIFileNode.rect.height
					if($H5UIFileNode.type==FileInfoType.RECTANGLE){
						$infoObj.ux=$H5UIFileNode.rect9.x/w
						$infoObj.uy=$H5UIFileNode.rect9.y/h
						$infoObj.uwidth=$H5UIFileNode.rect9.width/w
						$infoObj.uheight=$H5UIFileNode.rect9.height/h
						$infoObj.uox=$H5UIFileNode.rect9.x
						$infoObj.uoy=$H5UIFileNode.rect9.y
						$infoObj.uow=$H5UIFileNode.rect9.width
						$infoObj.uoh=$H5UIFileNode.rect9.height
					}
					if($H5UIFileNode.type==FileInfoType.SECTOR){
						$infoObj.cellX=$H5UIFileNode.rowColumn.x
						$infoObj.cellY=$H5UIFileNode.rowColumn.y
					}
					
					
					$infoArr.push($infoObj)
				}
				var fileObj:Object=new Object;
				fileObj.uiArr=$infoArr  
				fileObj.panelArr=	PanelModel.getInstance().geth5XML()
				var str:String = JSON.stringify(fileObj);
				var fs:FileStream = new FileStream();
				fs.open(new File($url+"/"+$filename+".xml"), FileMode.WRITE);
				for(var k:int = 0; k < str.length; k++)
				{
					fs.writeMultiByte(str.substr(k,1),"utf-8");
				}
				fs.close();
			}
			
		}
		//是否在重得的名字
		private static function  isHaveRepeatName():Boolean
		{

			if(nodeItem){
				var $infoArr:Array=new Array
				for(var i:uint=0;i<nodeItem.length;i++)
				{
					var $H5UIFileNodeA:H5UIFileNode=nodeItem[i] as H5UIFileNode;
					
					for(var j:uint=(i+1);j<nodeItem.length;j++)
					{
						var $H5UIFileNodeB:H5UIFileNode=nodeItem[j] as H5UIFileNode;
						if($H5UIFileNodeA.name==$H5UIFileNodeB.name){
							Alert.show($H5UIFileNodeA.name+" 名字重复！","提示")
							return true
						}
					}
				}
			}
			return false
		}
		
		


	}
}