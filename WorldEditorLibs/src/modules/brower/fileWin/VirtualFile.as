package modules.brower.fileWin
{
	import flash.filesystem.File;

	public class VirtualFile
	{
		public var url:String;
		public var type:int = -1;
		public var rootType:int;
		public var name:String;
		public var dataFile:Boolean;
		public var pointUrl:String;
		
		public static var vec:Vector.<VirtualFile> = new Vector.<VirtualFile>;
		public static var virtualChildDic:Object = new Object;
		
		public static var Model3D:uint=10
		public static var Model3DXFile:uint=11
		public static var Bone:uint=12
		public static var Object3D:uint=1
		public static var Texture3D:uint=2
		public static var TextureSpecial:uint=3
		public static var TextureCubeMap:uint=4
		public static var TextureShadow:uint=5
		public static var Texture2D:uint=6
		public static var TextureParticle:uint=7
		
	
		
		public function VirtualFile()
		{
			
		}
		
		public static function add(vf:VirtualFile):void{
			vec.push(vf);
		}
		
		public static function addVirtualChildFile(url:String,$vec:Vector.<File>):void{
			virtualChildDic[url] = $vec; 
		}
		
		public static function getVirtualChildFile(url:String):Vector.<File>{
			return virtualChildDic[url]; 
		}
		
		/**
		 * -1表示只读 0表示读写 >0 表示类型
		 * @param $url
		 * @return 
		 * 
		 */		
		public static function getCreatType($url:String):int{
			for(var i:int;i<vec.length;i++){
				if(vec[i].url == $url){
					return vec[i].type;
				}
			}
			return 0;
		}
		
		public static function getRootByType(type:int):Array{
			var ary:Array = new Array;
			for(var i:int;i<vec.length;i++){
				if(vec[i].rootType == type){
					ary.push(new File(vec[i].url));
				}
			}
			return ary;
		}
		
	}
}