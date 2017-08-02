var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var BaseButton = (function (_super) {
    __extends(BaseButton, _super);
    function BaseButton() {
        _super.call(this);
        this.trDown = new Rectangle;
        this._state = 0;
        this._currentState = 0;
    }
    BaseButton.prototype.update = function () {
        if (this._currentState != this._state) {
            this.applyRenderSize();
            this._currentState = this._state;
        }
    };
    BaseButton.prototype.applyRenderSize = function () {
        _super.prototype.applyRenderSize.call(this);
        if (this._state == 0) {
            this.renderData2[0] = this.tr.width;
            this.renderData2[1] = this.tr.height;
            this.renderData2[2] = this.tr.x;
            this.renderData2[3] = this.tr.y;
        }
        else if (this._state == 1) {
            this.renderData2[0] = this.trDown.width;
            this.renderData2[1] = this.trDown.height;
            this.renderData2[2] = this.trDown.x;
            this.renderData2[3] = this.trDown.y;
        }
        this.uiRender.makeRenderDataVc(this.vcId);
    };
    return BaseButton;
})(UICompenent);
//# sourceMappingURL=BaseButton.js.map