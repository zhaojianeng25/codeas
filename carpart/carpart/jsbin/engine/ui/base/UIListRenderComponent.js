var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var UIListRenderComponent = (function (_super) {
    __extends(UIListRenderComponent, _super);
    function UIListRenderComponent() {
        _super.call(this);
    }
    UIListRenderComponent.prototype.createList = function () {
        var list = new List;
        list.uiRender = this;
        return list;
    };
    UIListRenderComponent.prototype.createGridList = function () {
        var list = new GridList;
        list.uiRender = this;
        return list;
    };
    return UIListRenderComponent;
})(UIRenderComponent);
//# sourceMappingURL=UIListRenderComponent.js.map