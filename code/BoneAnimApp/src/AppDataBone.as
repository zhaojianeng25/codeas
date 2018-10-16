package
{
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.collections.ArrayCollection;
	
	import _Pan3D.display3D.Display3DContainer;
	
	import _me.xyzPos.XyzPosLevel;
	
	import renderLevel.Display3DMovieLocal;
	import renderLevel.Display3DTarget;
	import renderLevel.SceneLevel;
	import renderLevel.backGround.BackGroundLevel;
	import renderLevel.levels.BoundsLevel;
	import renderLevel.levels.MoveLineLevel;

	public class AppDataBone
	{
		public function AppDataBone()
		{
		}
		[Bindable]
		public static var appTitle:String = "粒子编辑器 -未命名";
		public static var showGrid:Boolean = true;
		public static var is3d:Boolean = true;
		public static var isHengban:Boolean = false;
		public static var particle:Object;
		
		public static var sceneLevel:SceneLevel;
		
		public static var usePostProcess:Boolean;
		
		public static var distortion:Boolean;
		public static var role:Display3DMovieLocal;
		public static var ride:Display3DMovieLocal;
		public static var targetRole:Display3DTarget;
		public static var roleContanier:Display3DContainer;
		
		public static var backLevel:BackGroundLevel;
		[Bindable]
		public static var boneList:ArrayCollection;
		
		public static var boundsLevel:BoundsLevel;
		//public static var xyzLevel:XyzPosLevel;
		
		public static var isAuthorize:Boolean;
		
		
		public static var projectType:int;
		

		public static var projectName:String;
		

		public static var statusString:String;
		
		public static var mapUrl:String;
		
		public static var lightTexture:Texture;
		public static var lightx:Number = 1;
		public static var lighty:Number = 1;
		
		public static var normalValue:Number = 0.8;
		public static var normalOffValue:Number = 1;
		public static var noramlMode:Boolean = false;
		
		public static var version:int = 1;
		

		public static var fileScale:Number = 1;
		public static var tittleHeight:Number = 0;
		public static var hitBoxPoint:Point = new Point(10,10)

		public static var userList:Array;
		
		//public static var bloodPosV3d:Vector3D = new Vector3D();
		
		


	}
}