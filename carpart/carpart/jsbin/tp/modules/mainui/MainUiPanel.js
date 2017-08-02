var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var mainui;
(function (mainui) {
    var MainUiPanel = (function (_super) {
        __extends(MainUiPanel, _super);
        function MainUiPanel() {
            _super.call(this);
            this.uiAtlasComplet = false;
            this.width = UIData.designWidth;
            this.height = UIData.designHeight;
            this._bottomRender = new UIRenderComponent;
            this.addRender(this._bottomRender);
            this._midRender = new UIRenderComponent;
            this.addRender(this._midRender);
            this._topRender = new UIRenderComponent;
            this.addRender(this._topRender);
        }
        MainUiPanel.prototype.applyLoad = function () {
            var _this = this;
            this._midRender.uiAtlas = new UIAtlas;
            this._midRender.uiAtlas.setInfo("ui/uidata/mainui/mainui.xml", "ui/uidata/mainui/mainui.png", function () { _this.loadConfigCom(); });
        };
        MainUiPanel.prototype.loadConfigCom = function () {
            this._bottomRender.uiAtlas = this._midRender.uiAtlas;
            this._topRender.uiAtlas = this._midRender.uiAtlas;
            this.addEvntBut("a_pic1", this._midRender);
            this.uiAtlasComplet = true;
            this.applyLoadComplete();
        };
        MainUiPanel.prototype.butClik = function (evt) {
            ModuleEventManager.dispatchEvent(new command.CammandEvent(command.CammandEvent.SHOW_CAMMAD_PANEL));
        };
        return MainUiPanel;
    })(UIPanel);
    mainui.MainUiPanel = MainUiPanel;
})(mainui || (mainui = {}));
//# sourceMappingURL=MainUiPanel.js.map