var IconManager = (function () {
    function IconManager() {
        this._dic = new Object;
        this._loadDic = new Object;
    }
    IconManager.getInstance = function () {
        if (!this._instance) {
            this._instance = new IconManager();
        }
        return this._instance;
    };
    IconManager.prototype.getIconName = function (name, $fun) {
        this.getIcon(geteqiconIconUrl(name), $fun);
    };
    IconManager.prototype.getIcon = function (url, $fun) {
        var _this = this;
        var uri = Scene_data.fileRoot + url;
        if (this._dic[uri]) {
            $fun(this._dic[uri]);
            return;
        }
        else if (!this._loadDic[uri]) {
            this._loadDic[uri] = new Array;
            this._loadDic[uri].push($fun);
            var _img = new Image();
            _img.onload = function () {
                var loadList = _this._loadDic[uri];
                for (var i = 0; i < loadList.length; i++) {
                    loadList[i](_img);
                }
                delete _this._loadDic[uri];
                _this._dic[uri] = _img;
            };
            _img.src = uri;
        }
        else {
            this._loadDic[uri].push($fun);
        }
    };
    return IconManager;
})();
//# sourceMappingURL=IconManager.js.map