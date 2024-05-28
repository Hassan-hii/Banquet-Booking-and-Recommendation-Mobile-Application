class MenuModel{

  static const String jPkgName = 'pkg_name', jMenuPrice = 'menu_price',
      jMainCourse = 'main_course', jDesserts = 'desserts', jDrinks = 'drinks', id = 'id';

  String? pkgName, menuPrice, mainCourse, desserts, drinks, menuId;
  MenuModel({required this.pkgName, required this.menuPrice, required this.mainCourse,
    required this.desserts, required this.drinks, this.menuId});

  factory MenuModel.fromJson(Map<String, dynamic>? json){
    return MenuModel(
        menuId: json != null ? json[id] : null,
        pkgName: json != null ? json[jPkgName] : null,
        menuPrice: json != null ? json[jMenuPrice] : null,
        mainCourse: json != null ? json[jMainCourse] : null,
        desserts: json != null ? json[jDesserts] : null,
        drinks: json != null ? json[jDrinks] : null,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      jPkgName: pkgName,
      jMenuPrice: menuPrice,
      jMainCourse: mainCourse,
      jDesserts: desserts,
      jDrinks: drinks
    };
  }

  static List<MenuModel> toMenuList(Map<String, dynamic> map){
    List<MenuModel> alteredMenu = [];
    map.forEach((key, value) {
      alteredMenu.add(MenuModel.fromJson(value));
    });
    return alteredMenu;
  }
}