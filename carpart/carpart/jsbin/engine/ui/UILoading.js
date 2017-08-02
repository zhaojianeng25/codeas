var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var UILoading = (function (_super) {
    __extends(UILoading, _super);
    function UILoading() {
        _super.call(this);
        this.width = 960;
        this.height = 540;
        this.center = 0;
        this.middle = 0;
        this.initData();
    }
    UILoading.getInstance = function () {
        if (!this._instance) {
            this._instance = new UILoading();
        }
        return this._instance;
    };
    UILoading.prototype.initData = function () {
        var _this = this;
        //var render:UIRenderComponent = new UIRenderComponent();
        this.atls = new UIAtlas();
        this.atls.configData = new Array;
        this.atls.configData.push(this.atls.getObject("load", 0, 0, 256, 256, 256, 256, 4, 4));
        this.atls.loadImgUrl("ui/load/ui_loding.png", function () { _this.loadCom(); });
    };
    UILoading.prototype.loadCom = function () {
        this._render = new UIRenderComponent();
        this._render.uiAtlas = this.atls;
        var ui = this._render.createFrame("load");
        this.addChild(ui);
        ui.speed = 1;
        ui.width = 100;
        ui.height = 100;
        ui.x = (960 - ui.width) / 2;
        ui.y = (540 - ui.height) / 2;
        this.addRender(this._render);
    };
    UILoading.prototype.show = function () {
        UIManager.getInstance().addUIContainer(this);
    };
    UILoading.prototype.hide = function () {
        UIManager.getInstance().removeUIContainer(this);
    };
    return UILoading;
})(UIConatiner);
//# sourceMappingURL=UILoading.js.map