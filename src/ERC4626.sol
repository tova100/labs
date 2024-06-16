//תומך בכל הפעולות של erc20
//כל חוזה של ERC4626 תומך רק בנכס אחד
//תקן ERC 4626 מספק אמצעי יעיל בגז לביצוע נהלי חשבונאות נפוצים מאוד של DeFi.
abstract contract ERC4626 is ERC20, IERC4626 {
    using Math for uint256;

    IERC20 private immutable asset;
    uint8 private immutable underlyingDecimals;

    constructor(IERC20 _asset) {
        (bool succes, uint8 assetDecimals) = tryGetAssetDecimals(asset);
        underlyingDecimals = success ? assetDecimals : 18;
        asset = _asset;
    }

    function convertToShares(uint256 assets, Math.Rouding rouding) internal view virtual returns (uint256) {
        return assets.mulDiv(totalSupply() + 10 ** _decimalsOffert(), totalAssets() + 1, rouding);
    }
}
