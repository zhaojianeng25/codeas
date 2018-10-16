package modules.lizhi
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import particle.ParticleStaticMesh;
	
	import proxy.pan3d.particle.ProxyPan3DParticle;
	import proxy.top.model.IModel;
	import proxy.top.model.IParticle;
	import proxy.top.render.Render;
	

	public class LizhiManager
	{
		private static var instance:LizhiManager;
		public function LizhiManager()
		{
		}
		public var listArr:ArrayCollection
		public static function getInstance():LizhiManager{
			if(!instance){
				instance = new LizhiManager();
			}
			return instance;
		}
		public function objToMesh($obj:Object):ParticleStaticMesh
		{
			var $particleStaticMesh:ParticleStaticMesh=new ParticleStaticMesh
			$particleStaticMesh.url=$obj.url
			$particleStaticMesh.addEventListener(Event.COMPLETE,onCOMPLETE)
			return $particleStaticMesh
		}
		protected function onCOMPLETE(event:Event):void
		{
			var $selectParticMesh:ParticleStaticMesh=ParticleStaticMesh(event.target)
				
			for(var i:uint=0;i<listArr.length;i++)
			{
			
				var $hierarchyFileNode:HierarchyFileNode=HierarchyFileNode(listArr[i])
				if($hierarchyFileNode.type==HierarchyNodeType.Particle)
				{
					var $proxyPan3DParticle:ProxyPan3DParticle =ProxyPan3DParticle($hierarchyFileNode.iModel);
					if($proxyPan3DParticle.particleStaticMesh==$selectParticMesh){
					
						ParticleManager.getInstance().removeParticle($proxyPan3DParticle.particleSprite)
						$proxyPan3DParticle.particleSprite = ParticleManager.getInstance().getParticle(Scene_data.fileRoot+$selectParticMesh.url);
						ParticleManager.getInstance().addParticle($proxyPan3DParticle.particleSprite)
						//$proxyPan3DParticle.particleSprite=$modelSprite
					}
				
				}
			}
	
				
				

		}
		public function addParticleModel($id:uint,$url:String):IModel
		{
			var $file:File=new File($url)
			if($file.exists){
				var $particleMesh:ParticleStaticMesh=new ParticleStaticMesh
				$particleMesh.url=$url.replace(AppData.workSpaceUrl,"")
				
				var $imode:IParticle=Render.creatParticle($particleMesh)

				
				var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
				$hierarchyFileNode.id=$id
				
				
				$hierarchyFileNode.name=$file.name.replace(("."+$file.extension),"")
			
				$hierarchyFileNode.iModel=$imode;
				$hierarchyFileNode.type=HierarchyNodeType.Particle
				$hierarchyFileNode.data=$particleMesh;
				
				
				listArr.addItem($hierarchyFileNode)
		
				$particleMesh.addEventListener(Event.COMPLETE,onCOMPLETE)
				return $imode;
			}
	
			return null;
			
			

			
		}
		
	
	}
}