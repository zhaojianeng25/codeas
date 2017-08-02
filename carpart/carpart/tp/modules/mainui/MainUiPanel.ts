module mainui {

    export class MainUiPanel extends UIPanel {

        private _bottomRender: UIRenderComponent;
        private _midRender: UIRenderComponent;
        private _topRender: UIRenderComponent;

        public constructor() {
            super();
            this.width = UIData.designWidth;
            this.height = UIData.designHeight;

            this._bottomRender = new UIRenderComponent;
            this.addRender(this._bottomRender);
            this._midRender = new UIRenderComponent;
            this.addRender(this._midRender);
            this._topRender = new UIRenderComponent;
            this.addRender(this._topRender);
        }

        public applyLoad(): void {
      
            this._midRender.uiAtlas = new UIAtlas;
            this._midRender.uiAtlas.setInfo("ui/uidata/mainui/mainui.xml", "ui/uidata/mainui/mainui.png", () => { this.loadConfigCom() });
        }
        private uiAtlasComplet: boolean = false;
        private loadConfigCom(): void
        {
            this._bottomRender.uiAtlas = this._midRender.uiAtlas;
            this._topRender.uiAtlas = this._midRender.uiAtlas;
            this.addEvntBut("a_pic1",this._midRender)
            this.uiAtlasComplet = true;
            this.applyLoadComplete();
     
        }
        protected butClik(evt: InteractiveEvent): void
        {

            ModuleEventManager.dispatchEvent(new command.CammandEvent(command.CammandEvent.SHOW_CAMMAD_PANEL));


   
        }
  
   
    }
}