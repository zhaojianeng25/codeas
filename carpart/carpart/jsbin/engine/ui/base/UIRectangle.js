var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var UIRectangle = (function (_super) {
    __extends(UIRectangle, _super);
    function UIRectangle() {
        _super.apply(this, arguments);
        this.pixelWitdh = 1;
        this.pixelHeight = 1;
        this.pixelX = 0;
        this.pixelY = 0;
        this.cellX = 0;
        this.cellY = 0;
        this.type = 0;
    }
    return UIRectangle;
})(Rectangle);
//# sourceMappingURL=UIRectangle.js.map