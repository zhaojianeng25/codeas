var HeightFieldModel = (function () {
    function HeightFieldModel() {
    }
    HeightFieldModel.getInstance = function () {
        if (!this._instance) {
            this._instance = new HeightFieldModel();
        }
        return this._instance;
    };
    HeightFieldModel.prototype.addField = function () {
        this.addHfBody();
    };
    HeightFieldModel.prototype.addHfBody = function () {
        var matrix = [];
        var sizeX = 64, sizeY = 64;
        for (var i = 0; i < sizeX; i++) {
            matrix.push([]);
            for (var j = 0; j < sizeY; j++) {
                var height = Math.cos(i / sizeX * Math.PI * 5) * Math.cos(j / sizeY * Math.PI * 5) * 2 + 0;
                if (i === 0 || i === sizeX - 1 || j === 0 || j === sizeY - 1) {
                    height = 3;
                }
                //height = 3
                matrix[i].push(height);
            }
        }
        var hfShape = new CANNON.Heightfield(matrix, {
            elementSize: 100 / sizeX
        });
        var hfBody = new CANNON.Body({ mass: 0 });
        hfBody.addShape(hfShape);
        hfBody.position.set(-sizeX * hfShape.elementSize / 2, -sizeY * hfShape.elementSize / 2, -1);
        var $disLock = new CanonPrefabSprite(hfBody);
        $disLock.addToWorld();
    };
    return HeightFieldModel;
})();
//# sourceMappingURL=HeightFieldModel.js.map