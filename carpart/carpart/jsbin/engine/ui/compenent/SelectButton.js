var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var SelectButton = (function (_super) {
    __extends(SelectButton, _super);
    function SelectButton() {
        _super.call(this);
        this._selected = false;
    }
    Object.defineProperty(SelectButton.prototype, "selected", {
        get: function () {
            return this._selected;
        },
        set: function (value) {
            this._selected = value;
            if (this._selected) {
                this._state = 1;
            }
            else {
                this._state = 0;
            }
        },
        enumerable: true,
        configurable: true
    });
    SelectButton.prototype.interactiveEvent = function (e) {
        if (!this.enable) {
            return false;
        }
        if (e.type == InteractiveEvent.Down) {
            if (this.testPoint(e.x, e.y)) {
                this._selected = !this._selected;
                if (this._selected) {
                    this._state = 1;
                }
                else {
                    this._state = 0;
                }
            }
        }
        return _super.prototype.interactiveEvent.call(this, e);
    };
    return SelectButton;
})(BaseButton);
//# sourceMappingURL=SelectButton.js.map