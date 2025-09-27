/// Enum representing different actions that can be performed on assets
enum AssetAction {
  add,
  remove,
  update,
}

/// Extension providing boolean getters for AssetAction enum
extension AssetActionX on AssetAction {
  /// Returns true if the action is to add an asset
  bool get isAdd => this == AssetAction.add;
  
  /// Returns true if the action is to remove an asset
  bool get isRemove => this == AssetAction.remove;
  
  /// Returns true if the action is to update an asset
  bool get isUpdate => this == AssetAction.update;
}
