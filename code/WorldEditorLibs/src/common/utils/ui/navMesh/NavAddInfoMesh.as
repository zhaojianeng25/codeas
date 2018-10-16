

package common.utils.ui.navMesh
{
	import common.utils.frame.BaseComponent;
	import common.utils.ui.cbox.ComLabelBox;
	
	public class NavAddInfoMesh extends BaseComponent
	{
	
		private var _navMeshNode:NavMeshNode
		protected var tbComboBox:ComLabelBox;

		public function NavAddInfoMesh()
		{
			super();
			
			this.tbComboBox = new ComLabelBox;
			this.tbComboBox.label = "设置为跳点 "
			this.tbComboBox.width = 200;
			this.tbComboBox.x=5
			this.tbComboBox.y=5
			this.tbComboBox.height = 18;
			this.tbComboBox.changFun=changeDrawType;
			this.tbComboBox.data = [{name:"true"},{name:"false"}]
			this.addChild(this.tbComboBox)
				
			this.tbComboBox.selectItem="false";
			
			
			addEvents();
			this.height=50
		}

		public function get navMeshNode():NavMeshNode
		{
			return _navMeshNode;
		}

		public function set navMeshNode(value:NavMeshNode):void
		{
			_navMeshNode = value;
			if(_navMeshNode.isJumpRect){
				this.tbComboBox.selectItem="true"
			}else{
				this.tbComboBox.selectItem="false"
			}
		}

		private function changeDrawType(value:Object):void
		{
			if(value.name=="true"){
				_navMeshNode.isJumpRect=true;
			}else{
				_navMeshNode.isJumpRect=false;
			}
		}
		private function addEvents():void
		{
			

			
		}
		
	
		

	
		
	}
}


