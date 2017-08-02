package common.msg.event.materials
{
	import com.zcp.frame.event.ModuleEvent;
	
	import materials.Material;
	import materials.MaterialCubeMap;
	import materials.MaterialReflect;
	import materials.MaterialShadow;
	import materials.Texture2DMesh;
	import materials.TextureParticleMesh;
	
	import modules.materials.view.BaseMaterialNodeUI;
	
	public class MEvent_Material extends ModuleEvent
	{
		public static var MEVENT_MATERIAL_CREATNEW:String = "MEvent_Material_CreatNew";
		public static var MEVENT_TEXTURECUBEMAP_CREATNEW:String = "MEvent_TextureCubeMap_CreatNew";
		public static var MEVENT_MATERIAL_SHOW:String = "MEvent_Material_show";
		//public static var MEVENT_TEXTURECUBEMAP_SHOW:String = "MEvent_TextureCubeMap_show";
		public static var MEVENT_MATERIAL_SAVE:String = "MEvent_Material_save";
		public static var MEVENT_MATERIAL_PROP:String = "MEvent_Material_prop";
		public static var MEVENT_MATERIAL_CREAT_INSTANCE:String = "MEvent_Material_creat_instance";
		public static var MEVENT_MATERIAL_SHOW_INSTANCE:String = "MEvent_Material_show_instance";
		
		public static var MEVENT_MATERIAL_SHOW_BASE:String = "MEVENT_MATERIAL_SHOW_Base";
		public static var MEVENT_MATERIAL_REFLECT_SHOW:String = "MEVENT_MATERIAL_reflect_SHOW";
		public static var MEVENT_MATERIAL_CUBEMAP_SHOW:String = "MEVENT_MATERIAL_cubeMap_SHOW";
		public static var MEVENT_MATERIAL_SHADOW_SHOW:String = "MEVENT_MATERIAL_shadow_SHOW";
		public static var MEVENT_TEXTURE2D_SHOW:String = "MEVENT_Texture2D_SHOW";
		public static var MEVENT_TEXTUREPARTICLE_SHOW:String = "MEVENT_TextureParticle_SHOW";
		public static var MEVENT_MATERIAL_JPNG_PANEL:String = "MEVENT_MATERIAL_JPNG_PANEL"
		public static var MEVENT_MATERIAL_COMBINE_LIGHTMAP:String = "mevent_material_combine_lightmap"
		
		public var url:String;
		public var name:String;
		public var material:Material;
		public var glslMaterial:Material;
		
		public var materialReflect:MaterialReflect;
		public var materialCubemap:MaterialCubeMap;
		public var materialShadow:MaterialShadow;
		public var texture2Dmesh:Texture2DMesh
		public var textureParticleMesh:TextureParticleMesh
		public var nodeTreeView:BaseMaterialNodeUI;
		
		public function MEvent_Material($action:String=null)
		{
			super($action);
		}
	}
}