class FoodModel{

  static const String jFoodName = 'food_name', jFoodDetails = 'food_details', jFoodDate = 'food_date',
      jBanquetName = 'banquet_name', jBanquetId = 'banquet_id';

  String foodName, foodDetails, foodDate,banquetName, banquetId;

  FoodModel({required this.foodName, required this.foodDetails,
    required this.foodDate, required this.banquetName, required this.banquetId});

  factory FoodModel.fromJson(Map<String, dynamic> json){
    return FoodModel(foodName: json[jFoodName], foodDetails: json[jFoodDetails],
        foodDate: json[jFoodDate], banquetName: json[jBanquetName], banquetId: json[jBanquetId]);
  }

  Map<String, dynamic> toJson(){
    return {
      jFoodName: foodName,
      jFoodDetails: foodDetails,
      jFoodDate: foodDate,
      jBanquetName: banquetName,
      jBanquetId: banquetId
    };
  }
}