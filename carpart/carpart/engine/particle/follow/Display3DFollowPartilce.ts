class Display3DFollowPartilce extends Display3DBallPartilce {
    private _bindMatrixAry: Array<Array<number>>;
    private _bindFlagAry: Array<number>;
    private flag: number = 0;

    public constructor() {
        super();
        //this.initBingMatrixAry();
    }

    public get followdata(): ParticleFollowData {
        return <ParticleFollowData>this.data;
    }

    public creatData(): void {
        this.data = new ParticleFollowData;
    }

    public setAllByteInfo($byte: ByteArray, version: number = 0): void {
        super.setAllByteInfo($byte, version);
        this.initBingMatrixAry();
    }

    public setVc(): void {
        super.setVc();

        this.updateBind();

        for (var i: number = 0; i < this.followdata._totalNum; i++) {

            Scene_data.context3D.setVc3fv(this.data.materialParam.shader, "bindpos[" + i + "]", this._bindMatrixAry[i]);
           // _context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 28 + i, _bindMatrixAry[i]);
        }

    }

    private initBingMatrixAry():void{
        this._bindMatrixAry = new Array;
        this._bindFlagAry = new Array;
        for (var i: number = 0; i < this.followdata._totalNum;i++){
		    this._bindMatrixAry.push([0, 0, 0]);
            this._bindFlagAry.push(0);
        }
    }

    public updateBind(): void {
        var time: number = this._time / Scene_data.frameTime;
        for (var i: number = this.flag; i < this.followdata._totalNum; i++) {
            var temp: number = (time - i * this.followdata._shootSpeed) / this.followdata._life;
            if (temp >= this._bindFlagAry[i]) {

                console.log(this.bindVecter3d);

                this._bindMatrixAry[i][0] = this.bindVecter3d.x;
                this._bindMatrixAry[i][1] = this.bindVecter3d.y;
                this._bindMatrixAry[i][2] = this.bindVecter3d.z;

                this._bindFlagAry[i]++;
            }
        }
    }

    public updateMatrix(): void {

        if (!this.bindMatrix) {
            return;
        }

        this.modelMatrix.identity();


        if (!this.groupMatrix.isIdentity) {
            this.posMatrix.append(this.groupMatrix);
        }

        this.modelMatrix.append(this.posMatrix);

        //this.modelMatrix.append(this.bindMatrix);

        //this.modelMatrix.appendTranslation(this.bindVecter3d.x, this.bindVecter3d.y, this.bindVecter3d.z);

    }

    public updateAllRotationMatrix(): void {
        this.followdata._allRotationMatrix.identity();

        this.followdata._allRotationMatrix.prependScale(this.followdata.overAllScale * this._scaleX * 0.1 * this.bindScale.x,
            this.followdata.overAllScale * this._scaleY * 0.1 * this.bindScale.y,
            this.followdata.overAllScale * this._scaleZ * 0.1 * this.bindScale.z);

        if (this.isInGroup) {
            this.followdata._allRotationMatrix.appendRotation(this.groupRotation.x, Vector3D.X_AXIS);
            this.followdata._allRotationMatrix.appendRotation(this.groupRotation.y, Vector3D.Y_AXIS);
            this.followdata._allRotationMatrix.appendRotation(this.groupRotation.z, Vector3D.Z_AXIS);
        }

    }

    public reset(): void {
        super.reset();

        for (var i: number = 0; i < this.followdata._totalNum; i++) {
            this._bindMatrixAry[i][0] = 0;
            this._bindMatrixAry[i][1] = 0;
            this._bindMatrixAry[i][2] = 0;
            this._bindFlagAry[i] = 0;
        }

    }


    public updateWatchCaramMatrix(): void {
        this._rotationMatrix.identity();

        if (this.followdata.facez) {
            this._rotationMatrix.prependRotation(90, Vector3D.X_AXIS);
        } else if (this.followdata._watchEye) {

            this._rotationMatrix.prependRotation(-Scene_data.cam3D.rotationY, Vector3D.Y_AXIS);
            this._rotationMatrix.prependRotation(-Scene_data.cam3D.rotationX, Vector3D.X_AXIS);

        }


    }
    //public regShader(): void {
    //    if (!this.materialParam) {
    //        return;
    //    }

    //    var shaderParameAry: Array<number> = this.getShaderParam();

    //    this.materialParam.program = ProgrmaManager.getInstance().getMaterialProgram(Display3DFollowShader.Display3D_Follow_Shader, new Display3DFollowShader(), this.materialParam.material, shaderParameAry);

    //}
    //public setAllByteInfo($byte: ByteArray, $allObj: any): void {

    //    super.setAllByteInfo($byte, $allObj);
    //    this.initBingMatrixAry();
    //}

    //public setAllInfo(allObj: any): void {
    //    super.setAllInfo(allObj);
    //    this.initBingMatrixAry();
    //}


}