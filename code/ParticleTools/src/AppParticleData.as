package
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.particle.Display3DParticle;
	
	import flash.geom.Point;
	
	import renderLevel.Display3DMovieLocal;
	import renderLevel.SceneLevel;
	import renderLevel.backGround.BackGroundLevel;
	import renderLevel.levels.Particle3DFacet;
	import renderLevel.levels.ParticleLevel;
	
	import view.ParticleItem;
	import view.TimeLineSprite;

	public class AppParticleData
	{
		public function AppParticleData()
		{
		}

		public static var lyfUrl:String;
		public static var is3d:Boolean = true;
		public static var isHengban:Boolean = false;
		public static var particle3DFacet:Particle3DFacet;
		public static var display3dParticle:Display3DParticle;
		public static var currentParticleItem:ParticleItem;
		public static var particleLevel:ParticleLevel;
		public static var showGrid:Boolean = true;
		public static var particleNativeRoot:String = "";
		public static var showXyz:Boolean;
		
		
		public static var sceneLevel:SceneLevel;
		public static var backLevel:BackGroundLevel;
		
		public static var role:Display3DMovieLocal;
		public static var roleContanier:Display3DContainer;
		
		public static var mapdata:Object;
		public static var posOffsetPoint:Point = new Point;
		
		public static var timeline:TimeLineSprite;
		
		public static var isAuthorize:Boolean;
		
		
		public static var distortion:Boolean;
		
		public static var projectType:int;
		
		[Bindable]
		public static var projectName:String;
		
		[Bindable]
		public static var statusString:String;
		
		public static var mapUrl:String;
		
		public static var userList:Array;
		
	}
}